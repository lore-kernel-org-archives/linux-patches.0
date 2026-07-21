Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 161C846D567;
	Tue, 21 Jul 2026 15:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649219; cv=none; b=geiUhZcd/BYp4nd11s+c6vnK2QOqsw29LDl5eAo7AyAmh2iSLPukJB9KgDIMGoQ74cpmTtAaY8APdLQWImBCnZ0XEybWzm9NoxEAvo/l7kzIjFpfNWb30dGRdr0GstRtV/eJdGs0ZmawLWuJ6blzL/gKCMCi5ZMwepU20WBxO2I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649219; c=relaxed/simple;
	bh=vq6TKwezdyh+pQ/sPh4dsEPR/CoO2UnBYCv8pSe4ViI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fKg5Be2FRCxXgVTnopRkKLjJ7f+rxPtuetQUB1n3PqyCVMkR4ZCycsI6AVPEf/2cjPZXyZKyzME4P1OTvOPHBbKk5wY3vJwjcmZNQphUoWc8QS3RDnDjc1siL3rStHlITGC5EtCkPazIwnxDpJtIxShfmktKc5PHhuoc8IzvNes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXGWl31S; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXGWl31S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A9A61F000E9;
	Tue, 21 Jul 2026 15:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649218;
	bh=oSqgfTq0Yf1jYRSHSylbBX+Ze5fX9+pEJAw5Ml0i7IE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXGWl31SOy1hXG/Nm5CcEo3/6mmhUul9PMNInDBqeeFsJEKGqZJkwuqn6I8EnOb9z
	 6YPeohYqvWk/or76NmY+ZP5VpE6ALxDPVxB5/n3LZqtRct+/TFyYBuoVucFe6NLfdC
	 oldNemzzJOfeGKGVNcC13nxeJRPqUXsUdIJJ/oJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0458/2077] mm: preserve PG_dropbehind flag during folio split
Date: Tue, 21 Jul 2026 17:02:11 +0200
Message-ID: <20260721152603.590415119@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 0ad186cf167fdbeb6b29a8005c71973781036bd3 ]

__split_folio_to_order() copies page flags from the original folio to
newly created sub-folios using an explicit allowlist, but PG_dropbehind
is not included. When a large folio with PG_dropbehind set is split,
only the head sub-folio retains the flag; all tail sub-folios silently
lose it and will not be reclaimed eagerly after writeback completes.

Add PG_dropbehind to the flag copy mask so that the drop-behind hint
is preserved across folio splits.

Fixes: a323281cdfec ("mm: add PG_dropbehind folio flag")
Assisted-by: Claude:claude-opus-4-6
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Link: https://patch.msgid.link/20260511-dontcache-v7-1-2848ddce8090@kernel.org
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/huge_memory.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index b118bcd392cb35..d29e85495091d4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3644,6 +3644,7 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
 				 (1L << PG_arch_3) |
 #endif
 				 (1L << PG_dirty) |
+				 (1L << PG_dropbehind) |
 				 LRU_GEN_MASK | LRU_REFS_MASK));
 
 		if (handle_hwpoison &&
-- 
2.53.0



