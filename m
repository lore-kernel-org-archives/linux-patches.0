Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A42541A6816;
	Sat, 12 Sep 2026 19:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240273; cv=none; b=LcvusXkqqvxEyFSgWuUd5ObsGV/ASX72FkvgHsjmfARob7ie31wEyXY15Ze5o//7zK+S66HWetVDLaFHRZnh9jpdmBfJAaxGgWauPCNnmknF2HugS4tgHqIlAnmpacFhVnAqh0nrBBuBJyb/oE3uDNNHwfYwZK8uXrrHAyJcOVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240273; c=relaxed/simple;
	bh=aiS9lGj2wqAv0db2lP+kjCRIsyShhtFHR8FI1Ydt4YY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/J+G0YH9opvZDVpZirzG09MKwisPZVBbt7hrAQuF4JfvxuJRM2Vpao/3VVshZ/I/B5OddwBoJBNgfGxnpo5iO/roID2UoLVmX6Oa0JVPNcd5Y/rrW+xOwhWOL0po0OHSypDqoGkRNTq0OS3DIF+NcMItY6Ah3fz0SRkV8k+iVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hg0Onxgn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hg0Onxgn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A92B1F000FF;
	Sat, 12 Sep 2026 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240269;
	bh=UKKMSDXVyYzsH4yBKaxbhc+xuKhqvAqc+sjokbuUn1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hg0OnxgnYVr0QFG/e525ZgwbowlQVWzL7jK2GZiYA1euknCLpHn2TNwTz6HJXtdYz
	 DkhwiRqp76zO78fgKg/NcU9IZMZ07IYLVG/NjI6UrPe+CH+ZvKhMWcRGF1qV59ZR/7
	 4UZ8PGnmOcs8foTrWS1tT4nIOSB5eadivMYwjJUU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Junseo Lim <zirajs7@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 834/935] lwt_bpf: Restore reserved headroom after xmit program
Date: Sat, 12 Sep 2026 09:04:24 +0200
Message-ID: <20260912065545.951988114@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



