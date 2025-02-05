Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C9031DC9AA;
	Wed,  5 Feb 2025 15:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768517; cv=none; b=BYdaqv8UumnzbmGm/tlARoCJFAk5QGFUM7r73rG0IrCjbzyxUkAw4V2BMpYXbkHoL+AmHNAB2UsU59kU79NAcnYGjQWeAnHTwBx8RmGRNazIzObibI1EazJ7hiWxDVI3ummCCEHdiJmcARuhivmfU7P69TF39rZl4drpP3TkEP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768517; c=relaxed/simple;
	bh=EABrEYW2OdubtjOjaqYjaIE1/13bCgWw3eBKLBc4az0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lpvm9rW9baDJw5CRbzdwTX4QD/rf5tEs64zyE8JQQ2fpkjemgbo5v99jglGKKfdsOyiJzqPsNp1weWJejHkmtSgyz2cv/HtJj//+sQUSADzaedYm3juAsMktXQri1pYHgd2Sbbkb6gUsjk2eb2QIrQzA2j/1xmkf9KnJ9oKogjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=St/oIxml; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="St/oIxml"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B581C4CED6;
	Wed,  5 Feb 2025 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768517;
	bh=EABrEYW2OdubtjOjaqYjaIE1/13bCgWw3eBKLBc4az0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=St/oIxmlWZ1Df2ZqoP4v+Y4n81J5lWTk+c37nhaTPcEByKJg74uAbDNotJ2CDZsEZ
	 Xdg2H/Blkacen1ky1xW5kSp7ZQrq0ylwSnjZV1gAbUb/nfo0xUX4RXi517Ge3wq3Il
	 NDdVrdzVFnCYT2in1l8tGDgJnM57AG3OVuCcqvCY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Noam Rathaus <noamr@ssd-disclosure.com>,
	Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 6.13 579/623] netfilter: nf_tables: reject mismatching sum of field_len with set key length
Date: Wed,  5 Feb 2025 14:45:21 +0100
Message-ID: <20250205134518.372770857@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5074,7 +5074,7 @@ static int nft_set_desc_concat_parse(con
 static int nft_set_desc_concat(struct nft_set_desc *desc,
 			       const struct nlattr *nla)
 {
-	u32 num_regs = 0, key_num_regs = 0;
+	u32 len = 0, num_regs;
 	struct nlattr *attr;
 	int rem, err, i;
 
@@ -5088,12 +5088,12 @@ static int nft_set_desc_concat(struct nf
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
 


