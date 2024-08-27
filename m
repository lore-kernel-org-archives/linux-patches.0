Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8601494AC;
	Tue, 27 Aug 2024 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724769698; cv=none; b=GejqQYSWbNusCx5AjUuOBWPAqIDzf7/EQA1aI5KE0lhb0xeKZVrwbeOQY7bmHU+yoSllJrjTBWP+bj6LJ9dByuRnUuybkJ4/SzGGsevDtvKwsDqSOCBHhtetPVbKJACUFM+qTHzCQ8HW/yQKBVKJo5oU0OhoWfSNp3VpyCGiq2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724769698; c=relaxed/simple;
	bh=a70w3VvkHA3REk9KiobLXLu4EsHpONrPE2AjrdPpzDg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sja9bq6NZ9llETXlQyPlYB/8pj5OiRm2TnzmdqMamgmlU79vlualIqQn4JP7ZcKoFWTDDa5htL5ufedbX3juNxfolkD9YJkgkEj1EB3UKNamCXlR4XILsptB6Z/gBMtMdufXX7beHqu+pjNiKVUhC7i+2rYj8IMrEsZgSJzolBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MjB2cUkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MjB2cUkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD866C6107F;
	Tue, 27 Aug 2024 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724769698;
	bh=a70w3VvkHA3REk9KiobLXLu4EsHpONrPE2AjrdPpzDg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MjB2cUkn+pbfktXJl0Gr+G//kPuxAtpU6ND1W83v5cs4F4FbfJJVneaBha8LJs3WY
	 pAswaBviilfIAOOAXl5+FYAsmFra79GAvi0rLaLp9iq7Mb1rFB9+5WSaHUop2/KKSw
	 nmPaMOTF9xGc6EZBJCcsHHoF7IAbx/5okC76TUl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eac39cba052f2e750dbe@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 6.6 010/341] char: xillybus: Check USB endpoints when probing device
Date: Tue, 27 Aug 2024 16:34:01 +0200
Message-ID: <20240827143843.797468683@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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

From: Eli Billauer <eli.billauer@gmail.com>

commit 2374bf7558de915edc6ec8cb10ec3291dfab9594 upstream.

Ensure, as the driver probes the device, that all endpoints that the
driver may attempt to access exist and are of the correct type.

All XillyUSB devices must have a Bulk IN and Bulk OUT endpoint at
address 1. This is verified in xillyusb_setup_base_eps().

On top of that, a XillyUSB device may have additional Bulk OUT
endpoints. The information about these endpoints' addresses is deduced
from a data structure (the IDT) that the driver fetches from the device
while probing it. These endpoints are checked in setup_channels().

A XillyUSB device never has more than one IN endpoint, as all data
towards the host is multiplexed in this single Bulk IN endpoint. This is
why setup_channels() only checks OUT endpoints.

Reported-by: syzbot+eac39cba052f2e750dbe@syzkaller.appspotmail.com
Cc: stable <stable@kernel.org>
Closes: https://lore.kernel.org/all/0000000000001d44a6061f7a54ee@google.com/T/
Fixes: a53d1202aef1 ("char: xillybus: Add driver for XillyUSB (Xillybus variant for USB)").
Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
Link: https://lore.kernel.org/r/20240816070200.50695-2-eli.billauer@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/xillybus/xillyusb.c |   22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

--- a/drivers/char/xillybus/xillyusb.c
+++ b/drivers/char/xillybus/xillyusb.c
@@ -1903,6 +1903,13 @@ static const struct file_operations xill
 
 static int xillyusb_setup_base_eps(struct xillyusb_dev *xdev)
 {
+	struct usb_device *udev = xdev->udev;
+
+	/* Verify that device has the two fundamental bulk in/out endpoints */
+	if (usb_pipe_type_check(udev, usb_sndbulkpipe(udev, MSG_EP_NUM)) ||
+	    usb_pipe_type_check(udev, usb_rcvbulkpipe(udev, IN_EP_NUM)))
+		return -ENODEV;
+
 	xdev->msg_ep = endpoint_alloc(xdev, MSG_EP_NUM | USB_DIR_OUT,
 				      bulk_out_work, 1, 2);
 	if (!xdev->msg_ep)
@@ -1932,14 +1939,15 @@ static int setup_channels(struct xillyus
 			  __le16 *chandesc,
 			  int num_channels)
 {
-	struct xillyusb_channel *chan;
+	struct usb_device *udev = xdev->udev;
+	struct xillyusb_channel *chan, *new_channels;
 	int i;
 
 	chan = kcalloc(num_channels, sizeof(*chan), GFP_KERNEL);
 	if (!chan)
 		return -ENOMEM;
 
-	xdev->channels = chan;
+	new_channels = chan;
 
 	for (i = 0; i < num_channels; i++, chan++) {
 		unsigned int in_desc = le16_to_cpu(*chandesc++);
@@ -1968,6 +1976,15 @@ static int setup_channels(struct xillyus
 		 */
 
 		if ((out_desc & 0x80) && i < 14) { /* Entry is valid */
+			if (usb_pipe_type_check(udev,
+						usb_sndbulkpipe(udev, i + 2))) {
+				dev_err(xdev->dev,
+					"Missing BULK OUT endpoint %d\n",
+					i + 2);
+				kfree(new_channels);
+				return -ENODEV;
+			}
+
 			chan->writable = 1;
 			chan->out_synchronous = !!(out_desc & 0x40);
 			chan->out_seekable = !!(out_desc & 0x20);
@@ -1977,6 +1994,7 @@ static int setup_channels(struct xillyus
 		}
 	}
 
+	xdev->channels = new_channels;
 	return 0;
 }
 


