Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E691E26F288;
	Thu, 12 Mar 2026 20:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347215; cv=none; b=fYkYLn/YkHOHp2hFE6q/Hja0ZgZfwr/hoAmJGXISBv6ElvJjC5gx1oeFs14aWEfaDS57m5FYxE+n+652MehZPcsBMYLKL19h8d3AZ6eB8C26qCAh+WmN4Z58ogFJ7TqSvLck9UIeoRPYmd5z7ClqiAAjapbVYAGMDaA1wc/IO18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347215; c=relaxed/simple;
	bh=UYT8wIw8pHLsFRtG2apIb8OLEIswMFmbLk8hQv2tBGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SxLkeuciCxrMhHFGouXI0uTgIBOCnZx0PF//zto7K8GbDwZzR2HU6+dsoUGGEgqrZ4OvLSTVDYnmOn6ZHGdqPmLUbYQWBlQvisa3MYLZ3ksiMPUOu0OXHJ53c7RnmuS6YW4xhbB4W0XYw0A48eBnqUD5gvO52xX043pVENoGXsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LwKywYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LwKywYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 481CDC2BC86;
	Thu, 12 Mar 2026 20:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347214;
	bh=UYT8wIw8pHLsFRtG2apIb8OLEIswMFmbLk8hQv2tBGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LwKywYurI5JAVQxBxz00fchaJPVUxpsbWl26t36uTFcz/SSNyPkSUTGFEf07i29K
	 la4i8vy5foyObw+P7SBL0VjaAk0SOIhwqmeJQ7UEG7eq2sDNqK9X8FSlw8YJpNxkrY
	 Ndm4C36HaiYy8rDQBBModgYSJbpriO+oB6vKjIPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Valerio <pvalerio@redhat.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 235/265] net: ethernet: mtk_eth_soc: Reset prog ptr to old_prog in case of error in mtk_xdp_setup()
Date: Thu, 12 Mar 2026 21:10:22 +0100
Message-ID: <20260312201026.820512173@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 64d86068b51eb..45d4bac984a52 100644
--- a/drivers/net/ethernet/mediatek/mtk_eth_soc.c
+++ b/drivers/net/ethernet/mediatek/mtk_eth_soc.c
@@ -3566,12 +3566,21 @@ static int mtk_xdp_setup(struct net_device *dev, struct bpf_prog *prog,
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



