Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2EE03D8103;
	Wed, 20 May 2026 16:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296371; cv=none; b=tsUAi+ZkO6Bnf3bdoItlDQPJzcDYqNqSsIfWm6cS6LechMY828ag/CPv08Rr6q/0HDh5iolA0Y16cXfD6YIp0ZVXfrayDM2MnulfGmtE71K+qpfmUS61nKzOjz0PIBP8D2nc+XNePOX36dMErxmvxU9cvL/tcz9K8I1zUmX32zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296371; c=relaxed/simple;
	bh=tQyXqC3eMGGF30iD6oZmmtjXEY1BaCaHYPR2t+Q1Fa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cnA1CdFXnl9lcEbDFIyXUU9NKbtpXjvLSNjGIAD5BRM2A8tXcF/hQ1UHi8V0DaPrKo/luH+kXM5dNZ2vK8aZbIYT/pfrQm5UVwM9EdwtwJuHQdLiP7d0/xE9dQ+ZadOSQrCW58gPsN7iwTYXroejNAM3edVQoHbvdZj1O9RqddA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WcDpgwPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WcDpgwPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD501F00893;
	Wed, 20 May 2026 16:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296368;
	bh=Vp6dMVB9k0yIIyuv12o8z0MjyP2JAJ09B5ZyaU/SVmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WcDpgwPhUThm36Vtd+LGEXErMD7lnjn0NSUl0+DfGXXpillzYx4P3E9Kw89kMxYhB
	 jstPXQ98jtqjS4eedY3OnMNyGOq9QtEGt99s1JSMDw1ojsghGPc3moLsyeUfK1HKX1
	 WUNh/Ve00VeqkYZHUp6sjrHy2RUdHWEwU2jtr/X4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0772/1146] net: airoha: Wait for NPU PPE configuration to complete in airoha_ppe_offload_setup()
Date: Wed, 20 May 2026 18:17:02 +0200
Message-ID: <20260520162205.689588973@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit f3206328bb52c2787197d80d7cbd687946047d5f ]

In order to properly enable flowtable hw offloading, poll
REG_PPE_FLOW_CFG register in airoha_ppe_offload_setup routine and
wait for NPU PPE configuration triggered by ppe_init callback to complete
before running airoha_ppe_hw_init().

Fixes: 00a7678310fe3 ("net: airoha: Introduce flowtable offload support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260414-airoha-wait-for-npu-config-offload-setup-v2-1-5a9bf6d43aee@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 28 ++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index 62cfffb4f0e55..684c8ae9576f1 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1335,6 +1335,29 @@ static struct airoha_npu *airoha_ppe_npu_get(struct airoha_eth *eth)
 	return npu;
 }
 
+static int airoha_ppe_wait_for_npu_init(struct airoha_eth *eth)
+{
+	int err;
+	u32 val;
+
+	/* PPE_FLOW_CFG default register value is 0. Since we reset FE
+	 * during the device probe we can just check the configured value
+	 * is not 0 here.
+	 */
+	err = read_poll_timeout(airoha_fe_rr, val, val, USEC_PER_MSEC,
+				100 * USEC_PER_MSEC, false, eth,
+				REG_PPE_PPE_FLOW_CFG(0));
+	if (err)
+		return err;
+
+	if (airoha_ppe_is_enabled(eth, 1))
+		err = read_poll_timeout(airoha_fe_rr, val, val, USEC_PER_MSEC,
+					100 * USEC_PER_MSEC, false, eth,
+					REG_PPE_PPE_FLOW_CFG(1));
+
+	return err;
+}
+
 static int airoha_ppe_offload_setup(struct airoha_eth *eth)
 {
 	struct airoha_npu *npu = airoha_ppe_npu_get(eth);
@@ -1348,6 +1371,11 @@ static int airoha_ppe_offload_setup(struct airoha_eth *eth)
 	if (err)
 		goto error_npu_put;
 
+	/* Wait for NPU PPE configuration to complete */
+	err = airoha_ppe_wait_for_npu_init(eth);
+	if (err)
+		goto error_npu_put;
+
 	ppe_num_stats_entries = airoha_ppe_get_total_num_stats_entries(ppe);
 	if (ppe_num_stats_entries > 0) {
 		err = npu->ops.ppe_init_stats(npu, ppe->foe_stats_dma,
-- 
2.53.0



