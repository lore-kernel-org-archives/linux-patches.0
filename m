Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A58DC304BA6;
	Tue,  2 Sep 2025 13:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819367; cv=none; b=dWgjfbQ9sRdpZLdIHuFtG6sDpKXPoUyJz4DoGj7/zEi6QNbMfd/pcJSgo/Nz3Sot1uKvvdimMQ0nFG+PVQTIQ1ACWsfhr/CYngBM95ZpqmjEmxyXm/GoR2qu8o9+tPzqFLXLzMsQcqDSoC9l96XjrlklmUnXU/xivM9IRHFQpSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819367; c=relaxed/simple;
	bh=KhzSii/zsza0S926lPY9HjSeWep7hEkh3CynBblwxCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JUPc05MWqebwYNTRsQ+G5rAlVZ1zCoIvyR1CxDNVB6YaXo8thjJpi/5RPO/Za94q58ylUWpRntteb5R2e+sAh5a0nmKpfb5GG6s1g4r3dU5Zem9NGd23xCul/R6Zb9J3/sAk/T7zfb4ZjsyoAI4eHA2Tv/zX/8nqrdWWQsaBbCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cT9tVC+c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cT9tVC+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4E0C4CEF4;
	Tue,  2 Sep 2025 13:22:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819367;
	bh=KhzSii/zsza0S926lPY9HjSeWep7hEkh3CynBblwxCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cT9tVC+cUd9jeEj2GjDEqEOAA4JNTBRYoKyS4ZsJRwX2LoK5b2Voz4we3q0kaJjFw
	 bk5JBcAk0xaUTtXk3IV9KT7PpNHMoqh1zkpXo5Vc26jijdJxzKqHnZb2JgBFzoyBls
	 i1y/UhlknJIOaSBzLbzRHvkoHflusmIHCHiEqrGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 014/142] perf symbol-minimal: Fix ehdr reading in filename__read_build_id
Date: Tue,  2 Sep 2025 15:18:36 +0200
Message-ID: <20250902131948.699735245@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit ba0b7081f7a521d7c28b527a4f18666a148471e7 ]

The e_ident is part of the ehdr and so reading it a second time would
mean the read ehdr was displaced by 16-bytes. Switch from stdio to
open/read/lseek syscalls for similarity with the symbol-elf version of
the function and so that later changes can alter then open flags.

Fixes: fef8f648bb47 ("perf symbol: Fix use-after-free in filename__read_build_id")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250823000024.724394-2-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 55 ++++++++++++++++----------------
 1 file changed, 27 insertions(+), 28 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index c73fe2e09fe91..fc9c6f39d5dd3 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -4,7 +4,6 @@
 
 #include <errno.h>
 #include <unistd.h>
-#include <stdio.h>
 #include <fcntl.h>
 #include <string.h>
 #include <stdlib.h>
