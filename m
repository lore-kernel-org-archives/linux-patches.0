Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694BA24A047;
	Thu, 28 May 2026 20:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999445; cv=none; b=Agg4el5/rcitG7liKHvA6OyapCBKjN1vvDsKEj7mwWD7svgW+ZDATyJkZCnl041+bqs/nvR2DXTNcOLEp5DBxWG3iRRrs/gbMyacIfM5B4p3v0ihwQ9696QiU+DtO1BTCZ4pJXo4rawbH5+T2ZHYrl//g3ZfDWepoTPGRTlF/20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999445; c=relaxed/simple;
	bh=PWhRXKTnbPmY15m2KRsIo1i/1zueOvg3T39XH/VDmuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=V63MpV9ym/TvXNQuHkd4yhUVG3BuPDbd3fPYfWyogpDhaTJqOtdKbJsc6j8obcI7tI3y8as05DdV7bTyJ26MJnme0P+APo3bqfJgRe6anqs06lli+tUO2ktAvjTgKWJqaq44S0RQ2KYQVaOT4bQzXv9yWVbVPnDgNw9t99rM8Rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XkNENj4j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XkNENj4j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D095B1F000E9;
	Thu, 28 May 2026 20:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999444;
	bh=E8T1pkib6KzkgA6zHDxBbCz3Xz7wJDOjcvuqPcpeITU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XkNENj4jUgB0So74On+QZUtScp+6gjJAfzTRc/dJ3CxFxJOJoc3RaG38F+3AXmNQU
	 YYRpeY5FrVRavbtg9yFhMIA5O6hFlfw2DP8655M1jfUzIfeCkX4oMLFT+usOgrRNuO
	 i6BzPbGRBBeR6ifs4A/Om4T/cLdXRj93t3gopYB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>,
	Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>,
	Xuewei Feng <fengxw06@126.com>,
	Qi Li <qli01@tsinghua.edu.cn>,
	Ke Xu <xuke@tsinghua.edu.cn>,
	Fernando Fernandez Mancera <fmancera@suse.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 068/377] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Thu, 28 May 2026 21:45:06 +0200
Message-ID: <20260528194640.331221793@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>

commit b6a91f68ebfed9c38e0e9150f58a9b85da07181c upstream.

In nft_inner_parse_l2l3(), when processing inner IPv6 packets,
ipv6_find_hdr() correctly computes the transport header offset
traversing all extension headers, but the result is immediately
overwritten with nhoff + sizeof(_ip6h) (40 bytes), which only
accounts for the IPv6 base header. This creates a desync between
inner_thoff (wrong — points to extension header start) and l4proto
(correct — e.g., IPPROTO_TCP), enabling transport header forgery
and potential firewall bypass. This issue affects stable versions
from Linux 6.2.

For comparison, the normal (non-inner) IPv6 path correctly
preserves ipv6_find_hdr()'s result. Removing the incorrect overwrite
ensures that ipv6_find_hdr()'s calculated transport header offset is
preserved, thereby fixing the desynchronization.

Fixes: 3a07327d10a0 ("netfilter: nft_inner: support for inner tunnel header matching")
Cc: stable@vger.kernel.org
Reported-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reported-by: Yuxiang Yang <yangyx22@mails.tsinghua.edu.cn>
Reported-by: Xuewei Feng <fengxw06@126.com>
Reported-by: Qi Li <qli01@tsinghua.edu.cn>
Reported-by: Ke Xu <xuke@tsinghua.edu.cn>
Assisted-by: GLM:5.1 Z.ai
Signed-off-by: Yizhou Zhao <zhaoyz24@mails.tsinghua.edu.cn>
Reviewed-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_inner.c |    1 -
 1 file changed, 1 deletion(-)

--- a/net/netfilter/nft_inner.c
+++ b/net/netfilter/nft_inner.c
@@ -163,7 +163,6 @@ static int nft_inner_parse_l2l3(const st
 			return -1;
 
 		if (fragoff == 0) {
-			thoff = nhoff + sizeof(_ip6h);
 			ctx->flags |= NFT_PAYLOAD_CTX_INNER_TH;
 			ctx->inner_thoff = thoff;
 			ctx->l4proto = l4proto;


