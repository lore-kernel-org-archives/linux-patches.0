Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B8122EBB83;
	Tue, 15 Jul 2025 13:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587171; cv=none; b=hPbaAUhgtsVhcxSM3lY8fRDVM7L9urmh/uun776PMkl7hVYADoxS+RUUTiqJeyUJ2pLdwSzB8nJR+r0Bg8De3lU+JQDh2O8iDL8GSTidcd+klcoU/CaE0xQCgv2eHdgbHhTuZF7Vko0u3UNY/hLtpz3ISnBDjFhsQUufM96qXLw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587171; c=relaxed/simple;
	bh=/JgwvGRaYAUs++OiMyU9wpp0gbRZWPrLWAwuhNn8IrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X3tRPAeayiXttjGOVd0+AYWLS+oo7lB8bvqr6/h2JmYz+Oai3V8zrq4JnCVDMUztGs10kw3wAFD45nKEBrwrV35i7TUtCFq+lhFix3vMNmFs5HOI48nhzVqastqA0cAdEgkxOjtkc+cCscmQ5Wo3icwGFcxrz6+nqM/JSCMyROU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vf47KSJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vf47KSJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EA5FC4CEE3;
	Tue, 15 Jul 2025 13:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587171;
	bh=/JgwvGRaYAUs++OiMyU9wpp0gbRZWPrLWAwuhNn8IrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vf47KSJiAQ4caZMG4XJZ4wDZK4dkkgG+/Q41QgdcMx4wuj2pBccL+gAEb02pmYiYp
	 D6y/yyelTBPw6SKScTQqR0itwsRw0OAhsKIrctPzt0Cv3upzLOqBRghDfLcjQbiWLJ
	 FZuIm1xvMdlySx2SJMBCiGPB/A4Stv23GycCIIE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 162/192] net/mlx5e: Add new prio for promiscuous mode
Date: Tue, 15 Jul 2025 15:14:17 +0200
Message-ID: <20250715130821.413654873@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 4c9fce56fa702059bbc5ab737265b68f79cbaac4 ]

An optimization for promiscuous mode adds a high-priority steering
table with a single catch-all rule to steer all traffic directly to
the TTC table.

However, a gap exists between the creation of this table and the
insertion of the catch-all rule. Packets arriving in this brief window
would miss as no rule was inserted yet, unnecessarily incrementing the
'rx_steer_missed_packets' counter and dropped.

This patch resolves the issue by introducing a new prio for this
table, placing it between MLX5E_TC_PRIO and MLX5E_NIC_PRIO. By doing
so, packets arriving during the window now fall through to the next
prio (at MLX5E_NIC_PRIO) instead of being dropped.

Fixes: 1c46d7409f30 ("net/mlx5e: Optimize promiscuous mode")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/1752155624-24095-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h   |  9 +++++++--
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 13 +++++++++----
 3 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index b5c3a2a9d2a59..9560fcba643f5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -18,7 +18,8 @@ enum {
 
 enum {
 	MLX5E_TC_PRIO = 0,
-	MLX5E_NIC_PRIO
+	MLX5E_PROMISC_PRIO,
+	MLX5E_NIC_PRIO,
 };
 
 struct mlx5e_flow_table {
@@ -68,9 +69,13 @@ struct mlx5e_l2_table {
 				 MLX5_HASH_FIELD_SEL_DST_IP   |\
 				 MLX5_HASH_FIELD_SEL_IPSEC_SPI)
 
-/* NIC prio FTS */
+/* NIC promisc FT level */
 enum {
 	MLX5E_PROMISC_FT_LEVEL,
+};
+
+/* NIC prio FTS */
+enum {
 	MLX5E_VLAN_FT_LEVEL,
 	MLX5E_L2_FT_LEVEL,
 	MLX5E_TTC_FT_LEVEL,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
index 05058710d2c79..537e732085b22 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_fs.c
@@ -776,7 +776,7 @@ static int mlx5e_create_promisc_table(struct mlx5e_flow_steering *fs)
 	ft_attr.max_fte = MLX5E_PROMISC_TABLE_SIZE;
 	ft_attr.autogroup.max_num_groups = 1;
 	ft_attr.level = MLX5E_PROMISC_FT_LEVEL;
-	ft_attr.prio = MLX5E_NIC_PRIO;
+	ft_attr.prio = MLX5E_PROMISC_PRIO;
 
 	ft->t = mlx5_create_auto_grouped_flow_table(fs->ns, &ft_attr);
 	if (IS_ERR(ft->t)) {
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 445301ea70426..53c4eba9867df 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -113,13 +113,16 @@
 #define ETHTOOL_PRIO_NUM_LEVELS 1
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
-/* Promiscuous, Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy,
+/* Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy,
  * {IPsec RoCE MPV,Alias table},IPsec RoCE policy
  */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 11
+#define KERNEL_NIC_PRIO_NUM_LEVELS 10
 #define KERNEL_NIC_NUM_PRIOS 1
-/* One more level for tc */
-#define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 1)
+/* One more level for tc, and one more for promisc */
+#define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 2)
+
+#define KERNEL_NIC_PROMISC_NUM_PRIOS 1
+#define KERNEL_NIC_PROMISC_NUM_LEVELS 1
 
 #define KERNEL_NIC_TC_NUM_PRIOS  1
 #define KERNEL_NIC_TC_NUM_LEVELS 3
@@ -187,6 +190,8 @@ static struct init_tree_node {
 			   ADD_NS(MLX5_FLOW_TABLE_MISS_ACTION_DEF,
 				  ADD_MULTIPLE_PRIO(KERNEL_NIC_TC_NUM_PRIOS,
 						    KERNEL_NIC_TC_NUM_LEVELS),
+				  ADD_MULTIPLE_PRIO(KERNEL_NIC_PROMISC_NUM_PRIOS,
+						    KERNEL_NIC_PROMISC_NUM_LEVELS),
 				  ADD_MULTIPLE_PRIO(KERNEL_NIC_NUM_PRIOS,
 						    KERNEL_NIC_PRIO_NUM_LEVELS))),
 		  ADD_PRIO(0, BY_PASS_MIN_LEVEL, 0, FS_CHAINING_CAPS,
-- 
2.39.5



