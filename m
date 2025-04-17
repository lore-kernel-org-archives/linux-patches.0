Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F885253B57;
	Thu, 17 Apr 2025 17:54:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912465; cv=none; b=FQWH+PjixB7B8oqdeRajWs30Qf5+YnIxPOsG4zVMubZnkiAHq13fiEr6fbR54cTsUvt/WyhooAP7kcQeIzBymmzoyZzcP6pjz19bDmDfldXzmGm7o/e3ya9FKR4eVtC4MJDJql83wnbFOXoie7m0yMGVlCLJLf9emiXV7FVN1OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912465; c=relaxed/simple;
	bh=fQ9wvu1OWQUsW2txfrTpCqDpGNjxGnmxIdmWv/56dGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ENAioIlHhBA4r6ZrgSdVWV0zCUIAcsbUJIuo0F3lVPjZe32xX834Alnqs5guI8hCv1le/u0FlpYSpKVC6tFZATCAnM5/qJ5KOJmd4GDbpKh0a4PF8IqUQNrZMppU6Y8NVDS5rGq++n1qWVYgUKyKMWzAgv+to3YY4g5XpFLngyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/ZFbICw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/ZFbICw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA914C4CEEA;
	Thu, 17 Apr 2025 17:54:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912465;
	bh=fQ9wvu1OWQUsW2txfrTpCqDpGNjxGnmxIdmWv/56dGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/ZFbICwGJDHiUkZCXqP7lT2Q8VVQZSHVRsn5VEhdK3/0ZLdYol6k+6CLAintipfU
	 TtsmRsqRlKQ58QHm/k3yWOOU2PvvjqVPAuVqQsKQr9Ey2YXbP4hOPW2qkGVI2VOP8z
	 juz3JxOzkk4fEtMJm9FGa9q1JkQcqSXWL0PgziSI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hariprasad Kelam <hkelam@marvell.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 020/449] octeontx2-pf: qos: fix VF root node parent queue index
Date: Thu, 17 Apr 2025 19:45:08 +0200
Message-ID: <20250417175118.803021826@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



