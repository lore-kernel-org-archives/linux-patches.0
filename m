Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8683833B969;
	Wed, 20 May 2026 16:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296161; cv=none; b=lsupSAWo5oR4O6tkAdi/Ti+87ysryf61EN8l1BRuQkBCXCAsutX8NZ/iYvRXVg3duUjRmS5YRNcx+PpyySpp/9ZF4laLfJMtyCVxisNSN3mUTHGqLjTdkm61V+szcazy4X+MTu2TSJKydxK/2OOKEgIq+dkkzy5Gvhprpb/d4AA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296161; c=relaxed/simple;
	bh=/u36lOQYKw+p7nClOQZEteQSAsVCbJPG8NMiFtJ7Q4g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CIjJogsJD5qwKRrbO6fserMm2VcV7kv10wmMwNEe1M/NDjIlENF2UdL+BV1EMeaVwRMIodE0s7KxOVoznuIAOj8Xw52AVcw0hRPOGyp8TDK3CwTCie1d6qUX6q5oTTHGwgKQtBT4j6MUfEs5IKih+QOpT8fVbkB/B08ZLgTEYYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xi5tyYXq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xi5tyYXq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB46B1F000E9;
	Wed, 20 May 2026 16:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296160;
	bh=o1fNIiUzpMLkiZrqIgmxUi/GOEb/0g3nL9mPHdDpQZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xi5tyYXqLhoIxGMoSAIMyd5Zp6HHIW1DCPzUbe0LyZCdPaSqKzntxkRWdbjA/X19A
	 TYtCmG6PlVwNpwN2yoW+ILvttUL+gQxsbSddhjDWXLKEAk6zpF9qJqN7pUmg81j7tn
	 lJZfZbSSXxP+VAha2aqq/Yo98aoJC/6z1t/zI22Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0654/1146] perf maps: Fix copy_from that can break sorted by name order
Date: Wed, 20 May 2026 18:15:04 +0200
Message-ID: <20260520162202.984727619@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit f552b132e4d5248715828e7e5c2bf7889bf05b2e ]

When an parent is copied into a child the name array is populated in
address not name order. Make sure the name array isn't flagged as sorted.

Fixes: 659ad3492b91 ("perf maps: Switch from rbtree to lazily sorted array for addresses")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/maps.c | 13 +++----------
 1 file changed, 3 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/maps.c b/tools/perf/util/maps.c
index c8b8081b7b31a..75b399a20b262 100644
--- a/tools/perf/util/maps.c
+++ b/tools/perf/util/maps.c
@@ -1082,16 +1082,9 @@ int maps__copy_from(struct maps *dest, struct maps *parent)
 				map__put(new);
 		}
 		maps__set_maps_by_address_sorted(dest, maps__maps_by_address_sorted(parent));
-		if (!err) {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx =
-				RC_CHK_ACCESS(parent)->last_search_by_name_idx;
-			maps__set_maps_by_name_sorted(dest,
-						dest_maps_by_name &&
-						maps__maps_by_name_sorted(parent));
-		} else {
-			RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
-			maps__set_maps_by_name_sorted(dest, false);
-		}
+		RC_CHK_ACCESS(dest)->last_search_by_name_idx = 0;
+		/* Values were copied into the name array in address order. */
+		maps__set_maps_by_name_sorted(dest, false);
 	} else {
 		/* Unexpected copying to a maps containing entries. */
 		for (unsigned int i = 0; !err && i < n; i++) {
-- 
2.53.0



