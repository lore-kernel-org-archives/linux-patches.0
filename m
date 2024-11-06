Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E9C91F4296;
	Wed,  6 Nov 2024 13:03:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730898221; cv=none; b=hVBq2ZfvD4Z+52yDAjRMuWRauDvcgc4wBDFCcsUmPXKsafCl0ZFK8Fa4nSFh3rcfWdt6ykG3+oCFUK3SGdj83XpGyVOtZ2UbmmdvI4S5bzJwwvtzjDuJ5teU2Z+KO98VUBkiXlYVZarxBjtsV84TvsKb5+Rj/RKpt15FrYbtX/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730898221; c=relaxed/simple;
	bh=nsC7to/1djJ3cfoPEeOYkJCP4ggSum23nRZr+xnBIGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CK6+EWUlTM2Yc7nWHLPEWMFk3ox4AIToMgSfS6FWAxuQdMuSjRGqY4Rk8dxN/lXZ7c1pMxUg+QGCX7iRIkYWkK97mpckKe5cPUlrjW6FoT+uDX5AWvbZFHvi1Ywz2UvCv3h8EkY5GDJPE2Ryfqgl9Vu0RNw/wpq+40xJqUqSEmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QIQnwtYj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QIQnwtYj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1982FC4CECD;
	Wed,  6 Nov 2024 13:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730898221;
	bh=nsC7to/1djJ3cfoPEeOYkJCP4ggSum23nRZr+xnBIGk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QIQnwtYjdxyGOiAVEWvR8BQJ9PNNj/V4e8AioaTVzyXwh6FSlDW5p6ZHk1rWZmM4Q
	 42tK2I6py8B6pMfKjN1wKjjrAzoM2UwuYxYwni7EBPKdB95K/xb9j0dWEevwOX7l0Z
	 bCTlHEYGiw5X+Rj3w31EQEJj9TwLzM628968VoOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 166/462] USB: misc: yurex: fix race between read and write
Date: Wed,  6 Nov 2024 13:00:59 +0100
Message-ID: <20241106120335.622169468@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

[ Upstream commit 93907620b308609c72ba4b95b09a6aa2658bb553 ]

The write code path touches the bbu member in a non atomic manner
without taking the spinlock. Fix it.

The bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240912132126.1034743-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/yurex.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index a85cc0f3e15c4..5f271d25b633d 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -405,7 +405,6 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	struct usb_yurex *dev;
 	int len = 0;
 	char in_buffer[MAX_S64_STRLEN];
-	unsigned long flags;
 
 	dev = file->private_data;
 
@@ -418,9 +417,9 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
 		return -EIO;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
-	spin_unlock_irqrestore(&dev->lock, flags);
+	spin_unlock_irq(&dev->lock);
 	mutex_unlock(&dev->io_mutex);
 
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
@@ -510,8 +509,11 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
 			__func__, retval);
 		goto error;
 	}
-	if (set && timeout)
+	if (set && timeout) {
+		spin_lock_irq(&dev->lock);
 		dev->bbu = c2;
+		spin_unlock_irq(&dev->lock);
+	}
 	return timeout ? count : -EIO;
 
 error:
-- 
2.43.0



