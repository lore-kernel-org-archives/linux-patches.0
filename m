Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69F9340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301125; cv=none; b=qIhgqe6cElll4p/a6lx5dIeBfBjeKG4lTHWYq3ZhF2ffIMCxgHdPWJhNhP1SWrPc83H6mbqnfLAhZlQGoqmat/x0l5kuOvOz+1pcmfPzDFyTWkbobXCq1mMSzuxs/E6BZIgU9jaXn0+erdbvKCyl8DDaM0T5uPilvlnFMXSK8iM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301125; c=relaxed/simple;
	bh=8guLpb75hb0arC8D4g3LrV9AZNZEybmCgTL8kHBrR3w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDBN75hnGhWIwzD4wNG4jFP23KGsSCKpM76LcV76BVmkBla4Ij6mJh3kg1+MSp7N/tfyPwywUBJs6A3b355ys/YSZtzznBzSp0WLP7W1K5RcHAoGF83DsPfRdoi45fV2df2+/hWf69WQcd9A6eGNaUKpKNQhaWyIC+GaO2Gs5NU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b4QIiuvF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b4QIiuvF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01884C116D0;
	Sat, 28 Feb 2026 17:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301125;
	bh=8guLpb75hb0arC8D4g3LrV9AZNZEybmCgTL8kHBrR3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4QIiuvF9JugYrElNoHKb70LwVvgYG+EgySV3fCya2VzgqAyl6Q1oESp5GpGBywtr
	 aLo+7VRrcTtGjHM/kF/cfKTD3LveTYf3aZ77tyDiyE7uADoPGTPvh5Jwk+UB4sBg4K
	 02HXGJ6d3dURTz1qomVYlfT7cyVaD53OcVxuyZoJrkyxZKXbCAPWrVNicizqkGyAlS
	 YZUmf/9CTp8rzIELqoTiusSeeZ+yyFEuIJA5Brymog+IRTvTJ9VIC0sj6NgbsJV1t4
	 MzJgPdzW6GqHWMlJWqvygYxq3RHkHnfpPKxkaC0A3GXCyP9WKzoF+Qv8G/eUX15wHu
	 L52a1uy2Ay72g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Joe Damato <joe@dama.to>,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/752] bnxt_en: Allow ntuple filters for drops
Date: Sat, 28 Feb 2026 12:39:55 -0500
Message-ID: <20260228174750.1542406-284-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Joe Damato <joe@dama.to>

[ Upstream commit 61cef6454cfbb9fcdbe41401fb53895f86603081 ]

It appears that in commit 7efd79c0e689 ("bnxt_en: Add drop action
support for ntuple"), bnxt gained support for ntuple filters for packet
drops.

However, support for this does not seem to work in recent kernels or
against net-next:

  % sudo ethtool -U eth0 flow-type udp4 src-ip 1.1.1.1 action -1
    rmgr: Cannot insert RX class rule: Operation not supported
    Cannot insert classification rule

The issue is that the existing code uses ethtool_get_flow_spec_ring_vf,
which will return a non-zero value if the ring_cookie is set to
RX_CLS_FLOW_DISC, which then causes bnxt_add_ntuple_cls_rule to return
-EOPNOTSUPP because it thinks the user is trying to set an ntuple filter
for a vf.

Fix this by first checking that the ring_cookie is not RX_CLS_FLOW_DISC.

After this patch, ntuple filters for drops can be added:

  % sudo ethtool -U eth0 flow-type udp4 src-ip 1.1.1.1 action -1
  Added rule with ID 0

  % ethtool -n eth0
  44 RX rings available
  Total 1 rules

  Filter: 0
      Rule Type: UDP over IPv4
      Src IP addr: 1.1.1.1 mask: 0.0.0.0
      Dest IP addr: 0.0.0.0 mask: 255.255.255.255
      TOS: 0x0 mask: 0xff
      Src port: 0 mask: 0xffff
      Dest port: 0 mask: 0xffff
      Action: Drop

Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260131003042.2570434-1-joe@dama.to
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
index 41686a6f84b58..df4f0d15dd3d8 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_ethtool.c
@@ -1340,16 +1340,17 @@ static int bnxt_add_ntuple_cls_rule(struct bnxt *bp,
 	struct bnxt_l2_filter *l2_fltr;
 	struct bnxt_flow_masks *fmasks;
 	struct flow_keys *fkeys;
-	u32 idx, ring;
+	u32 idx;
 	int rc;
-	u8 vf;
 
 	if (!bp->vnic_info)
 		return -EAGAIN;
 
-	vf = ethtool_get_flow_spec_ring_vf(fs->ring_cookie);
-	ring = ethtool_get_flow_spec_ring(fs->ring_cookie);
-	if ((fs->flow_type & (FLOW_MAC_EXT | FLOW_EXT)) || vf)
+	if (fs->flow_type & (FLOW_MAC_EXT | FLOW_EXT))
+		return -EOPNOTSUPP;
+
+	if (fs->ring_cookie != RX_CLS_FLOW_DISC &&
+	    ethtool_get_flow_spec_ring_vf(fs->ring_cookie))
 		return -EOPNOTSUPP;
 
 	if (flow_type == IP_USER_FLOW) {
@@ -1475,7 +1476,7 @@ static int bnxt_add_ntuple_cls_rule(struct bnxt *bp,
 	if (fs->ring_cookie == RX_CLS_FLOW_DISC)
 		new_fltr->base.flags |= BNXT_ACT_DROP;
 	else
-		new_fltr->base.rxq = ring;
+		new_fltr->base.rxq = ethtool_get_flow_spec_ring(fs->ring_cookie);
 	__set_bit(BNXT_FLTR_VALID, &new_fltr->base.state);
 	rc = bnxt_insert_ntp_filter(bp, new_fltr, idx);
 	if (!rc) {
-- 
2.51.0

