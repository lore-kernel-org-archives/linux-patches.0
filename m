Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C0923AE198;
	Wed, 23 Sep 2026 14:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174186; cv=none; b=ZMLZTiA6zx2W7BGgarRFjmVWcj7F0sXSYbfnsZr0PvhsEvbGTOTyvdNN9pw7NhtCwrMtHR443lYMithMQLUWk2N0qjwu8eMk0KlJbh2XmDRW6wB/XkKOZfa+ggpb7C8+5zkAn5LluVwvEumdzd99spG8bTLHT5MqwKu2XdT3/V8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174186; c=relaxed/simple;
	bh=YRucF0GRg6aBEzAgMWjP/Of1E2wH0tb53CPU2LOa29U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gxSDFpUToa2E+lI7YPBXUpXmz+fj09k53bGiHUSAUM3YB3YfD7A6mD9WKGh3SNcjDwt2+V8K91MHrc+xrwQWyuKJQM57VpUp4xellwZ9QFMbFXHvBHZttnWDogE9uhJZBzQF4TPqvG1ujChRwMZiLaLrqtoKkkysu+BQSQH3t3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qcmiw4hk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qcmiw4hk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF5C1F000FF;
	Wed, 23 Sep 2026 14:36:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174185;
	bh=BlppB2BGriKoLRqrrDDeIYo2bfZw2ReomCajSGsr+1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qcmiw4hkhfdGQBNsHlrsO3xkxyVQiSKiJLY4Es5Yl0CfMGYmW55vGxBs1M8H7c4BQ
	 BiznC5M7enNzsg9QMAyzJtnxfPK/MuFregNmLMZqFN1YtaZ+yR38BHvNBLspkhknZr
	 f4xuSNVbBUxKt7Y9L3LYGL6fRuvNVz9a2QBmSfeI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 018/398] xfrm: iptfs: fix runt reassembly panic from short inner tot_len
Date: Wed, 23 Sep 2026 16:01:32 +0200
Message-ID: <20260923140643.909483853@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit dc33262be1fe43d0eb0b84fb58c6ed42e2f64a8c ]

When the start of an inner packet is split across two outer packets
such that fewer than 4 bytes land at the end of the first one,
__input_process_payload() saves those bytes as a runt and skips the
iplen/iphlen validation performed for in-place packets. When the
continuation packet arrives, iptfs_reassem_cont() only requires the
declared inner length to be >= sizeof(ra_runt) (6) before allocating
the reassembly skb with that attacker-controlled length.

However, __iptfs_iphlen() always returns the fixed minimum IP header
size (20 for IPv4, 40 for IPv6), so for an inner IPv4 tot_len in
[6, 19] the header-completion copy writes past the declared packet
length, and the subsequent "ipremain -= copylen" underflows to ~4GB,
leaving the payload copy length bounded only by blkoff (up to 64KB).
At runtime the skb_put() tailroom check turns this into
skb_over_panic(), i.e. an unprivileged kernel panic (DoS), reachable
locally via userns+netns IPTFS SAs and remotely against IPTFS VPN
gateways when the decrypted outer skb is linear (e.g. AF_PACKET taps,
tun/tap delivery).

Align the runt path with the normal path by requiring the declared
inner length to cover at least the IP header size. This also subsumes
the previous >= sizeof(ra_runt) check, since the minimum IP header
is always larger than the runt buffer.

This issue was found by the autokbug dynamic kernel fuzzer at
Tencent Yunding Lab.

Fixes: 075694765446 ("xfrm: iptfs: handle received fragmented inner packets")
Reported-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 0f562301ceb34..4d3489acb099a 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -828,8 +828,8 @@ static u32 iptfs_reassem_cont(struct xfrm_iptfs_data *xtfs, u64 seq,
 		 * allocate an in progress skb
 		 */
 		ipremain = __iptfs_iplen(xtfs->ra_runt);
-		if (ipremain < sizeof(xtfs->ra_runt)) {
-			/* length has to be at least runtsize large */
+		if (ipremain < __iptfs_iphlen(xtfs->ra_runt)) {
+			/* length has to be at least the IP header size */
 			XFRM_INC_STATS(xs_net(xtfs->x),
 				       LINUX_MIB_XFRMINIPTFSERROR);
 			goto abandon;
-- 
2.53.0



