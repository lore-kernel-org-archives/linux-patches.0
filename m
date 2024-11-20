Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B45415853A;
	Wed, 20 Nov 2024 12:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107491; cv=none; b=j19xIlcd3fO4LsWX1VksEXGMSTm4EIysBOS/f3pz5F4JOfzp4raFW4robO5Z1mr0cZbtPZWI7vYm90aBZ4HLLyn/C6LDA7JChVSN6v50V7szsFtR7xhjc3SUyE7ErDpPNlM/eRs9UzaNbsShm6UDQpUhQ3xP6iTQtA+ILsAkq00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107491; c=relaxed/simple;
	bh=p19rQIXwdwjzf0VV7HfwqqWyjhwSho1E2fgNRr2Kzds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YEZE5ZmXAuv9DZFlkaJTIzlK/8/Pi5jTOUNJEqPQLrXh1wAysrUYm/Tq+zZBu6uuWrbRx1zsJyOmqIJoZ/PuhXs7YZaoTs90dpxyrUmymuoFZnn7RbgAknlZbFyhGQ4A1UmDwiJoaSK4y/i/BWL3whIHb1ARq15qURFMWxUjMag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPnVNzgZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPnVNzgZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26637C4CECD;
	Wed, 20 Nov 2024 12:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107491;
	bh=p19rQIXwdwjzf0VV7HfwqqWyjhwSho1E2fgNRr2Kzds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPnVNzgZcmLXJgzGvT6PdFFPA4UL7AcsKfp9Rmidp4L0TEBvBl1900pYkY03Zkxgb
	 xmx/fSyKAtXeAJSNRxIW0InvXBuepeINb/FuMs60BeqHP0vzLB+QJHtIxNVOLoA4Gf
	 6nUFaOPXUwPn/Z9HwC8GVT8Reh4JNT89mhj29B1E=
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
Subject: [PATCH 6.11 012/107] net/mlx5e: CT: Fix null-ptr-deref in add rule err flow
Date: Wed, 20 Nov 2024 13:55:47 +0100
Message-ID: <20241120125629.959140439@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 71a168746ebe2..deabed1d46a14 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c
@@ -866,7 +866,7 @@ mlx5_tc_ct_entry_add_rule(struct mlx5_tc_ct_priv *ct_priv,
 	return 0;
 
 err_rule:
-	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, zone_rule->attr, zone_rule->mh);
+	mlx5_tc_ct_entry_destroy_mod_hdr(ct_priv, attr, zone_rule->mh);
 	mlx5_put_label_mapping(ct_priv, attr->ct_attr.ct_labels_id);
 err_mod_hdr:
 	kfree(attr);
-- 
2.43.0



