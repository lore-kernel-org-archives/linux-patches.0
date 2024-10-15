Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F31271CFEA9;
	Tue, 15 Oct 2024 13:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997683; cv=none; b=JECo8bqvM8Um3ul1ra56ML77PQ+ucVFngdNr6J92f20xJ4TWal6aFHuArKb5a0j6IKWMpvqS2a1RAl5FINMyaUZWn+876WeUwOgK6krFfZI+FXz1cajNPqAGjTAEzTYvpfJjEZ27yhEAitxDicg0KALvunH8vFtoJwWYq3+U6l0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997683; c=relaxed/simple;
	bh=USE0kV8bRdCBv9wtU0QS4hm5riYfdaZUvyvhhx+v76E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BT2w+wLoLc0PhZPNJn4E0eIDKGNdEO4VYWW03YeixLbmh4diaFJwbt3Y/S1OXXLigsUX9NYVqJl4AqGhz6/pa0/4mk9yuA78d+dAuHGz+IqRGiVtaBS/2nzRxv8iiC5sUB487/t8DBSb5MJ7KofAIfH/BeGXfqmx3UTCk/H9YhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0g8q5L0r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0g8q5L0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B77FC4CEC6;
	Tue, 15 Oct 2024 13:08:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997682;
	bh=USE0kV8bRdCBv9wtU0QS4hm5riYfdaZUvyvhhx+v76E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0g8q5L0r6HanDpDmc3oKVazhCgu6XLa9PjVObF78AI7/c2ju7dcwDg0bWNAyQu7bx
	 2mH39ans8v9jZ7l5/HoOdG64zJTOfi+/AgPQg6U08esVMU4maBBNpK+ulWaNBLJz0Z
	 EnzO1Mi3hMIxjXY98NxwY+N5k42MS8cRjBYzfgXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 254/518] USB: misc: yurex: fix race between read and write
Date: Tue, 15 Oct 2024 14:42:38 +0200
Message-ID: <20241015123926.795308635@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 62bd302e8bb71..494db0178c1e1 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -403,7 +403,6 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	struct usb_yurex *dev;
 	int len = 0;
 	char in_buffer[MAX_S64_STRLEN];
-	unsigned long flags;
 
 	dev = file->private_data;
 
@@ -416,9 +415,9 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
 		return -EIO;
 
-	spin_lock_irqsave(&dev->lock, flags);
+	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
-	spin_unlock_irqrestore(&dev->lock, flags);
+	spin_unlock_irq(&dev->lock);
 	mutex_unlock(&dev->io_mutex);
 
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
@@ -508,8 +507,11 @@ static ssize_t yurex_write(struct file *file, const char __user *user_buffer,
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



