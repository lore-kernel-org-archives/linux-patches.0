Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 176182877FA;
	Tue, 22 Jul 2025 13:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192701; cv=none; b=hSatPlrrn+5l5l00mkp3kjf3pi3fyYpURoOSIBla6ucS5FU0d7qLR+mi27hTK5pF1875zPjaw6HG1v7qGL4ZXmn1MV77ClzVScMthRq7WPBQ3xwlSl52kmKGQSojBhlTYU8EC0rjBZ+Zs9DTODSM0KvIDEVqsffDDC+uhgqEBCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192701; c=relaxed/simple;
	bh=IrkJTQ1BPNLMQs4aqMwxIuyXMXMyOTKL+JyDRNMGo9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cSn8vLgF9AT2DDloNn+ztFmbqFlraCJxcgGUbbYxuoCyXIZi01E4uRcjUKRL2V7A0L8gDMyfvnI01YESMzE8/YwI1GSwp8l9+MyUTFFVG1sfhqBYopg8Atxy1M1k7Gk2Lw3T5qoGOPsRQCj+8HYLGPDry6OFceE05bv/6n2GL5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OqE+mp7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OqE+mp7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6C0C4CEEB;
	Tue, 22 Jul 2025 13:58:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192700;
	bh=IrkJTQ1BPNLMQs4aqMwxIuyXMXMyOTKL+JyDRNMGo9M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OqE+mp7whi7Ek1gLi1yw6RnEFSLbNZ8nDOkb+v1vx0V1CMSfFzjQg4GSYz9YtiUnu
	 yL8cv1xxB9S+N0YEocVfpRHYv6JNH4qZks/xXh+HTaVz2feJJ0JdxaWul2zX4cWA8Q
	 8z6mKcIp4VBRpEQN8gyToOGc3TL+bSK9ordNgl9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehowshua Immanuel <yehowshua.immanuel@twosixtech.com>,
	Drew Hamilton <drew.hamilton@zetier.com>
Subject: [PATCH 6.12 007/158] usb: musb: fix gadget state on disconnect
Date: Tue, 22 Jul 2025 15:43:11 +0200
Message-ID: <20250722134340.876733351@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/musb/musb_gadget.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1912,6 +1912,7 @@ static int musb_gadget_stop(struct usb_g
 	 * gadget driver here and have everything work;
 	 * that currently misbehaves.
 	 */
+	usb_gadget_set_state(g, USB_STATE_NOTATTACHED);
 
 	/* Force check of devctl register for PM runtime */
 	pm_runtime_mark_last_busy(musb->controller);
@@ -2018,6 +2019,7 @@ void musb_g_disconnect(struct musb *musb
 	case OTG_STATE_B_PERIPHERAL:
 	case OTG_STATE_B_IDLE:
 		musb_set_state(musb, OTG_STATE_B_IDLE);
+		usb_gadget_set_state(&musb->g, USB_STATE_NOTATTACHED);
 		break;
 	case OTG_STATE_B_SRP_INIT:
 		break;


