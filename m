Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622877;
	b=ttaTDpg9qQc12PNW99a9E5Cs+yahzcYarGytGEJc8a+OX/lltV/wxeOOr53ISHcPB4QJ
	 04eqOdYzcmGOBgdITv1VyR3syKVBVNeAo6kGx/VXd9fZQNMJo8hrB61nnL9nHlYzm3zro
	 b2pXhq11X75wCxR+Ktw6y/u4ilZfBRqUljornDqkpao+MkynFba2CTpZrLLIvghN2HbUz
	 oupyJ5WMrgvJXlRW5jXprbWOCbvscTMmTaMEMXtNrwNb+uZ2JSdZ9plOdBVYkk8CZGMxx
	 Ax5qpaQDONrFGwBNsT92ZLjG5gHSThTCPPVsIK5F39xQrMMiGIe8Q1wB1R0xs8T31dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7B4BFVmhxBJKWaTLpjvocotuEezDYJzNSi6pjP8ZWr4=;
	b=LixjW7cDODv3Lk2xL1HKRe9nbiOWOpxYCIyvV2RNFAjDUhLK927ZbylJujFrfeX7nIri
	 Ccw+2tPcaJzwtAlX67y8fZwMoICsfmts5w9i3xeSz0osN1iGAyN33gb0mkRPzaVfU0g1M
	 pIXefpW1OsjPCPsRbEzz7H3q+7A7lSXTjHttMnGhoMj7X1dd4qB88fxlLxofv8ebJA7X2
	 3LrO8LwegPQEl7ZOfxPI7KFhRlxWwer8tplFXKaJlBME2DU/KjGsEhvDzffz1ZvkA7RBP
	 a7JjOIiwYgAAZZC6383vD/g/Z/PVphOOVZOUwGeV1QlstK2UXQyM8SiTo5eMsOSp+yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziD8qilw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBD5606A323;
	Wed, 25 Nov 2026 16:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziD8qilw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C66BC1F000CF;
	Wed, 25 Nov 2026 16:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622877;
	bh=7B4BFVmhxBJKWaTLpjvocotuEezDYJzNSi6pjP8ZWr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziD8qilwCznQJcHD4bcvMRajz7sreLxAHSJl9TREZLxbjxXpKUMkN69SS4gLWpRz7
	 K1Caz/qvhmYtsjHb9rP4WJNia6HnAFgBI8qXy4G3TCjaFpR5TcZ9wZPUNQI8Y3XlSa
	 Sta57rpA7HXEcav9utIpL0kgF8sVKoDTQslbs30w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.18 677/990] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Wed, 25 Nov 2026 15:34:04 +0100
Message-ID: <20261125143837.944757880@linuxfoundation.org>
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

commit 9c52ebe9c89d41c56fcb5d94efe9e539414175a9 upstream.

Memory hotplug rebuilds zonelists in place while allocations walk them,
so a zoneref slot can change between two loads of it.

zonelist_zone() loads the slot with a plain access.  The compiler may
load it again later instead of keeping the zone it already read, so a
caller can check one zone and then use another, or the NULL terminator.

Use READ_ONCE().  Callers that take a zone from a slot and keep using
it, such as get_page_from_freelist() with ac->preferred_zoneref, need
that single load.

Fixes: 11cd8638c37f ("mm, page_alloc: remove stop_machine from build_all_zonelists")
Cc: stable@vger.kernel.org
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Link: https://patch.msgid.link/20261101021340.2251928-6-gourry@gourry.net
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mmzone.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1710,7 +1710,8 @@ extern struct zone *next_zone(struct zon
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(const struct zoneref *zoneref)


