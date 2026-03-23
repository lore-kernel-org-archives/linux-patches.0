Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CA4B3B9D9D;
	Mon, 23 Mar 2026 16:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774282652; cv=none; b=i+2h+OeAz8N0ZIALDKshCaEhgZR1/qspMg3G0mIP7VwnKQIsfFcAAvf6SX74oR+3sciRjr+mv3HwdW90yvfAdOAvu3yPYHK22OpcjM/g1QZz5qPs977kIYbQt/gI3qne91O8ycHUUidlIsop8h8K7NX+Ns0HnW4/XZu4jynugAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774282652; c=relaxed/simple;
	bh=LcKMhlzX3SA5DzYqBYEpi/4ceNWORuPGG2OWgvx31MQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D/YNvtfAZ38k9ZoA64QJqSb6cn5Hqx9xvdLRgBLBRZECmo5vo7OYCT6bGRNkpVfLne6+8jbCIkBl0my8ZAuwVQvq797+aHpS0kHrqaieGlhnf/BYYKApIu/ApHEsp7y0WAm8Yn9+fI81F4wqoflvfNeycoeQfL0Mj5UCwzgfhPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hJVl9/em; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hJVl9/em"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9923FC4CEF7;
	Mon, 23 Mar 2026 16:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774282652;
	bh=LcKMhlzX3SA5DzYqBYEpi/4ceNWORuPGG2OWgvx31MQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hJVl9/emoZSz23+eZYSc+ezGy3b2rcB1vcEzKFFm+aQ7WICryK7OHoj5c+gpMjOIf
	 RcBHre3ozsZN7O1omQD/Qk8LxH/yRja2JDhUG2KveFzaKe93uhF1XWOat/APQTHQoC
	 fEqwxa3NC86i437droTkF4UBpTbkogqfrqZBeUeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Simon Horman <horms@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 193/481] octeontx2-af: devlink health: use retained error fmsg API
Date: Mon, 23 Mar 2026 14:42:55 +0100
Message-ID: <20260323134529.895989861@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
References: <20260323134525.256603107@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Przemek Kitszel <przemyslaw.kitszel@intel.com>

[ Upstream commit d8cf03fca3411de8a493dae5e9fcf815a4f0977e ]

Drop unneeded error checking.

devlink_fmsg_*() family of functions is now retaining errors,
so there is no need to check for them after each call.

Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Przemek Kitszel <przemyslaw.kitszel@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 87f7dff3ec75 ("octeontx2-af: devlink: fix NIX RAS reporter to use RAS interrupt status")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../marvell/octeontx2/af/rvu_devlink.c        | 464 +++++-------------
 1 file changed, 133 insertions(+), 331 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 48ce98ae56611..ae06742670dc8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -14,26 +14,16 @@
 
 #define DRV_NAME "octeontx2-af"
 
-static int rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
+static void rvu_report_pair_start(struct devlink_fmsg *fmsg, const char *name)
 {
-	int err;
-
-	err = devlink_fmsg_pair_nest_start(fmsg, name);
-	if (err)
-		return err;
-
-	return  devlink_fmsg_obj_nest_start(fmsg);
+	devlink_fmsg_pair_nest_start(fmsg, name);
+	devlink_fmsg_obj_nest_start(fmsg);
 }
 
