Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625725;
	b=CEt0Mt0RNw3bqjbxcgjYvR4R8RiIVQYsnB6xA7dbnzEhTY3gBLYAbqt9+ghSpLQxrpdW
	 7AnwSZyNqcCYdEcNFGFiNp8b+Nyt9ykUotVnEVtypNpalehSa5rD3ATl+XOZJEHvg8/tp
	 R3Gf2AtuT7JRRsH8hy3GxRUqreVQYU5TK+90dtP3QL/hh4KtUlE/7amqRD2e7sRUuw+sJ
	 +xhHy/mE1w0U8sB6oyg6enu7Uv/vDsP5pa4Gy9yHvTRiYXRh0ffo0MMrSWvQu7jP/rp7R
	 Pi/SDIX0FAYdfk/n/BQthGAod1EvchpeUT3LljPHX7g9g10+Hu6+7DsTRIYo3goXp7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7ajzHdfgt42q9vVHqLwCjlpj4/xQMP9kGuUZboCQweU=;
	b=v/QSM7gQb98nRQwxfN84jEijNo8eW2Iez1uNjorinlpAALwuzLE8CAxswuUyTQ3Oc+l6
	 8Vs836C4XkXiW4V6WODfdvgnrh9RYcek1jvp90yd5BJ0JN2ga5dDTSuwBH2KWzmutBiTj
	 DaLpkIbSilCQ3ITEU3o/xJeDwupLUbjHD+7934EisPcetWwI+BdWRuSEgnTSg9fEJoslZ
	 M7o+OOPvyZLOsD1/if8niwjbfBXHeN4cgakOXFiXkpV2q5/9afJN8jV+Oi+QNvfty1EJN
	 /6zzt1+BPztIT2ahi8xyMw4LBxmwDgVUGshY5/1CL1JLTQXgj8Y5/0DsqcDdgFoseXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0oiA9vm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639A4606A31E;
	Wed, 25 Nov 2026 16:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Q0oiA9vm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731B91F000C0;
	Wed, 25 Nov 2026 16:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625725;
	bh=7ajzHdfgt42q9vVHqLwCjlpj4/xQMP9kGuUZboCQweU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q0oiA9vm12KgbP7LKUf2GQQziWk/KTANKEivL2LejSc4g4dVLdhHY0+pfZPVhikLF
	 rnEBj3z65y8Qrt27oSn88N/t5c9d39B/tWyzxZmFYjA67I0bGOJPWkFyWCf/JNzOZM
	 Nfsq+ERBXClF2s9Xp3Q9GE+TtH+gTD2r6vqakj7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 6.12 567/816] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Wed, 25 Nov 2026 15:35:15 +0100
Message-ID: <20261125143902.305414553@linuxfoundation.org>
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
@@ -1627,7 +1627,8 @@ extern struct zone *next_zone(struct zon
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(struct zoneref *zoneref)


