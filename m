Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DD035A92E;
	Fri,  9 Jan 2026 12:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961806; cv=none; b=qzmu4F/hVigtsU/jvgLqdbP8kwbEujxxOmq4IMAG5vAilFxbegp0RJRktMh/zpnVUkTfklzCmT3XJVb5Et8p9H6dHsaI/XDzqyeUuiVSfU5wQdPveVRdNslPkVbKS3lka8mBefCwiZRb1yY4J3Ew3Oi3rgNCZOW9t0FuETuwMng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961806; c=relaxed/simple;
	bh=0lk+PxISYgCotwZ0/yM5TCwDciplkG8WqomRZwCQQZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XvxVBBF+tk94O7Cvw0ge1K0HPKcgpoZmISWC6tem0FBaR0J7JwmF+Z75gIBGWZRJ/rD3ydLzY+5x+FTHWjSBPMoDzqeTl9ot6qmp2XIcwx+tYTmLMCtSUKokJSElnVLVldjwdVc4Ec1iUgEyZ3Uw9MQi+N3bSUeZDWDLnZvKbzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k3gfOHec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k3gfOHec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C59DC4CEF1;
	Fri,  9 Jan 2026 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961805;
	bh=0lk+PxISYgCotwZ0/yM5TCwDciplkG8WqomRZwCQQZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k3gfOHeceI1TzioUiHLE6samE/NwtyrKy7NveVTwuYwAcrUZzBEUdJ2SCsX8MjEID
	 Gh0r9ZbrbdWtFoyqV383JuU01eYrw5bV6Gbd8Row3yOmfHgNG9fbxiHkh2goqjvbQW
	 RHMg6vtS0CPdaphH6N9E+K0TgsfddYQ9I1tJVR6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 135/634] usb: chaoskey: fix locking for O_NONBLOCK
Date: Fri,  9 Jan 2026 12:36:53 +0100
Message-ID: <20260109112122.533159152@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



