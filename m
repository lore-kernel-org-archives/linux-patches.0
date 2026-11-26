Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704515;
	b=c+tMIwF2YTRi9NFZvEW7zewlLveys3b4ecbhJw0lsVauXKdixPuSvXdtjZmIqjZ41Dme
	 rs5WeK/NAkn/ClpJKglQUjgEOnM0YdSZhamB6c63z7jpwFvsRqFBikDih+4YUhqf9J7+8
	 MRNMnbNN+X+fe82t3vpXF/Rr6Ok23l54DWwdBjfZ3BuQ/QCtjFe7mojRoTzsj7tvk2/bV
	 xcHBQ9w7EdhGXMq7AToO/moEplz86IKkxU5oy5VkXKFf1pVPY0uPvICVSr4wZ/o7yEZ9T
	 o6YGooD20EmrT7Kpz/OW+KcTZu+0s+KbmTBQJXbJUEJO+uiYBqUbZw5ui9NXi4obMrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hCso3BdacZsqcp5NgKB11Q1+P7RZ9a3gdRcBylwdr+8=;
	b=r7uVyZ58D1SdoOzi02CQWlF/1Np007UmiT0SzaDQXRwN+74MXlxPGpV66LW3qB1qK6oN
	 5tIqw3Q/nkBqAFb8/hRad9FrcAWUvtIGs3KYKmOvnu2w6viCzdl/AaGujljc+9t3aAdlC
	 B37FUT51kXVUbxahFYsnuvbaSKFDRujMjsq79SPSuzhfrY4ks6rK73uyUYl+MH28nO7E3
	 rmXKW4sHp/Ep67Efq6iA8pEJKMDN/Rvp97cpl4dYaGXMeIeFsiwoS+EmGpCxxf8OMt6Bc
	 zSECDB4cfVjLqpJqeV4rSMxQgmtN8034AcwJaozxji5NQFR1vcsu7asErjQnSM5cnFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9RW1VS9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4BC4606A684;
	Thu, 26 Nov 2026 14:48:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s9RW1VS9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2855B1F000CA;
	Thu, 26 Nov 2026 14:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704514;
	bh=hCso3BdacZsqcp5NgKB11Q1+P7RZ9a3gdRcBylwdr+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s9RW1VS9D4c2td76McjzsnVz8tV8W/N/BlzwWMnT6/MVnAOeDhyyWFTt/Q6H0E9Qs
	 cT0HbgZJIRLxdCsRzHiBUbEyeDcLjJwWgBR63yz4VOUeVhPZU1TFwlYibqiT8GFJ9n
	 1ppi6LoFPjiNCZDTl+AScgntwgd6GtqoSytxwMzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 5.10 152/265] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Thu, 26 Nov 2026 15:38:02 +0100
Message-ID: <20261126143615.700321436@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4340,7 +4340,7 @@ static DEFINE_SEQLOCK(zonelist_update_se
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4348,7 +4348,7 @@ static unsigned int zonelist_iter_begin(
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;


