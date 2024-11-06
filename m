Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2E91D416E;
	Wed,  6 Nov 2024 12:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730895163; cv=none; b=OHu6oSefNtCwC7sxCIZXxwXiaUud0VRp3fVdRcZbwJBbX76L6k/bQ1WD3dETv1QvR0TFuilJBmVnF9IYZl7LtvKt2sTJDg+4sd3U0S8cCIEkFyxRWv48q7AW7e853hGNs+7VM4h/+OvebZqAhfeDV02iLiPsecYfLPHCb3P47EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730895163; c=relaxed/simple;
	bh=Ugnl2BH71lLiFmSZw8LGf3h8DgyGH2mjy7rurshcDk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X4jfZ4ZmSzn5otdKOUb7E7PX5ivD5OrmtcNNMfWRktZkyC/lX4PdJBW53fpf/hoRwUiVXmc72YyPvF440BZAl9qHQUQWMxUc3ND8HJR5zkri0NpN2fLYMaHlGLLD04qUH5+e5LBZHca3dWbhXX/449hIZ0Ea7+/65HnmTwC0XaE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0UmV5RXW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0UmV5RXW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43D8AC4CECD;
	Wed,  6 Nov 2024 12:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730895163;
	bh=Ugnl2BH71lLiFmSZw8LGf3h8DgyGH2mjy7rurshcDk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0UmV5RXWkV02MtHp0xTPO1ef0qcvZihGWn6mbh39kyrwKKJJygt1dGcO1K8HreDa0
	 8LU/e8e3T2UoBV7xk5O06tGyHtpyQ8OH4xsidoOEDkJlkctTEhiimERBoIkt6cMGeE
	 COpGgHgYlgnXIRxXYfzho1/3tGP1Tk6GlG8fFehw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 125/350] usb: yurex: Replace snprintf() with the safer scnprintf() variant
Date: Wed,  6 Nov 2024 13:00:53 +0100
Message-ID: <20241106120323.995986208@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lee Jones <lee@kernel.org>

[ Upstream commit 86b20af11e84c26ae3fde4dcc4f490948e3f8035 ]

There is a general misunderstanding amongst engineers that {v}snprintf()
returns the length of the data *actually* encoded into the destination
array.  However, as per the C99 standard {v}snprintf() really returns
the length of the data that *would have been* written if there were
enough space for it.  This misunderstanding has led to buffer-overruns
in the past.  It's generally considered safer to use the {v}scnprintf()
variants in their place (or even sprintf() in simple cases).  So let's
do that.

Whilst we're at it, let's define some magic numbers to increase
readability and ease of maintenance.

Link: https://lwn.net/Articles/69419/
Link: https://github.com/KSPP/linux/issues/105
Cc: Tomoki Sekiyama <tomoki.sekiyama@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20231213164246.1021885-9-lee@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 93907620b308 ("USB: misc: yurex: fix race between read and write")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/misc/yurex.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/usb/misc/yurex.c b/drivers/usb/misc/yurex.c
index 08b72bb22b7ef..a85cc0f3e15c4 100644
--- a/drivers/usb/misc/yurex.c
+++ b/drivers/usb/misc/yurex.c
@@ -34,6 +34,8 @@
 #define YUREX_BUF_SIZE		8
 #define YUREX_WRITE_TIMEOUT	(HZ*2)
 
+#define MAX_S64_STRLEN 20 /* {-}922337203685477580{7,8} */
+
 /* table of devices that work with this driver */
 static struct usb_device_id yurex_table[] = {
 	{ USB_DEVICE(YUREX_VENDOR_ID, YUREX_PRODUCT_ID) },
@@ -402,7 +404,7 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 {
 	struct usb_yurex *dev;
 	int len = 0;
-	char in_buffer[20];
+	char in_buffer[MAX_S64_STRLEN];
 	unsigned long flags;
 
 	dev = file->private_data;
@@ -413,14 +415,14 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 		return -ENODEV;
 	}
 
+	if (WARN_ON_ONCE(dev->bbu > S64_MAX || dev->bbu < S64_MIN))
+		return -EIO;
+
 	spin_lock_irqsave(&dev->lock, flags);
-	len = snprintf(in_buffer, 20, "%lld\n", dev->bbu);
+	scnprintf(in_buffer, MAX_S64_STRLEN, "%lld\n", dev->bbu);
 	spin_unlock_irqrestore(&dev->lock, flags);
 	mutex_unlock(&dev->io_mutex);
 
-	if (WARN_ON_ONCE(len >= sizeof(in_buffer)))
-		return -EIO;
-
 	return simple_read_from_buffer(buffer, count, ppos, in_buffer, len);
 }
 
-- 
2.43.0



