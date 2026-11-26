Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705385;
	b=mx5kXTSszvWUw5new2YjQI7X6HrlwX4t5ppfcWY0AHsBLKwAwAyQgqqDpju3SFVB42dF
	 L8UFtyt0gQu73lZ1iiqLescAX39EBvO6uZragLM3+RkVILxfA8HxLVe60MiUVvcVIrmng
	 VZnQbcjw7I0Z+vM5HYi+Klctqh1B8R/p8DsI9H1TdUyIXDnSznk2XQvoESg8hrsnfzJ5z
	 vu54zFla/IoHgV3tRZ4uPOPun9aXi3copArRHop9BLyh0zTJg8LZAZtdZIDskrS981yee
	 68HM0we4G2wNoCl3wnr4C1zpt3mhS/OMPxMgFxpaOJszeG0LH3MjveQYb1rAxmeLNsA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705385;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2CgGaDIpSevoZBfakN8fWqRASKsAOiEDHPHsr2/VIec=;
	b=3wGlOoyivU3TrbTs8t5KkpWNSSwXSAKfCWLFC0DdUaJZJEfGv6x1QdTLiYFDnKB62nxm
	 oDi66iZ/iM8PpHR0LcWdLo9LIKzqof6EmgV2+KyALPBWWKOGPpOmBiXNFbrax+5rwzifi
	 lXeijHhml00GSHQN+PrBHXyqGXCcVFYJfsAk5QL05YvsttV6J1htdY4772rGZD9pZE9ph
	 WPIgvgyuWEBiuXdTF5e3McKtDFXRAFqM4/hM3BBFBu2R+z6kAHv+HsNuKgNNeD1eXENii
	 Qac7fpte+aW+cy7NM374eZysnw8C846MYFFcnpziFM52f4hV78nK8iSz1l2HFzH/v/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luFZDHFl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90462606A31C;
	Thu, 26 Nov 2026 15:03:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=luFZDHFl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC50A1F000C0;
	Thu, 26 Nov 2026 15:03:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705385;
	bh=2CgGaDIpSevoZBfakN8fWqRASKsAOiEDHPHsr2/VIec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=luFZDHFlT2wAZ6hHRGE0YRHvVCr7qg2u1zq3EIwrhfttec0Q/ykYtp3T8wV6RBBk8
	 4NYEqwkdkHmnkykYxCycs4Uc1sM1OfAsN8TcJkNJqrnPsWowPz+90VL+9hZxDB0Gs7
	 aC9pWDo1oqtnmL+fl/hwssIDLQWwsT0BIYNe3brY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 5.15 181/319] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Thu, 26 Nov 2026 15:39:09 +0100
Message-ID: <20261126144010.831808706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4634,7 +4634,7 @@ static DEFINE_SEQLOCK(zonelist_update_se
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4642,7 +4642,7 @@ static unsigned int zonelist_iter_begin(
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;


