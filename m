Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC71C3B3BE1;
	Wed, 30 Sep 2026 18:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791884; cv=none; b=fTLhWGvt7Amrq9QM7+4o2zHSTeH4yfvzvKMzOHukmk1HVFHGUljKNYG3auhXRs8+zZdKwj5XXnUZn45ETJKRjFFcO7RBL6t4rRJkFQmMMZIWggVKavH8TKYcZsX2GP2dtInFQW1N8R3UZLJE8EdaF+fMYwG08+leaJqvSuOrgKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791884; c=relaxed/simple;
	bh=nxxRAvGWV4uek+kGr8pikw5107sbsdAAeaAJ7ixOEdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X+HyQnb35jWxjcvZ8D++lsCEDqqGpFNOJilkgltpGxWB8G66eZoHdLdKjxJZxprENiGAm6bb72334aaJR/nQjfZoiEtZxK1U3sHT1p19ACH44vPgqhX1MP6XK1j0ZJ8gSeoUlkw3BeJwaonFtDngaA1FPtgQjs9bV4bAm3TpoZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NATcSu1f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NATcSu1f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4772A1F000FF;
	Wed, 30 Sep 2026 18:11:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791882;
	bh=EneZ8cgnYxXVro1NxULNluSkmZc8G9UD5YBYAFCrjK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NATcSu1flBJ3qkYl2xBkTA3BOPPvfb985P/LhUqD1esTDDoSuQ1ztr66qeH1daXuj
	 jxy2VMh1zQEwoLlzZv/nXIf44LKU0K1JZ2LjZ2AoVvhu8HwWnLWin79XLzjaIVoKF3
	 VGWoHgYR2u8smLjA3yh14Ib/XiXYBCfZ4DY8XHWg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 457/752] RDMA/irdma: Enforce local fence for IB_WR_REG_MR
Date: Wed, 30 Sep 2026 17:25:27 +0200
Message-ID: <20260930152408.165952038@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jacob Moroni <jmoroni@google.com>

[ Upstream commit 3fb905f07ea45b31c8f67ba6e4668de46f527e65 ]

Enforce local fence for IB_WR_REG_MR to avoid spurious
FASTREG_VALID_MKEY async events during heavy invalidation
and registration activity.

Commit 69e8e429bca2 ("RDMA/irdma: Enforce local fence for LOCAL_INV WRs")
was very similar, but was not sufficient to prevent all occurrences
of these async events.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Jacob Moroni <jmoroni@google.com>
Link: https://patch.msgid.link/20260901160014.2026285-1-jmoroni@google.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/verbs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4c309781b4d6b..5e8ac04826b0e 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3245,7 +3245,7 @@ static int irdma_post_send(struct ib_qp *ibqp,
 			stag_info.total_len = iwmr->ibmr.length;
 			stag_info.reg_addr_pa = *palloc->level1.addr;
 			stag_info.first_pm_pbl_index = palloc->level1.idx;
-			stag_info.local_fence = ib_wr->send_flags & IB_SEND_FENCE;
+			stag_info.local_fence = true;
 			if (iwmr->npages > IRDMA_MIN_PAGES_PER_FMR)
 				stag_info.chunk_size = 1;
 			ret = irdma_sc_mr_fast_register(&iwqp->sc_qp, &stag_info,
-- 
2.53.0



