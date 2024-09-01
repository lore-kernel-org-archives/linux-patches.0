Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD621E87B;
	Sun,  1 Sep 2024 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209924; cv=none; b=MWduTcegYz4TCb+3J+aBoLuwKvwlwj2wzwxI7At2Z7aFYG5/AFgK6N5v6UNo5Qd/4/5LI2IT1Kb0DC1JQdIDBX+FtPjMXpddVirOESIxDdL2ning/pCAlnSUOvWpNWEGnIkLtf6BfVbRul4ttQL6qPuWL9u2Y8LXsVhhLecl/C4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209924; c=relaxed/simple;
	bh=jHevElhDfFwhCGrGRKjVGnT5Opj0rb07S3JIBDXiMY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akW84m7nuLh/n2jK4/CTk2aPmCqL73F/SqA1NMOTmFRTAAuLkoxqbIYIyQXH1R7FvmugjhjMKQi0X9/O1YRAp8UUuEk9xvf4KqbW3ZrQlY0P521rZcHV3kbV/paWCrHggcXXrUBEclqDvwBhuRBAyf2aJtQ+fQGvXTLpf87owcE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i2FPHFSm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i2FPHFSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A744EC4CEC3;
	Sun,  1 Sep 2024 16:58:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209924;
	bh=jHevElhDfFwhCGrGRKjVGnT5Opj0rb07S3JIBDXiMY4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i2FPHFSmTjSh6bXzN+zLcUvPVQwcVLU+1iCZA/JHTp/luIvRoD/IsOYfjNHwCATNC
	 w9iO5cx2c7kgVrWj01UAHBps2HIL3fV+dujalsE6RyLvmuofJCpQ/nmgtPPb/ehcA9
	 C4z54fPVLzhiQLl7UsPtPfRkkhMVzygb1J3BwC3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+eac39cba052f2e750dbe@syzkaller.appspotmail.com,
	stable <stable@kernel.org>,
	Eli Billauer <eli.billauer@gmail.com>
Subject: [PATCH 5.15 004/215] char: xillybus: Check USB endpoints when probing device
Date: Sun,  1 Sep 2024 18:15:16 +0200
Message-ID: <20240901160823.404189556@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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
@@ -1889,6 +1889,13 @@ static const struct file_operations xill
 
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
@@ -1918,14 +1925,15 @@ static int setup_channels(struct xillyus
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
@@ -1954,6 +1962,15 @@ static int setup_channels(struct xillyus
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
@@ -1963,6 +1980,7 @@ static int setup_channels(struct xillyus
 		}
 	}
 
+	xdev->channels = new_channels;
 	return 0;
 }
 


