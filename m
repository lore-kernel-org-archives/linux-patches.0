Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A1C19D8BC;
	Sat, 12 Sep 2026 09:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206926; cv=none; b=nRbDMiFbEsurgoNq8LFSZqxeZF4yvreBVUeFWIAg8Q5SS1nJLQkW5qq5prhz7NVNywaKsnNsNKN8jIqo5Sfk4zQ4wV7IzB4+TETn/50V28gd3vpEndSaJgNU2QZgb0q8ML688zXy7nePltFINmMirEBKob1Zry8gO473sOZZ78I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206926; c=relaxed/simple;
	bh=RcvSJVBbfBcnSiX3AAQJpIZMz9i+9K/IPsrImFkuhF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TfqCKm56LwEViJMqhyrExuzQfmMqRuxkC57UvdRrqwI+ZpIvk34LcjPFin4xUYJDdPqpPRaZcwzVS5uk1Zdgxk/e/H9bttjYmUniYfbeEd5QwYvppovQSMWjjba8pHsWyUrF1msZ30jXZmQ6g2vG+hcRKfkKi2GjfY6LumjofF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxxwoLaK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxxwoLaK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91ACE1F000FF;
	Sat, 12 Sep 2026 09:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206924;
	bh=TUHZ0jL7OxFxlLEVj4B+wyvifDc7Y2cOZQBfTcUr5TE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AxxwoLaK5qtVzsGPeZAJ+EGAt3A43GJqzSXwHmdxzOPy4MUZfYb9gn66HsyOwZb62
	 gUMPVWdEtWi6UoLz+ANmdWO0rn7hJGqPwwW3H8k9FrOFkT9EPCMUgqXIpD0CWNftIo
	 W1TdXrtq13wUHjSL+btlvkoQOz/BMtT2RWklHG6s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tengda Wu <wutengda@huaweicloud.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0306/1518] perf capstone: Fix kernel map reference count leak
Date: Sat, 12 Sep 2026 08:41:15 +0200
Message-ID: <20260912065630.402796401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 2c7feab61b7bf..1e2b697c86fc5 100644
--- a/tools/perf/util/capstone.c
+++ b/tools/perf/util/capstone.c
@@ -156,6 +156,7 @@ static void print_capstone_detail(cs_insn *insn, char *buf, size_t len,
 	for (i = 0; i < insn->detail->x86.op_count; i++) {
 		cs_x86_op *op = &insn->detail->x86.operands[i];
 		u64 orig_addr;
+		struct map *found_map = NULL;
 
 		if (op->type != X86_OP_MEM)
 			continue;
@@ -171,19 +172,22 @@ static void print_capstone_detail(cs_insn *insn, char *buf, size_t len,
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
@@ -192,6 +196,7 @@ static void print_capstone_detail(cs_insn *insn, char *buf, size_t len,
 			scnprintf(buf, len, "\t# %"PRIx64" <%s+%#"PRIx64">",
 				  orig_addr, sym->name, addr - sym->start);
 		}
+		map__put(found_map);
 		break;
 	}
 }
-- 
2.53.0



