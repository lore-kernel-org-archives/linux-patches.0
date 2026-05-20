Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24FB5349AFF;
	Wed, 20 May 2026 17:46:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299218; cv=none; b=ADun/B4yBMb0nkgdvKt+UxFxgqY5dMx5YV0qPA5cB0z9AVdFE2oUwicVaZgVjO2xq24r4Pd3BCs/TOe+SsVheuRzuoQQ38+OBLnYdCh6tYMSaTgJR+YywmyedSQCvkt7gQ645UqcBQzKNzaUAs1BHRnUH/EaXHSVS0toydTxOnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299218; c=relaxed/simple;
	bh=vcl0fk2bI5oWZlWPSvFeFTp4UwncwW9WCa6yQLibfEM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtf4ErfUGGi8cnsrVgGxgatNjI5PeSDeo1U1Y3aRmlzDi1ltiR2NNA9Wwm16kXSsvpJdXFw3+z+kQCsPLioSdqhJpz0nsJreKmurBGBfycYNgn1sxB46d3hYcg55lN7fj3iyOhfviSqL8U0mafFGcR3a/B9hhg7JTkmXKNfAKA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZB9gBDc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZB9gBDc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A5371F000E9;
	Wed, 20 May 2026 17:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299217;
	bh=C81+Y1eQA+I1wZ9yvzzxynBjzu+ZLceZ7DaMfUFModo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZB9gBDc+9hsr/dD4OGznXO7v1ydVcavN+yyZ7fRRxnbvUgWZ3/YDCW5v94+sk7ij
	 vIQdAZhO0LIX2T7RablC1Cm0Ovv3FqenzdWssCNojsuY40KeVTO+pw166blxnL3/U6
	 b9oM7UVgxZZwjpXwAz7eeFmgsdIZNOKcxP0VfKYk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Westphal <fw@strlen.de>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 666/957] netfilter: nfnetlink_osf: fix out-of-bounds read on option matching
Date: Wed, 20 May 2026 18:19:09 +0200
Message-ID: <20260520162148.976409704@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit f5ca450087c3baf3651055e7a6de92600f827af3 ]

In nf_osf_match(), the nf_osf_hdr_ctx structure is initialized once
and passed by reference to nf_osf_match_one() for each fingerprint
checked. During TCP option parsing, nf_osf_match_one() advances the
shared ctx->optp pointer.

If a fingerprint perfectly matches, the function returns early without
restoring ctx->optp to its initial state. If the user has configured
NF_OSF_LOGLEVEL_ALL, the loop continues to the next fingerprint.
However, because ctx->optp was not restored, the next call to
nf_osf_match_one() starts parsing from the end of the options buffer.
This causes subsequent matches to read garbage data and fail
immediately, making it impossible to log more than one match or logging
incorrect matches.

Instead of using a shared ctx->optp pointer, pass the context as a
constant pointer and use a local pointer (optp) for TCP option
traversal. This makes nf_osf_match_one() strictly stateless from the
caller's perspective, ensuring every fingerprint check starts at the
correct option offset.

Fixes: 1a6a0951fc00 ("netfilter: nfnetlink_osf: add missing fmatch check")
Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Reviewed-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_osf.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nfnetlink_osf.c b/net/netfilter/nfnetlink_osf.c
index 2305c7d9761eb..832a973c41777 100644
--- a/net/netfilter/nfnetlink_osf.c
+++ b/net/netfilter/nfnetlink_osf.c
@@ -64,9 +64,9 @@ struct nf_osf_hdr_ctx {
 static bool nf_osf_match_one(const struct sk_buff *skb,
 			     const struct nf_osf_user_finger *f,
 			     int ttl_check,
-			     struct nf_osf_hdr_ctx *ctx)
+			     const struct nf_osf_hdr_ctx *ctx)
 {
-	const __u8 *optpinit = ctx->optp;
+	const __u8 *optp = ctx->optp;
 	unsigned int check_WSS = 0;
 	int fmatch = FMATCH_WRONG;
 	int foptsize, optnum;
@@ -95,17 +95,17 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 	check_WSS = f->wss.wc;
 
 	for (optnum = 0; optnum < f->opt_num; ++optnum) {
-		if (f->opt[optnum].kind == *ctx->optp) {
+		if (f->opt[optnum].kind == *optp) {
 			__u32 len = f->opt[optnum].length;
-			const __u8 *optend = ctx->optp + len;
+			const __u8 *optend = optp + len;
 
 			fmatch = FMATCH_OK;
 
-			switch (*ctx->optp) {
+			switch (*optp) {
 			case OSFOPT_MSS:
-				mss = ctx->optp[3];
+				mss = optp[3];
 				mss <<= 8;
-				mss |= ctx->optp[2];
+				mss |= optp[2];
 
 				mss = ntohs((__force __be16)mss);
 				break;
@@ -113,7 +113,7 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 				break;
 			}
 
-			ctx->optp = optend;
+			optp = optend;
 		} else
 			fmatch = FMATCH_OPT_WRONG;
 
@@ -156,9 +156,6 @@ static bool nf_osf_match_one(const struct sk_buff *skb,
 		}
 	}
 
-	if (fmatch != FMATCH_OK)
-		ctx->optp = optpinit;
-
 	return fmatch == FMATCH_OK;
 }
 
-- 
2.53.0



