Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2DE3355036;
	Tue, 16 Dec 2025 11:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885988; cv=none; b=fcki0pPPEjbaKkySbKzj+HZC9zW2TK0gC9haQQSrrR5l66Us3WDKuhoo7Lwl0NfIfWzMHko2aKcIeWXbMoc025nZGKIiIBG5SAxiz9wirWl2LIVuKTKtS4jOoCWRx9Hfyc4LZUkIQKuIBvvFMEbivRF+JukAIklvXUOgU+lA56o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885988; c=relaxed/simple;
	bh=GLvo8a6QcxldPgjxXc7MyNCZRP+tkEBLrS1i8FhEdW0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r505Xa9KsmimXBbd/Dl3RgvJAVz41cOFLm4kJ7iRCFg7GmMIa+0EVpJetSuP8EpohpzsyB4uAAWIRtTNULGIqi3XPsS+8EGiYlR8Pvj6PZo1AOFsi//YIFVdbVsDo6e1XD6pRnGaumK1qT88gmBKgjVBNo+0k5p75A/z/LIxiMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=17Ukx8i7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="17Ukx8i7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53118C4CEF5;
	Tue, 16 Dec 2025 11:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885988;
	bh=GLvo8a6QcxldPgjxXc7MyNCZRP+tkEBLrS1i8FhEdW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=17Ukx8i7mUp6n3V49dJ3OkSwU9hH895bgKIsB7JwAq2bANgilFRmFYwrNgMik69zw
	 guWZCnOE0dzdTl2ZAFSsut3AsJNthcFqWYF1tk8YvznzI77NpHCHxYQiAnj3FZMk/l
	 ZAxxNfr4jqgh4XhBNjVgXeX7TLPAWph0jkJaZPTU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 304/507] usb: chaoskey: fix locking for O_NONBLOCK
Date: Tue, 16 Dec 2025 12:12:25 +0100
Message-ID: <20251216111356.486574805@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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



