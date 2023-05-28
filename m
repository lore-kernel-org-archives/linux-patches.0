Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2132611E
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:38:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D7FAC433D2;
	Sun, 28 May 2023 19:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302733;
	bh=2YnKG/u1enG7Whl4T4pOCXXfFaDk9JuCPV89dYTqLEg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRP6cEd67PTyhPs7KRgmxU7vihAXkrxvGnpykokbS8Qkd3voM8r7qO1Frmfur9sT0
	 aoPZw0leZ3kEtHCEK++FSFzjWypN2egLJEh4zT5h4GfwPMQq/FstHslFwPd8lp8l1G
	 w2z5teGTuW+hfbdtQY19RuLRX9NGEsPnq5Qc6P5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>
Subject: [PATCH 6.1 105/119] net/mlx5e: Use correct encap attribute during invalidation
Date: Sun, 28 May 2023 20:11:45 +0100
Message-Id: <20230528190838.981343118@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vlad Buslov <vladbu@nvidia.com>

commit be071cdb167fc3e25fe81922166b3d499d23e8ac upstream.

With introduction of post action infrastructure most of the users of encap
attribute had been modified in order to obtain the correct attribute by
calling mlx5e_tc_get_encap_attr() helper instead of assuming encap action
is always on default attribute. However, the cited commit didn't modify
mlx5e_invalidate_encap() which prevents it from destroying correct modify
header action which leads to a warning [0]. Fix the issue by using correct
attribute.

[0]:

Feb 21 09:47:35 c-237-177-40-045 kernel: WARNING: CPU: 17 PID: 654 at drivers/net/ethernet/mellanox/mlx5/core/en_tc.c:684 mlx5e_tc_attach_mod_hdr+0x1cc/0x230 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel: RIP: 0010:mlx5e_tc_attach_mod_hdr+0x1cc/0x230 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel: Call Trace:
Feb 21 09:47:35 c-237-177-40-045 kernel:  <TASK>
Feb 21 09:47:35 c-237-177-40-045 kernel:  mlx5e_tc_fib_event_work+0x8e3/0x1f60 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? mlx5e_take_all_encap_flows+0xe0/0xe0 [mlx5_core]
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lock_downgrade+0x6d0/0x6d0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x273/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x273/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  process_one_work+0x7c2/0x1310
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? lockdep_hardirqs_on_prepare+0x3f0/0x3f0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? pwq_dec_nr_in_flight+0x230/0x230
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? rwlock_bug.part.0+0x90/0x90
Feb 21 09:47:35 c-237-177-40-045 kernel:  worker_thread+0x59d/0xec0
Feb 21 09:47:35 c-237-177-40-045 kernel:  ? __kthread_parkme+0xd9/0x1d0

Fixes: 8300f225268b ("net/mlx5e: Create new flow attr for multi table actions")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -1338,11 +1338,13 @@ static void mlx5e_invalidate_encap(struc
 	struct mlx5e_tc_flow *flow;
 
 	list_for_each_entry(flow, encap_flows, tmp_list) {
-		struct mlx5_flow_attr *attr = flow->attr;
 		struct mlx5_esw_flow_attr *esw_attr;
+		struct mlx5_flow_attr *attr;
 
 		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
+
+		attr = mlx5e_tc_get_encap_attr(flow);
 		esw_attr = attr->esw_attr;
 
 		if (flow_flag_test(flow, SLOW))