-static int rvu_report_pair_end(struct devlink_fmsg *fmsg)
+static void rvu_report_pair_end(struct devlink_fmsg *fmsg)
 {
-	int err;
-
-	err = devlink_fmsg_obj_nest_end(fmsg);
-	if (err)
-		return err;
-
-	return devlink_fmsg_pair_nest_end(fmsg);
+	devlink_fmsg_obj_nest_end(fmsg);
+	devlink_fmsg_pair_nest_end(fmsg);
 }
 
 static bool rvu_common_request_irq(struct rvu *rvu, int offset,
@@ -284,175 +274,81 @@ static int rvu_nix_report_show(struct devlink_fmsg *fmsg, void *ctx,
 {
 	struct rvu_nix_event_ctx *nix_event_context;
 	u64 intr_val;
-	int err;
 
 	nix_event_context = ctx;
 	switch (health_reporter) {
 	case NIX_AF_RVU_INTR:
 		intr_val = nix_event_context->nix_af_rvu_int;
-		err = rvu_report_pair_start(fmsg, "NIX_AF_RVU");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX RVU Interrupt Reg ",
-						nix_event_context->nix_af_rvu_int);
-		if (err)
-			return err;
-		if (intr_val & BIT_ULL(0)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NIX_AF_RVU");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNIX RVU Interrupt Reg ",
+					  nix_event_context->nix_af_rvu_int);
+		if (intr_val & BIT_ULL(0))
+			devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
+		rvu_report_pair_end(fmsg);
 		break;
 	case NIX_AF_RVU_GEN:
 		intr_val = nix_event_context->nix_af_rvu_gen;
-		err = rvu_report_pair_start(fmsg, "NIX_AF_GENERAL");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX General Interrupt Reg ",
-						nix_event_context->nix_af_rvu_gen);
-		if (err)
-			return err;
-		if (intr_val & BIT_ULL(0)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tRx multicast pkt drop");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(1)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tRx mirror pkt drop");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(4)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tSMQ flush done");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NIX_AF_GENERAL");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNIX General Interrupt Reg ",
+					  nix_event_context->nix_af_rvu_gen);
+		if (intr_val & BIT_ULL(0))
+			devlink_fmsg_string_put(fmsg, "\n\tRx multicast pkt drop");
+		if (intr_val & BIT_ULL(1))
+			devlink_fmsg_string_put(fmsg, "\n\tRx mirror pkt drop");
+		if (intr_val & BIT_ULL(4))
+			devlink_fmsg_string_put(fmsg, "\n\tSMQ flush done");
+		rvu_report_pair_end(fmsg);
 		break;
 	case NIX_AF_RVU_ERR:
 		intr_val = nix_event_context->nix_af_rvu_err;
-		err = rvu_report_pair_start(fmsg, "NIX_AF_ERR");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX Error Interrupt Reg ",
-						nix_event_context->nix_af_rvu_err);
-		if (err)
-			return err;
-		if (intr_val & BIT_ULL(14)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_INST_S read");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(13)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_RES_S write");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(12)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(6)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tRx on unmapped PF_FUNC");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(5)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tRx multicast replication error");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(4)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_RX_MCE_S read");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(3)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on multicast WQE read");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(2)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on mirror WQE read");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(1)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on mirror pkt write");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(0)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on multicast pkt write");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NIX_AF_ERR");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNIX Error Interrupt Reg ",
+					  nix_event_context->nix_af_rvu_err);
+		if (intr_val & BIT_ULL(14))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_INST_S read");
+		if (intr_val & BIT_ULL(13))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_AQ_RES_S write");
+		if (intr_val & BIT_ULL(12))
+			devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
+		if (intr_val & BIT_ULL(6))
+			devlink_fmsg_string_put(fmsg, "\n\tRx on unmapped PF_FUNC");
+		if (intr_val & BIT_ULL(5))
+			devlink_fmsg_string_put(fmsg, "\n\tRx multicast replication error");
+		if (intr_val & BIT_ULL(4))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on NIX_RX_MCE_S read");
+		if (intr_val & BIT_ULL(3))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on multicast WQE read");
+		if (intr_val & BIT_ULL(2))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on mirror WQE read");
+		if (intr_val & BIT_ULL(1))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on mirror pkt write");
+		if (intr_val & BIT_ULL(0))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on multicast pkt write");
+		rvu_report_pair_end(fmsg);
 		break;
 	case NIX_AF_RVU_RAS:
 		intr_val = nix_event_context->nix_af_rvu_err;
