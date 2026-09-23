Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6008A4A3850;
	Wed, 23 Sep 2026 14:10:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790172601; cv=none; b=t8x6CeBp4IjxifqbfK4OGhb7EHR3zw0GsOCOqpLptfPw6BYO/ZQEw4m2rXsg1LQEAldNtEsaZD24Trs4i/IoYoVoRFV3BHtYXLZ1iTNWo/0Mqth0vDNBisYxXyyB1t9LC7RgPJ954YaNhFyWq+aoxKAONN9gvC8Z42LQFP8Mat8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790172601; c=relaxed/simple;
	bh=FAdHvTWS7pWcDa4JoUDxZsdIBpRSwqX6h9sB5T81aE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sk10omr+1GexIXOJh6T357zl2GJ5sqS5g7ol7FgFkl84T6wt9C+JpYVew4ZX4s9WPP7ewP6TfPxAHML1CwrOKQpvIz/pv6hMJqDMOvYNh0y6lnO1OmJRtKaIstcuaHy/RACKOYHJgw8sFi/0fszuWhu2Yqzb42mWXZJjJkZUJno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfUYdLhj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfUYdLhj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64A491F000FF;
	Wed, 23 Sep 2026 14:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790172599;
	bh=lVuo+mIJ5qBcdBmFdzYSl2SKcDG95t+Ld7uVDTOxmhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WfUYdLhjPi7uXsoUAHFqxx8vSZ22MTgLWSerPor1On9cNFwyRomCzDFdffRySD9RD
	 MRoNSIwo/M/trg69QpZxAkoIq7XUqhmi2CxCiRY+dB5Tjsv/KioPrSlRCRK/ySBF+a
	 M9r1gKNTiNOjYgMK7MVQjs7HqSh3yEFuakp76SsI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 007/438] xfrm: iptfs: fix runt reassembly panic from short inner tot_len
Date: Wed, 23 Sep 2026 16:00:28 +0200
Message-ID: <20260923140644.960446527@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140644.756254324@linuxfoundation.org>
References: <20260923140644.756254324@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2ce15c472cc4d..6920940a35b49 100644
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



