Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D75D1487F4;
	Mon,  6 Jan 2025 15:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177220; cv=none; b=JUlwlt1A1TyrSQj7HM9OzEmIsPB1DkSBAJiQscy6x93NgsZzBiyAfKOLBHesVfbWHCSkkn0jAfDttMINt9xV7ATalR8BvXxneqQtuSvFHquQY6bqzuzX/xFhNb0N3TDOuynItbFEahATgdpqm3EjRg6ZML5Uyxgq2c7vwL68YSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177220; c=relaxed/simple;
	bh=hYyp2d4B2fEZirBJq9/3k63YvBp9rX11359KtEVDnwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YC3uf5ez+RJN/FxwfgTTrglF29Pc2t0VLuphwLU/gd10+VmA+CC06lCtjOkcSe1PNu9aAVIa75xTkWVsRTfNggvPOav/ZG+1EbnFTc2UpmLqi2ZVKC7oNtVJbsHEm3Lwl0i/YGbwFT0hvY6OFwIcgjG2vnhEIvztlVOXQpKdCY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p8s7eeRs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p8s7eeRs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12006C4CED2;
	Mon,  6 Jan 2025 15:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177220;
	bh=hYyp2d4B2fEZirBJq9/3k63YvBp9rX11359KtEVDnwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p8s7eeRsBZNbLr69H5DR3ZsSLb+U4tb72iB+P5W9l8PZn143YwhqXWmnKhV/IyH18
	 GRoY07fiFopEBc2tniZBXsJYTQzrWKcWuFPcDULA3z3o2TWYsNvJlkaslP1SndN33E
	 eSOEjd92r92qm3I/TdMgHg8SNrgrz1mu5+JzsjrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 060/222] usb: chipidea: udc: limit usb request length to max 16KB
Date: Mon,  6 Jan 2025 16:14:24 +0100
Message-ID: <20250106151152.880061902@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

[ Upstream commit ca8d18aa7b0f22d66a3ca9a90d8f73431b8eca89 ]

To let the device controller work properly on short packet limitations,
one usb request should only correspond to one dTD. Then every dTD will
set IOC. In theory, each dTD support up to 20KB data transfer if the
offset is 0. Due to we cannot predetermine the offset, this will limit
the usb request length to max 16KB. This should be fine since most of
the user transfer data based on this size policy.

Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Peter Chen <peter.chen@kernel.org>
Link: https://lore.kernel.org/r/20240923081203.2851768-2-xu.yang_2@nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/chipidea/ci.h  | 1 +
 drivers/usb/chipidea/udc.c | 6 ++++++
 2 files changed, 7 insertions(+)

diff --git a/drivers/usb/chipidea/ci.h b/drivers/usb/chipidea/ci.h
index e4b003d060c2..97437de52ef6 100644
--- a/drivers/usb/chipidea/ci.h
+++ b/drivers/usb/chipidea/ci.h
@@ -25,6 +25,7 @@
 #define TD_PAGE_COUNT      5
 #define CI_HDRC_PAGE_SIZE  4096ul /* page size for TD's */
 #define ENDPT_MAX          32
+#define CI_MAX_REQ_SIZE	(4 * CI_HDRC_PAGE_SIZE)
 #define CI_MAX_BUF_SIZE	(TD_PAGE_COUNT * CI_HDRC_PAGE_SIZE)
 
 /******************************************************************************
diff --git a/drivers/usb/chipidea/udc.c b/drivers/usb/chipidea/udc.c
index 9f7d003e467b..f2ae5f4c5828 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -959,6 +959,12 @@ static int _ep_queue(struct usb_ep *ep, struct usb_request *req,
 		return -EMSGSIZE;
 	}
 
+	if (ci->has_short_pkt_limit &&
+		hwreq->req.length > CI_MAX_REQ_SIZE) {
+		dev_err(hwep->ci->dev, "request length too big (max 16KB)\n");
+		return -EMSGSIZE;
+	}
+
 	/* first nuke then test link, e.g. previous status has not sent */
 	if (!list_empty(&hwreq->queue)) {
 		dev_err(hwep->ci->dev, "request already in queue\n");
-- 
2.39.5



