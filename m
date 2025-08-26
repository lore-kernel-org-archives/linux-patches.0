Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EAC034F490;
	Tue, 26 Aug 2025 14:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217187; cv=none; b=DirVfg+kk/2/zgJOYcSYDkmaYnl10brSUfVKsySUh9Z8rZit+U+UdG+ECWKya6gBUVEsO4E3QtYjcQMU/n2FD17DEXeeE5VRnxsMB5YGCu8vZozWMKyhG57ktHQAovpMfW26ccVXeaxIi8inC0cI1gf4oevHEfM8VSgVAe8oia0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217187; c=relaxed/simple;
	bh=rC8VEThPR/J6QZDGDfTZQiz4oQfMhKmis8TPuFkCNx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G0AdSAjp9lPMopPH9vdQlWUtX1IQ77jxbwOBw7NVMDyd6CHk2wK/zauv91yuJyhR+ARp6o4MnoqhdwIbRBPJGUSbLO6lAWJKXq1AlWhXCy+h+Pv6HB7c5fjrdy+a1u1tv+1U1sLtndq1YdA4zSF1g/xbqZmGCTzMAQhT02Jr/Ws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vlXv1Nca; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vlXv1Nca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE693C116B1;
	Tue, 26 Aug 2025 14:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217187;
	bh=rC8VEThPR/J6QZDGDfTZQiz4oQfMhKmis8TPuFkCNx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vlXv1NcaHfQ5IEYn4mngxxDKLA5QHQtEvwxSJ34ad4IPZaM/oFX94GLBmF2OgXlrS
	 8yriMh1i/58GE4Tn6peZaxaanPXWMB62sbrjTwmWnUa4GrwTn/4AhWX+lEcb3r+g6f
	 4Sa1BnPLY9ngC3mvl1cVzwWSUErVoLVtXc7J5l1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>,
	Drew Hamilton <drew.hamilton@zetier.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/523] usb: musb: fix gadget state on disconnect
Date: Tue, 26 Aug 2025 13:04:19 +0200
Message-ID: <20250826110925.809061287@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Drew Hamilton <drew.hamilton@zetier.com>

commit 67a59f82196c8c4f50c83329f0577acfb1349b50 upstream.

When unplugging the USB cable or disconnecting a gadget in usb peripheral mode with
echo "" > /sys/kernel/config/usb_gadget/<your_gadget>/UDC,
/sys/class/udc/musb-hdrc.0/state does not change from USB_STATE_CONFIGURED.

Testing on dwc2/3 shows they both update the state to USB_STATE_NOTATTACHED.

Add calls to usb_gadget_set_state in musb_g_disconnect and musb_gadget_stop
to fix both cases.

Fixes: 49401f4169c0 ("usb: gadget: introduce gadget state tracking")
Cc: stable@vger.kernel.org
Co-authored-by: Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>
Signed-off-by: Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>
Signed-off-by: Drew Hamilton <drew.hamilton@zetier.com>
Link: https://lore.kernel.org/r/20250701154126.8543-1-drew.hamilton@zetier.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1909,6 +1909,7 @@ static int musb_gadget_stop(struct usb_g
 	 * gadget driver here and have everything work;
 	 * that currently misbehaves.
 	 */
+	usb_gadget_set_state(g, USB_STATE_NOTATTACHED);
 
 	/* Force check of devctl register for PM runtime */
 	schedule_delayed_work(&musb->irq_work, 0);
@@ -2017,6 +2018,7 @@ void musb_g_disconnect(struct musb *musb
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_IDLE:
 		musb_set_state(musb, OTG_STATE_B_IDLE);
+		usb_gadget_set_state(&musb->g, USB_STATE_NOTATTACHED);
 		break;
 	case OTG_STATE_B_SRP_INIT:
 		break;


