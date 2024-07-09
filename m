Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C0E3155389;
	Tue,  9 Jul 2024 11:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523649; cv=none; b=GrfZVGREYIbBfuTwMYPsKQWhIqYzkCperWdu/FMDSJCtJJWyc5eH9MtBcwM+Pt6Eer2x4NUJyLzDCLeutNR+xyiWi7e/1U8Tak4yB5g8G0yhvdh41gtAEffrivBqq6rrrR7i2aZDNb7zYOaanFCSfNv2xUoppEzFfH057DX/G40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523649; c=relaxed/simple;
	bh=RsoNwXtjvc6k83jcDswS3myWvCQGQ/vPlNtr+pH9PpY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vE8Ixu4PNmfdaEmTQbHMpuV5M9MsDEjAMXn90tHSfCinkdwct5JUJXQcDyk7szCItlBaxMZnMhHG1k/LzlI1Yo7du5+yBIGTZgEZVrf33mff/Gt7LLp/vIxL+hvTKXlY48rcnFnLs4mFNIkFYNlKqCPtRPSrtLz2cWhdAtvvkO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BYGRyQ9d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BYGRyQ9d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BC9C3277B;
	Tue,  9 Jul 2024 11:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523649;
	bh=RsoNwXtjvc6k83jcDswS3myWvCQGQ/vPlNtr+pH9PpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BYGRyQ9d6g9GS7AI9VG7NQ4/0T+Np64DykfkcyL+HqZXiOuC0sc7PI08MZ3Ve0MDC
	 YA95HIn8ckTV6TkpL56kkG13RxbEvd5IQGJfJXSHYhtqbz5yWIxe2G2MoNpsl+yUgi
	 ZcdZdfy0Eb8ERJLJsUet9x1e78/WEN5XcsQvbffw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 064/139] net/mlx5: E-switch, Create ingress ACL when needed
Date: Tue,  9 Jul 2024 13:09:24 +0200
Message-ID: <20240709110700.649799186@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit b20c2fb45470d0c7a603613c9cfa5d45720e17f2 ]

Currently, ingress acl is used for three features. It is created only
when vport metadata match and prio tag are enabled. But active-backup
lag mode also uses it. It is independent of vport metadata match and
prio tag. And vport metadata match can be disabled using the
following devlink command:

 # devlink dev param set pci/0000:08:00.0 name esw_port_metadata \
	value false cmode runtime

If ingress acl is not created, will hit panic when creating drop rule
for active-backup lag mode. If always create it, there will be about
5% performance degradation.

Fix it by creating ingress acl when needed. If esw_port_metadata is
true, ingress acl exists, then create drop rule using existing
ingress acl. If esw_port_metadata is false, create ingress acl and
then create drop rule.

Fixes: 1749c4c51c16 ("net/mlx5: E-switch, add drop rule support to ingress ACL")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/esw/acl/ingress_ofld.c | 37 +++++++++++++++----
 1 file changed, 29 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
index 50d2ea3239798..a436ce895e45a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/ingress_ofld.c
@@ -6,6 +6,9 @@
 #include "helper.h"
 #include "ofld.h"
 
+static int
+acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport);
+
 static bool
 esw_acl_ingress_prio_tag_enabled(struct mlx5_eswitch *esw,
 				 const struct mlx5_vport *vport)
@@ -123,18 +126,31 @@ static int esw_acl_ingress_src_port_drop_create(struct mlx5_eswitch *esw,
 {
 	struct mlx5_flow_act flow_act = {};
 	struct mlx5_flow_handle *flow_rule;
+	bool created = false;
 	int err = 0;
 
+	if (!vport->ingress.acl) {
+		err = acl_ingress_ofld_setup(esw, vport);
+		if (err)
+			return err;
+		created = true;
+	}
+
 	flow_act.action = MLX5_FLOW_CONTEXT_ACTION_DROP;
 	flow_act.fg = vport->ingress.offloads.drop_grp;
 	flow_rule = mlx5_add_flow_rules(vport->ingress.acl, NULL, &flow_act, NULL, 0);
 	if (IS_ERR(flow_rule)) {
 		err = PTR_ERR(flow_rule);
-		goto out;
+		goto err_out;
 	}
 
 	vport->ingress.offloads.drop_rule = flow_rule;
-out:
+
+	return 0;
+err_out:
+	/* Only destroy ingress acl created in this function. */
+	if (created)
+		esw_acl_ingress_ofld_cleanup(esw, vport);
 	return err;
 }
 
@@ -299,16 +315,12 @@ static void esw_acl_ingress_ofld_groups_destroy(struct mlx5_vport *vport)
 	}
 }
 
-int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
-			       struct mlx5_vport *vport)
+static int
+acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
 {
 	int num_ftes = 0;
 	int err;
 
-	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
-	    !esw_acl_ingress_prio_tag_enabled(esw, vport))
-		return 0;
-
 	esw_acl_ingress_allow_rule_destroy(vport);
 
 	if (mlx5_eswitch_vport_match_metadata_enabled(esw))
@@ -347,6 +359,15 @@ int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw,
 	return err;
 }
 
+int esw_acl_ingress_ofld_setup(struct mlx5_eswitch *esw, struct mlx5_vport *vport)
+{
+	if (!mlx5_eswitch_vport_match_metadata_enabled(esw) &&
+	    !esw_acl_ingress_prio_tag_enabled(esw, vport))
+		return 0;
+
+	return acl_ingress_ofld_setup(esw, vport);
+}
+
 void esw_acl_ingress_ofld_cleanup(struct mlx5_eswitch *esw,
 				  struct mlx5_vport *vport)
 {
-- 
2.43.0



