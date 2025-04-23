Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 352A25674E;
	Wed, 23 Apr 2025 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419845; cv=none; b=TuBnvLOVuAwxMVhSeJ4MEhXH4LkT6uaGlILXRYd8+eXmUztRcTK+W5qITzeBlEvIBWwKOj1wr1o2A4D86zBz3HMYvuAglEFcrZQ6GawOuyMlTyeggRPJYNJW8rRl/IE+viOwsuu2yEHMKVHITb1Bt1Wq3yz8rJHY3BTI01cKNzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419845; c=relaxed/simple;
	bh=S6VBzRTDWG3OtqZdyFTWsKambqYReE1t9iULWxLExl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4c4CkKmiPwwX1PxO5pBK2agSJJM8ZJakI5LLhNIM9uislpi3IfSXzoCSnZBy2AiECpipfhANipRD4VkseUU021YCUqC/5M026jftomTopvpAs3r0SD/cPqdQQBfwxwXPF5ZsLwszqno1LPgZWJ5NQ/S1+uOKrSiRSM0GGL3XgM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bp0p7nUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bp0p7nUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF5E9C4CEE2;
	Wed, 23 Apr 2025 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419845;
	bh=S6VBzRTDWG3OtqZdyFTWsKambqYReE1t9iULWxLExl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bp0p7nUsP3PbPgnPJ6x32fZhTT2cEylhBRNeyz3L8ejyaSO4IpaJ41ZyTEhBl9Cyk
	 TWZjofUrhvEGUDiZTv9MFRy1OI5o7ShVVfkAaHTAoLO2HYa+Wln8aBhAwi0D2Bmlm/
	 7tBIFTPbVzMnNa0oV5ho+puHjOuXWeJnFRbM7Vuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/393] octeontx2-pf: qos: fix VF root node parent queue index
Date: Wed, 23 Apr 2025 16:38:27 +0200
Message-ID: <20250423142643.739226029@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hariprasad Kelam <hkelam@marvell.com>

[ Upstream commit b7db94734e785e380b0db0f9295e07024f4d42a0 ]

The current code configures the Physical Function (PF) root node at TL1
and the Virtual Function (VF) root node at TL2.

This ensure at any given point of time PF traffic gets more priority.

                    PF root node
                      TL1
                     /  \
                    TL2  TL2 VF root node
                    /     \
                   TL3    TL3
                   /       \
                  TL4      TL4
                  /         \
                 SMQ        SMQ

Due to a bug in the current code, the TL2 parent queue index on the
VF interface is not being configured, leading to 'SMQ Flush' errors

Fixes: 5e6808b4c68d ("octeontx2-pf: Add support for HTB offload")
Signed-off-by: Hariprasad Kelam <hkelam@marvell.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250407070341.2765426-1-hkelam@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/qos.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
index 4995a2d54d7d0..37db19584c143 100644
--- a/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/qos.c
@@ -165,6 +165,11 @@ static void __otx2_qos_txschq_cfg(struct otx2_nic *pfvf,
 
 		otx2_config_sched_shaping(pfvf, node, cfg, &num_regs);
 	} else if (level == NIX_TXSCH_LVL_TL2) {
+		/* configure parent txschq */
+		cfg->reg[num_regs] = NIX_AF_TL2X_PARENT(node->schq);
+		cfg->regval[num_regs] = (u64)hw->tx_link << 16;
+		num_regs++;
+
 		/* configure link cfg */
 		if (level == pfvf->qos.link_cfg_lvl) {
 			cfg->reg[num_regs] = NIX_AF_TL3_TL2X_LINKX_CFG(node->schq, hw->tx_link);
-- 
2.39.5



