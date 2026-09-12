Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F300634252D;
	Sat, 12 Sep 2026 07:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198122; cv=none; b=W3k2w6cu89sjxWdsZ25vhT0Rq9xT7gSItbX70wFdqB8GXfQud24PoAZo+JxQTGnpaFx7Cxyf6FLuSlLneWHmkDSvbDDB3Csum7q5zdbL3k5Iqt002bly36qy8Eb5/jZKf+HMC3wTYM1AL08hUKwG7F01bwCA2U8c1k/QPy0w3JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198122; c=relaxed/simple;
	bh=eJJj008jcGa6vZr3VkM1YZijed0pqUuQ2lYjq7lzH88=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+hEWnxWZx/gIXsINjQ8rbJGs4Jf5/yyKFm+Ei3jlSlgltYIcZy/7K2yHvxvGzZpP9HZPfFBrHyWrBOOjNyCuFzbVHy3riRJoYr5gDmr8sSOS1ebhvjRkEidG5TQf00zbM9tUQV3m/qKZbrwhRNvNVE9lDBRX95Y+YAmJG53RI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8JdUR9L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8JdUR9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C45961F000FF;
	Sat, 12 Sep 2026 07:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198120;
	bh=Agh3VAM6T9TKFpUwZ6p4zhP964bkFDAzyNmoxT4a80E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8JdUR9LP9rvlfO4gjQkBh9UJEuoCX2XqgQpTFOeyT/PQ0IFf2y8O7ydWaqO4x5wG
	 HWw4IuBqgbTGdWZxRIx7Gg/nlvB6WPblyIjEyBsJ1oTpbObJIEAO/iblb1+w4AlpAd
	 Kqu3pnJyYmvtlxfc60SFCRbgggqCRTu00gEg+bXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0313/1815] perf capstone: Fix kernel map reference count leak
Date: Sat, 12 Sep 2026 08:34:23 +0200
Message-ID: <20260912065656.290309268@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tengda Wu <wutengda@huaweicloud.com>

[ Upstream commit d3c9fca531e2465f3a8f585965f3d10e1a6595ff ]

In print_capstone_detail(), maps__find() is used to locate the kernel
map. This function increments the reference count of the found map
object. However, the current implementation fails to call map__put()
after the map is no longer needed, leading to a reference count leak.

Fix this by adding a map__put(map) call to properly release the
reference after use.

Fixes: 92dfc59463d5 ("perf annotate: Add symbol name when using capstone")
Signed-off-by: Tengda Wu <wutengda@huaweicloud.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/capstone.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/capstone.c b/tools/perf/util/capstone.c
index 5ad537fea4360..9bba78ee0c5a2 100644
--- a/tools/perf/util/capstone.c
+++ b/tools/perf/util/capstone.c
@@ -302,6 +302,7 @@ static void print_capstone_detail(struct cs_insn *insn, char *buf, size_t len,
 	for (i = 0; i < insn->detail->x86.op_count; i++) {
 		struct cs_x86_op *op = &insn->detail->x86.operands[i];
 		u64 orig_addr;
+		struct map *found_map = NULL;
 
 		if (op->type != X86_OP_MEM)
 			continue;
@@ -317,19 +318,22 @@ static void print_capstone_detail(struct cs_insn *insn, char *buf, size_t len,
 		if (dso__kernel(map__dso(map))) {
 			/*
 			 * The kernel maps can be split into sections, let's
-			 * find the map first and the search the symbol.
+			 * find the map first and then search the symbol.
 			 */
-			map = maps__find(map__kmaps(map), addr);
-			if (map == NULL)
+			found_map = maps__find(map__kmaps(map), addr);
+			if (found_map == NULL)
 				continue;
+			map = found_map;
 		}
 
 		/* convert it to map-relative address for search */
 		addr = map__map_ip(map, addr);
 
 		sym = map__find_symbol(map, addr);
-		if (sym == NULL)
+		if (sym == NULL) {
+			map__put(found_map);
 			continue;
+		}
 
 		if (addr == sym->start) {
 			scnprintf(buf, len, "\t# %"PRIx64" <%s>",
@@ -338,6 +342,7 @@ static void print_capstone_detail(struct cs_insn *insn, char *buf, size_t len,
 			scnprintf(buf, len, "\t# %"PRIx64" <%s+%#"PRIx64">",
 				  orig_addr, sym->name, addr - sym->start);
 		}
+		map__put(found_map);
 		break;
 	}
 }
-- 
2.53.0



