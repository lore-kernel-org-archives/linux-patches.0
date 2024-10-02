Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EB31CF7D4;
	Wed,  2 Oct 2024 14:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878755; cv=none; b=DeH6lWjNtn899QtdrkphIzgYfAmnupk9B1r4wz15Gstmh2uti1GUwQk+ItAG5bz/VVGOfzbTl9aUKtJIVvZNYg0EpBdbO8TyS9fBplsjpxWuoCmhSNM+VIdlOYF7L7KiYfF8yagKi+5KNblMXdWqjms6wjeUslFm2ov0Ipjyi/M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878755; c=relaxed/simple;
	bh=1KRMTPn5bdeTg0a8KxKjhGLdStyLBXMrbsTqdDlkt74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=giWi4PEkp1vmsMhEM3dYHBzXy7FW1umAP/S65dxofGQ5xb0kYOUNvE3m0Jic+Q1Apac71BOJ9WxtWdavv86/dWEeizRUWRdOfXej9UUyMlgarHpwdsLLoVL1UFkWZ7tOkaIeBdldM48hN86MxpVbD/FUTfF9D0eX4BawD9qnuYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3LGzErg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3LGzErg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28F9C4CEC2;
	Wed,  2 Oct 2024 14:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878755;
	bh=1KRMTPn5bdeTg0a8KxKjhGLdStyLBXMrbsTqdDlkt74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3LGzErgjQosWkcnMpkC+yNA8uddvvph0QT6rvZP4OHrDF02FAR6LxEek+kagcWMa
	 AomRuvtafVosY7JQWCD/0zYVOWt1INGNAYs2I+pXJaJpqM2nwdAuZEnZ9AGwOcv0qm
	 KAuizhE4aq1GSdFrlNHX+nTaln4xqCIHNXefNkY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>
Subject: [PATCH 6.10 522/634] USB: misc: yurex: fix race between read and write
Date: Wed,  2 Oct 2024 15:00:22 +0200
Message-ID: <20241002125831.710867399@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oliver Neukum <oneukum@suse.com>

commit 93907620b308609c72ba4b95b09a6aa2658bb553 upstream.

The write code path touches the bbu member in a non atomic manner
without taking the spinlock. Fix it.

The bug is as old as the driver.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
CC: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240912132126.1034743-1-oneukum@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/misc/yurex.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -404,7 +404,6 @@ static ssize_t yurex_read(struct file *f
 	struct usb_yurex *dev;
 	int len = 0;
 	char in_buffer[MAX_S64_STRLEN];
-	unsigned long flags;
 
 	dev = file->private_data;
 
@@ -419,9 +418,9 @@ static ssize_t yurex_read(struct file *f
 		return -EIO;
 	}
 
-	spin_lock_irqsave(&dev->lock, flags);
+	spin_lock_irq(&dev->lock);
 	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
-	spin_unlock_irqrestore(&dev->lock, flags);
+	spin_unlock_irq(&dev->lock);
 	mutex_unlock(&dev->io_mutex);
 
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
@@ -511,8 +510,11 @@ static ssize_t yurex_write(struct file *
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


