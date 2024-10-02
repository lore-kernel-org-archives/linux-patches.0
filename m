Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20D0763CB;
	Wed,  2 Oct 2024 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727880513; cv=none; b=mlXTxV8N+lDX8u/Z5pX4Xw5mdzSnMk4kWe+nuzIS/ugDPFFQu28WTiiortRGYZmA2SnR06pQRjDWnlecFPvxlrZIBSXul3EtXfwWKWmOjMS+1MO9aAMfAVADg0RWfEPdqYsq7wLbemrYZVOsVk96L5RacRpdlNabCart5WKjzu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727880513; c=relaxed/simple;
	bh=UaXoDjYuSFXr93BmOtBbGnA/ymjtpsajw6roOfc6Ec8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eP+yq77yGAEpGOyhz3xfe1F0rUfpK2BaE2Bow+w8kiKVwBTrlRKYz5wFDxVNDpjiPhSGZiWP6pSlZZBfqRHXS9gyqaobVxgzICfFYUrAmZ/ukCUjOl8jbSVpHn1QpX7fwK+EO8Rfr48LAazCIj2cbnd9gFRmpzSn0BZ0X/axKCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j43q3l9J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j43q3l9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37BA2C4CEC2;
	Wed,  2 Oct 2024 14:48:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727880512;
	bh=UaXoDjYuSFXr93BmOtBbGnA/ymjtpsajw6roOfc6Ec8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j43q3l9JaS61MB1xnvIeDhJofsNg2KyJa5WOPLLt/rTmaQnL63b+tII22cKMEl8DH
	 pxzOyyUCUQ69GNtMGQL61vRKJ975IP79n4kBhObHKAYxfiboVMf5nuPxAxFtCOiHHd
	 IGbP4KqKaPRpGppErdL0RievqYi2jwCRVpcpx7AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomoki Sekiyama <tomoki.sekiyama@gmail.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 485/538] usb: yurex: Replace snprintf() with the safer scnprintf() variant
Date: Wed,  2 Oct 2024 15:02:04 +0200
Message-ID: <20241002125811.586119169@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125751.964700919@linuxfoundation.org>
References: <20241002125751.964700919@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index c640f98d20c54..5a13cddace0e6 100644
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
@@ -401,7 +403,7 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
 {
 	struct usb_yurex *dev;
 	int len = 0;
-	char in_buffer[20];
+	char in_buffer[MAX_S64_STRLEN];
 	unsigned long flags;
 
 	dev = file->private_data;
@@ -412,14 +414,14 @@ static ssize_t yurex_read(struct file *file, char __user *buffer, size_t count,
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



