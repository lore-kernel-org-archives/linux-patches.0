Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AC1224AEF;
	Tue, 16 Dec 2025 12:33:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765888403; cv=none; b=oEOvDq+jVutRSqlkotPRvKkKnT6BLHQSuYWxvVYPimub+drZvEVzsc+PwQGfmfEewXELoK9aNrFnsatVGTAXYWoHmegZbO2y1j2BjJZRaFhms8ykOSS9bcCEdbihloYUEUFGZ91AowNsCWHNcFmItTgNIPVsfyGD3zIHq2+1j0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765888403; c=relaxed/simple;
	bh=IBLn50srKcopysaGosl39GK9/Smz2UGWHNDKcsspo0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d3IF+SD1kQgxp1AkYF59P4Ym+CiGpI87mDLAANXitFzy7flVWJxB+4HlMMvJ57GNUmJJQEVFD1NT5qr/yTqrTKJZBnF//fy7SqL7kTqP1fPz2GR/ev8rpEFdwMX/oyF+IrCriNwW/Es1HTAcrAknsdvJm6k7eDffRW88ftDbwqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lOioacb2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lOioacb2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26937C4CEF1;
	Tue, 16 Dec 2025 12:33:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765888403;
	bh=IBLn50srKcopysaGosl39GK9/Smz2UGWHNDKcsspo0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lOioacb26aw7btpxhlYRZZSohnPSaa+b37MkU7Tkh+v/0V+ZRhDAXEp0NtTjXhiuK
	 V0qQ57CiMs2XBrZIDyYQigV71lT5lR0oQKaa0pqfS+pfpKzk6tlnV731VLDKvZm6bw
	 pC7vw0woHhUulCo8ol9ZFuuO9qDVONj2zPo/cypA=
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
Subject: [PATCH 6.18 523/614] perf jitdump: Add sym/str-tables to build-ID generation
Date: Tue, 16 Dec 2025 12:14:50 +0100
Message-ID: <20251216111420.326267301@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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



