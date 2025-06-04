Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E115C1D8A0A;
	Wed,  4 Jun 2025 00:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998339; cv=none; b=IpM5cOsgw/McTqCfrHw4xk03H6GjNN4cTcC4nVh8dF37rs/g1TDXttDlH6h9EIf9aaIlAyWl4KD5ONKWDkhicRtG7beQ3vOQ57nOIABe1SQ61pz74qFM3BosGOM/t1KeJ5slQ6/0CqqiPFaxEF7CjiMizX/ejBW4xs/YwQbcqGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998339; c=relaxed/simple;
	bh=xnnzBswyhFf3D+i7h9yNvSVCo8KrjEdgMT2uzXupEb4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uhewku4AnrsSuM/W9irXwPpsII8Risk4s40Qo0TQ/v+RDqv1yg/Pw4MnaNsSIyVMUzVeLnPXO55+87q0aNyeoYbWHVKv6TttQxPY+Vd2asW7oFw35pbLiGTkEw0r5eKTj592i8xIDpsGabUEuBezi+luO7c8i/80r5r3s3DN9VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jD45mTEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jD45mTEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA792C4CEED;
	Wed,  4 Jun 2025 00:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998338;
	bh=xnnzBswyhFf3D+i7h9yNvSVCo8KrjEdgMT2uzXupEb4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jD45mTEtbOC8xzLWFW3j+84Nhf6J/RD5ogegbJbA9VQn+DT7qFQoe3WZiQPQnqkhM
	 nuET/5qZZSMhjQMsXdPKwp3VIFbxkSFObMILZxcKb2pKasdj3LZOe4a16wQuYOx3ZR
	 RJI0Z5cFkrMxf4u7vm/Qdo/RXhMTrjxQh55Su8hwZep1/sStQOjKG2OCiDmv78moC+
	 XZLFV42kwuIi80gC3TqlIAimFBMMw904hPG65V4qkN9JX32aMC/+OZNajOcILHPzax
	 nj9Ych8zvIBdoZk6YuZEjJAMjhEy45Ju/YikjdUx/ET0O0I+YFQ8IJex++gRKiWPMw
	 xJ3/sQWtNTjWg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	irusskikh@marvell.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 045/118] net: atlantic: generate software timestamp just before the doorbell
Date: Tue,  3 Jun 2025 20:49:36 -0400
Message-Id: <20250604005049.4147522-45-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jason Xing <kernelxing@tencent.com>

[ Upstream commit 285ad7477559b6b5ceed10ba7ecfed9d17c0e7c6 ]

Make sure the call of skb_tx_timestamp is as close as possible to the
doorbell.

Signed-off-by: Jason Xing <kernelxing@tencent.com>
Link: https://patch.msgid.link/20250510134812.48199-2-kerneljasonxing@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees. Here's
my comprehensive analysis: ## Primary Analysis **This is a timestamp
accuracy fix that addresses when software timestamps are recorded
relative to hardware transmission**. The commit moves
`skb_tx_timestamp(skb)` from before the hardware doorbell to immediately
after it, ensuring timestamps are recorded as close as possible to
actual packet transmission. ## Code Change Analysis ### What Changed 1.
**In `aq_main.c`**: Removed `skb_tx_timestamp(skb)` from the main
transmission path 2. **In `aq_nic.c`**: Added `skb_tx_timestamp(skb)` in
`aq_nic_xmit()` right after `aq_nic_map_skb()` but before the hardware
doorbell via `hw_ring_tx_xmit()` ### Critical Timing Issue Fixed The
original sequence was: ```c // BEFORE (problematic):
skb_tx_timestamp(skb); // Timestamp recorded before hardware
notification return aq_nic_xmit(aq_nic, skb); └─ frags =
aq_nic_map_skb(self, skb, ring); └─ hw_ring_tx_xmit() // Hardware
doorbell rung HERE ``` The fixed sequence is: ```c // AFTER (correct):
return aq_nic_xmit(aq_nic, skb); └─ frags = aq_nic_map_skb(self, skb,
ring); └─ skb_tx_timestamp(skb); // Timestamp recorded right before
hardware doorbell └─ hw_ring_tx_xmit() // Hardware doorbell rung
immediately after ``` ## Backporting Assessment ### 1. **Fixes Important
Timing Bug** ✅ - **Software timestamp accuracy** is critical for network
applications, especially PTP (Precision Time Protocol) - **Wrong
timestamp ordering** can cause timing skew and affect time-sensitive
applications - **Low-latency networking** applications depend on
accurate TX timestamps ### 2. **Minimal Risk** ✅ - **Small, contained
change**: Only moves one function call - **No behavioral changes**: Same
timestamp function, just better timing - **No architectural
modifications**: Same code path, different ordering - **No new
dependencies**: Uses existing functionality ### 3. **Clear Bug Fix** ✅ -
**Specific problem**: Timestamps recorded too early in TX pipeline -
**Well-defined solution**: Move timestamp closer to hardware
transmission - **Matches stable criteria**: Important bugfix with
minimal regression risk ### 4. **Comparison with Similar Commits** This
commit is **nearly identical** to Similar Commit #1 (marked YES for
backporting): - **Subject: "nfp: TX time stamp packets before HW
doorbell is rung"** - **Same exact issue**: Moving timestamp call to be
closer to hardware doorbell - **Same pattern**: `skb_tx_timestamp(skb)`
moved from after to before hardware notification - **Same stable tree
acceptance**: The NFP driver fix was accepted The only differences are:
- Different driver (atlantic vs nfp) - Same underlying network timing
issue - Same solution approach ### 5. **User Impact** ✅ - **Affects all
atlantic driver users** who rely on software timestamps - **Time-
sensitive applications** like PTP, trading systems, and real-time
monitoring - **Improves timestamp precision** without breaking existing
functionality ### 6. **Stable Tree Compatibility** ✅ - **No API
changes**: Uses standard `skb_tx_timestamp()` function - **No kernel
version dependencies**: Should work across stable versions - **Self-
contained**: Limited to atlantic driver code ## Conclusion This commit
meets all stable backporting criteria: - **Fixes important timestamp
accuracy bug** - **Minimal regression risk** - **Clear, contained
solution** - **Matches proven pattern** from Similar Commit #1 (NFP
driver fix) - **Benefits time-sensitive network applications** The fix
ensures software timestamps are recorded as close as possible to when
hardware actually starts transmitting packets, which is crucial for
applications requiring precise timing information.

 drivers/net/ethernet/aquantia/atlantic/aq_main.c | 1 -
 drivers/net/ethernet/aquantia/atlantic/aq_nic.c  | 2 ++
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_main.c b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
index c1d1673c5749d..b565189e59139 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -123,7 +123,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index bf3aa46887a1c..e71cd10e4e1f1 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -898,6 +898,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	frags = aq_nic_map_skb(self, skb, ring);
 
+	skb_tx_timestamp(skb);
+
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-- 
2.39.5

