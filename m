Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F1336124;
	Wed, 30 Jul 2025 09:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753869047; cv=none; b=pelcelrwCirximteUK001y+teqqLBR5OeLP+qV1B9G8Py2yLrbToUm0OcWIhqEDtNQktQz6t+7zT/8h+kXmaGtY+TRVjazlfCsjExLwj4iQG8BWLiAvGF4mzM0iPfjIXX7a+S1ep9zeHuX/GFHiUeUfhJMnXly8bL2Vozp2217g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753869047; c=relaxed/simple;
	bh=VX//OmU7/gFEHby7Owy6Bjw7TMORw+UsP+/Cw4CqUHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBf4LpSy8RH8jn7UWbdmcPUwWcgBYdGIljcre2TBtk92DG1S0zs2a71oPr2gln84FWi4z4u+taTF6/3MQ9rvZmRuZ88rBtkourr1hr2n/o0C4CcRJHWCY5dIiOieHmB9VZPbNtTqToMEngHK7a9Ko5rY3MsVT/5pYQTzsSZtfIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1J1kivC8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1J1kivC8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C5D5C4CEF5;
	Wed, 30 Jul 2025 09:50:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753869046;
	bh=VX//OmU7/gFEHby7Owy6Bjw7TMORw+UsP+/Cw4CqUHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1J1kivC8rWGNs1+HEsOV/6/m9MClSvReiNLgZ2Bd0FaRszVi5XnHNxifdemSInQ6G
	 lQPISLv/cJ72ozQiN343yDWt13nrvcHcP5xlSqQ/dLmHtwz9t3rCYxcDcqLkTrI+Bb
	 FZQ0Pu46TV7a3zr1xn0+AQYO7gqWklLQjGKK7OqA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 24/92] xfrm: ipcomp: adjust transport header after decompressing
Date: Wed, 30 Jul 2025 11:35:32 +0200
Message-ID: <20250730093231.548487935@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit 2ca58d87ebae20906cf808ef813d747db0177a18 ]

The skb transport header pointer needs to be adjusted by network header
pointer plus the size of the ipcomp header.

This shows up when running traffic over ipcomp using transport mode.
After being reinjected, packets are dropped because the header isn't
adjusted properly and some checks can be triggered. E.g the skb is
mistakenly considered as IP fragmented packet and later dropped.

kworker/30:1-mm     443 [030]   102.055250:     skb:kfree_skb:skbaddr=0xffff8f104aa3ce00 rx_sk=(
        ffffffff8419f1f4 sk_skb_reason_drop+0x94 ([kernel.kallsyms])
        ffffffff8419f1f4 sk_skb_reason_drop+0x94 ([kernel.kallsyms])
        ffffffff84281420 ip_defrag+0x4b0 ([kernel.kallsyms])
        ffffffff8428006e ip_local_deliver+0x4e ([kernel.kallsyms])
        ffffffff8432afb1 xfrm_trans_reinject+0xe1 ([kernel.kallsyms])
        ffffffff83758230 process_one_work+0x190 ([kernel.kallsyms])
        ffffffff83758f37 worker_thread+0x2d7 ([kernel.kallsyms])
        ffffffff83761cc9 kthread+0xf9 ([kernel.kallsyms])
        ffffffff836c3437 ret_from_fork+0x197 ([kernel.kallsyms])
        ffffffff836718da ret_from_fork_asm+0x1a ([kernel.kallsyms])

Fixes: eb2953d26971 ("xfrm: ipcomp: Use crypto_acomp interface")
Link: https://bugzilla.suse.com/1244532
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Acked-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xfrm/xfrm_ipcomp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/xfrm/xfrm_ipcomp.c b/net/xfrm/xfrm_ipcomp.c
index 907c3ccb440da..a38545413b801 100644
--- a/net/xfrm/xfrm_ipcomp.c
+++ b/net/xfrm/xfrm_ipcomp.c
@@ -97,7 +97,7 @@ static int ipcomp_input_done2(struct sk_buff *skb, int err)
 	struct ip_comp_hdr *ipch = ip_comp_hdr(skb);
 	const int plen = skb->len;
 
-	skb_reset_transport_header(skb);
+	skb->transport_header = skb->network_header + sizeof(*ipch);
 
 	return ipcomp_post_acomp(skb, err, 0) ?:
 	       skb->len < (plen + sizeof(ip_comp_hdr)) ? -EINVAL :
-- 
2.39.5



