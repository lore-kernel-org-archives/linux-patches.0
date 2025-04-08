Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CABA025FA04;
	Tue,  8 Apr 2025 11:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110881; cv=none; b=BLcfLu4mqwCWko8TqUoOmbsSquw09gZWQd+ADcmAglfNzIR2rAYeF4EdxD3OX1UibiaHheXr5qe/KpClaLGJld4ttlRReBXoRpFp4jHWWtI7XVadIQTCFcNARimqCS2nd2p8eey2p1QYd7UgBumI+Vygm2yxnon3niaZ9THMJMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110881; c=relaxed/simple;
	bh=N27tBPx4wo/XGHSaxSqO6vCy9rpKw+1VQwmUmEVApLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OqO7LpWrCNWfIYqELlKuvY3tuJcAB4AZRL/h6cUrchgwV6ucPfJFFtegnC22t1Hw9EwuEdCbO3gT+DNWSKlfk9EGLTOmqc5bpgaiNbZQBzu95HSAKLj37DlJOJMEETkiaf/GPQ7lOclOUgmHoIQePaisMTfQJ3naQOP5teUdPQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XlDmXh4e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XlDmXh4e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5170AC4CEE5;
	Tue,  8 Apr 2025 11:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110881;
	bh=N27tBPx4wo/XGHSaxSqO6vCy9rpKw+1VQwmUmEVApLQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XlDmXh4eVX6l/wmHkW4quhk8pe9QuOzeARNfMMkeb/epXrSHd+5CZo3QEqGSktqfS
	 q+kd6OjyidrvczivC7fWhLxaH3ai+Efi6/PY2rLJh4+cMDr46eJW5IOfWoUD2Nv4Ud
	 mAmVhdN1XqkMiEZa2/XGBnHy9NGkwPwxrVvrbwaA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 229/731] eth: bnxt: fix out-of-range access of vnic_info array
Date: Tue,  8 Apr 2025 12:42:06 +0200
Message-ID: <20250408104919.607872034@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 919f9f497dbcee75d487400e8f9815b74a6a37df ]

The bnxt_queue_{start | stop}() access vnic_info as much as allocated,
which indicates bp->nr_vnics.
So, it should not reach bp->vnic_info[bp->nr_vnics].

Fixes: 661958552eda ("eth: bnxt: do not use BNXT_VNIC_NTUPLE unconditionally in queue restart logic")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20250316025837.939527-1-ap420073@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 55f553debd3b2..0ddc3d41e2d81 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15651,7 +15651,7 @@ static int bnxt_queue_start(struct net_device *dev, void *qmem, int idx)
 	cpr = &rxr->bnapi->cp_ring;
 	cpr->sw_stats->rx.rx_resets++;
 
-	for (i = 0; i <= bp->nr_vnics; i++) {
+	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 
 		rc = bnxt_hwrm_vnic_set_rss_p5(bp, vnic, true);
@@ -15679,7 +15679,7 @@ static int bnxt_queue_stop(struct net_device *dev, void *qmem, int idx)
 	struct bnxt_vnic_info *vnic;
 	int i;
 
-	for (i = 0; i <= bp->nr_vnics; i++) {
+	for (i = 0; i < bp->nr_vnics; i++) {
 		vnic = &bp->vnic_info[i];
 		vnic->mru = 0;
 		bnxt_hwrm_vnic_update(bp, vnic,
-- 
2.39.5



