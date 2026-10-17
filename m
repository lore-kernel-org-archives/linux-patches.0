Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C6223BFAD1;
	Sat, 17 Oct 2026 17:17:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257429; cv=none; b=Nocg32B9J8oecIFV4aQr+tQtf31rZKH/cV9xrF8K3jWJaxviZkQTvZiQqC5vf4UPUreL3EmXjm57R3TmtApCJxrptgECcWJIl4T4SLFGkvDgTTAPLibFTa08YVOCirhpAgfw9aTBTE0hlzJdHH2lW44AjJxFdY6dtyotTf6eJ8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257429; c=relaxed/simple;
	bh=Pod4c1LGuOzAs001iVN3lvp2Svp5V+Pty4TtDJKQkGM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UKE4hU1LoG9wjpLJYeEPXNeVO57qUHb6bPqZy51zTFm+QmbyV30YLhD260srsKPXlDS6mIXEs9gHrX/w4v9InbUnC9SIvxUBXjUUdgGoXBLW5ROEdgqBoGSeL/ryhhUbXw/0HsRnCbF63xB3RQqoY34xqM/chqJ8D2Ozlj0Qqqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AiRvlx7H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AiRvlx7H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A7C1F000C5;
	Sat, 17 Oct 2026 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257428;
	bh=uk9nV16O7twOE3h0OblWAEdiz5ax81HUJP0kvrYxM9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AiRvlx7H75DUzanO7dx1r/ULQ1oy9R64SjRLBtOCF4K0WTMbYWSyfXJrW3PNHV49n
	 VFMUgWFQyLwIr0meo79Xa+zvuwS6lZmo+CddW9MYDwLE39LHEBpMvpb9umukBv62+v
	 LSpoYs8yTne8NaEDaXEQSlRE0mkzpM7EMau1c2nc=
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
Subject: [PATCH 6.6 0555/1674] mlxsw: spectrum_flower: Fix port range register leak in tmplt_create()
Date: Sat, 17 Oct 2026 17:47:07 +0200
Message-ID: <20261017160445.341173065@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 02ca2871b6f9f..1422ffaff856a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -998,6 +998,8 @@ void mlxsw_sp_acl_ruleset_prio_get(struct mlxsw_sp_acl_ruleset *ruleset,
 struct mlxsw_sp_acl_rule_info *
 mlxsw_sp_acl_rulei_create(struct mlxsw_sp_acl *acl,
 			  struct mlxsw_afa_block *afa_block);
+void mlxsw_sp_acl_rulei_free(struct mlxsw_sp *mlxsw_sp,
+			     const struct mlxsw_sp_acl_rule_info *rulei);
 void mlxsw_sp_acl_rulei_destroy(struct mlxsw_sp *mlxsw_sp,
 				struct mlxsw_sp_acl_rule_info *rulei);
 int mlxsw_sp_acl_rulei_commit(struct mlxsw_sp_acl_rule_info *rulei);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_acl.c
index b01b000bc71c1..eac09cd6ecd47 100644
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
index fba545938fd7d..7892c4d222cee 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -848,14 +848,19 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
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



