Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305042D73AB;
	Thu, 15 Jan 2026 17:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499127; cv=none; b=hez43jHfwAef35xO0qRlv5ebmLrIUJ86kvmxk2j8upPyMehxm0sh0vBa5FCTxXQAkbjnOIgThKTmfUAlMwDe/3sExS/ROCUNbGIiteAudXI1kpbBCw0YsiKo0ARRmKNC1dHOvu4kbU+TYtF4A/wMpnLgjb9GOQCG3RITY5TQlc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499127; c=relaxed/simple;
	bh=+CZPauTgaxye7PysiKqE7DfTpXl46jvb6m8rD5BdAj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay/+lJi4gRJGo06hHTxmKI5bxRqePnxUgYEzVsu+9ziMMMUD5AWiUl3vvD7QTD2Eiz6KDH8iiioKZR1XINhUtZwslVNK+9IbJ7jyKpuXPXTaOsJC+ab18htvVlkapFNpd8WoIOFviQaVcsYpC3kaiCQI3hzwAEVxZAU7hil3c0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdgWQlNN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdgWQlNN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC6DC116D0;
	Thu, 15 Jan 2026 17:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499126;
	bh=+CZPauTgaxye7PysiKqE7DfTpXl46jvb6m8rD5BdAj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdgWQlNNQTK+2ivEhaHTUI9MlTgwova8KvtKoIzs6V6/myDmHCSj5ozLpjrjT/4l1
	 nTuJLdT1g//E9WF1BcaYUSNhjaNrcw7h0wt3hR8NtnylIFulaC3TSInat0dX6+kO/a
	 YReQLlSoy8KbxYLOCA2njLK7HjmHotuZaiFNx6WY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 090/451] usb: chaoskey: fix locking for O_NONBLOCK
Date: Thu, 15 Jan 2026 17:44:51 +0100
Message-ID: <20260115164234.174331217@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index d99d424c05a7a..50909cc9a0bb2 100644
--- a/drivers/usb/misc/chaoskey.c
+++ b/drivers/usb/misc/chaoskey.c
@@ -445,9 +445,19 @@ static ssize_t chaoskey_read(struct file *file,
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



