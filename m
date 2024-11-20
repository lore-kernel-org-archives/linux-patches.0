Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F761BD9CC;
	Wed, 20 Nov 2024 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107571; cv=none; b=Pe7X2/gguZVAbcc8EOqwWdmjrBJ+XIhRZhr4Zx/Qw3GHHXIU0wdUD2Yxfm5aKiukrYUXGDk4f0Fx2O2hg/9ZB3h/UJr4+6Sl+nqOyxd4Wz8Im6SIyqhxGXObpSdxK4eSioAynaa9tVDD21JLwezXKZtiX+wZ5+Nf28rXkzstVMg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107571; c=relaxed/simple;
	bh=S3az6dTGuOns76O+/+kTlCPmRFtjzop4rdjWsKbOMQM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O1ZVF3GKLooCCgupo0yppbENmnUobyKLK/adOQf+UEgHGLYYSjdlCyKkqXYNtlHzy/hvl8CEegn20H0aQ9gIFvVHS7yWm3lSUJnvediZ0BvWgpI8lIoPrjkemORy6zzk1gaY3IMRTH6G40fsPPXhEV/f7j6r17Xle+ZKI8/2bB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKDgSQjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKDgSQjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FED4C4CECD;
	Wed, 20 Nov 2024 12:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107571;
	bh=S3az6dTGuOns76O+/+kTlCPmRFtjzop4rdjWsKbOMQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PKDgSQjMfMMyLK0m1dpmqHckAxiFE9/Dz7/e8Ec+V7d9zox6tQKMQDOqJEQ301ZdH
	 Ou3MKA820kT0EZdKVS3j6tPGUrIFynPnuwqI3FwLpeB4EH9mdHEiemWTXBMY/kTqU+
	 6Im4sEOLbaOfVPCTrsqDQ+SQr6ktL/wgczhzt2N8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 10/82] net/mlx5e: CT: Fix null-ptr-deref in add rule err flow
Date: Wed, 20 Nov 2024 13:56:20 +0100
Message-ID: <20241120125629.849107811@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
References: <20241120125629.623666563@linuxfoundation.org>
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

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit e99c6873229fe0482e7ceb7d5600e32d623ed9d9 ]

In error flow of mlx5_tc_ct_entry_add_rule(), in case ct_rule_add()
callback returns error, zone_rule->attr is used uninitiated. Fix it to
use attr which has the needed pointer value.

Kernel log:
 BUG: kernel NULL pointer dereference, address: 0000000000000110
 RIP: 0010:mlx5_tc_ct_entry_add_rule+0x2b1/0x2f0 [mlx5_core]
…
 Call Trace:
  <TASK>
  ? __die+0x20/0x70
  ? page_fault_oops+0x150/0x3e0
  ? exc_page_fault+0x74/0x140
  ? asm_exc_page_fault+0x22/0x30
  ? mlx5_tc_ct_entry_add_rule+0x2b1/0x2f0 [mlx5_core]
  ? mlx5_tc_ct_entry_add_rule+0x1d5/0x2f0 [mlx5_core]
  mlx5_tc_ct_block_flow_offload+0xc6a/0xf90 [mlx5_core]
  ? nf_flow_offload_tuple+0xd8/0x190 [nf_flow_table]
  nf_flow_offload_tuple+0xd8/0x190 [nf_flow_table]
  flow_offload_work_handler+0x142/0x320 [nf_flow_table]
  ? finish_task_switch.isra.0+0x15b/0x2b0
  process_one_work+0x16c/0x320
  worker_thread+0x28c/0x3a0
  ? __pfx_worker_thread+0x10/0x10
  kthread+0xb8/0xf0
  ? __pfx_kthread+0x10/0x10
  ret_from_fork+0x2d/0x50
  ? __pfx_kthread+0x10/0x10
  ret_from_fork_asm+0x1a/0x30
  </TASK>

Fixes: 7fac5c2eced3 ("net/mlx5: CT: Avoid reusing modify header context for natted entries")
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241107183527.676877-7-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
index 8c4e3ecef5901..65cee5c6f1dd6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -854,7 +854,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 
 err_rule:
-	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, zone_rule->mh);
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, attr, zone_rule->mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
-- 
2.43.0



