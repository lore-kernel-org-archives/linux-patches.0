Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7C11946B8;
	Wed,  5 Feb 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738767109; cv=none; b=DygasNyYUsNUPEBNMN/hWJoEnX3k0XJV7N8xZz+GGfYXy1skf+NjBZP+gfQdjyRN7JVr+0XXPWH74dOcBnbrmgyiEyIZGpe46qRbj+r6m/tg8Wvfk+7bRJaWPIq6+VAXe3uGntGzqmavwbf+KrHPC/J0Kr1oriKEu09DaH+Xsj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738767109; c=relaxed/simple;
	bh=X2r4fn6T8D36PkrDXV+a6OOMSpPdjPdkvipJAAzvCa0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7cp6g+PofVLjvTaRa+RzdhnKe/VysruRe6p0qbUxnuM95EafHLv4BJC31PUXcI4+os4NHJhs+oCjUOKZXX/wUHrQAMQJtBCygKGh4WgnDatlzDDK6GJOVCYJRVeNh7TGoscmGUSkX51RODuhr9ONUV6FVZcoW048yaa7LTbJH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NdFuiYW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NdFuiYW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24BEBC4CED1;
	Wed,  5 Feb 2025 14:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738767109;
	bh=X2r4fn6T8D36PkrDXV+a6OOMSpPdjPdkvipJAAzvCa0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NdFuiYW6yXEn5oKKPNvZqVfHE9YnKKpQaVJSYR2lK4CUmvs/yu63vNcigbP7PvsdJ
	 1povdNwfTCUaqBDEzJ00n68D6iMVS1rvgRylR1KvoAhNfaUVk/CF7pXuGcNWCsaxzm
	 Xl6j77TEb8GkXeLNnrRvJOE44R0MHIsNdfjXKSBs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 407/590] media: lmedm04: Handle errors for lme2510_int_read
Date: Wed,  5 Feb 2025 14:42:42 +0100
Message-ID: <20250205134510.839645226@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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
index 8a34e6c0d6a6d..f0537b741d135 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -373,6 +373,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	struct dvb_usb_device *d = adap_to_d(adap);
 	struct lme2510_state *lme_int = adap_to_priv(adap);
 	struct usb_host_endpoint *ep;
+	int ret;
 
 	lme_int->lme_urb = usb_alloc_urb(0, GFP_KERNEL);
 
@@ -390,11 +391,20 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 
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



