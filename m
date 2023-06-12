Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539BB18AE1
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:28:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BB7C433D2;
	Mon, 12 Jun 2023 10:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565715;
	bh=Lyp3YVggMv9Onw4Bxy0I9K5NFFkW7fChYsptXNPaxDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VntHozg5ufFROc3qrD82dN0CHgDJpGbuTP/xzb3DpAN1aJN/rHCk+ODrdqmzeEvWf
	 tZ72pedwxeuZOk15OAjhDcOjrM23df6M69laDJjU2U4B1Vpunw9G7rqlO68tfZAI5D
	 n2GQNkZKAqGU1WVEr3jjJvgDW0R0IMBjZdSNPFRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 10/21] bnxt_en: Query default VLAN before VNIC setup on a VF
Date: Mon, 12 Jun 2023 12:26:05 +0200
Message-ID: <20230612101651.416961281@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.048240731@linuxfoundation.org>
References: <20230612101651.048240731@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Somnath Kotur <somnath.kotur@broadcom.com>

[ Upstream commit 1a9e4f501bc6ff1b6ecb60df54fbf2b54db43bfe ]

We need to call bnxt_hwrm_func_qcfg() on a VF to query the default
VLAN that may be setup by the PF.  If a default VLAN is enabled,
the VF cannot support VLAN acceleration on the receive side and
the VNIC must be setup to strip out the default VLAN tag.  If a
default VLAN is not enabled, the VF can support VLAN acceleration
on the receive side.  The VNIC should be set up to strip or not
strip the VLAN based on the RX VLAN acceleration setting.

Without this call to determine the default VLAN before calling
bnxt_setup_vnic(), the VNIC may not be set up correctly.  For
example, bnxt_setup_vnic() may set up to strip the VLAN tag based
on stale default VLAN information.  If RX VLAN acceleration is
not enabled, the VLAN tag will be incorrectly stripped and the
RX data path will not work correctly.

Fixes: cf6645f8ebc6 ("bnxt_en: Add function for VF driver to query default VLAN.")
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Signed-off-by: Somnath Kotur <somnath.kotur@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 89782e8e0b913..ee438674d6cc4 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -5239,6 +5239,9 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
 		goto err_out;
 	}
 
+	if (BNXT_VF(bp))
+		bnxt_hwrm_func_qcfg(bp);
+
 	rc = bnxt_setup_vnic(bp, 0);
 	if (rc)
 		goto err_out;
-- 
2.39.2



