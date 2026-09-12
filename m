Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E88332E757;
	Sat, 12 Sep 2026 16:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789231619; cv=none; b=XIXu9DrQpaRixf1KHFcEUfU1A1cZGz2eG3U542G1HisG0B0iRfz2sfDh96wPGOIAzdeVOpCHWprneWX4A7q/HmhfbI8nIfYaHGV9670sniBRACx8VIaqBN6t8QB0cUOxhtLGnmGDfptkq7vpL6ksN6A/d6gN3CD7jMvTD4LUWP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789231619; c=relaxed/simple;
	bh=2GWGMM32l7jcfxVJo1Wpp/WfqIOa52X78wr8HT+id+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KnKDYBPOiiandCFwSG83MmcIo6jd0WD8Mu9vwiM4Ktp9GHlJknMozyMOImOBsgnnefcvqmm3taFA6McWULpzGCbQSYYjD9M18WWxnGxGXrxhrmlWC1xEZveX2CBPwQHzQmvgU7d6PakAX3WZp7NtsWfZiKOwNX3Oy7fWJZD8eW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V7VXt9SA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V7VXt9SA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B851F000FF;
	Sat, 12 Sep 2026 16:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789231618;
	bh=Xb3994Hk8mQb22irv/a10oQjA2MrE1+UGSNlMNlE6GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V7VXt9SAa50j8h5/BlIsvnyOPy67YhMQ3y0jbQhUoiM8RFkT5aUTme3Ze3QxNO6YE
	 YIRZQhOydEPop9QgqmPtBBAFtUV9fMB+VofRDh6THCShcfj5onhpzyviW9f87Wd8ES
	 89zgXPd0cXvCwENinLVq+WwF1Xbkqyo4s8ibx7q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Junseo Lim <zirajs7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1036/1191] lwt_bpf: Restore reserved headroom after xmit program
Date: Sat, 12 Sep 2026 09:02:44 +0200
Message-ID: <20260912065611.450185546@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index c5b90a309685e..8c83b34ed58af 100644
--- a/net/core/lwt_bpf.c
+++ b/net/core/lwt_bpf.c
@@ -158,10 +158,10 @@ static int bpf_output(struct net *net, struct sock *sk, struct sk_buff *skb)
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
@@ -273,7 +273,7 @@ static int bpf_xmit(struct sk_buff *skb)
 
 	bpf = bpf_lwt_lwtunnel(dst->lwtstate);
 	if (bpf->xmit.prog) {
-		int hh_len = dst->dev->hard_header_len;
+		int hroom = LL_RESERVED_SPACE(dst->dev);
 		__be16 proto = skb->protocol;
 		int ret;
 
@@ -289,9 +289,12 @@ static int bpf_xmit(struct sk_buff *skb)
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



