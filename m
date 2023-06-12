Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 648A4156EF
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E10A3C433EF;
	Mon, 12 Jun 2023 10:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565936;
	bh=l7vSjQ6yVyLbbzpSZxaXcYEEBskK+HUj9K2JwQfps/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IwjVSNdo0XwQi2IY0zICgS9xBOqiciHOF88BDnXsIsNSEBTaQVcdhQVfDfLf9ld8c
	 bt2VeJ/AXXYLOfJWSb5mPL0CYzW2i7FXPqU3Z3bf5+6yH+ymTtWiyof0Ecd6ZDTUlN
	 bjEpiYk75ybOoLRvWBAZO620dJ31+t73GWElb4MY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 18/45] bnxt_en: Query default VLAN before VNIC setup on a VF
Date: Mon, 12 Jun 2023 12:26:12 +0200
Message-ID: <20230612101655.388193455@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
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
index 2c71e838fa3d8..7f85315744009 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7781,6 +7781,9 @@ static int bnxt_init_chip(struct bnxt *bp, bool irq_re_init)
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



