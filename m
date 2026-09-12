Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0F3F39936E;
	Sat, 12 Sep 2026 20:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243332; cv=none; b=CS7WfUKCIClHR63jM18I4+9AWIwUYsVp/qOw67z/7Yc6HQiz0GkagzcLMoA+RTc7J7WEQ7GvyQrk6aMAu8MxPAutUd945kXmO32GQsXID/GkoSj5qvgcmlMU4j8jQusFPL6VcNuZfP75Tls+l8stHZYqbjskbk4UEm1pzVxwWl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243332; c=relaxed/simple;
	bh=dT91K4C6VHeIrqcSzL0d8tBXp1zcc7c/ezDxXYuRQRQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0lOsL8SPuHYOMgKLdwFrJ1EVfNwzC1UTetruApzFIcmAL/ioCkbPCbcKjsEFTDexx5ixhQPgSuTxxWHwujjWbsCeSiJq1MeQ0K0XpGUt65Px3Rr8l1/26sad2VO9umOqNLHJYOYeLq+kK3DQ5V9w1ZdfATDBagXEb7RRYx3Mm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LPJKOLyD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LPJKOLyD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 266801F000FF;
	Sat, 12 Sep 2026 20:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243330;
	bh=osLa9wix1nzwHhx6yb/pUjvO0jEtxYgDJExIpPZouXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPJKOLyDOmkLPejB4K94FZjSxhtwwFbuhJs1z8tpUyu5/xjf5w3KE+pL/Hi7CNiEd
	 o3W+Y8g2xPez/Kt4DobipygOVrEv5gBHeE6o2DS+bCOKZEP0wf1rQW3H2pDEwpXgqW
	 Mo9sZbw+2bBbtM6IEizD0LgIEvybtjDXZhVVe4hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Junseo Lim <zirajs7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 718/798] lwt_bpf: Restore reserved headroom after xmit program
Date: Sat, 12 Sep 2026 09:05:46 +0200
Message-ID: <20260912065533.538089982@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junseo Lim <zirajs7@gmail.com>

[ Upstream commit 5fe7007aed9ad069b2bd77e5d0c875c64f5c0269 ]

ip_finish_output2() expands an skb to LL_RESERVED_SPACE(dev) before LWT
xmit. An LWT_XMIT BPF program can then modify the skb head and still
return BPF_OK, so bpf_xmit() rechecks the remaining headroom before the
skb continues to neighbour output.

That recheck uses dst->dev->hard_header_len. This is not enough for the
neighbour cached-header path: neigh_hh_output() copies the cached hardware
header using the aligned hh_cache size, HH_DATA_MOD for short headers or
HH_DATA_ALIGN(hh_len) otherwise.

On Ethernet, hard_header_len is 14 but the cached copy needs 16 bytes. If
an LWT_XMIT BPF program calls bpf_skb_change_head(skb, 1, 0), the skb can
still have 15 bytes of headroom after the program. The existing check
accepts that, after which neigh_hh_output() hits its headroom warning and
drops the skb.

Use LL_RESERVED_SPACE(dst->dev) in the post-BPF headroom check to match
the reservation made before LWT xmit.

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Reported-by: Sechang Lim <rhkrqnwk98@gmail.com>
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Junseo Lim <zirajs7@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20260811044149.118235-1-zirajs7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/lwt_bpf.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/net/core/lwt_bpf.c b/net/core/lwt_bpf.c
index c883366a85b80..7953a3d0f94e9 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -157,10 +157,10 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
 	return dst->lwtstate->orig_output(net, sk, skb);
 }
 
-static int xmit_check_hhlen(struct sk_buff *skb, int hh_len)
+static int xmit_check_headroom(struct sk_buff *skb, int hroom)
 {
-	if (skb_headroom(skb) < hh_len) {
-		int nhead = HH_DATA_ALIGN(hh_len - skb_headroom(skb));
+	if (skb_headroom(skb) < hroom) {
+		int nhead = hroom - skb_headroom(skb);
 
 		if (pskb_expand_head(skb, nhead, 0, GFP_ATOMIC))
 			return -ENOMEM;
@@ -272,7 +272,7 @@ static int bpf_xmit(struct sk_buff *skb)
 
 	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
 	if (bpf->xmit.prog) {
-		int hh_len = dst->dev->hard_header_len;
+		int hroom = LL_RESERVED_SPACE(dst->dev);
 		__be16 proto = skb->protocol;
 		int ret;
 
@@ -288,9 +288,12 @@ static int bpf_xmit(struct sk_buff *skb)
 				return -EINVAL;
 			}
 			/* If the header was expanded, headroom might be too
-			 * small for L2 header to come, expand as needed.
+			 * small for the L2 header to come, expand as needed.
+			 * neigh_hh_output() copies the cached header in
+			 * HH_DATA_MOD aligned chunks, so match the reservation
+			 * made before LWT xmit.
 			 */
-			ret = xmit_check_hhlen(skb, hh_len);
+			ret = xmit_check_headroom(skb, hroom);
 			if (unlikely(ret))
 				return ret;
 
-- 
2.53.0



