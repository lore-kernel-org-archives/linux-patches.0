Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A6A1F0E36;
	Tue, 21 Jan 2025 18:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482901; cv=none; b=Mei8azlI8x7Pz8JMwzFA4V7YzN0Xl2ir5RY11tsk+y0OO36zuf1Dt4OqHIEb20X6Hp7EylAPGl+YCtiOASuwvXlOLSTxIpfbVQlq8uhkYK8VTj0ZSkxnyRE0b6zrGNolsffS/7ZmOw/KsxyflOfQrT0nUh1519PDLBZ9mUMe9oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482901; c=relaxed/simple;
	bh=AFOo5YpIP/XQMWoTi/2JABjsBOX/GAUBAehReRU12BE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RQyJqxsd/i/m1GqLS5x/i3/TTlbKe96RiToJe3Q+SKgTBrjvxne/WcH3hNJRvmD1lc3ONaJgVn2nQYd0Ie+TFXMy0C4uyi66DXNbnLOSUdoZkoH/EDu11MFRIc9Ft67AqbrfHNsiBV2JyOe+IbYOgtpuqAuEvGuLn/mxR6rzLGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+0ZrTvr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+0ZrTvr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6951C4CEE0;
	Tue, 21 Jan 2025 18:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482901;
	bh=AFOo5YpIP/XQMWoTi/2JABjsBOX/GAUBAehReRU12BE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B+0ZrTvr/Q+3jKt+v7/Np67Ee4jGzhGCjakCVAeHsfGcerHeE6I6ekRGJS4qCsp89
	 oS6xFYUkl/RJLhbdR59dd9x6+L9crSLrXWN55Wwpp9TiBdGUSUXsFU7UCSmUdiU+9g
	 nkSP2bvWxFWTH0z+VsAhftVLnIw7AZQhka4zf9sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Yan <jerrysteve1101@gmail.com>
Subject: [PATCH 5.15 048/127] USB: usblp: return error when setting unsupported protocol
Date: Tue, 21 Jan 2025 18:52:00 +0100
Message-ID: <20250121174531.525247534@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jun Yan <jerrysteve1101@gmail.com>

commit 7a3d76a0b60b3f6fc3375e4de2174bab43f64545 upstream.

Fix the regression introduced by commit d8c6edfa3f4e ("USB:
usblp: don't call usb_set_interface if there's a single alt"),
which causes that unsupported protocols can also be set via
ioctl when the num_altsetting of the device is 1.

Move the check for protocol support to the earlier stage.

Fixes: d8c6edfa3f4e ("USB: usblp: don't call usb_set_interface if there's a single alt")
Cc: stable <stable@kernel.org>
Signed-off-by: Jun Yan <jerrysteve1101@gmail.com>
Link: https://lore.kernel.org/r/20241212143852.671889-1-jerrysteve1101@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/class/usblp.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/usb/class/usblp.c
+++ b/drivers/usb/class/usblp.c
@@ -1337,11 +1337,12 @@ static int usblp_set_protocol(struct usb
 	if (protocol < USBLP_FIRST_PROTOCOL || protocol > USBLP_LAST_PROTOCOL)
 		return -EINVAL;
 
+	alts = usblp->protocol[protocol].alt_setting;
+	if (alts < 0)
+		return -EINVAL;
+
 	/* Don't unnecessarily set the interface if there's a single alt. */
 	if (usblp->intf->num_altsetting > 1) {
-		alts = usblp->protocol[protocol].alt_setting;
-		if (alts < 0)
-			return -EINVAL;
 		r = usb_set_interface(usblp->dev, usblp->ifnum, alts);
 		if (r < 0) {
 			printk(KERN_ERR "usblp: can't set desired altsetting %d on interface %d\n",


