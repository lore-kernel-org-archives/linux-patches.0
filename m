Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 556C01D0492;
	Tue, 15 Oct 2024 11:55:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728993348; cv=none; b=s6ZhMyqCS1uIt80LtvIykjhPxQQMmavLTLOAl7MRKNXjSCw3ja/gt78GSKci0vPwkvNn3zv1XFQL8jO3B2+y95qEf9dVJqjP1a1F6950dkkqjSjQu7WTD1hOL/aO/X2bP8sVHWKf+UVbdvxWCixFzhuSI0GGrvIBAqcYteYv/eU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728993348; c=relaxed/simple;
	bh=hKp+C7YYgCrrhu04519CImfKCcih16s57/5KEQpQegg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBCQGksncRym4TV6Bd0Iq0M7PJYMJVEWbxYXwhckimKkaD60F1xybih0eriRCFQQx+yCvIpQH68avuAjNEyyy9ZVRWCEXvwdnx0zYb9I7u/hrBhrHPk+QW/YiVFoP550tt8zLY2LigsxVTVwB5cdrIy/SQNwAeuN8ZTrh2Sr0SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RO0K90da; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RO0K90da"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0642C4CEC6;
	Tue, 15 Oct 2024 11:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728993348;
	bh=hKp+C7YYgCrrhu04519CImfKCcih16s57/5KEQpQegg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RO0K90dai7RWjtpUlddLyXGwAF7M1xy/R0NWdxQCap4Mc638IyVWfjkGVz0Y5LZl5
	 aZ7o3xgDJ8bOtBq31Vs8sFC9Xqw/wX1IrWnevpsbt9fS+QlMM9c5roQvTKLebIN2Ko
	 bT75wHQh6cys2c1NEsi6nqVRdOgYb2rWPa51pZ34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 353/691] USB: misc: yurex: fix race between read and write
Date: Tue, 15 Oct 2024 13:25:01 +0200
Message-ID: <20241015112454.356630155@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



