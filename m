Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57487222590;
	Mon, 22 Sep 2025 19:42:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758570148; cv=none; b=es0xtyxeozHdjZyMx7be0xAWpSBs0ui5Xs8BNdNfCuYhAPkSW0jqTTZ/o5NfEHyi0XSqO4ZwznJxU2SOcZbkxjeNi0wPjVV1xyu0lJxwWgDrloE8cv1iUccYwpDCz8y8C/Fy7Ky9832DpSyjgLk9hrmF1811QZ8NgAyGp6oa7VE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758570148; c=relaxed/simple;
	bh=B7FZYyOBDT+3A+/jD2i1p2owmz/Zlin7bzCmTiksi8Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A/wqwUap31MWYDrat884aen9YYeru+/ieGMzTN1aUA6SDVxhoibMTIxw7ki+Vc4b6jL/1+nWdDV14l22W9YVJIchs3TlUUv5b9O6YJQzeYDbXqbDP+ZR0tzKeVQ1314TnoV8aNU2NOiDci9nSpfRmRJLaBcggq53ehY2CSM22ow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBYP+g94; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBYP+g94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBE4C4CEF0;
	Mon, 22 Sep 2025 19:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1758570148;
	bh=B7FZYyOBDT+3A+/jD2i1p2owmz/Zlin7bzCmTiksi8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rBYP+g94lmIcDyct9ztLQipioWyfYKnGjO2w7LOpun4zS9rFdm9r8YZU8314FmPd+
	 gHmwMqLR//NV5KtLBMV2sjEdDk9OHm83RhNZ7pVRqD6FziGjvzUpkwkoTjiEBJbEtF
	 h1rEmEKnxwY95rIctwlG7whbuOCTvKF8rW9fONQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Chris Mi <cmi@nvidia.com>,
	Lama Kayal <lkayal@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 037/149] net/mlx5e: Add a miss level for ipsec crypto offload
Date: Mon, 22 Sep 2025 21:28:57 +0200
Message-ID: <20250922192413.801432373@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
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

From: Lama Kayal <lkayal@nvidia.com>

[ Upstream commit 7601a0a46216f4ba05adff2de75923b4e8e585c2 ]

The cited commit adds a miss table for switchdev mode. But it
uses the same level as policy table. Will hit the following error
when running command:

 # ip xfrm state add src 192.168.1.22 dst 192.168.1.21 proto	\
	esp spi 1001 reqid 10001 aead 'rfc4106(gcm(aes))'	\
	0x3a189a7f9374955d3817886c8587f1da3df387ff 128		\
	mode tunnel offload dev enp8s0f0 dir in
 Error: mlx5_core: Device failed to offload this state.

The dmesg error is:

 mlx5_core 0000:03:00.0: ipsec_miss_create:578:(pid 311797): fail to create IPsec miss_rule err=-22

Fix it by adding a new miss level to avoid the error.

Fixes: 7d9e292ecd67 ("net/mlx5e: Move IPSec policy check after decryption")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Chris Mi <cmi@nvidia.com>
Signed-off-by: Lama Kayal <lkayal@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1757939074-617281-4-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h             | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h    | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c           | 4 ++--
 4 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
index 9560fcba643f5..ac65e31914802 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/fs.h
@@ -92,6 +92,7 @@ enum {
 	MLX5E_ACCEL_FS_ESP_FT_LEVEL = MLX5E_INNER_TTC_FT_LEVEL + 1,
 	MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL,
 	MLX5E_ACCEL_FS_POL_FT_LEVEL,
+	MLX5E_ACCEL_FS_POL_MISS_FT_LEVEL,
 	MLX5E_ACCEL_FS_ESP_FT_ROCE_LEVEL,
 #endif
 };
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
index ffcd0cdeb7754..23703f28386ad 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h
@@ -185,6 +185,7 @@ struct mlx5e_ipsec_rx_create_attr {
 	u32 family;
 	int prio;
 	int pol_level;
+	int pol_miss_level;
 	int sa_level;
 	int status_level;
 	enum mlx5_flow_namespace_type chains_ns;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
index 98b6a3a623f99..65dc3529283b6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c
@@ -747,6 +747,7 @@ static void ipsec_rx_create_attr_set(struct mlx5e_ipsec *ipsec,
 	attr->family = family;
 	attr->prio = MLX5E_NIC_PRIO;
 	attr->pol_level = MLX5E_ACCEL_FS_POL_FT_LEVEL;
+	attr->pol_miss_level = MLX5E_ACCEL_FS_POL_MISS_FT_LEVEL;
 	attr->sa_level = MLX5E_ACCEL_FS_ESP_FT_LEVEL;
 	attr->status_level = MLX5E_ACCEL_FS_ESP_FT_ERR_LEVEL;
 	attr->chains_ns = MLX5_FLOW_NAMESPACE_KERNEL;
@@ -833,7 +834,7 @@ static int ipsec_rx_chains_create_miss(struct mlx5e_ipsec *ipsec,
 
 	ft_attr.max_fte = 1;
 	ft_attr.autogroup.max_num_groups = 1;
-	ft_attr.level = attr->pol_level;
+	ft_attr.level = attr->pol_miss_level;
 	ft_attr.prio = attr->prio;
 
 	ft = mlx5_create_auto_grouped_flow_table(attr->ns, &ft_attr);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 29ce09af59aef..3b57ef6b3de38 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -114,9 +114,9 @@
 #define ETHTOOL_NUM_PRIOS 11
 #define ETHTOOL_MIN_LEVEL (KERNEL_MIN_LEVEL + ETHTOOL_NUM_PRIOS)
 /* Vlan, mac, ttc, inner ttc, {UDP/ANY/aRFS/accel/{esp, esp_err}}, IPsec policy,
- * {IPsec RoCE MPV,Alias table},IPsec RoCE policy
+ * IPsec policy miss, {IPsec RoCE MPV,Alias table},IPsec RoCE policy
  */
-#define KERNEL_NIC_PRIO_NUM_LEVELS 10
+#define KERNEL_NIC_PRIO_NUM_LEVELS 11
 #define KERNEL_NIC_NUM_PRIOS 1
 /* One more level for tc, and one more for promisc */
 #define KERNEL_MIN_LEVEL (KERNEL_NIC_PRIO_NUM_LEVELS + 2)
-- 
2.51.0



