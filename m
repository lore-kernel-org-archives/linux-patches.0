Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A93883546C8;
	Wed, 20 May 2026 17:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299178; cv=none; b=tctcgKvj66Cm9Fyfzt4BM9/lnOsLrLo1etjAbPElTylIDiJ8dUoZfCqmDxjattNMmBDR0mUE84zLOfM0XFzz/lFTnpn0sAbEZjRXI3J/GEzBNx/o7rvleZ4VKi4PH6+cV7wdN3iZ83NRv3yiy2me4TmqufzVTO5UtG5361bBByA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299178; c=relaxed/simple;
	bh=zIawil63On3d5YS4qVpuyVnSFEHb2VGH//mjpB62ueU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BVoScN9gyCuCtgm37tUrrPk8q2rsndcCl+18EfCbJmtmnMETWCL9wnF9MeU2FshRP0zlzsxsUHMrsJooqXEFWgoFSrWvxca209EoySsXWdWAZu8srwD/gvu+MqgtenHq9dNIu6JstAxYcL88aA2cwGKS7Qhin5k5HxgLCU8oJx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v01C2PXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v01C2PXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B2FF1F000E9;
	Wed, 20 May 2026 17:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299177;
	bh=0pVoIVrNZwfWn91wgMT0RHq2tEJd5ybfk+DKlYQSq7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v01C2PXc/0fqk2wMGjfkzXiRm2V8IM42jfFCy41WqhYVneIXUR1FQ4V7P90FQ7YZ8
	 UcK+D6rZvX3I6C3gSPPylFgNxMIk8enlZQTETb6vBKELIb3MgIflfJbSqPc49KtHtu
	 AaEhvhFAdY0rSZOwVLIamzmiYamhpd907e4sRqLQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 691/957] net: airoha: ppe: Dynamically allocate foe_check_time array in airoha_ppe struct
Date: Wed, 20 May 2026 18:19:34 +0200
Message-ID: <20260520162149.524845619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 6d5b601d52a27aafff555b480e538507901c672c ]

This is a preliminary patch to properly enable PPE support for AN7583
SoC.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20251017-an7583-eth-support-v3-2-f28319666667@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Stable-dep-of: 3309965fe44c ("net: airoha: Add missing bits in airoha_qdma_cleanup_tx_queue()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_eth.h | 2 +-
 drivers/net/ethernet/airoha/airoha_ppe.c | 5 +++++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/airoha/airoha_eth.h b/drivers/net/ethernet/airoha/airoha_eth.h
index 054fe86d67bd1..9929c44d84702 100644
--- a/drivers/net/ethernet/airoha/airoha_eth.h
+++ b/drivers/net/ethernet/airoha/airoha_eth.h
@@ -548,7 +548,7 @@ struct airoha_ppe {
 	struct rhashtable l2_flows;
 
 	struct hlist_head *foe_flow;
-	u16 foe_check_time[PPE_NUM_ENTRIES];
+	u16 *foe_check_time;
 
 	struct airoha_foe_stats *foe_stats;
 	dma_addr_t foe_stats_dma;
diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index e9994c794c703..072cc2dd50dda 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1538,6 +1538,11 @@ int airoha_ppe_init(struct airoha_eth *eth)
 			return -ENOMEM;
 	}
 
+	ppe->foe_check_time = devm_kzalloc(eth->dev, PPE_NUM_ENTRIES,
+					   GFP_KERNEL);
+	if (!ppe->foe_check_time)
+		return -ENOMEM;
+
 	err = rhashtable_init(&eth->flow_table, &airoha_flow_table_params);
 	if (err)
 		return err;
-- 
2.53.0



