Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37C1A248BCB;
	Wed, 15 Jan 2025 10:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938312; cv=none; b=r4o8wmL+xkM+HXus+1UBsUTjaYzQ5OLZJPUJBSsL2e399qpUAcZqi2Eo3qgYyxx+mikB4f/jkH4eJl56nZI6gZWTkM90GL0FHh5lANz3ZZgi5MxkUKj1PkdwCyBPhQgz7BqGbwVrdhm5FaUkJWBjpX/uya3yzdvu0C/LfHKiFmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938312; c=relaxed/simple;
	bh=i/+x/HEVQCKj93uYJAkv4y4yBypMQGb6lG0Vlk7a+KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WyZFaiDmrOmOuygXteZDls6qjmWFu7XTXK/beMI0tzgf4w20R8U8ugsJwdtB9G+Hj5Y7f+ryuwo+5d6bPCjX98rWZM/5GAg/XD0ongf4/4pyfm/7kgrmH2B2fnPkA163DAqGjD5GVMTPgbR8chtfTuuiBd4FNY/yqpKefPPcfsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TT0tHKnc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TT0tHKnc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A34C4CEDF;
	Wed, 15 Jan 2025 10:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938312;
	bh=i/+x/HEVQCKj93uYJAkv4y4yBypMQGb6lG0Vlk7a+KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TT0tHKnconU36QXDDJMLHQC7o1vqJOHOshW6BLlvBQC3D0Izt2ljKllwwLY+PoREG
	 ySRnJdVJZQt7qLR3tIzGF50Bv1+QT+3CWbQmDy4zaHTE719lBjzEJm8t0i3QWvpjGN
	 mdjaYXXgPlt5jhEHf/yIXf+huGGzKegsfv2d/BnU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Jun Yan <jerrysteve1101@gmail.com>
Subject: [PATCH 6.12 145/189] USB: usblp: return error when setting unsupported protocol
Date: Wed, 15 Jan 2025 11:37:21 +0100
Message-ID: <20250115103612.207525135@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


