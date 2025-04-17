Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11B38259CB9;
	Thu, 17 Apr 2025 18:38:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915107; cv=none; b=g3w3rgKhrpylfEcu5J8RiEfpsclH6d3utAa2/ONAb0RKvjuz2FgqFVRlP+geuo5FG/cJSmFo+OLU7634Z6/EbJwMcng04mTTBXC9AKY4pjjHEdxihrNgZKj2KSIbSMfvx4GV5RQNvdS/grsbuG6+YS6b5rtis6uRFSlK6MJEuTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915107; c=relaxed/simple;
	bh=Arwn/tUN66c0Muq4SomMwkDzVKB0pYHBogm03ISNbgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oiei4lOY7tnrBSVQdLhDjbpL45eDqIk3uq5piIAbP1ezdgMPkYZecoTcCQZc7eppHRF6xQO7HF0n/vNnc5DB1U6jvnrB7dSTUpZcqowzyelB0sp3d3BxX1UpNxvMKhJBApgUL2DlNv3sPQfSoRP0yc/m+QiBCSo6LlOA58Wcfvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vp5uoZgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vp5uoZgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10B7EC4CEE4;
	Thu, 17 Apr 2025 18:38:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915106;
	bh=Arwn/tUN66c0Muq4SomMwkDzVKB0pYHBogm03ISNbgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vp5uoZgJwjCy/75t/PxQnod4tPiSpl7eQkaA/T1nKTLOU0TM6cDrOdHzjO1NjN5My
	 /2/XafPHX1REjdqHfLeWBD3VwUcdFs8ZfnCQTpXtciJ7cM4qqgoiIek+33S61mjZPu
	 d9EB6dzFs/ciwK4yDtGSXU7C6rfr8JnXv5DTPwsc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 020/393] octeontx2-pf: qos: fix VF root node parent queue index
Date: Thu, 17 Apr 2025 19:47:09 +0200
Message-ID: <20250417175108.406033262@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0f844c14485a0..35acc07bd9648 100644
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



