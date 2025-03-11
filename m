Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC9CB25D54A;
	Tue, 11 Mar 2025 15:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741705477; cv=none; b=EpQ2s3f+dwAsy1n3wk9V4kWQ/ECHYOMybNSIcPZu9WR3VbjDoTASeCm3/j8eMGxvz2bVzVP6ck+gINQxa7du3CPlQN4zz9lBxE6BGod9WfEN3LBmU+MbPTbeX/gJ/eFMxi+u/iE6k5VaDb3Ecr6EUc3JzivPC69koBOuOjTCl/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741705477; c=relaxed/simple;
	bh=f5lPR/5JootuH4+QpVqUveqxHqGMZ+R7jQZcWeI+/YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a3+Mf06oNSiLNtds/zhwtB1XtQSdvnugPalbxHQ/nRV0kGDC2QDaakHOOb0fdQnwHlpAPEN/rzvT/SPAPLyPpAfORf7LmbgQlOmyBZZOg6Odv2K6qm3N22OF8meQ+SQ/ZoY+TnzFUuwUyCWNFyv44nArKEayIKiOU/sv7TfIO3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bu1Lb4W3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bu1Lb4W3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FD7C4CEE9;
	Tue, 11 Mar 2025 15:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741705477;
	bh=f5lPR/5JootuH4+QpVqUveqxHqGMZ+R7jQZcWeI+/YY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bu1Lb4W3QL4oXUd03i698Dap6kkQTirCeJwHiM4wfBtnVPcKggMETXgbBALmwGzxK
	 Y0UFs/jVG2Uf3Q4BWml057xWojeOqd4Mt2rmNG+Nd0Cop78bvJCYKdzGiwoVBfmapW
	 xywVPeQqI3tPD50JGq3wUTOj5S1XtYeeojoH9uys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Malcolm Priestley <tvboxspy@gmail.com>,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 049/328] media: lmedm04: Use GFP_KERNEL for URB allocation/submission.
Date: Tue, 11 Mar 2025 15:56:59 +0100
Message-ID: <20250311145716.842764074@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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
index 5ac1a6af87826..2b3b780782a40 100644
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



