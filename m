Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475AA25EF80;
	Tue, 11 Mar 2025 15:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706579; cv=none; b=Xqq09bWA17lUlaH4I03V4KX9KBG5DYWdX8mGgyViORd5WSTfvnd38aPxI8B/jNLCbdLb2vXe55xyHVFk6IcCyUzw388aH8yuD4b8Ezs44wFg1iP5m+r0OinTZGasxwwK5+VRAqqr5AUbEOZ0gBKWJcSEBaWie0+7L001GW7+OUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706579; c=relaxed/simple;
	bh=bSlRghUto02kAnii+2SgsWg+k9NXLZ1FE4ysB0ht/6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KsU2NWL1K6F8NooBTRHz8Bbu4BaXecRCxd/jqVhUb3PxqUIHkUgf4pqb3GRYDb27ReFsGsIJR2Fz7GER9WxNI4C2rjXPVPCtN02/6zRJfH3088zjsdwwKv3SX6vvBcJpKR/sSsmulrzr4rLcP/MydChY/m9EczKi8rC5Yn+WplY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcxRl9g1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcxRl9g1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEE8BC4CEE9;
	Tue, 11 Mar 2025 15:22:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706579;
	bh=bSlRghUto02kAnii+2SgsWg+k9NXLZ1FE4ysB0ht/6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcxRl9g1Lg1NX4LB+n7Rzhi+ZxKVDPQKPvv9ztj1QKhd7zRi5QW0DDTz/tdT2qcQm
	 lw2MmxAtRxdNTgHdw8QBpu9QmhtoPA4T6791cZ3xBUE+fz9XqKUJJtOIBMSZFOyh08
	 jx+J2niP4o//W4Ul05RKVuKjD3owtu7xtguApOLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 096/462] xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO
Date: Tue, 11 Mar 2025 15:56:02 +0100
Message-ID: <20250311145802.152089971@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit c05c5e5aa163f4682ca97a2f0536575fc7dbdecb ]

When skb needs GSO and wrap around happens, if xo->seq.low (seqno of
the first skb segment) is before the last seq number but oseq (seqno
of the last segment) is after it, xo->seq.low is still bigger than
replay_esn->oseq while oseq is smaller than it, so the update of
replay_esn->oseq_hi is missed for this case wrap around because of
the change in the cited commit.

For example, if sending a packet with gso_segs=3 while old
replay_esn->oseq=0xfffffffe, we calculate:
    xo->seq.low = 0xfffffffe + 1 = 0x0xffffffff
    oseq = 0xfffffffe + 3 = 0x1
(oseq < replay_esn->oseq) is true, but (xo->seq.low <
replay_esn->oseq) is false, so replay_esn->oseq_hi is not incremented.

To fix this issue, change the outer checking back for the update of
replay_esn->oseq_hi. And add new checking inside for the update of
packet's oseq_hi.

Fixes: 4b549ccce941 ("xfrm: replay: Fix ESN wrap around for GSO")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_replay.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/xfrm/xfrm_replay.c b/net/xfrm/xfrm_replay.c
index 65d009e3b6bbe..aedc61ceadb30 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -657,10 +657,12 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
 			oseq += skb_shinfo(skb)->gso_segs;
 		}
 
-		if (unlikely(xo->seq.low < replay_esn->oseq)) {
-			XFRM_SKB_CB(skb)->seq.output.hi = ++oseq_hi;
-			xo->seq.hi = oseq_hi;
-			replay_esn->oseq_hi = oseq_hi;
+		if (unlikely(oseq < replay_esn->oseq)) {
+			replay_esn->oseq_hi = ++oseq_hi;
+			if (xo->seq.low < replay_esn->oseq) {
+				XFRM_SKB_CB(skb)->seq.output.hi = oseq_hi;
+				xo->seq.hi = oseq_hi;
+			}
 			if (replay_esn->oseq_hi == 0) {
 				replay_esn->oseq--;
 				replay_esn->oseq_hi--;
-- 
2.39.5



