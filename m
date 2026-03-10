Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C34944B69C;
	Tue, 10 Mar 2026 11:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142207; cv=none; b=Eufwss3rG9u5/KVogsi3hco5POyjQnF25eLroB5z8R4HHbcnv9IilJxWQKXLsSEkplvAO59KGFpJFtumCSd4OPEDcnlO5FG1VgvIm8CJt2LS7Aiy7E7bpEm5omtZQMDFT7xCpUh8r6IRfyd0HGW3pekuzgSg7CYehbk+6RkCbJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142207; c=relaxed/simple;
	bh=sw5uOHKyg6O3p1VPYkNOLqNJ6yX0Y+EfmfHWwddlBCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uPOyD5M3+PIvmqsW0xSIuBH0BnhpqGI/rT8G0nvXtRpWOPzJyzbZj+YFk6uLjzOmYxULlJPPuFx4Q+GxGdXm2ocpYSSUnJX5lbYQNnSsI0e9bPSkOKV8G+FpY6o2UPyn4mBlX3ss3ok/3cxwQvRrYvrysV99GrJV6u0pH4XcDMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lBPFzVuS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lBPFzVuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD534C2BCAF;
	Tue, 10 Mar 2026 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142207;
	bh=sw5uOHKyg6O3p1VPYkNOLqNJ6yX0Y+EfmfHWwddlBCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBPFzVuSjV1DC++AgwjKo/NzJbLBnC7AyZmTpuWyxDByTjVCrX1jjHHhRxs5Eh75d
	 IcM9REfjiSkNVqOBIrj+L+rya3B7Uo4xvZBscHE1XElbLKopJhJxA2xDnJvPvdSm/u
	 gqeBmijUs/whgskKtZklQ+Ry99QCp+uA5F6aC9P8QqDFELHDOHzsmqMMZ78ekPTTlp
	 RyjY7feVw38t7M2mVOabA0tCYjdby528Wa8ypsM26u5Esa0/ej1ja7MLH9gHAl+Dzu
	 jwTlpjG5jQA+ydZ5QyEibT3jEmCfq8P5dGSKZtS8U5oUHARSNlNRuFtZOnugGv3iJV
	 ibLyEidw4dSpw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Valerio <pvalerio@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 297/314] net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()
Date: Tue, 10 Mar 2026 07:19:16 -0400
Message-ID: <4af6a4e2e639cd4909e78d61c373a52f21087176.1773141556.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit 0abc73c8a40fd64ac1739c90bb4f42c418d27a5e ]

Reset eBPF program pointer to old_prog and do not decrease its ref-count
if mtk_open routine in mtk_xdp_setup() fails.

Fixes: 7c26c20da5d42 ("net: ethernet: mtk_eth_soc: add basic XDP support")
Suggested-by: Paolo Valerio <pvalerio@redhat.com>
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/20260303-mtk-xdp-prog-ptr-fix-v2-1-97b6dbbe240f@kernel.org
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_eth_soc.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_eth_soc.c b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
index e68997a29191b..8d3e15bc867d2 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3749,12 +3749,21 @@ static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
 		mtk_stop(dev);
 
 	old_prog = rcu_replace_pointer(eth->prog, prog, lockdep_rtnl_is_held());
+
+	if (netif_running(dev) && need_update) {
+		int err;
+
+		err = mtk_open(dev);
+		if (err) {
+			rcu_assign_pointer(eth->prog, old_prog);
+
+			return err;
+		}
+	}
+
 	if (old_prog)
 		bpf_prog_put(old_prog);
 
-	if (netif_running(dev) && need_update)
-		return mtk_open(dev);
-
 	return 0;
 }
 
-- 
2.51.0

