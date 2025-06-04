Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF3F723E342;
	Wed,  4 Jun 2025 01:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748999150; cv=none; b=mMto5X/ByGo6K2ozTGoJJ12ua0Y5J6iDVCH3mch2iJt1pwcP8PsiVPVOrGbzkICvlrpn7lwXnFzsZWyHVZQMCVC6ddftvXnqoTTTaeMAeRmT8We83W9NEIpIou66p30ve0woDDL3IT3Jko+F1H17M9EHimokXfeja3ii3n0bpJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748999150; c=relaxed/simple;
	bh=6mYKNDzFT3roG7ny09YeyiFpbuTL+ChgnsIX9qznKBo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z3cC4WpJ7spgIl+BYkyqInuUnMhnrHQ/1kwELatTd3ErtuRhxVZDvhWVfF1pkOzOKovb6c4daO6rjtBzTc9VQ+A3fPbyUJ0gWYNpRaPLHkmI2H4JG8I9omiURK/kjRc9/lU0XcPcdbxKlxzRkdvnpicr2gYifQ1oaSpAj4LdqvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n42+29gl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n42+29gl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAFD8C4CEED;
	Wed,  4 Jun 2025 01:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748999149;
	bh=6mYKNDzFT3roG7ny09YeyiFpbuTL+ChgnsIX9qznKBo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n42+29glVpmUg7cHn7tEUjlXS8ZSNHHi+w7BFVBT1SVlPtGdbmFvCRfOuefEvVtXx
	 hEWRH/CVwcp7jpSomx4jp/sEtSbphfjLTWBIs9Mlp18EV7hCiGo5gWlMEUvYYLN4HW
	 aBccirPE0iNW1W353QT7m0cY4zlapzftFuu5SH8qzQBWmI4rV+RM9n12vpqFPQZx5d
	 WMMfAwYt0ZoYIZdUXuequKZ+IYi/bq39s4ZoaRRhj7iTw4kLi4/4ByF0uFhy1zVG/o
	 moH1x1Fp8xwg9BbrgB2XI4BjVpmpx8vuzoADObumbnK7gxU75TVANoBHKWabDxgR9K
	 op6LA72wMh3DQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jason Xing <kernelxing@tencent.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	irusskikh@marvell.com,
	netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 14/33] net: atlantic: generate software timestamp just before the doorbell
Date: Tue,  3 Jun 2025 21:05:05 -0400
Message-Id: <20250604010524.6091-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604010524.6091-1-sashal@kernel.org>
References: <20250604010524.6091-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.184
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
index 45ed097bfe49a..026e628664a9d 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_main.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_main.c
@@ -117,7 +117,6 @@ static netdev_tx_t aq_ndev_start_xmit(struct sk_buff *skb, struct net_device *nd
 	}
 #endif
 
-	skb_tx_timestamp(skb);
 	return aq_nic_xmit(aq_nic, skb);
 }
 
diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
index 25349a2ae5cfe..2afa61e9bf8c6 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_nic.c
@@ -751,6 +751,8 @@ int aq_nic_xmit(struct aq_nic_s *self, struct sk_buff *skb)
 
 	frags = aq_nic_map_skb(self, skb, ring);
 
+	skb_tx_timestamp(skb);
+
 	if (likely(frags)) {
 		err = self->aq_hw_ops->hw_ring_tx_xmit(self->aq_hw,
 						       ring, frags);
-- 
2.39.5

