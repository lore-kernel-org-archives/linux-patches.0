Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AF9644E05A;
	Tue, 10 Mar 2026 11:30:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142214; cv=none; b=JqhiBhAmq296gR2apAYskvkHwpDyZrsKj9K8ThsY+Dr2eRhUEG68teRP3SnYGzwb8/nTR6hP+vmsZ2jn03drcriYEkYNE34sS/FVkVIncBqxdoNIgme6FrVACMZ238jlb94jDZbspIn/PyrokMqGUG73K1lB8r8xH/5E1+GQc5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142214; c=relaxed/simple;
	bh=jL2YmWuNH/EwcXPNbJGeGdFlV2KzVYMIbccNSki/pOo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LA84hNnm+8A8Z6ESUSjHPNFRkdkBH7Kwa4TPDaVjFGonHFPnLTpjJEDlXj3Jh9uHDmWXaEbm8S5bCy/L3cTfqraB1gtYV8eE+d7YAkFZn9W5+xfPUF0zQnLb+OTbqVytwTN8klccdv8fujJ6B7sbm3/nDSLYX8s9GsZVXGRGtyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=goVleLT1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="goVleLT1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADD3AC2BC86;
	Tue, 10 Mar 2026 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142214;
	bh=jL2YmWuNH/EwcXPNbJGeGdFlV2KzVYMIbccNSki/pOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goVleLT1vyzx4lWXjXhKPMkTDwoaT7TlZ/uQ8zq08fVdQPE8mWh6UaiV1bm+s9jQ7
	 Fsa9A58j5pe+4KooErORFDFy4wRPQq5KBJYXu7k87wo8LKCXicrj4343nf9egDLLOs
	 PpK+SeR74fD71c2B0bMiRHHidR9xJXO0z5iPMb8Rr9ONCvqfd8ytl66ZJJpkhnf51x
	 9QDN0RcO1GkfEgp50ZMoyROhwcRZ3r2GVQx9STeorzKlw/xaht0HUqfLqDxrJfEJ5m
	 IL8q/kNVpKF1W7TAJniX+Z1fPRR1Gr3ulZbmlRxT5BCxbc8mb3quwC3EInDrX5XKaf
	 WtuMA4ABHR3WA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Larysa Zaremba <larysa.zaremba@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Aleksandr Loktionov <aleksandr.loktionov@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 304/314] xdp: use modulo operation to calculate XDP frag tailroom
Date: Tue, 10 Mar 2026 07:19:23 -0400
Message-ID: <db13b9219556c5839c6629c701ff652db003e7c4.1773141556.git.sashal@kernel.org>
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

From: Larysa Zaremba <larysa.zaremba@intel.com>

[ Upstream commit 88b6b7f7b216108a09887b074395fa7b751880b1 ]

The current formula for calculating XDP tailroom in mbuf packets works only
if each frag has its own page (if rxq->frag_size is PAGE_SIZE), this
defeats the purpose of the parameter overall and without any indication
leads to negative calculated tailroom on at least half of frags, if shared
pages are used.

There are not many drivers that set rxq->frag_size. Among them:
* i40e and enetc always split page uniformly between frags, use shared
  pages
* ice uses page_pool frags via libeth, those are power-of-2 and uniformly
  distributed across page
* idpf has variable frag_size with XDP on, so current API is not applicable
* mlx5, mtk and mvneta use PAGE_SIZE or 0 as frag_size for page_pool

As for AF_XDP ZC, only ice, i40e and idpf declare frag_size for it. Modulo
operation yields good results for aligned chunks, they are all power-of-2,
between 2K and PAGE_SIZE. Formula without modulo fails when chunk_size is
2K. Buffers in unaligned mode are not distributed uniformly, so modulo
operation would not work.

To accommodate unaligned buffers, we could define frag_size as
data + tailroom, and hence do not subtract offset when calculating
tailroom, but this would necessitate more changes in the drivers.

Define rxq->frag_size as an even portion of a page that fully belongs to a
single frag. When calculating tailroom, locate the data start within such
portion by performing a modulo operation on page offset.

Fixes: bf25146a5595 ("bpf: add frags support to the bpf_xdp_adjust_tail() API")
Acked-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Aleksandr Loktionov <aleksandr.loktionov@intel.com>
Signed-off-by: Larysa Zaremba <larysa.zaremba@intel.com>
Link: https://patch.msgid.link/20260305111253.2317394-2-larysa.zaremba@intel.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index d93f7dea828e5..7bcb713681bab 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4152,7 +4152,8 @@ static int bpf_xdp_frags_increase_tail(struct xdp_buff *xdp, int offset)
 	if (!rxq->frag_size || rxq->frag_size > xdp->frame_sz)
 		return -EOPNOTSUPP;
 
-	tailroom = rxq->frag_size - skb_frag_size(frag) - skb_frag_off(frag);
+	tailroom = rxq->frag_size - skb_frag_size(frag) -
+		   skb_frag_off(frag) % rxq->frag_size;
 	if (unlikely(offset > tailroom))
 		return -EINVAL;
 
-- 
2.51.0

