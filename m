Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90B9346A0C;
	Tue, 21 Jul 2026 20:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666560; cv=none; b=OxU2w8wSi4Admy0K8uz0HiYGVFGxxlniEr9KbudndpraF9tRqYMfAXX6F7LMItfdiL7e33l31FR/2AXzPBxKMPP4pwlNoFmGrPHhU2LEX86vvlpZc2VZ0ggFXVo9p6yD7QxjIvn1XlF1nxEC+ZoZ3PXRkOiD89KTABM5brTj+RQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666560; c=relaxed/simple;
	bh=ZZPeboUotlQjIUGb3VUz3DcFomzQKmbw9ZcmYdcZRkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ohDwH7B/qK3+XvHFaCBSP7x8vl8oqa4jXnC8JmG322GmjMbO5AZ7bhO6YYm/k+JqPYPy3GolJzfHe92DQMd66tFwTZajDH+3+a0cEm4ZlC2b1844+iHx7f8NjtuWFxVFmqOmY61/P0bHeLi4MddQGZWnv2C2hDe+HbHH5qeHP0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N9YaJGIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N9YaJGIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21AD61F000E9;
	Tue, 21 Jul 2026 20:42:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666559;
	bh=ltOp7heawy/fDHM5mEEtm3HBNzMGhnQhcsGSjtE+WTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N9YaJGIiAFg0t2GsxPKFQtv9Z+lUpOUw/9cwNUC07LBJvk0BfiSpzYCoPhd3D4YnF
	 zPWQenc0VpmqzAwMZRA4gQk1L4TGVcbJa/eFmeiSPaLJZhQ8H2BuxzIUgmaXryRtSJ
	 XAsvRDg91Y/Pc26NMMj5mTvUIJOJyI2W+hiEQPhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0692/1266] perf symbols: Add bounds checks to read_build_id() note iteration in minimal build
Date: Tue, 21 Jul 2026 17:18:49 +0200
Message-ID: <20260721152457.340415481@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 52e582e316c48c53bb3082c29f7862ebc554087e ]

symbol-minimal.c's read_build_id() iterates ELF notes with the same
pattern as symbol-elf.c's elf_read_build_id(): pointer arithmetic
driven by n_namesz and n_descsz from 32-bit note header fields,
without validating that the name and desc fit within the note section
data.  A malformed ELF file with oversized note sizes causes
out-of-bounds reads past the section data buffer.

Add the same bounds check as the libelf path: validate namesz and
descsz individually against remaining data before advancing the
pointer, avoiding size_t overflow on 32-bit.

Fixes: b691f64360ecec49 ("perf symbols: Implement poor man's ELF parser")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index a81a14769bd101..b95dd77239e835 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -1,3 +1,4 @@
+#include "debug.h"
 #include "dso.h"
 #include "symbol.h"
 #include "symsrc.h"
@@ -45,7 +46,7 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
 	ptr = note_data;
 	while (ptr < (note_data + note_len)) {
 		const char *name;
-		size_t namesz, descsz;
+		size_t namesz, descsz, remaining;
 
 		nhdr = ptr;
 		if (need_swap) {
@@ -57,6 +58,14 @@ static int read_build_id(void *note_data, size_t note_len, struct build_id *bid,
 		namesz = NOTE_ALIGN(nhdr->n_namesz);
 		descsz = NOTE_ALIGN(nhdr->n_descsz);
 
+		/* validate individually to avoid size_t overflow on 32-bit */
+		remaining = note_data + note_len - ptr - sizeof(*nhdr);
+		if (namesz > remaining || descsz > remaining - namesz) {
+			pr_warning("%s: oversized note: n_namesz=%u, n_descsz=%u\n",
+				   __func__, nhdr->n_namesz, nhdr->n_descsz);
+			break;
+		}
+
 		ptr += sizeof(*nhdr);
 		name = ptr;
 		ptr += namesz;
-- 
2.53.0



