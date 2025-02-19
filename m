Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6561CAA68;
	Wed, 19 Feb 2025 09:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956654; cv=none; b=QeUkS+vpHbJL3nw44w0bFpnqBR9IbLWX7miOKZGpvg5ofLvivh3nI1E6Bvy1vBfoUhVPI/ExxVbZqlrZtDH7m33ampTe2j8BL4esJugMxlbLNTelJB8xlFjY1XAZ+A7pgz3tE2hPURfo4GIfDU0Zf+BbFg2FhghDSvyEeD1uJPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956654; c=relaxed/simple;
	bh=VDhHfS2DYDtUlN3IymnEc5a13wiY5JVfFOXA+lgM5PQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYVyOtnuCh+ShtEcbdcshQNEgrv1DXH+RH8x8Rv5UHUTfnLNcsEdySYGt22gmzW3rBwsfrdtsVj1gNZJsML/sCtUM0T76YcbEeVYHjVunx4rkLJ85hbD/y4xvkunhJddmjSZRa3p8VvSFDEdaFByAy5AVuwOXnfU3PlmuexdfC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wf/rvsHG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wf/rvsHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9892C4CED1;
	Wed, 19 Feb 2025 09:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956654;
	bh=VDhHfS2DYDtUlN3IymnEc5a13wiY5JVfFOXA+lgM5PQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wf/rvsHGZP27/pBwGdDKLJeBxrc9G95xQxu8V90kX+15yAlqYbVh1qb82D10ipXl7
	 C/A5qOC58IZeYj/w9uXl1QHQKgmv6MnIMn06HXa6eXvW1OKtE1Kf79DOn5h03P8CVk
	 qQbUzV4SvpayP+W3XphHyMO4hTIA/I08b+PxEZ4o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.1 246/578] netfilter: nf_tables: reject mismatching sum of field_len with set key length
Date: Wed, 19 Feb 2025 09:24:10 +0100
Message-ID: <20250219082702.709010006@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pablo Neira Ayuso <pablo@netfilter.org>

commit 1b9335a8000fb70742f7db10af314104b6ace220 upstream.

The field length description provides the length of each separated key
field in the concatenation, each field gets rounded up to 32-bits to
calculate the pipapo rule width from pipapo_init(). The set key length
provides the total size of the key aligned to 32-bits.

Register-based arithmetics still allows for combining mismatching set
key length and field length description, eg. set key length 10 and field
description [ 5, 4 ] leading to pipapo width of 12.

Cc: stable@vger.kernel.org
Fixes: 3ce67e3793f4 ("netfilter: nf_tables: do not allow mismatch field size and set key length")
Reported-by: Noam Rathaus <noamr@ssd-disclosure.com>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4567,7 +4567,7 @@ static int nft_set_desc_concat_parse(con
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
-	u32 num_regs = 0, key_num_regs = 0;
+	u32 len = 0, num_regs;
 	struct nlattr *attr;
 	int rem, err, i;
 
@@ -4581,12 +4581,12 @@ static int nft_set_desc_concat(struct nf
 	}
 
 	for (i = 0; i < desc->field_count; i++)
-		num_regs += DIV_ROUND_UP(desc->field_len[i], sizeof(u32));
+		len += round_up(desc->field_len[i], sizeof(u32));
 
-	key_num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
-	if (key_num_regs != num_regs)
+	if (len != desc->klen)
 		return -EINVAL;
 
+	num_regs = DIV_ROUND_UP(desc->klen, sizeof(u32));
 	if (num_regs > NFT_REG32_COUNT)
 		return -E2BIG;
 


