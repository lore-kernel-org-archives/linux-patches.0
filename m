Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDB9C3563CA;
	Tue, 16 Dec 2025 12:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886515; cv=none; b=A1rUHbYs7KGyxveHhQBPjz4tqhFu/pefJBURdIsdmdmFlWviJ29p1M/yYF7//2Ow0fHGOsql0gJX//dNOQjQQBgqdyAe1mPOruiR2HonDCF9F6BBSE9oWQvt+nHw0MoikSyU56nrzXYrRfh2ucoLKEUXemqBLMNne8hNc3QHDpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886515; c=relaxed/simple;
	bh=cx4UbQOxyeqAPcW1Qy5sJPe9ZkNl/v5hb1LXPvxFOtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RAjCwjnEDXhGzasyfPogGT0o9p3thxUp/OmXKICZBrjp0Rcm4LpM/bFR4sJnc6TmZpjm4y33eQ/vIJgCbqnxvtnSxytLmfdk0H7YDSG4E+KAW5bapb/IzpxqN6C6WtQub6ENzmzKuopfPleFUaP5OpuymbI55goy3B/cN3j4YOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fCiku2g+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fCiku2g+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E49C4CEF1;
	Tue, 16 Dec 2025 12:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886515;
	bh=cx4UbQOxyeqAPcW1Qy5sJPe9ZkNl/v5hb1LXPvxFOtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fCiku2g+cpxcpPtSVmIAUiXIYNsXcUKP8YNypoFz+mOC84vwg0XmC6HaOFDnGTsw0
	 3Uu0mUSR8PmDG2uMl0geHY5YopBeQeghfrWJTrq4N/b5biY8zqZ9D9DhNliZjXKIuV
	 ROG77uQZ9TJVZeco0kvT/hEuKz6VH9fnt1JkfkbY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Pablo Galindo <pablogsal@gmail.com>,
	Fangrui Song <maskray@sourceware.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 426/507] perf jitdump: Add sym/str-tables to build-ID generation
Date: Tue, 16 Dec 2025 12:14:27 +0100
Message-ID: <20251216111400.895173679@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 25d498e636d1f8d138d65246cfb5b1fc3069ca56 ]

It was reported that python backtrace with JIT dump was broken after the
change to built-in SHA-1 implementation.  It seems python generates the
same JIT code for each function.  They will become separate DSOs but the
contents are the same.  Only difference is in the symbol name.

But this caused a problem that every JIT'ed DSOs will have the same
build-ID which makes perf confused.  And it resulted in no python
symbols (from JIT) in the output.

Looking back at the original code before the conversion, it used the
load_addr as well as the code section to distinguish each DSO.  But it'd
be better to use contents of symtab and strtab instead as it aligns with
some linker behaviors.

This patch adds a buffer to save all the contents in a single place for
SHA-1 calculation.  Probably we need to add sha1_update() or similar to
update the existing hash value with different contents and use it here.
But it's out of scope for this change and I'd like something that can be
backported to the stable trees easily.

Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Eric Biggers <ebiggers@kernel.org>
Cc: Pablo Galindo <pablogsal@gmail.com>
Cc: Fangrui Song <maskray@sourceware.org>
Link: https://github.com/python/cpython/issues/139544
Fixes: e3f612c1d8f3945b ("perf genelf: Remove libcrypto dependency and use built-in sha1()")
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf.c | 32 ++++++++++++++++++++++++++++++--
 1 file changed, 30 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index 591548b10e34e..a1cd5196f4ec8 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -173,6 +173,8 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	Elf_Shdr *shdr;
 	uint64_t eh_frame_base_offset;
 	char *strsym = NULL;
+	void *build_id_data = NULL, *tmp;
+	int build_id_data_len;
 	int symlen;
 	int retval = -1;
 
@@ -251,6 +253,14 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_flags = SHF_EXECINSTR | SHF_ALLOC;
 	shdr->sh_entsize = 0;
 
+	build_id_data = malloc(csize);
+	if (build_id_data == NULL) {
+		warnx("cannot allocate build-id data");
+		goto error;
+	}
+	memcpy(build_id_data, code, csize);
+	build_id_data_len = csize;
+
 	/*
 	 * Setup .eh_frame_hdr and .eh_frame
 	 */
@@ -334,6 +344,15 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_entsize = sizeof(Elf_Sym);
 	shdr->sh_link = unwinding ? 6 : 4; /* index of .strtab section */
 
+	tmp = realloc(build_id_data, build_id_data_len + sizeof(symtab));
+	if (tmp == NULL) {
+		warnx("cannot allocate build-id data");
+		goto error;
+	}
+	memcpy(tmp + build_id_data_len, symtab, sizeof(symtab));
+	build_id_data = tmp;
+	build_id_data_len += sizeof(symtab);
+
 	/*
 	 * setup symbols string table
 	 * 2 = 1 for 0 in 1st entry, 1 for the 0 at end of symbol for 2nd entry
@@ -376,6 +395,15 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	shdr->sh_flags = 0;
 	shdr->sh_entsize = 0;
 
+	tmp = realloc(build_id_data, build_id_data_len + symlen);
+	if (tmp == NULL) {
+		warnx("cannot allocate build-id data");
+		goto error;
+	}
+	memcpy(tmp + build_id_data_len, strsym, symlen);
+	build_id_data = tmp;
+	build_id_data_len += symlen;
+
 	/*
 	 * setup build-id section
 	 */
@@ -394,7 +422,7 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	/*
 	 * build-id generation
 	 */
-	sha1(code, csize, bnote.build_id);
+	sha1(build_id_data, build_id_data_len, bnote.build_id);
 	bnote.desc.namesz = sizeof(bnote.name); /* must include 0 termination */
 	bnote.desc.descsz = sizeof(bnote.build_id);
 	bnote.desc.type   = NT_GNU_BUILD_ID;
@@ -439,7 +467,7 @@ jit_write_elf(int fd, uint64_t load_addr __maybe_unused, const char *sym,
 	(void)elf_end(e);
 
 	free(strsym);
-
+	free(build_id_data);
 
 	return retval;
 }
-- 
2.51.0



