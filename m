Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A50F525F78A;
	Tue, 11 Mar 2025 15:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706733; cv=none; b=qGr/6LphJ9oxhQfq1YrKOIAi6dSqBaf72IrEgQhNOS0osajz7GlmzkbeBteqeicbl3j1wWnw+czquKblUH/uYZO6qKXTD73wtP2TU1chC3GeWyRZ+LoqIw8bQeEyL5i4u3ZiYwMsSDBrRlco+kFn2JXl9CQY3xG5q5XtX4rXi58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706733; c=relaxed/simple;
	bh=99ekOshrdHo1iqkm4PP8gUwIfKQwq8+JRmjd9iwkBBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PO90v1Vh/uQzwyVu9uEsfawYZU+v3Vxn90CjDNTmL/co38kZATzLFfevQ6Bmfzltx7xnkYkoxhZ78mV7YMOoEp7+IYvKA5/4Mzl3mLV4PXJblBjp7Jc7igBrZ+fHPs9GArNAikjbP/aNKfCY8B8n+6eXTp3aMxjp+ChMjCJ8IJE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1EnNxd7j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1EnNxd7j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D23C4AF09;
	Tue, 11 Mar 2025 15:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706733;
	bh=99ekOshrdHo1iqkm4PP8gUwIfKQwq8+JRmjd9iwkBBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1EnNxd7jLKYd7iLdaJIZyXpJtFFe0JnOihZza8ViCf9NELHSHrDL+L5LtB4b9Ss6G
	 oG3X8LFBh4X6onG8ls9ALZnvk9nbgiJWVN1jf6XlQQce76ZDFUv1JBLbMphBbqhwS+
	 4IJc724gqR9LUFAI5CoZRzcwu0q9BEvvzK6rBHo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.10 117/462] netfilter: nf_tables: reject mismatching sum of field_len with set key length
Date: Tue, 11 Mar 2025 15:56:23 +0100
Message-ID: <20250311145802.984286041@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4346,7 +4346,7 @@ static int nft_set_desc_concat_parse(con
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
-	u32 num_regs = 0, key_num_regs = 0;
+	u32 len = 0, num_regs;
 	struct nlattr *attr;
 	int rem, err, i;
 
@@ -4360,12 +4360,12 @@ static int nft_set_desc_concat(struct nf
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
 


