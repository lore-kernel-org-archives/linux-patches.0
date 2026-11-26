Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705515;
	b=OuPhAlq3x0Qfw7Th8clHIcSgesktJVbTQjQy8SbjHmiCO7gqG9ws75DKKdSUa6nNo/Gc
	 0NUjEJG5bvj7SibgCn4lk2W++amPK4S7UGFGX8QDs/CgIsmwnUTfiyzygARdUoAAmaSon
	 +fSCB7g3WQHrgGPMT6XyLHVAXwmEzTeuNvWcN4UcnTVq90dKdAZ0vV2nsT8Iv5iRGte1L
	 fyxAW/aG+jVouweQW90DDP5/uYQWx8u7fLGtMkGY4RlmnpjzylCRUOau5jHt97TYefwUG
	 yNFlrbap2sE6chaXRxYrqtKQ9PG9zsiWdG/0tSMHeJ/tHY6ejHdrJRkHaEBqkEdHvKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DTSuniK8UTMdInItQ90+eQPX9cJwCqDwyacHYAoandY=;
	b=ALyvIqzRC+eO1Oddfec1VK+2aTKZk/whr4lAoKH2DAvh9H4W4+R+pv0dm8SSsFI9AgQp
	 980F8D3ggpLSYSKv6XhxWOnXX8Unb4bMdNrMbzAKHvDANNk+Cz3RD5Y8dFAVXiDaEgudS
	 ZEQHHiXmrCtnFTlxfkRSPRmPf0xNYHwQbPcZ4tfVG6Ej17u337obM9KKUnI7/MpX6B+kg
	 SYN6V8lTfRgccSnvj1afJM/C5pl0VBfuX7N8zZjyUZmFZO7FLgumXfl5L/0MBqNLXGk8W
	 DPhx6LazXsC6MGNRoqLZUACx2OjDZ4xsliWDEpiPSp15Pn360fi1Ssww/NsFX/sVpvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJQLPsgk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01389606A33E;
	Thu, 26 Nov 2026 15:05:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JJQLPsgk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 619161F0180E;
	Thu, 26 Nov 2026 15:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705514;
	bh=DTSuniK8UTMdInItQ90+eQPX9cJwCqDwyacHYAoandY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JJQLPsgkZ5kEHCsEr86NdgSfZItrtEsamEp866wgPY9bWSt8skqSOKeSn5TAd5q4X
	 0e/aw7P8SeP7XhMtNlf9RSdSvAa+MxUKZEQktnSg0jCK7qFLd0AL2LjyVRS+8GMjvS
	 UU52UgZBA2pkP9Czu14ig/D55Ypuc9834tyQywJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gregory Price (Meta)" <gourry@gourry.net>,
	Zi Yan <ziy@nvidia.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Subject: [PATCH 5.15 179/319] mm/mmzone: read the zoneref slot once in zonelist_zone()
Date: Thu, 26 Nov 2026 15:39:07 +0100
Message-ID: <20261126144010.787250560@linuxfoundation.org>
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
@@ -1127,7 +1127,8 @@ extern struct zone *next_zone(struct zon
 
 static inline struct zone *zonelist_zone(struct zoneref *zoneref)
 {
-	return zoneref->zone;
+	/* Memory hotplug rewrites zonelists in place. */
+	return READ_ONCE(zoneref->zone);
 }
 
 static inline int zonelist_zone_idx(struct zoneref *zoneref)


