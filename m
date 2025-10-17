Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F3F330B17;
	Fri, 17 Oct 2025 15:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716078; cv=none; b=HsQ63uOdIBIHyzhvsVI5fRat5KdgYbEh75JKRJzXvcvz39IWRy57jzhKZgfNSe8cihkwp9Gx6WpsaLPOJcETryfKbYQerXNi1vMWd27BAV31UwXLokC1zMRHsKcteyy7XiSmOg0jfpIxyegzrQH+AyutJ3LnBLDlcpzrn0Ay308=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716078; c=relaxed/simple;
	bh=5+OEJQd3bQDcuc7HkXF3tbOhh5r73lC2QSlfoZ5h0jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uI8ANSamNRYRTY92hIAJRuVy6d/5Q5SZCZeqYF42uisgnvURn+ZYCCQHzMVHcMgXEMW1SXQ5As2+s/5uirNi3Hi0VKbD5alxUeOPAsa6lRZpWsklppVrMNBzQJsdk312Ee4xxjpojIqjPS/gNMchHwHy/5/uduri6tadOl/0bOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hW1alKUy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hW1alKUy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A039FC116B1;
	Fri, 17 Oct 2025 15:47:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716078;
	bh=5+OEJQd3bQDcuc7HkXF3tbOhh5r73lC2QSlfoZ5h0jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hW1alKUyDwhQmLvnx6zIlNVdFdHfOPXD1SaG0IfRu0Yx67pClDpAknLEFVyYWOSM3
	 xsdE5l9BlZ/JKT8T7hpNnnZwv6HiayDs5aknqb04eFpZne5IVxTMjwsV1AGhhGurbJ
	 hA6Bbx8kg9+6sobR8/PB9kiOSEXXcOG1No/FNsFQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Wu <william.wu@rock-chips.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 065/276] usb: gadget: configfs: Correctly set use_os_string at bind
Date: Fri, 17 Oct 2025 16:52:38 +0200
Message-ID: <20251017145144.862152054@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

From: William Wu <william.wu@rock-chips.com>

[ Upstream commit e271cc0d25015f4be6c88bd7731444644eb352c2 ]

Once the use_os_string flag is set to true for some functions
(e.g. adb/mtp) which need to response the OS string, and then
if we re-bind the ConfigFS gadget to use the other functions
(e.g. hid) which should not to response the OS string, however,
because the use_os_string flag is still true, so the usb gadget
response the OS string descriptor incorrectly, this can cause
the USB device to be unrecognizable on the Windows system.

An example of this as follows:

echo 1 > os_desc/use
ln -s functions/ffs.adb configs/b.1/function0
start adbd
echo "<udc device>" > UDC   #succeed

stop adbd
rm configs/b.1/function0
echo 0 > os_desc/use
ln -s functions/hid.gs0 configs/b.1/function0
echo "<udc device>" > UDC  #fail to connect on Windows

This patch sets the use_os_string flag to false at bind if
the functions not support OS Descriptors.

Signed-off-by: William Wu <william.wu@rock-chips.com>
Fixes: 87213d388e92 ("usb: gadget: configfs: OS String support")
Link: https://lore.kernel.org/r/1755833769-25434-1-git-send-email-william.wu@rock-chips.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/configfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/gadget/configfs.c b/drivers/usb/gadget/configfs.c
index 6423930b0e72e..9a3de907de696 100644
--- a/drivers/usb/gadget/configfs.c
+++ b/drivers/usb/gadget/configfs.c
@@ -1364,6 +1364,8 @@ static int configfs_composite_bind(struct usb_gadget *gadget,
 		cdev->use_os_string = true;
 		cdev->b_vendor_code = gi->b_vendor_code;
 		memcpy(cdev->qw_sign, gi->qw_sign, OS_STRING_QW_SIGN_LEN);
+	} else {
+		cdev->use_os_string = false;
 	}
 
 	if (gadget_is_otg(gadget) && !otg_desc[0]) {
-- 
2.51.0



