Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622900;
	b=J1NDxa+CXjin3GqXh+ZEPoE8eIKDsYh0O4HfwPmExRIA5bInt0GnPP9itmV45PX94BxN
	 JBzNIggbFiIpMc+Loya6MUv64wsCxisFkIb+FYAZa0IEeEL5m3jTCXl7iJTicjQ/7/kuK
	 snIzHK/UUK8pznGSCbp5cdqVF5zufiPvB5muFqiaqqjHs20DiGhk9OUTb5nwa6CDCZRlP
	 9V0iuzJ3WI/C15qkMbTsUGnbEawhnspNIBTSmJnRo/2NM+EVSjSink7VSgiHfEFFQbEt4
	 5yFiLyuaTg/ziQvf2xJGlE3F4JP0vOQvnXggySmTauPVNefZjr7URcrxmyJCGREkHJQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622900;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sxercxBgKWeom17sOzY3QBvteISEh86golG7mnqSaFk=;
	b=3Sda/bkvv00b0ukOjMUwt0+8p8sPS9us257rD+7SjdBAaY3TMsww3FgjZ8qb0UaTxGJx
	 NsTLpqBQkbkeGo7PVKbFwQGFy/gGGZ1xFKp73EoCWvLKiZ7ZDkqVy2t9elvi50sx+t4cU
	 pEeG0WGbcjg62bI9wxCUZKO84olRd2PRP3fbnQMcWuL5t1kGE9Y201FRGqbpiJWbK4NZw
	 MGCM9ctPQaRGP7jUaDoMUqPYijwqsn6BuL+qI/fyEYqeWfSu+yIfimjIvwmFSmXbIWjI4
	 VdPzOsVzZPD8JlWJxvWH/uSdmwkbjZtNYyIuLiqpcYHw2kmrQNFTFOL6N2YeOBE2CBA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1yhCCTQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D2DB606A326;
	Wed, 25 Nov 2026 16:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f1yhCCTQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A2B1F000C4;
	Wed, 25 Nov 2026 16:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622900;
	bh=sxercxBgKWeom17sOzY3QBvteISEh86golG7mnqSaFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f1yhCCTQYaC3dcSTUJ1fxzBI2hv/0VhcOn5pwhl4ZM5bSfa+JdmygNeM+ktNr61LX
	 xUOhQa34bOrxePUA6T/XPqLTIOjek9G0pLAVmW3GAuSvqfuzLnfORHrinQTV9PY6vP
	 OwbOOTDgiKvCvRNVmA/FESXUF6JToTCGnArQNDiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>
Subject: [PATCH 6.18 684/990] mm/page_alloc: detect zonelist rebuilds from memory hot-add
Date: Wed, 25 Nov 2026 15:34:11 +0100
Message-ID: <20261125143838.107597896@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4416,7 +4416,7 @@ static DEFINE_SEQLOCK(zonelist_update_se
 
 static unsigned int zonelist_iter_begin(void)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqbegin(&zonelist_update_seq);
 
 	return 0;
@@ -4424,7 +4424,7 @@ static unsigned int zonelist_iter_begin(
 
 static unsigned int check_retry_zonelist(unsigned int seq)
 {
-	if (IS_ENABLED(CONFIG_MEMORY_HOTREMOVE))
+	if (IS_ENABLED(CONFIG_MEMORY_HOTPLUG))
 		return read_seqretry(&zonelist_update_seq, seq);
 
 	return seq;