@@ -88,11 +87,8 @@ int filename__read_debuglink(const char *filename __maybe_unused,
  */
 int filename__read_build_id(const char *filename, struct build_id *bid)
 {
-	FILE *fp;
-	int ret = -1;
+	int fd, ret = -1;
 	bool need_swap = false, elf32;
-	u8 e_ident[EI_NIDENT];
-	int i;
 	union {
 		struct {
 			Elf32_Ehdr ehdr32;
@@ -103,28 +99,27 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			Elf64_Phdr *phdr64;
 		};
 	} hdrs;
-	void *phdr;
-	size_t phdr_size;
-	void *buf = NULL;
-	size_t buf_size = 0;
+	void *phdr, *buf = NULL;
+	ssize_t phdr_size, ehdr_size, buf_size = 0;
 
-	fp = fopen(filename, "r");
-	if (fp == NULL)
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
 		return -1;
 
-	if (fread(e_ident, sizeof(e_ident), 1, fp) != 1)
+	if (read(fd, hdrs.ehdr32.e_ident, EI_NIDENT) != EI_NIDENT)
 		goto out;
 
-	if (memcmp(e_ident, ELFMAG, SELFMAG) ||
-	    e_ident[EI_VERSION] != EV_CURRENT)
+	if (memcmp(hdrs.ehdr32.e_ident, ELFMAG, SELFMAG) ||
+	    hdrs.ehdr32.e_ident[EI_VERSION] != EV_CURRENT)
 		goto out;
 
-	need_swap = check_need_swap(e_ident[EI_DATA]);
-	elf32 = e_ident[EI_CLASS] == ELFCLASS32;
+	need_swap = check_need_swap(hdrs.ehdr32.e_ident[EI_DATA]);
+	elf32 = hdrs.ehdr32.e_ident[EI_CLASS] == ELFCLASS32;
+	ehdr_size = (elf32 ? sizeof(hdrs.ehdr32) : sizeof(hdrs.ehdr64)) - EI_NIDENT;
 
-	if (fread(elf32 ? (void *)&hdrs.ehdr32 : (void *)&hdrs.ehdr64,
-		  elf32 ? sizeof(hdrs.ehdr32) : sizeof(hdrs.ehdr64),
-		  1, fp) != 1)
+	if (read(fd,
+		 (elf32 ? (void *)&hdrs.ehdr32 : (void *)&hdrs.ehdr64) + EI_NIDENT,
+		 ehdr_size) != ehdr_size)
 		goto out;
 
 	if (need_swap) {
@@ -138,14 +133,18 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 			hdrs.ehdr64.e_phnum = bswap_16(hdrs.ehdr64.e_phnum);
 		}
 	}
-	phdr_size = elf32 ? hdrs.ehdr32.e_phentsize * hdrs.ehdr32.e_phnum
-			  : hdrs.ehdr64.e_phentsize * hdrs.ehdr64.e_phnum;
+	if ((elf32 && hdrs.ehdr32.e_phentsize != sizeof(Elf32_Phdr)) ||
+	    (!elf32 && hdrs.ehdr64.e_phentsize != sizeof(Elf64_Phdr)))
+		goto out;
+
+	phdr_size = elf32 ? sizeof(Elf32_Phdr) * hdrs.ehdr32.e_phnum
+			  : sizeof(Elf64_Phdr) * hdrs.ehdr64.e_phnum;
 	phdr = malloc(phdr_size);
 	if (phdr == NULL)
 		goto out;
 
-	fseek(fp, elf32 ? hdrs.ehdr32.e_phoff : hdrs.ehdr64.e_phoff, SEEK_SET);
-	if (fread(phdr, phdr_size, 1, fp) != 1)
+	lseek(fd, elf32 ? hdrs.ehdr32.e_phoff : hdrs.ehdr64.e_phoff, SEEK_SET);
+	if (read(fd, phdr, phdr_size) != phdr_size)
 		goto out_free;
 
 	if (elf32)
@@ -153,8 +152,8 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 	else
 		hdrs.phdr64 = phdr;
 
-	for (i = 0; i < elf32 ? hdrs.ehdr32.e_phnum : hdrs.ehdr64.e_phnum; i++) {
-		size_t p_filesz;
+	for (int i = 0; i < (elf32 ? hdrs.ehdr32.e_phnum : hdrs.ehdr64.e_phnum); i++) {
+		ssize_t p_filesz;
 
 		if (need_swap) {
 			if (elf32) {
@@ -180,8 +179,8 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 				goto out_free;
 			buf = tmp;
 		}
-		fseek(fp, elf32 ? hdrs.phdr32[i].p_offset : hdrs.phdr64[i].p_offset, SEEK_SET);
-		if (fread(buf, p_filesz, 1, fp) != 1)
+		lseek(fd, elf32 ? hdrs.phdr32[i].p_offset : hdrs.phdr64[i].p_offset, SEEK_SET);
+		if (read(fd, buf, p_filesz) != p_filesz)
 			goto out_free;
 
 		ret = read_build_id(buf, p_filesz, bid, need_swap);
@@ -194,7 +193,7 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 	free(buf);
 	free(phdr);
 out:
-	fclose(fp);
+	close(fd);
 	return ret;
 }
 
-- 
2.50.1



