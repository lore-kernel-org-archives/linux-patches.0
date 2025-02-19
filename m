Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F6CC1E04BA;
	Wed, 19 Feb 2025 09:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956557; cv=none; b=GV3s271xNDWaq7GokhwuiRYMUekXXAj1wH6y0ZDxmi2qYTWSPFat01aI7BrdoLXbNOunkoF5oDeMeuKqNHzYHPR9l+lNN5GQ9muKyi08dYe1EWqSzsef828n7xrDjmnz4UNVT4+1O6e9OjSXz0wO/Gso/XMoypLFhNpL/em1RUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956557; c=relaxed/simple;
	bh=YC41/R21y+x/twDCogc+SGQCUT3o0nWxnEIzIHLd3hI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7/JaHQItJ3GsvY0AZhfULavh/YMeF4fUUOx00CegK5wRspWpJhNB0PAk1mR4W6Y5xGcmjBF+6CI0OjMeSm9jk9M/iUK61/zRUQeIFhE0zL5giiXG39i+I243O+IRUaYtuRseSzmm/s8a/VM0iU6ORK4usn2k2rwqKMRqMuURjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nVXdsCQu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nVXdsCQu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D7AC4AF0C;
	Wed, 19 Feb 2025 09:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956557;
	bh=YC41/R21y+x/twDCogc+SGQCUT3o0nWxnEIzIHLd3hI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nVXdsCQumAt7d0DI+otdQI/qqloAXW+UImPdTG1v3XoLzR9GwcmJNyu+GPo2iKgfF
	 1bASZCQ4edYOH+sqo3i8QmK09VrtRoHSxttuJtrFOMtDVJnrWHpuB4eLF+UuoPZ4B2
	 +23dF9RlJqCUSAnSaiN67VkPvD75VY9HnRStJISc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/578] xfrm: replay: Fix the update of replay_esn->oseq_hi for GSO
Date: Wed, 19 Feb 2025 09:23:36 +0100
Message-ID: <20250219082701.398823256@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ce56d659c55a6..7f52bb2e14c13 100644
--- a/net/xfrm/xfrm_replay.c
+++ b/net/xfrm/xfrm_replay.c
@@ -714,10 +714,12 @@ static int xfrm_replay_overflow_offload_esn(struct xfrm_state *x, struct sk_buff
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