-		err = rvu_report_pair_start(fmsg, "NIX_AF_RAS");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNIX RAS Interrupt Reg ",
-						nix_event_context->nix_af_rvu_err);
-		if (err)
-			return err;
-		err = devlink_fmsg_string_put(fmsg, "\n\tPoison Data on:");
-		if (err)
-			return err;
-		if (intr_val & BIT_ULL(34)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_INST_S");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(33)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_RES_S");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(32)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tHW ctx");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(4)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tPacket from mirror buffer");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(3)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tPacket from multicast buffer");
-
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(2)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tWQE read from mirror buffer");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(1)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tWQE read from multicast buffer");
-			if (err)
-				return err;
-		}
-		if (intr_val & BIT_ULL(0)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX_RX_MCE_S read");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NIX_AF_RAS");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNIX RAS Interrupt Reg ",
+					  nix_event_context->nix_af_rvu_err);
+		devlink_fmsg_string_put(fmsg, "\n\tPoison Data on:");
+		if (intr_val & BIT_ULL(34))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_INST_S");
+		if (intr_val & BIT_ULL(33))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX_AQ_RES_S");
+		if (intr_val & BIT_ULL(32))
+			devlink_fmsg_string_put(fmsg, "\n\tHW ctx");
+		if (intr_val & BIT_ULL(4))
+			devlink_fmsg_string_put(fmsg, "\n\tPacket from mirror buffer");
+		if (intr_val & BIT_ULL(3))
+			devlink_fmsg_string_put(fmsg, "\n\tPacket from multicast buffer");
+		if (intr_val & BIT_ULL(2))
+			devlink_fmsg_string_put(fmsg, "\n\tWQE read from mirror buffer");
+		if (intr_val & BIT_ULL(1))
+			devlink_fmsg_string_put(fmsg, "\n\tWQE read from multicast buffer");
+		if (intr_val & BIT_ULL(0))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX_RX_MCE_S read");
+		rvu_report_pair_end(fmsg);
 		break;
 	default:
 		return -EINVAL;
@@ -919,181 +815,87 @@ static int rvu_npa_report_show(struct devlink_fmsg *fmsg, void *ctx,
 	struct rvu_npa_event_ctx *npa_event_context;
 	unsigned int alloc_dis, free_dis;
 	u64 intr_val;
-	int err;
 
 	npa_event_context = ctx;
 	switch (health_reporter) {
 	case NPA_AF_RVU_GEN:
 		intr_val = npa_event_context->npa_af_rvu_gen;
-		err = rvu_report_pair_start(fmsg, "NPA_AF_GENERAL");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA General Interrupt Reg ",
-						npa_event_context->npa_af_rvu_gen);
-		if (err)
-			return err;
-		if (intr_val & BIT_ULL(32)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap PF Error");
-			if (err)
-				return err;
-		}
+		rvu_report_pair_start(fmsg, "NPA_AF_GENERAL");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNPA General Interrupt Reg ",
+					  npa_event_context->npa_af_rvu_gen);
+		if (intr_val & BIT_ULL(32))
+			devlink_fmsg_string_put(fmsg, "\n\tUnmap PF Error");
 
 		free_dis = FIELD_GET(GENMASK(15, 0), intr_val);
