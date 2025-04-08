Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFA126FD91;
	Tue,  8 Apr 2025 12:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116589; cv=none; b=Cf5BT9b3FnlgvD90lhJox6N1GdlIVH/bX+qdbeUrtqrVCcNBMDWfqh84QKW9ByAK6sIYEEIF7Z9hmUSGDyzlrwWdAzvpUTQVPR3AS3XrTzfBXTskSJhS9V8iojGlk3ggvMwPSJ+b1MIL5U5iB1zMgNRyTPvb6CNnBLFpK9X22Ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116589; c=relaxed/simple;
	bh=57gNqUjrx1dnWxUAVGCteVVu23NnVUGiJGYCHXTCGvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jOeOcLzSG1dDGHVLuJxQjZE1zO6dwoQwNy7bI7FOCqWNevA5pwizsCtxZS6QaUXWr1S1/8xEsvNXLIox3tTbYxcyZ7ZF9kLNB9F7fdR7ZmWkthztyJ1WL/cJXOyFRxdzjHydafMEdFPqPn5Wjcy1L6/BdxZ13Jvzrpf1BzEgilQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NJFvcjyp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NJFvcjyp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 738F2C4CEE5;
	Tue,  8 Apr 2025 12:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116588;
	bh=57gNqUjrx1dnWxUAVGCteVVu23NnVUGiJGYCHXTCGvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NJFvcjypjRzjyyXKDpVeyvis+iVxgnPdb/7gz1OAAHrLxMzv3UwHVEyai6Usxf0Nk
	 lUUqwOfmHiEFAlvHxTOUdJIPVxb7kHsH1jAGbc7I2cp/jAm7VIY+vLy/3Md9r4HZcf
	 xf38as1WqFGiyFqYCuNVywgRsCnMTFDwAI3drnk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 195/423] perf units: Fix insufficient array space
Date: Tue,  8 Apr 2025 12:48:41 +0200
Message-ID: <20250408104850.277805951@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit cf67629f7f637fb988228abdb3aae46d0c1748fe ]

No need to specify the array size, let the compiler figure that out.

This addresses this compiler warning that was noticed while build
testing on fedora rawhide:

  31    15.81 fedora:rawhide                : FAIL gcc version 15.0.1 20250225 (Red Hat 15.0.1-0) (GCC)
    util/units.c: In function 'unit_number__scnprintf':
    util/units.c:67:24: error: initializer-string for array of 'char' is too long [-Werror=unterminated-string-initialization]
       67 |         char unit[4] = "BKMG";
          |                        ^~~~~~
    cc1: all warnings being treated as errors

Fixes: 9808143ba2e54818 ("perf tools: Add unit_number__scnprintf function")
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Link: https://lore.kernel.org/r/20250310194534.265487-3-acme@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/units.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/util/units.c b/tools/perf/util/units.c
index 32c39cfe209b3..4c6a86e1cb54b 100644
--- a/tools/perf/util/units.c
+++ b/tools/perf/util/units.c
@@ -64,7 +64,7 @@ unsigned long convert_unit(unsigned long value, char *unit)
 
 int unit_number__scnprintf(char *buf, size_t size, u64 n)
 {
-	char unit[4] = "BKMG";
+	char unit[] = "BKMG";
 	int i = 0;
 
 	while (((n / 1024) > 1) && (i < 3)) {
-- 
2.39.5



