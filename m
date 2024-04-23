Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9CC143889;
	Tue, 23 Apr 2024 21:43:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908599; cv=none; b=GUGWgW8z6b/+yRwvF50F/Qrgt4OoH2gRn/qBncE3LLl5tTKxsYfECx0lGKNFuLQ84CtOWgGfXSNirG/a/TCfmICSA/iVHCHtyK98GHbBsiNfsmBnkdKgfVRtsEZ34E+vs9TfphgFZSzmmEGxaWWim6oYM+F3Lykd8U5VfgehT5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908599; c=relaxed/simple;
	bh=sXc3rfg34GbXZXY3rElCBaWh4sj1a0ziTLeEQlZo7kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=D7DWGPbwqEome1fKCVi0PMORxACC8pskt8SEqDb8bIEQwq84S1fPu02sz5HUaSfacVvICRauIi8E1sXULPvQPONnZylgNnHC8snU55UmDimaKTFkZbukio1nQOhCgIymNPXdgK2uLUjpPSDtWrYrYfPXGiGPqFkFNQV2AWEYOP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZmxHU53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZmxHU53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B87C4AF07;
	Tue, 23 Apr 2024 21:43:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908599;
	bh=sXc3rfg34GbXZXY3rElCBaWh4sj1a0ziTLeEQlZo7kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZmxHU530PdGXMiFYKZ3V7UxLyCWtNARAldjZLE6YU5QSt6DTXRhY8DbsnSA3m886
	 Z14yMibqK+23a8AgUOfFKcYc6y9njFBpnbnvTlduQdIUIVeUuuhpSFwyShqsxBwFck
	 FD4DY2ez9p9B8ZJxKSmXx3TFgSw72wUtYWPEvq2k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	Jacob Keller <jacob.e.keller@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 045/158] octeontx2-pf: fix FLOW_DIS_IS_FRAGMENT implementation
Date: Tue, 23 Apr 2024 14:38:02 -0700
Message-ID: <20240423213857.238522628@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 75ce9506ee3dc66648a7d74ab3b0acfa364d6d43 ]

Upon reviewing the flower control flags handling in
this driver, I notice that the key wasn't being used,
only the mask.

Ie. `tc flower ... ip_flags nofrag` was hardware
offloaded as `... ip_flags frag`.

Only compile tested, no access to HW.

Fixes: c672e3727989 ("octeontx2-pf: Add support to filter packet based on IP fragment")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
index 423ce54eaea69..46bdbee9d38ad 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_tc.c
@@ -588,6 +588,7 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 
 	if (flow_rule_match_key(rule, FLOW_DISSECTOR_KEY_CONTROL)) {
 		struct flow_match_control match;
+		u32 val;
 
 		flow_rule_match_control(rule, &match);
 		if (match.mask->flags & FLOW_DIS_FIRST_FRAG) {
@@ -596,12 +597,14 @@ static int otx2_tc_prepare_flow(struct otx2_nic *nic, struct otx2_tc_flow *node,
 		}
 
 		if (match.mask->flags & FLOW_DIS_IS_FRAGMENT) {
+			val = match.key->flags & FLOW_DIS_IS_FRAGMENT;
 			if (ntohs(flow_spec->etype) == ETH_P_IP) {
-				flow_spec->ip_flag = IPV4_FLAG_MORE;
+				flow_spec->ip_flag = val ? IPV4_FLAG_MORE : 0;
 				flow_mask->ip_flag = IPV4_FLAG_MORE;
 				req->features |= BIT_ULL(NPC_IPFRAG_IPV4);
 			} else if (ntohs(flow_spec->etype) == ETH_P_IPV6) {
-				flow_spec->next_header = IPPROTO_FRAGMENT;
+				flow_spec->next_header = val ?
+							 IPPROTO_FRAGMENT : 0;
 				flow_mask->next_header = 0xff;
 				req->features |= BIT_ULL(NPC_IPFRAG_IPV6);
 			} else {
-- 
2.43.0



