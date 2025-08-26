Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221BA2FC89C;
	Tue, 26 Aug 2025 14:29:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218544; cv=none; b=h4eAlTYPcMaMBV1xgkw1mA99xlN5q7knlqiY8hbrjWr1zzPdIvlluH491gboT/AkA9qoEnTa31f70qcMtm3XTyiK+voX7Fqy1zwWVaTQkXcFcN4VTD2yLnj9OaMoM6VXsqnKzNcckenf5ISM6uuWm/vue1H5sqCQZz1T9Lo3OZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218544; c=relaxed/simple;
	bh=3CDN/iTDGdSb7mnlWXzyoa6/xzmhg7zjEXr++NvRqQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3skOVfxe5fBqO6qoXt7I1lpHSBuOYjKxVHqA5BVr7mniowxyFsV/Q5kiIoJuTM9ivOQ0XeuzkfKVkW1mbFo0tejtLHI7nFdE3xFMjjVT4Fi356QpwK8WEVYawVmzkyKWrDYCpZT4Ao7+0hPQ3OBketH9xv3g52/kjs9xKGjN+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J2KUsB5e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J2KUsB5e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDA5C4CEF1;
	Tue, 26 Aug 2025 14:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218544;
	bh=3CDN/iTDGdSb7mnlWXzyoa6/xzmhg7zjEXr++NvRqQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J2KUsB5eXCDcSqXIaItXvp0JjWKq1vaJkQ48CeLd/rh7zPMg2SjpBMyaDVBDRpJkx
	 MW2j8WBc6DSGZpLLP6vhXJ3D94z01l111HwZLke9oWeKjnAhL1lmQzaTFzKMAQbTQu
	 cKdRiO6iu6hziTSUlfIEWROz1PIFHbpNPMukFSm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>,
	Drew Hamilton <drew.hamilton@zetier.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 040/403] usb: musb: fix gadget state on disconnect
Date: Tue, 26 Aug 2025 13:06:06 +0200
Message-ID: <20250826110906.923920683@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
[ replaced musb_set_state() call with direct otg state assignment ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1910,6 +1910,7 @@ static int musb_gadget_stop(struct usb_g
 	 * gadget driver here and have everything work;
 	 * that currently misbehaves.
 	 */
+	usb_gadget_set_state(g, USB_STATE_NOTATTACHED);
 
 	/* Force check of devctl register for PM runtime */
 	schedule_delayed_work(&musb->irq_work, 0);
@@ -2018,6 +2019,7 @@ void musb_g_disconnect(struct musb *musb
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_IDLE:
 		musb->xceiv->otg->state = OTG_STATE_B_IDLE;
+		usb_gadget_set_state(&musb->g, USB_STATE_NOTATTACHED);
 		break;
 	case OTG_STATE_B_SRP_INIT:
 		break;


