Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74A7280327;
	Thu, 15 Jan 2026 17:19:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497566; cv=none; b=GGJnFk/KWcgYl7gCkEyXAdNsx5TY7dSIng6eaCGoBwC84ohUVZzPyiyeU7g7Od5tLiYjnXv93I83PCGxJAkQbkl9TIRKzbJkpAWcoS8uxIpXw81sYspUjotfGvNOvQNsTwL8I2QYcvHPdWO9yF/iaxy4S8oL2/Xxw+4ovZefJzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497566; c=relaxed/simple;
	bh=8wieetV6u1EQw5hVVwJMbqfiuFqYhNulOwMdExBP7CQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQtahS8I1GGNyVzFeTrGy6QlZdsm1N7ALrlvL6BK1ZSy1cn8/8lpv5T96SJB7m6gHR7qeER82ZnZHovdHs2484ZslNz4ucdxYzddUk7ZQjIVCW30asyIa563O6oa2wFwB46WnpeiO1ID7+G1v7VKTFc4M9JK6eZ+MeGKWAZN7O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k4kC6bfl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k4kC6bfl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3211DC116D0;
	Thu, 15 Jan 2026 17:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497566;
	bh=8wieetV6u1EQw5hVVwJMbqfiuFqYhNulOwMdExBP7CQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k4kC6bflIpXv4x9KGZZ0Y+e+cm04GiJoW525y6tmZ1PwFM3Ij96G0ThjlYF1RLyH+
	 V2rDgD5IUgmK643OqGdWCQOD5V46BkA8fnz3i2PRvXppV4B8Cb9/EXVQRPSH9fak7j
	 fOwDYvEWehhI1F+Bar+R+PyORIFJ544Eu7pHg0Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/554] usb: chaoskey: fix locking for O_NONBLOCK
Date: Thu, 15 Jan 2026 17:43:11 +0100
Message-ID: <20260115164250.771832878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



