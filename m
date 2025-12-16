Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461AE3431E3;
	Tue, 16 Dec 2025 11:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884470; cv=none; b=WNpUaTzaC+NMmoQ8l2+xZG8nlhJw9q7dYO8J/KoX/TpnSVSya2jrcG6LJiMfv7yPqEym69xLx/fsxjDmhQIT7hHmpUlCDG+ubgv9a5WXmXq8GoYRmhk8Dzo/KSVeKcIy1/tvHVtWn83CWyTBc6lTd3NFgcud4pNZC16SDJ81qCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884470; c=relaxed/simple;
	bh=H+Vqmm7LJCqR+VPhv8z6BbvM2t0VflUqaICQnc1i24E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBO4aHbp1tbVR676wFkx8YnZTxfg9TsIvjsantISM6JZ6CAs71Ds43lO0BfpI0bivML/UN+T3gZ/C31fex91b75zYgcZcrb/vPv3Bxs3BJv+m8mmicw81+UrFYkUnrjUpaAcm0m3SxG8PGw9kogrb4oGpMQfmhwmp+Qt2o5lXws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=juWw19Wl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="juWw19Wl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5BDC4CEF1;
	Tue, 16 Dec 2025 11:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884470;
	bh=H+Vqmm7LJCqR+VPhv8z6BbvM2t0VflUqaICQnc1i24E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=juWw19Wlyvc8EIN68lCGL9v0FXCGQYOBhhsZKN9qG6v6lod2v+Cqj42iV/jvPLs2m
	 3n+Vb8b8um8w6AW/cPBudXBHPEQbs4arhEVLaZT3Jvpfipqq72ZsFllqqYt6+Dwe9O
	 C7iXk3PNbjJ1s7rQeP1sjMtALbE5yWxc7pjdkPnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/354] usb: chaoskey: fix locking for O_NONBLOCK
Date: Tue, 16 Dec 2025 12:12:49 +0100
Message-ID: <20251216111328.237398500@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit a2fa8a12e6bc9d89c0505b8dd7ae38ec173d25de ]

A failure to take a lock with O_NONBLOCK needs to result
in -EAGAIN. Change it.

Fixes: 66e3e591891da ("usb: Add driver for Altus Metrum ChaosKey device (v2)")
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Link: https://patch.msgid.link/20251030093918.2248104-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/chaoskey.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/misc/chaoskey.c b/drivers/usb/misc/chaoskey.c
index 225863321dc47..45cff32656c6e 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -444,9 +444,19 @@ static ssize_t chaoskey_read(struct file *file,
 			goto bail;
 		mutex_unlock(&dev->rng_lock);
 
-		result = mutex_lock_interruptible(&dev->lock);
-		if (result)
-			goto bail;
+		if (file->f_flags & O_NONBLOCK) {
+			result = mutex_trylock(&dev->lock);
+			if (result == 0) {
+				result = -EAGAIN;
+				goto bail;
+			} else {
+				result = 0;
+			}
+		} else {
+			result = mutex_lock_interruptible(&dev->lock);
+			if (result)
+				goto bail;
+		}
 		if (dev->valid == dev->used) {
 			result = _chaoskey_fill(dev);
 			if (result < 0) {
-- 
2.51.0



