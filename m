Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D39A7387569;
	Tue, 10 Mar 2026 11:14:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141287; cv=none; b=aCDB3YYcn7XkFa3rScNEoZaGishNzp4kgkwcEtN/lcqobIlngFW7jCy/s2a1OtDjjkreHXaARMr9Bs1hmZJ9uwBnYntAAFCUaIWH0TlJu8xC+OMxeNCMJvx2JX+UxJngwj+IK9LswGfh9qfCetwbvdz15wrsdnelqhYpo0BK5mY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141287; c=relaxed/simple;
	bh=sw5uOHKyg6O3p1VPYkNOLqNJ6yX0Y+EfmfHWwddlBCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mUzaKbsBMx8vY6jsY9C1yQ5egyYnka1OjnU8DcuNvE/bpGUc80VzCequfOYFEaGHVjOwoo0WkLe0orqFA3k77ZIbr8dd2gY8CeSX5SZwjOoeIHIpToDiY9uCt1Wx72BZuzEmpCelmHsWQKmp7bgqLDvXxEbwQAKErxZICDPSkhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nS57tElh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nS57tElh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAE9AC19423;
	Tue, 10 Mar 2026 11:14:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141287;
	bh=sw5uOHKyg6O3p1VPYkNOLqNJ6yX0Y+EfmfHWwddlBCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nS57tElhaRqmutKVGlv5tJNIu3cmWPa8NtxG4I1yAohJvXIkfqmSIMD6uc6Bt8kr3
	 7LvvSqJqWdqfAaByUdH6HJJxp1nIrAcug0AVKsBJqcCQRf716tU0BUeKcULo0oiPtU
	 k0OLz1AghWcZKCq5YbmaECdvWRzHWXR0r5gjHzxQf5cH8rdg3yzylUI41LazdbBgkH
	 RDWwRO18Pihb5WeQulkvQP/tjBzvXfFIYbOiOndXE6rSReH2WtdTe94fmgT2Of4CcZ
	 dLQBCCO/1f66UImqDS3Muvk8I8WeBc6juxXyByKDeCv/bHVQCJkRtVq5qyom+JPLu6
	 mnfT//Nrm48LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Valerio <pvalerio@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 291/311] net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()
Date: Tue, 10 Mar 2026 07:05:38 -0400
Message-ID: <2a328612be7f52ddaba025295ba9569f0e6e7f0c.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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

