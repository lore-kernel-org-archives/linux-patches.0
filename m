Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279993B9619;
	Thu, 15 Jan 2026 16:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496395; cv=none; b=Rcgg0X1rOIpj66ena5T8Xtmua7gqNIlc1USEyuUGvdGt9F5PdgeGzaXN6+nSUSe1Ba0Yh5LZafJHht1hzVzB2O6dPslQVv521AO08HC+wb8465trzJe7+wqX2smFCHRmvmToa+SmYcUN5d/bKNxYJ57PqmVHLcZ+sRmk/7H6KCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496395; c=relaxed/simple;
	bh=IH0Nx5PfyN/veTq82G6Wul1q37Ddiy+KYZ/P2h7GUWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mTXhaxe/iH+BlSb1Wrp1J3WZlrsiLsFB8DPkOAML9C+bPbVG42WzlVmt0lESJBth0Qc6yES0G5gzVxMK7S1kBhWWwS0B826l7HO1abAAIIXx6h1Iz0JaDS9okahZA7Sv0EcZZG2dJrxQ4G/x6/3cIXgMJj0a8TQbmsRkCmPcSYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L20OpbzA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L20OpbzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5C9BC116D0;
	Thu, 15 Jan 2026 16:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496395;
	bh=IH0Nx5PfyN/veTq82G6Wul1q37Ddiy+KYZ/P2h7GUWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L20OpbzAyaK1tRwXME75cWjuPbXGWabQKcvAq+xgJVf10nGfOcJ79oTXUN7fQMsKm
	 G+nPgwt6UuYoC2/J/3Rh3BkiiLWIFKEXuSO94Jaaq5l+yxqPur1JtVOvi9D0RtL2Y1
	 jZKR1xKVkLO0uAYPuT1nGDmcprsmayfgjE/q44ow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 147/181] net: airoha: Fix schedule while atomic in airoha_ppe_deinit()
Date: Thu, 15 Jan 2026 17:48:04 +0100
Message-ID: <20260115164207.622358052@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

[ Upstream commit 6abcf751bc084804a9e5b3051442e8a2ce67f48a ]

airoha_ppe_deinit() runs airoha_npu_ppe_deinit() in atomic context.
airoha_npu_ppe_deinit routine allocates ppe_data buffer with GFP_KERNEL
flag. Rely on rcu_replace_pointer in airoha_ppe_deinit routine in order
to fix schedule while atomic issue in airoha_npu_ppe_deinit() since we
do not need atomic context there.

Fixes: 00a7678310fe3 ("net: airoha: Introduce flowtable offload support")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260105-airoha-fw-ethtool-v2-1-3b32b158cc31@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/airoha/airoha_ppe.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/airoha/airoha_ppe.c b/drivers/net/ethernet/airoha/airoha_ppe.c
index c0e17035db18e..190d98970014f 100644
--- a/drivers/net/ethernet/airoha/airoha_ppe.c
+++ b/drivers/net/ethernet/airoha/airoha_ppe.c
@@ -1466,13 +1466,16 @@ void airoha_ppe_deinit(struct airoha_eth *eth)
 {
 	struct airoha_npu *npu;
 
-	rcu_read_lock();
-	npu = rcu_dereference(eth->npu);
+	mutex_lock(&flow_offload_mutex);
+
+	npu = rcu_replace_pointer(eth->npu, NULL,
+				  lockdep_is_held(&flow_offload_mutex));
 	if (npu) {
 		npu->ops.ppe_deinit(npu);
 		airoha_npu_put(npu);
 	}
-	rcu_read_unlock();
+
+	mutex_unlock(&flow_offload_mutex);
 
 	rhashtable_destroy(&eth->ppe->l2_flows);
 	rhashtable_destroy(&eth->flow_table);
-- 
2.51.0



