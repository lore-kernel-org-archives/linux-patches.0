Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F7333EA;
	Tue, 11 Mar 2025 15:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706625; cv=none; b=f34/U8n9uKim25RjdZp0hXsDl3e/3H4QNh7zXCH9x5h3/olwl/gSwlnJ2dy17MmbLiSIsnkFi/8BG87r8mVlN69wPiDUFS+1/xTRH1eN+XNi+c8nOwvxWnqzeBEx7O75h1hSx7ngtffAWyW2hTyta9NSi/oGzChQm/yNpvjD2OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706625; c=relaxed/simple;
	bh=1NxUMNJhOm2lYKPaqIuifd3lBgX2SHQThvb8s2COlYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mu/gIvMMPpM1GYBzUjg83CeTAfAwRyJuFPETe2oWY18CbxU7DQiBt6UGep/NjSzxyGzav9WcQhyIWun7D14aSeI/a7BdfORscoP46mc63Iq2T+QAJie9EzuRTltoIDYuvyCV4iMhhWQxzZ0LXjxvWfgNgYrel4+O2JCLPJYpQCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hE6H8eDD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hE6H8eDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27516C4CEE9;
	Tue, 11 Mar 2025 15:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706625;
	bh=1NxUMNJhOm2lYKPaqIuifd3lBgX2SHQThvb8s2COlYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hE6H8eDD1kGrZSoF4S19rE+mGxmZKHHbMQxtLQd7P2sOyKCdQ4MZxd1IjoIvR/L6L
	 NkD5FyDmPgZSf2V6SWiOrUTKXgfkUrazLkoOT1dbgWWlVZrXbLC9BYBxIF3sDxIPZl
	 QqJ823QKTiTeRd3wDTQ73W5+Xg/uAGaPkSdVO/Kg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/462] media: lmedm04: Handle errors for lme2510_int_read
Date: Tue, 11 Mar 2025 15:55:47 +0100
Message-ID: <20250311145801.552296909@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

From: Chen Ni <nichen@iscas.ac.cn>

[ Upstream commit a2836d3fe220220ff8c495ca9722f89cea8a67e7 ]

Add check for the return value of usb_pipe_endpoint() and
usb_submit_urb() in order to catch the errors.

Fixes: 15e1ce33182d ("[media] lmedm04: Fix usb_submit_urb BOGUS urb xfer, pipe 1 != type 3 in interrupt urb")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Link: https://lore.kernel.org/r/20240521091042.1769684-1-nichen@iscas.ac.cn
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 0f5a1eed5ea9f..b54eb5a083561 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -372,6 +372,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *lme_int = adap_to_priv(adap);
 	struct usb_host_endpoint *ep;
+	int ret;
 
 	lme_int->lme_urb = usb_alloc_urb(0, GFP_KERNEL);
 
@@ -389,11 +390,20 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 
 	/* Quirk of pipe reporting PIPE_BULK but behaves as interrupt */
 	ep = usb_pipe_endpoint(d->udev, lme_int->lme_urb->pipe);
+	if (!ep) {
+		usb_free_urb(lme_int->lme_urb);
+		return -ENODEV;
+	}
 
 	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
 		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa);
 
-	usb_submit_urb(lme_int->lme_urb, GFP_KERNEL);
+	ret = usb_submit_urb(lme_int->lme_urb, GFP_KERNEL);
+	if (ret) {
+		usb_free_urb(lme_int->lme_urb);
+		return ret;
+	}
+
 	info("INT Interrupt Service Started");
 
 	return 0;
-- 
2.39.5



