Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26E2FABFC;
	Tue, 12 Aug 2025 18:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755025075; cv=none; b=Hi2TiqamCvSjzP0z0iF+lO0zZtUZZBkyIUBdPZJVxPD5ujtYVUb+pwOi3dH18YR/bDpa3Sv/WcAgGRHk2Bwb82ANp+Edol780IQXzhDlVj/k8x4QVlgrHGjOthk3UvDWnpmhDN6DI+HIFP/Dq/2aqv/X3eQga0SRK0A45nkTzl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755025075; c=relaxed/simple;
	bh=CwUcIVJNCF9FoQ4/06zbCw1+bsJgSC9l8NVhPF5I4rU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqDmvz79qfsmuzc3H28j2ET3EpoAnzCwXFvjG1N89t54RM5uqzEsdrUIBiNX9pueqRRFgLOW+QjlKJzNCpnQ3+gSfLiUZpuD5nKxpSf3bBpQJDaBQwh0an4gCeMcOmmGPd+92UyXLcx9icm4cJcgloxd2RCHgniHtf+tY1aBcb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peFjMFVJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peFjMFVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 907A1C4CEF0;
	Tue, 12 Aug 2025 18:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755025075;
	bh=CwUcIVJNCF9FoQ4/06zbCw1+bsJgSC9l8NVhPF5I4rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=peFjMFVJl1jK0Uml9Wo6dfpDMvJjjBr3yABOtaoQu1hmkYtf69rh4pRkYC3dYwrzJ
	 NWbgnmb02CJM4hpexndJbul5zWpP1g8wW1sLOMpQnWnq9eU1TFeoOSGg9yrOP171rd
	 zq/4l4T2maxu6CPaPCFvjatMJg96LJLSlfTuAx6Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dawid Osuchowski <dawid.osuchowski@linux.intel.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 529/627] net: airoha: Fix PPE table access in airoha_ppe_debugfs_foe_show()
Date: Tue, 12 Aug 2025 19:33:44 +0200
Message-ID: <20250812173452.029429728@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 38358fa3cc8e16c6862a3e5c5c233f9f652e3a6d ]

In order to avoid any possible race we need to hold the ppe_lock
spinlock accessing the hw PPE table. airoha_ppe_foe_get_entry routine is
always executed holding ppe_lock except in airoha_ppe_debugfs_foe_show
routine. Fix the problem introducing airoha_ppe_foe_get_entry_locked
routine.

Fixes: 3fe15c640f380 ("net: airoha: Introduce PPE debugfs support")
Reviewed-by: Dawid Osuchowski <dawid.osuchowski@linux.intel.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20250731-airoha_ppe_foe_get_entry_locked-v2-1-50efbd8c0fd6@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 26 ++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 0e217acfc5ef..7832fe8fc202 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -498,9 +498,11 @@ static void airoha_ppe_foe_flow_stats_update(struct airoha_ppe *ppe,
 		FIELD_PREP(AIROHA_FOE_IB2_NBQ, nbq);
 }
 
-struct airoha_foe_entry *airoha_ppe_foe_get_entry(struct airoha_ppe *ppe,
-						  u32 hash)
+static struct airoha_foe_entry *
+airoha_ppe_foe_get_entry_locked(struct airoha_ppe *ppe, u32 hash)
 {
+	lockdep_assert_held(&ppe_lock);
+
 	if (hash < PPE_SRAM_NUM_ENTRIES) {
 		u32 *hwe = ppe->foe + hash * sizeof(struct airoha_foe_entry);
 		struct airoha_eth *eth = ppe->eth;
@@ -527,6 +529,18 @@ struct airoha_foe_entry *airoha_ppe_foe_get_entry(struct airoha_ppe *ppe,
 	return ppe->foe + hash * sizeof(struct airoha_foe_entry);
 }
 
+struct airoha_foe_entry *airoha_ppe_foe_get_entry(struct airoha_ppe *ppe,
+						  u32 hash)
+{
+	struct airoha_foe_entry *hwe;
+
+	spin_lock_bh(&ppe_lock);
+	hwe = airoha_ppe_foe_get_entry_locked(ppe, hash);
+	spin_unlock_bh(&ppe_lock);
+
+	return hwe;
+}
+
 static bool airoha_ppe_foe_compare_entry(struct airoha_flow_table_entry *e,
 					 struct airoha_foe_entry *hwe)
 {
@@ -641,7 +655,7 @@ airoha_ppe_foe_commit_subflow_entry(struct airoha_ppe *ppe,
 	struct airoha_flow_table_entry *f;
 	int type;
 
-	hwe_p = airoha_ppe_foe_get_entry(ppe, hash);
+	hwe_p = airoha_ppe_foe_get_entry_locked(ppe, hash);
 	if (!hwe_p)
 		return -EINVAL;
 
@@ -693,7 +707,7 @@ static void airoha_ppe_foe_insert_entry(struct airoha_ppe *ppe,
 
 	spin_lock_bh(&ppe_lock);
 
-	hwe = airoha_ppe_foe_get_entry(ppe, hash);
+	hwe = airoha_ppe_foe_get_entry_locked(ppe, hash);
 	if (!hwe)
 		goto unlock;
 
@@ -808,7 +822,7 @@ airoha_ppe_foe_flow_l2_entry_update(struct airoha_ppe *ppe,
 		u32 ib1, state;
 		int idle;
 
-		hwe = airoha_ppe_foe_get_entry(ppe, iter->hash);
+		hwe = airoha_ppe_foe_get_entry_locked(ppe, iter->hash);
 		if (!hwe)
 			continue;
 
@@ -845,7 +859,7 @@ static void airoha_ppe_foe_flow_entry_update(struct airoha_ppe *ppe,
 	if (e->hash == 0xffff)
 		goto unlock;
 
-	hwe_p = airoha_ppe_foe_get_entry(ppe, e->hash);
+	hwe_p = airoha_ppe_foe_get_entry_locked(ppe, e->hash);
 	if (!hwe_p)
 		goto unlock;
 
-- 
2.39.5



