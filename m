Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16376471268;
	Tue, 21 Jul 2026 18:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657464; cv=none; b=nkjKehCbM8bbQh89nPSoIrRi9c7boILVj7EUccdyFdpOpJ0K3QPoaXV0aITWfTncZ9nfsjteIbzW1ROiziSGxGAiShClJoabjpGCN7t0iipgD/3Pb7o6Vpj9QcQSPXf/ki5zHLx//AK6bwXPDHlYlmbAIoz0VkuNZC/n7iurH/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657464; c=relaxed/simple;
	bh=9YX8cjqmNX2kMbtOuSLBQmiwuoNM0QkoJsl7t+TrH20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wv737O6zPSvnkzx2aluWuqx6ciLWVIC2gtiuFlxIz6b8FzmUphGeFGaFRBTHUlFNXMa908IWM7hV3jVh+svK4GwVX+SlIq3pOr///EwW7GlyNvun6VEi5cJDPqTGwZtRsvPBEWylt9F2JG/QpF5X+4sbbauC6dkSqMuT/v4l9Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W2KLN6Ao; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W2KLN6Ao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DB871F000E9;
	Tue, 21 Jul 2026 18:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657463;
	bh=qnSnEYfNzcrkDS9JQGnHloa3hQI5KlWjB9gOGdOZhXg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W2KLN6AoXJA2LEltZ/ldUOhgMtvQb7p5gs5HzN2EOypFJumdS+z9Z//rNoSvgTHJK
	 Mx3eNC4jamSUzR7nxb5rpO6c7A4Oy42wieuiyW8bI8/7GlA5eAii7jW5ulznGR/jge
	 6dL6VBtLcn3zBeaz39gsxiaKKBIXBANQPu0gFgVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0773/1611] perf tools: Add O_CLOEXEC to open() calls in DSO and ELF code
Date: Tue, 21 Jul 2026 17:14:49 +0200
Message-ID: <20260721152532.773045201@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit b145137fec13dc8fc7fcb14193ce395a1164e3a1 ]

open() calls in dso.c and symbol-elf.c omit O_CLOEXEC, which leaks
file descriptors to child processes spawned during symbol resolution
(e.g., addr2line, objdump).  This can exhaust the fd limit during
long profiling sessions or when processing many DSOs.

Add O_CLOEXEC to all open() calls in both files (12 call sites).

Fixes: cdd059d731eeb466 ("perf tools: Move dso_* related functions into dso object")
Fixes: e5a1845fc0aeca85 ("perf symbols: Split out util/symbol-elf.c")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Stable-dep-of: f973e52a9977 ("perf dso: Fix heap overflow in dso__get_filename() on decompressed path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c        |  4 ++--
 tools/perf/util/symbol-elf.c | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index 3077f2ab3f125a..db0513936cea88 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -343,7 +343,7 @@ int filename__decompress(const char *name, char *pathname,
 	 * descriptor to the uncompressed file.
 	 */
 	if (!compressions[comp].is_compressed(name))
-		return open(name, O_RDONLY);
+		return open(name, O_RDONLY | O_CLOEXEC);
 
 	fd = mkstemp(tmpbuf);
 	if (fd < 0) {
@@ -1843,7 +1843,7 @@ static const u8 *__dso__read_symbol(struct dso *dso, const char *symfs_filename,
 	int saved_errno;
 
 	nsinfo__mountns_enter(dso__nsinfo(dso), &nsc);
-	fd = open(symfs_filename, O_RDONLY);
+	fd = open(symfs_filename, O_RDONLY | O_CLOEXEC);
 	saved_errno = errno;
 	nsinfo__mountns_exit(&nsc);
 	if (fd < 0) {
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 26c842ddaf235b..0dbc3d56a00a1f 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -217,7 +217,7 @@ bool filename__has_section(const char *filename, const char *sec)
 	GElf_Shdr shdr;
 	bool found = false;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return false;
 
@@ -887,7 +887,7 @@ static int read_build_id(const char *filename, struct build_id *bid)
 	if (size < BUILD_ID_SIZE)
 		goto out;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -948,7 +948,7 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 	size_t size = sizeof(bid->data);
 	int fd, err = -1;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -1019,7 +1019,7 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	if (err >= 0)
 		goto out;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -1184,7 +1184,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 
 		type = dso__symtab_type(dso);
 	} else {
-		fd = open(name, O_RDONLY);
+		fd = open(name, O_RDONLY | O_CLOEXEC);
 		if (fd < 0) {
 			*dso__load_errno(dso) = errno;
 			return -1;
@@ -1985,7 +1985,7 @@ static int kcore__open(struct kcore *kcore, const char *filename)
 {
 	GElf_Ehdr *ehdr;
 
-	kcore->fd = open(filename, O_RDONLY);
+	kcore->fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (kcore->fd == -1)
 		return -1;
 
@@ -2018,7 +2018,7 @@ static int kcore__init(struct kcore *kcore, char *filename, int elfclass,
 	if (temp)
 		kcore->fd = mkstemp(filename);
 	else
-		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL, 0400);
+		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0400);
 	if (kcore->fd == -1)
 		return -1;
 
@@ -2494,11 +2494,11 @@ static int kcore_copy__compare_files(const char *from_filename,
 {
 	int from, to, err = -1;
 
-	from = open(from_filename, O_RDONLY);
+	from = open(from_filename, O_RDONLY | O_CLOEXEC);
 	if (from < 0)
 		return -1;
 
-	to = open(to_filename, O_RDONLY);
+	to = open(to_filename, O_RDONLY | O_CLOEXEC);
 	if (to < 0)
 		goto out_close_from;
 
@@ -2916,7 +2916,7 @@ int get_sdt_note_list(struct list_head *head, const char *target)
 	Elf *elf;
 	int fd, ret;
 
-	fd = open(target, O_RDONLY);
+	fd = open(target, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return -EBADF;
 
-- 
2.53.0



