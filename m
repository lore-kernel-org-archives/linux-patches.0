Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8B233A70E;
	Thu,  2 Jul 2026 16:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783009913; cv=none; b=fEboqEo4wZw3p+f0ki7ZDW5AbxBAqnyZd9UAjY1QfbfBaB6nf9NuWTYLMY2j/vcJO/lCKG/hcF6zUl/LxlloTwf0BZljdrpyfR8ROzl8Nw5dmbszTHjMtes0BMvc8O9uNmGmp+kZzj0O09Fam04gJROLv2p9zQ4u3yx7J93ZYUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783009913; c=relaxed/simple;
	bh=8dWDyH5/05GJ2Z4vewdnbmfVntu2OE4f5WIsOWE/PDw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bC7SnTv4A4OtQEkIkjG7gVlDlyeTR42vWUAWZqbmlhgoADHoNcBRqRRv0btCOILqG3dmjSb5FN9k97prl8LMOGfIXUZRs2tlQihc49S8DUsrapkqz0ddk5Moagz5g303u5EXn8JYOrrCzV7F+C1tHgp2KZnq/7w7V+IC3qAV0qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2feixvkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2feixvkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C484C1F00A3A;
	Thu,  2 Jul 2026 16:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783009912;
	bh=PNALnhKzI5/SHSklP/hxI8qnExTnyGXJiG/5RZZmX18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2feixvkIgGhPkMfcfyoxOphNTntQlywdS9ngLpM4t7RnM9zExjTM9QqEsGQmVTGdN
	 wNavFPfAbw45iNZNi3sdJsHXhYnDjoqd9pXCDf3Xl3f3DhadBbb5XmRNz4MWzp4kjY
	 HTYgCHXA5KmAWC6dwXW3yteyifWMzwulJE71yFbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Florian Westphal <fw@strlen.de>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>
Subject: [PATCH 6.1 039/129] netfilter: nf_tables: always walk all pending catchall elements
Date: Thu,  2 Jul 2026 18:19:18 +0200
Message-ID: <20260702155112.962952668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.163984240@linuxfoundation.org>
References: <20260702155112.163984240@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Westphal <fw@strlen.de>

commit 7cb9a23d7ae40a702577d3d8bacb7026f04ac2a9 upstream.

During transaction processing we might have more than one catchall element:
1 live catchall element and 1 pending element that is coming as part of the
new batch.

If the map holding the catchall elements is also going away, its
required to toggle all catchall elements and not just the first viable
candidate.

Otherwise, we get:
 WARNING: ./include/net/netfilter/nf_tables.h:1281 at nft_data_release+0xb7/0xe0 [nf_tables], CPU#2: nft/1404
 RIP: 0010:nft_data_release+0xb7/0xe0 [nf_tables]
 [..]
 __nft_set_elem_destroy+0x106/0x380 [nf_tables]
 nf_tables_abort_release+0x348/0x8d0 [nf_tables]
 nf_tables_abort+0xcf2/0x3ac0 [nf_tables]
 nfnetlink_rcv_batch+0x9c9/0x20e0 [..]

Fixes: 628bd3e49cba ("netfilter: nf_tables: drop map element references from preparation phase")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
[ Shivani: Modified to apply on v6.6.y-v6.1.y ]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_tables_api.c |    2 --
 1 file changed, 2 deletions(-)

--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -627,7 +627,6 @@ static void nft_map_catchall_deactivate(
 		elem.priv = catchall->elem;
 		nft_set_elem_change_active(ctx->net, set, ext);
 		nft_setelem_data_deactivate(ctx->net, set, &elem);
-		break;
 	}
 }
 
@@ -5267,7 +5266,6 @@ static void nft_map_catchall_activate(co
 		nft_clear(ctx->net, ext);
 		elem.priv = catchall->elem;
 		nft_setelem_data_activate(ctx->net, set, &elem);
-		break;
 	}
 }
 


