Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081AE413D9C;
	Tue, 21 Jul 2026 19:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660494; cv=none; b=HRd4et74d4ozVYv7tLfLblh6RYduV4WurR0h+3koI/DKNX0MISv3ItXGDiWJpMz138n9lpe8N9kUXjQuisHKCyfX/nAxMA7YG7QxXCbMUzeZbs0h+jxYlygroju5DRj1iJ8Kke8aVhPzlq1sxtZmRaI7iKQju4DXFWE6EQnCfZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660494; c=relaxed/simple;
	bh=iLfCC6ZFClnFB9+vOgxnB2DZL9OrO915eV0ROcWFeNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UQrJodOcmyGVYG8WXwGwk/ZrKI3iacxKUUhSiffHQC49YNhY5S17AjanZs4KqgLgnvHe/yQf9TUo+byKtv/QRps2nGcVQfuxb+rfJG1KkET57r8NkGsYfiv1lBKHHVLehLXA+zlNn/b35QChJF74oryd8eFTWxjYU1L89CoFo9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seVEunhS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seVEunhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 352781F0155C;
	Tue, 21 Jul 2026 19:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660459;
	bh=hnN8C88ZkGSGacdD6PI80OVMCf224kfCaWDD/Zbqzzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seVEunhSmioZs+bd/Z2AOFjEdmjvE0DCX+s/zJ+o104EalTYg/H0OIPJME9qieOMN
	 4hjx/t3thW2plJ+NkjE/3yJbliaVerplxw1P4DNxptr6OuANOxV5oRTMh0XJURc/Qi
	 eqCQWjTW5kU0QxUv2R01oOYMvVsch7fu7wStvPSU=
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
Subject: [PATCH 7.1 0988/2077] perf tools: Add O_CLOEXEC to open() calls in DSO and ELF code
Date: Tue, 21 Jul 2026 17:11:01 +0200
Message-ID: <20260721152616.122043132@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/dso.c        |  4 ++--
 tools/perf/util/symbol-elf.c | 20 ++++++++++----------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index b791e1b6b2cf01..511e91843fbd8e 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -344,7 +344,7 @@ int filename__decompress(const char *name, char *pathname,
 	 * descriptor to the uncompressed file.
 	 */
 	if (!compressions[comp].is_compressed(name))
-		return open(name, O_RDONLY);
+		return open(name, O_RDONLY | O_CLOEXEC);
 
 	fd = mkstemp(tmpbuf);
 	if (fd < 0) {
@@ -1904,7 +1904,7 @@ static const u8 *__dso__read_symbol(struct dso *dso, const char *symfs_filename,
 	int saved_errno;
 
 	nsinfo__mountns_enter(dso__nsinfo(dso), &nsc);
-	fd = open(symfs_filename, O_RDONLY);
+	fd = open(symfs_filename, O_RDONLY | O_CLOEXEC);
 	saved_errno = errno;
 	nsinfo__mountns_exit(&nsc);
 	if (fd < 0) {
diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 7afa8a1171396b..0ba2c60ea5aaba 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -217,7 +217,7 @@ bool filename__has_section(const char *filename, const char *sec)
 	GElf_Shdr shdr;
 	bool found = false;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return false;
 
@@ -871,7 +871,7 @@ static int read_build_id(const char *filename, struct build_id *bid)
 	if (size < BUILD_ID_SIZE)
 		goto out;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -934,7 +934,7 @@ int sysfs__read_build_id(const char *filename, struct build_id *bid)
 	size_t size = sizeof(bid->data);
 	int fd, err = -1;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -994,7 +994,7 @@ int filename__read_debuglink(const char *filename, char *debuglink,
 	if (err >= 0)
 		goto out;
 
-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		goto out;
 
@@ -1152,7 +1152,7 @@ int symsrc__init(struct symsrc *ss, struct dso *dso, const char *name,
 
 		type = dso__symtab_type(dso);
 	} else {
-		fd = open(name, O_RDONLY);
+		fd = open(name, O_RDONLY | O_CLOEXEC);
 		if (fd < 0) {
 			*dso__load_errno(dso) = errno;
 			return -1;
@@ -1945,7 +1945,7 @@ static int kcore__open(struct kcore *kcore, const char *filename)
 {
 	GElf_Ehdr *ehdr;
 
-	kcore->fd = open(filename, O_RDONLY);
+	kcore->fd = open(filename, O_RDONLY | O_CLOEXEC);
 	if (kcore->fd == -1)
 		return -1;
 
@@ -1978,7 +1978,7 @@ static int kcore__init(struct kcore *kcore, char *filename, int elfclass,
 	if (temp)
 		kcore->fd = mkstemp(filename);
 	else
-		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL, 0400);
+		kcore->fd = open(filename, O_WRONLY | O_CREAT | O_EXCL | O_CLOEXEC, 0400);
 	if (kcore->fd == -1)
 		return -1;
 
@@ -2454,11 +2454,11 @@ static int kcore_copy__compare_files(const char *from_filename,
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
 
@@ -2876,7 +2876,7 @@ int get_sdt_note_list(struct list_head *head, const char *target)
 	Elf *elf;
 	int fd, ret;
 
-	fd = open(target, O_RDONLY);
+	fd = open(target, O_RDONLY | O_CLOEXEC);
 	if (fd < 0)
 		return -EBADF;
 
-- 
2.53.0



