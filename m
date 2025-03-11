Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9B7A25D918;
	Tue, 11 Mar 2025 15:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706622; cv=none; b=QwJ7hw/8hE7F1gAjq7jZkZkzXgKVABF9G4iSIUXWHYvse2UCHu2e+rQ6Si05zGeA372eFHarDBa2YJWcX2oLfato7TGiepOXeYWmoIFdF6+HX11HBRs6EOuNu+OEJRd4FqoZ1HNK9X4Lr3bLSmFRSnLhjX9qGVrmb3KcszOE/zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706622; c=relaxed/simple;
	bh=aSR7b1lRxsO5T1gTT6rb/rNVRRIyvOej+5udk4lYq94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fX64BCj+TZ5kh//TjY2sXrJqaPTaMorc79a1VJSmUPnhsRf6G2npvwapNY9FLaz4gT8bmrfE7oUbJ8EeMeSDkBmcR8aF0hZ+244SyVEEolgvEEfVEch7PerYwCXYhnNzko1jBtLDFMJpE1rB4zdn39AnZ2BvfCh7T5ni34HTB+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ja6cUwNO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ja6cUwNO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36167C4CEE9;
	Tue, 11 Mar 2025 15:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706622;
	bh=aSR7b1lRxsO5T1gTT6rb/rNVRRIyvOej+5udk4lYq94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ja6cUwNOtkswsrTKVfz7alcnwyQ0Ytn30/wd+ycgknUraFAMClpmNXvHcyzQLC05V
	 3z/RIP8cjLtQL9NrqZ5g4QHIyarDQ9X+H9ivUgOlP3Rno4PoB0Xlea4VNrCpmuQO3q
	 Hf8/horeBCnQ1vQcBmS6E3dXSa30DCdmw8cb9a1w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/462] media: lmedm04: Use GFP_KERNEL for URB allocation/submission.
Date: Tue, 11 Mar 2025 15:55:46 +0100
Message-ID: <20250311145801.514108397@linuxfoundation.org>
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

From: Malcolm Priestley <tvboxspy@gmail.com>

[ Upstream commit add5861769f912af0181f5fbd79dbf19c8211c20 ]

lme2510_int_read is not atomically called so use GFP_KERNEL for
usb_alloc_urb and usb_submit_urb which is the first in the chain
of interrupt submissions.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: a2836d3fe220 ("media: lmedm04: Handle errors for lme2510_int_read")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb-v2/lmedm04.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/dvb-usb-v2/lmedm04.c b/drivers/media/usb/dvb-usb-v2/lmedm04.c
index 9ddda8d68ee0f..0f5a1eed5ea9f 100644
--- a/drivers/media/usb/dvb-usb-v2/lmedm04.c
+++ b/drivers/media/usb/dvb-usb-v2/lmedm04.c
@@ -373,7 +373,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	struct lme2510_state *lme_int = adap_to_priv(adap);
 	struct usb_host_endpoint *ep;
 
-	lme_int->lme_urb = usb_alloc_urb(0, GFP_ATOMIC);
+	lme_int->lme_urb = usb_alloc_urb(0, GFP_KERNEL);
 
 	if (lme_int->lme_urb == NULL)
 			return -ENOMEM;
@@ -393,7 +393,7 @@ static int lme2510_int_read(struct dvb_usb_adapter *adap)
 	if (usb_endpoint_type(&ep->desc) == USB_ENDPOINT_XFER_BULK)
 		lme_int->lme_urb->pipe = usb_rcvbulkpipe(d->udev, 0xa);
 
-	usb_submit_urb(lme_int->lme_urb, GFP_ATOMIC);
+	usb_submit_urb(lme_int->lme_urb, GFP_KERNEL);
 	info("INT Interrupt Service Started");
 
 	return 0;
-- 
2.39.5



