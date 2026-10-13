Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955DF4F4CF8;
	Tue, 13 Oct 2026 12:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894546; cv=none; b=OKyiEWEBZQ4+WerDnno2qvJoWoakzAYzv+G2LVDfUZLaemHqW7V+IOb0k3E69/h9KkeJY4yme+UMjHuC61576F9gequ4Ro11A5EbgciKlvP2He22lni2CU6u12SfcRYAxYzPHen5LlhXcCyW93Qc8c1GLJnu9taRBSzKBIxmJWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894546; c=relaxed/simple;
	bh=7H0Bf5upbq2df+vd+3qdao6xx0ciK4njidsPWyv0iIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nUiR7VJq3p/q5Uxk/cTfzIOtm6Yjhvw5qrRd9sfo5DpkTIkJtLZB25HZ0oktySp9RQCjlJqbKDsOWs2Xl0K5GunJMcfdAWF674zr4hG3fJe1QTJkJ1NBF0WK5GjzwNxdiY27Hn1UdMWMU3gLYWacF+6tWET/Aw16BgjYKJRUXjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2HE317+u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2HE317+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1801F000FF;
	Tue, 13 Oct 2026 12:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894543;
	bh=DpBqrf0VQSNkj3C18sc6/QPWllgUmY9Iiam8GOdDGSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2HE317+uofNKl5H0nxhx49HlWPDaD+d00FVhqsc7ERwdvTTgTsu+IJ2JIpfJVnqA8
	 FAJhVwdrGOb/ZNNSlZUwambNxB0BI9ZTv+YsADXMSpn0+CzGGbx1ugili+TlfLdkNi
	 8fWbU2EGXKORdENM9exgCnv9Qd7RpWWKtMHrhOnA=
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
Subject: [PATCH 6.18 596/621] mlxsw: spectrum_flower: Fix port range register leak in tmplt_create()
Date: Tue, 13 Oct 2026 13:39:51 +0200
Message-ID: <20261013112934.944397674@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b03ff9e044f9e..10af08ce72efa 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.h
@@ -989,6 +989,8 @@ void mlxsw_sp_acl_ruleset_prio_get(struct mlxsw_sp_acl_ruleset *ruleset,
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
index 353fd9ca89a68..5e4632cb792d5 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_flower.c
@@ -862,14 +862,19 @@ int mlxsw_sp_flower_tmplt_create(struct mlxsw_sp *mlxsw_sp,
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



