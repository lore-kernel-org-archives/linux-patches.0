Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BFCB329E79;
	Tue, 13 Oct 2026 12:54:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896068; cv=none; b=qoySUDOLB6RdClllODim1XUbIGH2Yb8YFcZXe8eJxak27YF9NZhNxPEtXM5uhRNpcdPA77eZETOO/3RsDibv5oJGF8Ju5rRE01DnM+5cmsES1VtVC3QSMasZWuFV+beUaiznpg/cVtOsR2WutN1El8Gtpy33V7lk096iUSYhbwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896068; c=relaxed/simple;
	bh=7L4r/tRPp/RIOh/OMtXXCGvJSbOK/VwVC0jVwJ417xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RgDkvOrSNYtfUofElS49VTYGNSrn/vv+TV0YLqco1Vj7qEbigPHW/OyCBBHWUwRpuU+mR+jpZ0pVgKeLivYtRFZ6YctrrFU7o1As0YUPItJHiVawm4FABEcAa0yHVs8BEJ24k/pqDpyoVpQPUIX8ofvkC0UGkb9+2LvGq6zQ/g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HERaBDHA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HERaBDHA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 765BE1F000FF;
	Tue, 13 Oct 2026 12:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896066;
	bh=4n2CBi/JNOWU49LygqRRFrUwdr/nhKjFa8h4SX8gjww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HERaBDHAVAdNSkiy5h1EpI0WA9tlx8RHvoyrYwIxjZ5rt+Wds7P7U1zvfEhEUB2db
	 BIIS3gPpZlY+wYVSJRq2rlktrLE1IJ7fPeKR7rIpK8V2kahwXTSiZMVg/87f/lBGQI
	 8qwk5xncwYV/KAudxbcS/TPSOBcnECPC4aoEPQxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 486/497] mlxsw: spectrum_flower: Fix port range register leak in tmplt_create()
Date: Tue, 13 Oct 2026 13:40:53 +0200
Message-ID: <20261013112919.411971819@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Petr Machata <petrm@nvidia.com>

[ Upstream commit 7ea07afb230f1342ab0f9365edd0aae137f425d3 ]

mlxsw_sp_flower_tmplt_create() parses a flow_cls_offload template
into a stack-local struct mlxsw_sp_acl_rule_info purely to compute
rulei.values.elusage. Parsing can acquire port range registers via
mlxsw_sp_flower_parse_ports_range(), but since this rulei never goes
through mlxsw_sp_acl_rulei_destroy(), those registers were never
released, including through chain template deletion.

Factor out of mlxsw_sp_acl_rulei_destroy() the code to actually
release the necessary resources and call from
mlxsw_sp_flower_tmplt_create() to plug the leak.

The issue was found during a review of Wentao Liang's patch referenced
below.

Fixes: fe22f7410527 ("mlxsw: spectrum_flower: Add ability to match on port ranges")
Reported-by: Wentao Liang <vulab@iscas.ac.cn>
Closes: https://lore.kernel.org/netdev/20260917113236.2149095-1-vulab@iscas.ac.cn/
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/95339cf970ce78e1a74aa86ffcc104ecf7c7762c.1791294384.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.h        |  2 ++
 drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c    | 10 ++++++++--
 drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c |  9 +++++++--
 3 files changed, 17 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
index 8d3c61287696e..934cdb4227408 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -1000,6 +1000,8 @@ void mlxsw_sp_acl_ruleset_prio_get(struct mlxsw_sp_acl_ruleset *ruleset,
 struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 			  struct mlxsw_afa_block *afa_block);
+void mlxsw_sp_acl_rulei_free(struct mlxsw_sp *mlxsw_sp,
+			     const struct mlxsw_sp_acl_rule_info *rulei);
 void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index 3e70cee4d2f3e..cac2f15d91c23 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
@@ -340,8 +340,8 @@ mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 	return ERR_PTR(err);
 }
 
-void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp *mlxsw_sp,
-				struct mlxsw_sp_acl_rule_info *rulei)
+void mlxsw_sp_acl_rulei_free(struct mlxsw_sp *mlxsw_sp,
+			     const struct mlxsw_sp_acl_rule_info *rulei)
 {
 	if (rulei->action_created)
 		mlxsw_afa_block_destroy(rulei->act_block);
@@ -351,6 +351,12 @@ void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp *mlxsw_sp,
 	if (rulei->dst_port_range_reg_valid)
 		mlxsw_sp_port_range_reg_put(mlxsw_sp,
 					    rulei->dst_port_range_reg_index);
+}
+
+void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp *mlxsw_sp,
+				struct mlxsw_sp_acl_rule_info *rulei)
+{
+	mlxsw_sp_acl_rulei_free(mlxsw_sp, rulei);
 	kfree(rulei);
 }
 
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
index a8d4cf8b92998..0f3f5a573866b 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -852,14 +852,19 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
 	memset(&rulei, 0, sizeof(rulei));
 	err = mlxsw_sp_flower_parse(mlxsw_sp, block, &rulei, f);
 	if (err)
-		return err;
+		goto out;
+
 	ruleset = mlxsw_sp_acl_ruleset_get(mlxsw_sp, block,
 					   f->common.chain_index,
 					   MLXSW_SP_ACL_PROFILE_FLOWER,
 					   &rulei.values.elusage);
+	err = PTR_ERR_OR_ZERO(ruleset);
+
+out:
+	mlxsw_sp_acl_rulei_free(mlxsw_sp, &rulei);
 
 	/* keep the reference to the ruleset */
-	return PTR_ERR_OR_ZERO(ruleset);
+	return err;
 }
 
 void mlxsw_sp_flower_tmplt_destroy(struct mlxsw_sp *mlxsw_sp,
-- 
2.53.0



