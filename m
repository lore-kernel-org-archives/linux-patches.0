Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 200C5423A72;
	Tue, 16 Jun 2026 15:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625320; cv=none; b=F+f8aMVfuvbscfHDpW9K8EZtQNthaUSqAy12UR0txxfg2T0GyoBhxH7AVba7S599Qi32PTfsEax0YLq6d6oNfJQGsnoVYjEfTlQkRjxpqBwRiutR1BJbfelhmy1cmEdJ3dr0lnVRzBQhP2ESGWOBLapSxRRvTv3k7ZtfwHTuBJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625320; c=relaxed/simple;
	bh=IG8w7omnZFZAzukCaQoyVGlHZZu8CVWxA3TGfSAGd1o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZyPdKmFsItH6RPccUZQdqeHCXwQdHlSyk8qfw4WGLrm8AqQLGYLVKlExGwVaMxoDNjVieKuzmY3aBCNFgxAgXB9lyyR8zYaAIQ5YJzq7jCCRyQcyrBLSSDQeyMRmOyThCJnO3x3zbiP+XNjdMtJ+rJ/895YkT2HzU1eEmHolyNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbAc/6Gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbAc/6Gz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0C01F00A3A;
	Tue, 16 Jun 2026 15:55:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625318;
	bh=9XA7NtXLJkK9xhdDMNAjMTMas0EQm8JrPMfGcMJE2s0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbAc/6GzJB/Njl75haq7yLkDoswCXLDuf/QG8bXg/y70GKR8ZxvEVwtssLfzsXz+B
	 be2saguHZOJ0IpCd6L6AIx8R40hGyWu1uMzrWcdjby5TQHDOfyILIlOH0E1tsokqFM
	 ds1cUyCxCt1XgLfWfnnoivA08r06SBoM+6ascewc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 086/325] xfrm: iptfs: fix use-after-free on first_skb in __input_process_payload
Date: Tue, 16 Jun 2026 20:28:02 +0530
Message-ID: <20260616145101.998232653@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e11e4f7411fd25..3dbb9c2cf4d5f6 100644
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



