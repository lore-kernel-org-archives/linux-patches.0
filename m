Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9D581C5F0C;
	Wed, 19 Feb 2025 09:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956468; cv=none; b=OIThcP079I9vLpHO1O2BKs/63R8ZoqjW0i1NI3/BTL/j/O8zkbtUd0MUVrmNmfA5CnrvLHfX43XghLR0cZ7uR3YvMOZL/gmcKALz1zoLVezfGWfJs2QCFTR2Qbe8qJgGbmDGBVzF8JM7/o4d15XA5yh7ja+F4F6FQ/pYJXPI9MY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956468; c=relaxed/simple;
	bh=dYmD60QiUP1yOA0KXtnxEzWVxmKFhGZcIS1KC79Okp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUe1LvB1oXHvhs+V4oW0j5sOvNStInacX6r8jMRLIAQIY+u/KHJc15OEuYBacoSm1mCY+QAEA5OnxDIt61YehUTiJYX4L8x+MFqCzOnhY8T+AG4ZX9UW5KfLmJkG1tXXNEb8I8Ncgs1Z3SrH+137UBFIITNtcC4a9Q7dr8Ir/+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY5cvXi1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY5cvXi1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2A3C4CED1;
	Wed, 19 Feb 2025 09:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956468;
	bh=dYmD60QiUP1yOA0KXtnxEzWVxmKFhGZcIS1KC79Okp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY5cvXi1mBhIXlC0wOB2Yekk6qvWK7yLKHPrUL0Ue6isAwKeSZgpATtV2MA2JFWPr
	 t3iS/KW6ApNJzA0mjT30DoSx5u/DEIInXtJL9YxryxmeTm1eOcNUHz2/8htgHDUTX5
	 fexL/TPNGRMJL+EP4lZNzD/IBH8GBOFy/EKdOjdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 189/578] media: lmedm04: Handle errors for lme2510_int_read
Date: Wed, 19 Feb 2025 09:23:13 +0100
Message-ID: <20250219082700.399710752@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



