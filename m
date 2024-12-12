Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D219223C79;
	Thu, 12 Dec 2024 16:18:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020286; cv=none; b=YVRO+3Q98tuUGut7KqAFoQaBPQzl3Knxw1a6fHLa5ob8so9YF0fPkFT+SzOI3/48nl5BtyPxbf17q06aMkZbu4qqmsPjgqobe2nNKCk8cQGSxX7TVKmzeWVJAfFFUvGTGGBC/94cZVSTfLWaVMhTCbOGinUM8xOqDRGtxd347Ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020286; c=relaxed/simple;
	bh=FgUsAPojHbIEkCmKDjgohBCmmSyGb8fQ4XjliuQriAA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h4vhzYDOKw7860Pmo+J7fzaKNKyabrvcaFUEowwO+cXs88KI+9n9zAlyt/TvLpZlghdc7wVcljVbvPH8IOAnWaXFACHV4Ggv6SMXpwKxYLNrtQl8+Vk854CQF7s6KJeVE7yEGu3SsIM1Njf+iqkQrJ7C+6rSm1n/JnMc6/+eZO8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AP3JR1z9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AP3JR1z9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBCB4C4CECE;
	Thu, 12 Dec 2024 16:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020286;
	bh=FgUsAPojHbIEkCmKDjgohBCmmSyGb8fQ4XjliuQriAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AP3JR1z9TWl4dn0G2GJOMVvOn+ZeJ++Xg2UXPCKbqVE6JZXXMeT4E8bJ876EgbPMk
	 TvjI+sSNFwYSEuarb8IMBvKUB8Jv9wwl10RwWdT8oV92GwDpVJGreAZ9yBxGgF/pRL
	 CKADu27wrOWbwekESTTXNNpZldQMnOANeyEaVs80=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Subject: [PATCH 6.1 420/772] usb: dwc3: gadget: Fix looping of queued SG entries
Date: Thu, 12 Dec 2024 15:56:05 +0100
Message-ID: <20241212144407.273009102@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thinh Nguyen <Thinh.Nguyen@synopsys.com>

commit b7fc65f5141c24785dc8c19249ca4efcf71b3524 upstream.

The dwc3_request->num_queued_sgs is decremented on completion. If a
partially completed request is handled, then the
dwc3_request->num_queued_sgs no longer reflects the total number of
num_queued_sgs (it would be cleared).

Correctly check the number of request SG entries remained to be prepare
and queued. Failure to do this may cause null pointer dereference when
accessing non-existent SG entry.

Cc: stable@vger.kernel.org
Fixes: c96e6725db9d ("usb: dwc3: gadget: Correct the logic for queuing sgs")
Signed-off-by: Thinh Nguyen <Thinh.Nguyen@synopsys.com>
Link: https://lore.kernel.org/r/d07a7c4aa0fcf746cdca0515150dbe5c52000af7.1731545781.git.Thinh.Nguyen@synopsys.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/dwc3/gadget.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -1443,8 +1443,8 @@ static int dwc3_prepare_trbs_sg(struct d
 	struct scatterlist *s;
 	int		i;
 	unsigned int length = req->request.length;
-	unsigned int remaining = req->request.num_mapped_sgs
-		- req->num_queued_sgs;
+	unsigned int remaining = req->num_pending_sgs;
+	unsigned int num_queued_sgs = req->request.num_mapped_sgs - remaining;
 	unsigned int num_trbs = req->num_trbs;
 	bool needs_extra_trb = dwc3_needs_extra_trb(dep, req);
 
@@ -1452,7 +1452,7 @@ static int dwc3_prepare_trbs_sg(struct d
 	 * If we resume preparing the request, then get the remaining length of
 	 * the request and resume where we left off.
 	 */
-	for_each_sg(req->request.sg, s, req->num_queued_sgs, i)
+	for_each_sg(req->request.sg, s, num_queued_sgs, i)
 		length -= sg_dma_len(s);
 
 	for_each_sg(sg, s, remaining, i) {


