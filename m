Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AB19F40B;
	Mon, 14 Oct 2024 15:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918524; cv=none; b=op69Fu+iG3V3k+Nihs9ygWwSZ71U1jZ7E6CaXmVcoBnQpGV73x/KVdvXgrf4OojURyGLJxS695J1x4aW/2BFYvWU3d2Ikx1QfrcHfIY3c/ZOzcweuWc48D7qyImSlhSl1CY8fviyQWN+iNX0E8JRi8PWh/3VCoG9ZePwI8HtAb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918524; c=relaxed/simple;
	bh=kBOAmqPfeeatyyBh22JEwYtcCg5A+i2vzCkq+2EQw9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fz77jmL9kt5kflfm7+GOjuASYtIdqC9qWpBsM5gK89Foo35TxiFMDJMAE+i7lFiXiwiGGLm9iMdGaLcqo0OP7SVlzkmlRtxu+TmriJz3gA2e1afcBgpmaCe6BvyAQxsd45Kepy/Mvfid1y7o79OMMeqjA0cx8z9jBYnVt3xBVOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azTTYTxn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azTTYTxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFB72C4CECF;
	Mon, 14 Oct 2024 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918524;
	bh=kBOAmqPfeeatyyBh22JEwYtcCg5A+i2vzCkq+2EQw9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azTTYTxn0nYr/OgHX39BwgghNELqUQuj7HN6hvsF7FBrN29ClklsZyUUpbUV88n5J
	 k45k7pwIcMZBsY/OC7RLUrjDNdqMyzGcDbF3A95klaOWFV5r+AVKM9EnbLXnBeA5iW
	 +6SqgkFBVk9owLzahevrsMjASHGeh+KVwwThzAZg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 347/798] USB: misc: yurex: fix race between read and write
Date: Mon, 14 Oct 2024 16:15:01 +0200
Message-ID: <20241014141231.580734098@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 5a13cddace0e6..44136989f6c6a 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -404,7 +404,6 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	struct usb_yurex *dev;
 	int len = 0;
 	char in_buffer[MAX_S64_STRLEN];
-	unsigned long flags;
 
 	dev = file->private_data;
 
@@ -417,9 +416,9 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
 		return -EIO;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
-	spin_unlock_irqrestore(&dev->lock, flags);
+	spin_unlock_irq(&dev->lock);
 	mutex_unlock(&dev->io_mutex);
 
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
@@ -509,8 +508,11 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
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



