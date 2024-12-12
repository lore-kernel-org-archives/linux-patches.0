Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA042153D9;
	Thu, 12 Dec 2024 15:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017200; cv=none; b=GspLXsVooSkUQoU/LLisjeuo284oPBi2JY6SGB6OZzI822ArYD41y+e9JV/eZWkPC+B/h5hrWZtjfunjc+mc7WuZuorz/VrNfFd85tufStyNgmipRAe3CIhvXkgoF3OJd5fIWKDFYPQE4lQm1LOxAEdcZCNJNhsmJGQNpSrRQiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017200; c=relaxed/simple;
	bh=lt5xH4ZuINjcfgo/da4VsWPLt5dXHtMoAfM1ksfu0w4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=etoChkJZ9JXEf6kcymMdp5WwDMf8jcg3vb8wxNR4882Vsbnfbx23lDgdx4sYbrzskxFzw71IO2fspBDJQRa9dQIiOF5EC56M4xFALbzLo5HUttWZL2Lc+i/GUPx8tAyl9dM9UhmtD4riAlXg/FFPif2690h96B3qoEbyt6/+5ig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=te2dRpJo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="te2dRpJo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5703C4CECE;
	Thu, 12 Dec 2024 15:26:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017200;
	bh=lt5xH4ZuINjcfgo/da4VsWPLt5dXHtMoAfM1ksfu0w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=te2dRpJoFDP8CPDeyBkhtwQuZKOfzfmzQe65YVeqemRd1n49zSt/7iu9cX6pGm5sw
	 sBzHGMtTpXqW66K/kr9G1pO8aJLtTIX8OrUOvU+T3cVnydbQQpc1z2qI3GzdGGC1Rp
	 Km9ByHDszzANiXTtgK5qIMKUNgDUm6hrH5/TS1wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Peter Chen <peter.chen@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 410/466] usb: chipidea: udc: limit usb request length to max 16KB
Date: Thu, 12 Dec 2024 15:59:39 +0100
Message-ID: <20241212144322.955118835@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
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
index e4b003d060c26..97437de52ef68 100644
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
index 69ef3cd8d4f83..d3556416dae4f 100644
--- a/drivers/usb/chipidea/udc.c
+++ b/drivers/usb/chipidea/udc.c
@@ -960,6 +960,12 @@ static int _ep_queue(struct usb_ep *ep, struct usb_request *req,
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
2.43.0



