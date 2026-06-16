Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1072243E4A8;
	Tue, 16 Jun 2026 15:19:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623163; cv=none; b=YMANRsk1UOGqaRCqlyRCXaQeSfwzExSePOv0xseqgFSG12eBexMhWApsD2wvBBArfUYHUBWHmx7b+fle8MHd4mRsFF0JD5UyN9XNi+tH1bKstTXstfpl0F8gGKc6Jpm/Akb4uiHW/jhsC50Hcvhq9EQ5riljaVRwJQxvC3HPkMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623163; c=relaxed/simple;
	bh=Ega/VDBZG9TDgn0YQBU31PznhOFhm9gN9tA1qN/1NCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TAXXw+pSQ/1ZCSi37lGB7/HauQuakmGM78ogRU+kP9YPEgvhCA2qTlR+DCkCv2irKfwyR5BLKJcPEqNpKpgTtsyBPv6SVwItPQuyW0A2it/3NyRQNhVgzqtZ4wegObbqCRC7evgpwxqN15uTt4kSY2G7sZ1auao+KtE60siFYR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=b0Y/olgW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b0Y/olgW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCE8E1F000E9;
	Tue, 16 Jun 2026 15:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623162;
	bh=tReeCiwfSfVAphbR4uNQduo8d5XlLvNGRui48V+OqEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b0Y/olgWFAXRPSbSKNF9/IdnBLKGIwEoMydWvqKdlI/HTJWpxgP0FpX3hzRgprwWi
	 KosOl97HQx09rLKeVOw4uwwAKfIEWU2tJAN+Lg72h9GPgNpoAMBF6YDXNn7cAQxwqc
	 GDVlZujLYdcsGJiak9MkxuT4WiqswPMSlDdtnCJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 098/378] xfrm: iptfs: fix use-after-free on first_skb in __input_process_payload
Date: Tue, 16 Jun 2026 20:25:29 +0530
Message-ID: <20260616145115.483082193@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenghang Xiao <kipreyyy@gmail.com>

[ Upstream commit eb48730bb827d1550401a5d391903f9d90b493c8 ]

__input_process_payload() stores first_skb into xtfs->ra_newskb under
drop_lock when starting partial reassembly, then unlocks and breaks out
of the processing loop. The post-loop check reads xtfs->ra_newskb
without the lock to decide whether first_skb is still owned:

    if (first_skb && first_iplen && !defer && first_skb != xtfs->ra_newskb)

Between spin_unlock and this read, a concurrent CPU running
iptfs_reassem_cont() (or the drop_timer hrtimer) can complete
reassembly, NULL xtfs->ra_newskb, and free the skb. The check then
evaluates first_skb != NULL as true, and pskb_trim/ip_summed/consume_skb
operate on the freed skb — a use-after-free in skbuff_head_cache.

Replace the unlocked read with a local bool that records whether
first_skb was handed to the reassembly state in the current call. The
flag is set after the existing spin_unlock, before the break, using the
pointer equality that is stable at that point (first_skb == skb iff
first_skb was stored in ra_newskb).

Fixes: 3f3339885fb3 ("xfrm: iptfs: add reusing received skb for the tunnel egress packet")
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_iptfs.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_iptfs.c b/net/xfrm/xfrm_iptfs.c
index 6c6bbc0405170c..f25504610d8b23 100644
--- a/net/xfrm/xfrm_iptfs.c
+++ b/net/xfrm/xfrm_iptfs.c
@@ -954,6 +954,7 @@ static bool __input_process_payload(struct xfrm_state *x, u32 data,
 	u32 first_iplen, iphlen, iplen, remaining, tail;
 	u32 capturelen;
 	u64 seq;
+	bool first_skb_partial = false;
 
 	xtfs = x->mode_data;
 	net = xs_net(x);
@@ -1161,6 +1162,7 @@ static bool __input_process_payload(struct xfrm_state *x, u32 data,
 
 			spin_unlock(&xtfs->drop_lock);
 
+			first_skb_partial = (first_skb == skb);
 			break;
 		}
 
@@ -1172,7 +1174,7 @@ static bool __input_process_payload(struct xfrm_state *x, u32 data,
 		/* this should not happen from the above code */
 		XFRM_INC_STATS(net, LINUX_MIB_XFRMINIPTFSERROR);
 
-	if (first_skb && first_iplen && !defer && first_skb != xtfs->ra_newskb) {
+	if (first_skb && first_iplen && !defer && !first_skb_partial) {
 		/* first_skb is queued b/c !defer and not partial */
 		if (pskb_trim(first_skb, first_iplen)) {
 			/* error trimming */
-- 
2.53.0



