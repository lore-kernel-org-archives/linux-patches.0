Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA5F32BF5D;
	Thu, 28 May 2026 19:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998119; cv=none; b=SH8JGaeX6ARpQNm4Rc8bASYq/S3+TF2JcMptpctcHcpN0CNeM8DdpgxAlyb2zVzKQDygtbIhYbhT9bIgB5bpUv8qzL0wXVep/gl6mHCw5Cg2242Fzx09rGRjGoEBXfL/qpzihuRsx0UGI8efGHdpqX7V1y9c62UFkw41Bo9sLcE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998119; c=relaxed/simple;
	bh=AMyQxJfPfP/oxHzWeqWqP+EdyFos+THjfvAZBlKEmyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=P15HNouukBAvqH7wC3AD1C9tv7xjlHrgco4bRKxuKlkeAKUthEP/MaoHp5B1Nd6Qk6e228EPCmR1B8og/SWGhrij/wyNbruJqmaBE32X/l7YHW4W2LxHLRuhFkGH9JExY1IkjxIbGzCTeRIUhhUzIJ5Kg+zCA9uJuVaMRZ8pLpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yogkoxsn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yogkoxsn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4045C1F000E9;
	Thu, 28 May 2026 19:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998118;
	bh=dG1Df0/OZGUg9hmh3lsHo+64U+VARdhW5Z4Ha9NXFJs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yogkoxsnBn596h1PcYFp+D+BzfT4ZdGSFw0xTP7ALHFVKZcN/8gK8ZRYmbyghyX1S
	 QEr4p9f3U67vyfxhDVxdV7+aTEU5gfh/Qj5a/1jJ+qjhVnWAoU6LlTrICW88JW3mrI
	 uOETVg53PhWXFQ9NIcaNjqK6EBSBpfpK8da39ap0=
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
Subject: [PATCH 7.0 060/461] netfilter: nft_inner: Fix IPv6 inner_thoff desync
Date: Thu, 28 May 2026 21:43:09 +0200
Message-ID: <20260528194648.649294754@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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