-		if (free_dis & BIT(NPA_INPQ_NIX0_RX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0: free disabled RX");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_NIX0_TX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0:free disabled TX");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_NIX1_RX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1: free disabled RX");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_NIX1_TX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1:free disabled TX");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_SSO)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for SSO");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_TIM)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for TIM");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_DPI)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for DPI");
-			if (err)
-				return err;
-		}
-		if (free_dis & BIT(NPA_INPQ_AURA_OP)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for AURA");
-			if (err)
-				return err;
-		}
+		if (free_dis & BIT(NPA_INPQ_NIX0_RX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX0: free disabled RX");
+		if (free_dis & BIT(NPA_INPQ_NIX0_TX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX0:free disabled TX");
+		if (free_dis & BIT(NPA_INPQ_NIX1_RX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX1: free disabled RX");
+		if (free_dis & BIT(NPA_INPQ_NIX1_TX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX1:free disabled TX");
+		if (free_dis & BIT(NPA_INPQ_SSO))
+			devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for SSO");
+		if (free_dis & BIT(NPA_INPQ_TIM))
+			devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for TIM");
+		if (free_dis & BIT(NPA_INPQ_DPI))
+			devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for DPI");
+		if (free_dis & BIT(NPA_INPQ_AURA_OP))
+			devlink_fmsg_string_put(fmsg, "\n\tFree Disabled for AURA");
 
 		alloc_dis = FIELD_GET(GENMASK(31, 16), intr_val);
-		if (alloc_dis & BIT(NPA_INPQ_NIX0_RX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0: alloc disabled RX");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_NIX0_TX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX0:alloc disabled TX");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_NIX1_RX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1: alloc disabled RX");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_NIX1_TX)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tNIX1:alloc disabled TX");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_SSO)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for SSO");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_TIM)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for TIM");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_DPI)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for DPI");
-			if (err)
-				return err;
-		}
-		if (alloc_dis & BIT(NPA_INPQ_AURA_OP)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for AURA");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		if (alloc_dis & BIT(NPA_INPQ_NIX0_RX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX0: alloc disabled RX");
+		if (alloc_dis & BIT(NPA_INPQ_NIX0_TX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX0:alloc disabled TX");
+		if (alloc_dis & BIT(NPA_INPQ_NIX1_RX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX1: alloc disabled RX");
+		if (alloc_dis & BIT(NPA_INPQ_NIX1_TX))
+			devlink_fmsg_string_put(fmsg, "\n\tNIX1:alloc disabled TX");
+		if (alloc_dis & BIT(NPA_INPQ_SSO))
+			devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for SSO");
+		if (alloc_dis & BIT(NPA_INPQ_TIM))
+			devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for TIM");
+		if (alloc_dis & BIT(NPA_INPQ_DPI))
+			devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for DPI");
+		if (alloc_dis & BIT(NPA_INPQ_AURA_OP))
+			devlink_fmsg_string_put(fmsg, "\n\tAlloc Disabled for AURA");
+
+		rvu_report_pair_end(fmsg);
 		break;
 	case NPA_AF_RVU_ERR:
-		err = rvu_report_pair_start(fmsg, "NPA_AF_ERR");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA Error Interrupt Reg ",
-						npa_event_context->npa_af_rvu_err);
-		if (err)
-			return err;
-
-		if (npa_event_context->npa_af_rvu_err & BIT_ULL(14)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_INST_S read");
-			if (err)
-				return err;
-		}
-		if (npa_event_context->npa_af_rvu_err & BIT_ULL(13)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_RES_S write");
-			if (err)
-				return err;
-		}
-		if (npa_event_context->npa_af_rvu_err & BIT_ULL(12)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NPA_AF_ERR");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNPA Error Interrupt Reg ",
+					  npa_event_context->npa_af_rvu_err);
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(14))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_INST_S read");
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(13))
+			devlink_fmsg_string_put(fmsg, "\n\tFault on NPA_AQ_RES_S write");
+		if (npa_event_context->npa_af_rvu_err & BIT_ULL(12))
+			devlink_fmsg_string_put(fmsg, "\n\tAQ Doorbell Error");
+		rvu_report_pair_end(fmsg);
 		break;
 	case NPA_AF_RVU_RAS:
-		err = rvu_report_pair_start(fmsg, "NPA_AF_RVU_RAS");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA RAS Interrupt Reg ",
-						npa_event_context->npa_af_rvu_ras);
-		if (err)
-			return err;
-		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(34)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_INST_S");
-			if (err)
-				return err;
-		}
-		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(33)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_RES_S");
-			if (err)
-				return err;
-		}
-		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(32)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tPoison data on HW context");
-			if (err)
-				return err;
-		}
-		err = rvu_report_pair_end(fmsg);
-		if (err)
-			return err;
+		rvu_report_pair_start(fmsg, "NPA_AF_RVU_RAS");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNPA RAS Interrupt Reg ",
+					  npa_event_context->npa_af_rvu_ras);
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(34))
+			devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_INST_S");
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(33))
+			devlink_fmsg_string_put(fmsg, "\n\tPoison data on NPA_AQ_RES_S");
+		if (npa_event_context->npa_af_rvu_ras & BIT_ULL(32))
+			devlink_fmsg_string_put(fmsg, "\n\tPoison data on HW context");
+		rvu_report_pair_end(fmsg);
 		break;
 	case NPA_AF_RVU_INTR:
-		err = rvu_report_pair_start(fmsg, "NPA_AF_RVU");
-		if (err)
-			return err;
-		err = devlink_fmsg_u64_pair_put(fmsg, "\tNPA RVU Interrupt Reg ",
-						npa_event_context->npa_af_rvu_int);
-		if (err)
-			return err;
-		if (npa_event_context->npa_af_rvu_int & BIT_ULL(0)) {
-			err = devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
-			if (err)
-				return err;
-		}
-		return rvu_report_pair_end(fmsg);
+		rvu_report_pair_start(fmsg, "NPA_AF_RVU");
+		devlink_fmsg_u64_pair_put(fmsg, "\tNPA RVU Interrupt Reg ",
+					  npa_event_context->npa_af_rvu_int);
+		if (npa_event_context->npa_af_rvu_int & BIT_ULL(0))
+			devlink_fmsg_string_put(fmsg, "\n\tUnmap Slot Error");
+		rvu_report_pair_end(fmsg);
+		break;
 	default:
 		return -EINVAL;
 	}
-- 
2.51.0



