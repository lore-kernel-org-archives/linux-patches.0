Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625604;
	b=bQ8n257X+kR4b57EBKlXFFcLD563zTdAzj09uer8BnCeHVpw08DbD/O8Xj8N6eH1j0Rw
	 OQQBxQyP3H0Atq9ct9YyF3drOBNLwhwDHYUCtbkdle2nQbNuPnXMQsYXkeuuomKv7aW7X
	 egElvE/qNMY72tlbnUshpy/woG6V59ddT5Z78HLaTnUZ6tlYdU7zLfawM8pe9KxBfLxgZ
	 YCR2aBn4Hw9jR/VPPqB9ftEBBkHtx7MW4n8uUDOE9uMDzv24sk2nxnsQ0+ddkJEfboQm9
	 nqn6Fm41wtv2ko9CaQVtTl1XarVEp/jXw8SkrA8kkTsSWHyU1ePb9h7XbBIBfpyLcBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625604;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yQ4CacT1FTjG1vadrJPextBS+QAADZjVSLeziYvGz7E=;
	b=s1YC+AJHmGvgiTxOgmNxfIadE3mEPibZYSgOOVNxzTHIqizhy8IatBYf+OGD5MYJtUSJ
	 QYim1Vh4xYSeqRvWX4tkjzxj4CbNFNh2Uwgu+8lBFe0lzMrUmfwuccHMRfouJOg2aFPHL
	 xwjzwrKwkaJMDynxDn8AB7emHr+H++ZWegOnOEG1BbfZ5ARo/IY/Mus8xFx8amqO2hqaE
	 NMDHlR100uxzcBKYKyzDISPHMH2N0p/0IAnhTH/vzlG6YW2AYyXBoOGXHl5tcZ6fZgiFl
	 GrXCswy2fBsEbqPrnjnU/0l/d4w6C7yRWIrqVjHvcmbyLTYj0wIa/NjF8Tcpep3DfIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AyVxiQHU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2112606A32A;
	Wed, 25 Nov 2026 16:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AyVxiQHU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EE851F000C4;
	Wed, 25 Nov 2026 16:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625603;
	bh=yQ4CacT1FTjG1vadrJPextBS+QAADZjVSLeziYvGz7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AyVxiQHUhHRcwW1AHCQXOY0OHSPVu9g5Tsc2SlsWUzlpjKpf9/oFDQKup/jXxOwVP
	 9YHOhYS/YhLjbapo5DlFnCgMbyj2drmWVei2LEmbQlHTJkSGJ4h7dH0NUNEs5il78C
	 eACAVhDeJ5UBbFgQ5NeDoNGuZFoL8pEjN4Mn/hjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.12 572/816] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 25 Nov 2026 15:35:20 +0100
Message-ID: <20261125143902.421333188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gregory Price (Meta) <gourry@gourry.net>

commit e5db040c3d09c5d85dda70f736d4d1a6714b741e upstream.

The zonelist_update_seq retry was limited to CONFIG_MEMORY_HOTREMOVE,
presumably because only hot-remove takes zones out of a zonelist.

However, build_zonerefs_node() rewrites the zonelists in place, so
onlining the first block of a zone shifts the entries that follow it
in every zonelist containing that zone.  This can cause a spurious
allocation failure for a __GFP_THISNODE caller.

For a node with only ZONE_NORMAL, onlining its first ZONE_MOVABLE block
rewrites the node's ZONELIST_NOFALLBACK list as:

  [NORMAL, NULL] -> [MOVABLE, NULL] -> [MOVABLE, NORMAL, NULL]

A concurrent GFP_KERNEL | __GFP_THISNODE allocation can observe the
intermediate list, skip ZONE_MOVABLE, and find no eligible zone. With
CONFIG_MEMORY_HOTREMOVE=n, check_retry_zonelist() returns 0 and the
allocation fails even though the node has free ZONE_NORMAL memory.

Gate the sequence checks on CONFIG_MEMORY_HOTPLUG, which covers every
configuration that rebuilds zonelists after boot.

Fixes: 3d36424b3b58 ("mm/page_alloc: fix race condition between build_all_zonelists and page allocation")
Cc: stable@vger.kernel.org
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-5-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3982,7 +3982,7 @@ static DEFINE_SEQLOCK(zonelist_update_se
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -3990,7 +3990,7 @@ static unsigned int zonelist_iter_begin(
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;


