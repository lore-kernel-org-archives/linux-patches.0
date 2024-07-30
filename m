Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBAB757FC;
	Tue, 30 Jul 2024 16:44:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357871; cv=none; b=eN4JBwkVe9gYncAGV1FS0ylxzcXhjE0L4pOHoC52PefgI3mK2lPpmv5E4ZCTwfta2NdP4lqbkso4NcJFT3c65YoYGg7SreVLizyhnkh7R1TIaJPisNZcTcJMdyTQqjYg5x7h+fL4OHeNvuFDX4RrsTzVRbUxGnY+dGGZ/mcgJ14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357871; c=relaxed/simple;
	bh=5y9921NxaeHArQoWzELxm7WGiN82f2J/8r2NW7TMwls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EXfh9gGshOOZiUsq/sEpwys81s4TcTsOg2KHc5frcq1kRCCz7Y8RKgohg5PBs+Hb+SSI1f7xQ/pD1B5aVgfPYe7Y7oc4/TcNYwP0UxnBfW9ZawZvCmFAze5er3F/W4V0kW2+qzpK2kF60QrXAVuvQ16RncUE9z+N8T5TE5rCeYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ipAsstwd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ipAsstwd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F068FC4AF0C;
	Tue, 30 Jul 2024 16:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357871;
	bh=5y9921NxaeHArQoWzELxm7WGiN82f2J/8r2NW7TMwls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ipAsstwdY644w845KybLjpeFvV9BvPmd4JYGFCytpcyXXEuTXuRIbZNaQrM6z7vGK
	 kAZY+wXA4sJOJWOqH0wyZ5/pclXULUQQRx0C/8yZgEIE1+ns+5biZN+2PtfOHiqvTr
	 d4ixftqFE8qIGgvrez8+RVbk8b6rqgr7KUYb1jQc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@arm.com>,
	"Steinar H . Gunderson" <sesse@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 300/809] perf maps: Fix use after free in __maps__fixup_overlap_and_insert
Date: Tue, 30 Jul 2024 17:42:56 +0200
Message-ID: <20240730151736.444337179@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 0b90dfda222e38b7ca8dad6e098e36f5186f0b94 ]

In the case 'before' and 'after' are broken out from pos,
maps_by_address may be changed by __maps__insert, as such it needs
re-reading.

Don't ignore the return value from __maps_insert.

Fixes: 659ad3492b91 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Signed-off-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@arm.com>
Cc: Steinar H . Gunderson <sesse@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20240521165109.708593-2-irogers@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index 16b39db594f4c..eaada3e0f5b4e 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -741,7 +741,6 @@ static unsigned int first_ending_after(struct maps *maps, const struct map *map)
  */
 static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 {
-	struct map **maps_by_address;
 	int err = 0;
 	FILE *fp = debug_file();
 
@@ -749,12 +748,12 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 	if (!maps__maps_by_address_sorted(maps))
 		__maps__sort_by_address(maps);
 
-	maps_by_address = maps__maps_by_address(maps);
 	/*
 	 * Iterate through entries where the end of the existing entry is
 	 * greater-than the new map's start.
 	 */
 	for (unsigned int i = first_ending_after(maps, new); i < maps__nr_maps(maps); ) {
+		struct map **maps_by_address = maps__maps_by_address(maps);
 		struct map *pos = maps_by_address[i];
 		struct map *before = NULL, *after = NULL;
 
@@ -821,8 +820,10 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 			/* Maps are still ordered, go to next one. */
 			i++;
 			if (after) {
-				__maps__insert(maps, after);
+				err = __maps__insert(maps, after);
 				map__put(after);
+				if (err)
+					goto out_err;
 				if (!maps__maps_by_address_sorted(maps)) {
 					/*
 					 * Sorting broken so invariants don't
@@ -851,7 +852,7 @@ static int __maps__fixup_overlap_and_insert(struct maps *maps, struct map *new)
 		check_invariants(maps);
 	}
 	/* Add the map. */
-	__maps__insert(maps, new);
+	err = __maps__insert(maps, new);
 out_err:
 	return err;
 }
-- 
2.43.0



