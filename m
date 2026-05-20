Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30EAB3F58D6;
	Wed, 20 May 2026 17:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299907; cv=none; b=Cjvs6SQH8sqzs1ezhzVpydGMfMYMSqIufZ3KR3aWs31Iiqa9YC0JeQz3/kSYDaf7ko29/uO9XXUVMO/zOJWDZmilx0TbsOB4j2vKbsoQEk8ma56aeD4f4BWPkcMdCpRrXLcweM24YIT7XkGyWGcdzcYsE9pDKCEvk9Be+KsJCbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299907; c=relaxed/simple;
	bh=cE1I/LT77D9VSQVoZA8SyC2bCqFbLnUDYym822bavqk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3EgtUkf64fjb2MF71wtEJq9GyPN1T6pWMjm/tBW8O1j0CIAH+V3qQSZpcyjMpqc+XjBZBLkQ8mJae9zyQp74z2MlxQlYjqU70jQWcZygkyUtAfBlgnvdxpV/Oxwun3gp+VMF26NTZljEGv2MB7/A2/lB+cBHP78ALqdj9TBBl8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NqHutNOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NqHutNOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C92D1F000E9;
	Wed, 20 May 2026 17:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299905;
	bh=BYgYVcvRe4LZa7IEnbk9xKZJkuGXQFhoKbb+N5jDgkM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NqHutNOBY3YEPETrFgumyxwee4sMAwgLAlUPxRS2mTgsPcr9MMpUakh4lzvoQ7V+t
	 ac2ffvdDGlGHj+R1wf87zXU1sjbdFop22dLnpsOF08lwDKvd+lpmEOlWBtJJyDwuRQ
	 nhQeqIicK1pZg23wFMgZZv179xhjcqhnfD3oJv9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Xiasong <lixiasong1@huawei.com>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.18 889/957] netfilter: nft_ct: fix missing expect put in obj eval
Date: Wed, 20 May 2026 18:22:52 +0200
Message-ID: <20260520162153.849286708@linuxfoundation.org>
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

From: Li Xiasong <lixiasong1@huawei.com>

commit 19f94b6fee75b3ef7fbc06f3745b9a771a8a19a4 upstream.

nft_ct_expect_obj_eval() allocates an expectation and may call
nf_ct_expect_related(), but never drops its local reference.

Add nf_ct_expect_put(exp) before return to balance allocation.

Fixes: 857b46027d6f ("netfilter: nft_ct: add ct expectations support")
Cc: stable@vger.kernel.org
Signed-off-by: Li Xiasong <lixiasong1@huawei.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nft_ct.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -1382,6 +1382,8 @@ static void nft_ct_expect_obj_eval(struc
 
 	if (nf_ct_expect_related(exp, 0) != 0)
 		regs->verdict.code = NF_DROP;
+
+	nf_ct_expect_put(exp);
 }
 
 static const struct nla_policy nft_ct_expect_policy[NFTA_CT_EXPECT_MAX + 1] = {


