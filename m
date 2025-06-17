Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C6BF2FA658;
	Tue, 17 Jun 2025 16:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178498; cv=none; b=OZ+g3zDRtAFPll1rax1DYAihoPxdWJAOmVLEK4yG4M/2Ufezs53kDv6/x0Ifcj/x7GAUVQvtUyJyMmb/IP+MQOpWFEgpAm+oN61MjayKGL6ihBnse5j2C1nmsWd8InWOoUH8hLOtk68RXeoCed271VANKWbc9zdfuinXlVLrkgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178498; c=relaxed/simple;
	bh=wnUcnUrHCtNAofhwaWj0RqNYScisFk9XZXennVYc114=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ODs6CGdAGqW65DyDH2OJuu/AMYUFPEmiIjRhFkfeGyCqTpuHBONdPnjqOPDPwL2tj91flhCeNv7M41faMegYRzOg7P1IYg+iUZ2E87mEI6HSOe5lnVGyonb46s9DDe4E1Av+PRi8+nA1W98FR3uzhkJFoRhhsR5auO3f/rQJzbc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1AE5qfyV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1AE5qfyV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDA0C4CEE3;
	Tue, 17 Jun 2025 16:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178498;
	bh=wnUcnUrHCtNAofhwaWj0RqNYScisFk9XZXennVYc114=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1AE5qfyVRCsvIjJVfI7gn68292Jn0apzjVGj4y9fN8bHFfavjkPChRabCoXuJA/Su
	 DDPA320UqaWFeh6JXRezOmWxh+MID2nzeB5+tnmLftZuFpY55/s94l8w9DFB7AnZsb
	 rpePbx0fmi7cmhDUdwx1wC+pl1XWQGZrnn1vR6zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Gary Guo <gary@garyguo.net>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Howard Chu <howardchu95@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Weilin Wang <weilin.wang@intel.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	James Clark <james.clark@linaro.org>,
	Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
	Andi Kleen <ak@linux.intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Kan Liang <kan.liang@linux.intel.com>,
	Stephen Brennan <stephen.s.brennan@oracle.com>,
	Benno Lossin <benno.lossin@proton.me>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Ingo Molnar <mingo@redhat.com>,
	Trevor Gross <tmgross@umich.edu>,
	linux-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 468/780] perf symbol: Fix use-after-free in filename__read_build_id
Date: Tue, 17 Jun 2025 17:22:56 +0200
Message-ID: <20250617152510.547482531@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit fef8f648bb47726d96a5701fe31ed606268da73d ]

The same buf is used for the program headers and reading notes. As the
notes memory may be reallocated then this corrupts the memory pointed
to by the phdr. Using the same buffer is in any case a logic
error. Rather than deal with the duplicated code, introduce an elf32
boolean and a union for either the elf32 or elf64 headers that are in
use. Let the program headers have their own memory and grow the buffer
for notes as necessary.

Before `perf list -j` compiled with asan would crash with:
```
==4176189==ERROR: AddressSanitizer: heap-use-after-free on address 0x5160000070b8 at pc 0x555d3b15075b bp 0x7ffebb5a8090 sp 0x7ffebb5a8088
READ of size 8 at 0x5160000070b8 thread T0
    #0 0x555d3b15075a in filename__read_build_id tools/perf/util/symbol-minimal.c:212:25
    #1 0x555d3ae43aff in filename__sprintf_build_id tools/perf/util/build-id.c:110:8
...

0x5160000070b8 is located 312 bytes inside of 560-byte region [0x516000006f80,0x5160000071b0)
freed by thread T0 here:
    #0 0x555d3ab21840 in realloc (perf+0x264840) (BuildId: 12dff2f6629f738e5012abdf0e90055518e70b5e)
    #1 0x555d3b1506e7 in filename__read_build_id tools/perf/util/symbol-minimal.c:206:11
...

previously allocated by thread T0 here:
    #0 0x555d3ab21423 in malloc (perf+0x264423) (BuildId: 12dff2f6629f738e5012abdf0e90055518e70b5e)
    #1 0x555d3b1503a2 in filename__read_build_id tools/perf/util/symbol-minimal.c:182:9
...
```

Note: this bug is long standing and not introduced by the other asan
fix in commit fa9c4977fbfb ("perf symbol-minimal: Fix double free in
filename__read_build_id").

Fixes: b691f64360ecec49 ("perf symbols: Implement poor man's ELF parser")
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250528032637.198960-2-irogers@google.com
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Howard Chu <howardchu95@gmail.com>
Cc: Alice Ryhl <aliceryhl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Weilin Wang <weilin.wang@intel.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: James Clark <james.clark@linaro.org>
Cc: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Kan Liang <kan.liang@linux.intel.com>
Cc: Stephen Brennan <stephen.s.brennan@oracle.com>
Cc: Benno Lossin <benno.lossin@proton.me>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: linux-kernel@vger.kernel.org
Cc: linux-perf-users@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-minimal.c | 168 +++++++++++++------------------
 1 file changed, 70 insertions(+), 98 deletions(-)

diff --git a/tools/perf/util/symbol-minimal.c b/tools/perf/util/symbol-minimal.c
index d8da3da01fe6b..36c1d3090689f 100644
--- a/tools/perf/util/symbol-minimal.c
+++ b/tools/perf/util/symbol-minimal.c
@@ -90,11 +90,23 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 {
 	FILE *fp;
 	int ret = -1;
-	bool need_swap = false;
+	bool need_swap = false, elf32;
 	u8 e_ident[EI_NIDENT];
-	size_t buf_size;
-	void *buf;
 	int i;
+	union {
+		struct {
+			Elf32_Ehdr ehdr32;
+			Elf32_Phdr *phdr32;
+		};
+		struct {
+			Elf64_Ehdr ehdr64;
+			Elf64_Phdr *phdr64;
+		};
+	} hdrs;
+	void *phdr;
+	size_t phdr_size;
+	void *buf = NULL;
+	size_t buf_size = 0;
 
 	fp = fopen(filename, "r");
 	if (fp == NULL)
@@ -108,119 +120,79 @@ int filename__read_build_id(const char *filename, struct build_id *bid)
 		goto out;
 
 	need_swap = check_need_swap(e_ident[EI_DATA]);
+	elf32 = e_ident[EI_CLASS] == ELFCLASS32;
 
-	/* for simplicity */
-	fseek(fp, 0, SEEK_SET);
-
-	if (e_ident[EI_CLASS] == ELFCLASS32) {
-		Elf32_Ehdr ehdr;
-		Elf32_Phdr *phdr;
-
-		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
-			goto out;
+	if (fread(elf32 ? (void *)&hdrs.ehdr32 : (void *)&hdrs.ehdr64,
+		  elf32 ? sizeof(hdrs.ehdr32) : sizeof(hdrs.ehdr64),
+		  1, fp) != 1)
+		goto out;
 
-		if (need_swap) {
-			ehdr.e_phoff = bswap_32(ehdr.e_phoff);
-			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
-			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+	if (need_swap) {
+		if (elf32) {
+			hdrs.ehdr32.e_phoff = bswap_32(hdrs.ehdr32.e_phoff);
+			hdrs.ehdr32.e_phentsize = bswap_16(hdrs.ehdr32.e_phentsize);
+			hdrs.ehdr32.e_phnum = bswap_16(hdrs.ehdr32.e_phnum);
+		} else {
+			hdrs.ehdr64.e_phoff = bswap_64(hdrs.ehdr64.e_phoff);
+			hdrs.ehdr64.e_phentsize = bswap_16(hdrs.ehdr64.e_phentsize);
+			hdrs.ehdr64.e_phnum = bswap_16(hdrs.ehdr64.e_phnum);
 		}
+	}
+	phdr_size = elf32 ? hdrs.ehdr32.e_phentsize * hdrs.ehdr32.e_phnum
+			  : hdrs.ehdr64.e_phentsize * hdrs.ehdr64.e_phnum;
+	phdr = malloc(phdr_size);
+	if (phdr == NULL)
+		goto out;
 
-		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
-		buf = malloc(buf_size);
-		if (buf == NULL)
-			goto out;
-
-		fseek(fp, ehdr.e_phoff, SEEK_SET);
-		if (fread(buf, buf_size, 1, fp) != 1)
-			goto out_free;
-
-		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
-			void *tmp;
-			long offset;
-
-			if (need_swap) {
-				phdr->p_type = bswap_32(phdr->p_type);
-				phdr->p_offset = bswap_32(phdr->p_offset);
-				phdr->p_filesz = bswap_32(phdr->p_filesz);
-			}
-
-			if (phdr->p_type != PT_NOTE)
-				continue;
-
-			offset = phdr->p_offset;
-			if (phdr->p_filesz > buf_size) {
-				buf_size = phdr->p_filesz;
-				tmp = realloc(buf, buf_size);
-				if (tmp == NULL)
-					goto out_free;
-				buf = tmp;
-			}
-			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
-				goto out_free;
+	fseek(fp, elf32 ? hdrs.ehdr32.e_phoff : hdrs.ehdr64.e_phoff, SEEK_SET);
+	if (fread(phdr, phdr_size, 1, fp) != 1)
+		goto out_free;
 
-			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
-			if (ret == 0) {
-				ret = bid->size;
-				break;
-			}
-		}
-	} else {
-		Elf64_Ehdr ehdr;
-		Elf64_Phdr *phdr;
+	if (elf32)
+		hdrs.phdr32 = phdr;
+	else
+		hdrs.phdr64 = phdr;
 
-		if (fread(&ehdr, sizeof(ehdr), 1, fp) != 1)
-			goto out;
+	for (i = 0; i < elf32 ? hdrs.ehdr32.e_phnum : hdrs.ehdr64.e_phnum; i++) {
+		size_t p_filesz;
 
 		if (need_swap) {
-			ehdr.e_phoff = bswap_64(ehdr.e_phoff);
-			ehdr.e_phentsize = bswap_16(ehdr.e_phentsize);
-			ehdr.e_phnum = bswap_16(ehdr.e_phnum);
+			if (elf32) {
+				hdrs.phdr32[i].p_type = bswap_32(hdrs.phdr32[i].p_type);
+				hdrs.phdr32[i].p_offset = bswap_32(hdrs.phdr32[i].p_offset);
+				hdrs.phdr32[i].p_filesz = bswap_32(hdrs.phdr32[i].p_offset);
+			} else {
+				hdrs.phdr64[i].p_type = bswap_32(hdrs.phdr64[i].p_type);
+				hdrs.phdr64[i].p_offset = bswap_64(hdrs.phdr64[i].p_offset);
+				hdrs.phdr64[i].p_filesz = bswap_64(hdrs.phdr64[i].p_filesz);
+			}
 		}
+		if ((elf32 ? hdrs.phdr32[i].p_type : hdrs.phdr64[i].p_type) != PT_NOTE)
+			continue;
 
-		buf_size = ehdr.e_phentsize * ehdr.e_phnum;
-		buf = malloc(buf_size);
-		if (buf == NULL)
-			goto out;
-
-		fseek(fp, ehdr.e_phoff, SEEK_SET);
-		if (fread(buf, buf_size, 1, fp) != 1)
-			goto out_free;
-
-		for (i = 0, phdr = buf; i < ehdr.e_phnum; i++, phdr++) {
+		p_filesz = elf32 ? hdrs.phdr32[i].p_filesz : hdrs.phdr64[i].p_filesz;
+		if (p_filesz > buf_size) {
 			void *tmp;
-			long offset;
-
-			if (need_swap) {
-				phdr->p_type = bswap_32(phdr->p_type);
-				phdr->p_offset = bswap_64(phdr->p_offset);
-				phdr->p_filesz = bswap_64(phdr->p_filesz);
-			}
-
-			if (phdr->p_type != PT_NOTE)
-				continue;
 
-			offset = phdr->p_offset;
-			if (phdr->p_filesz > buf_size) {
-				buf_size = phdr->p_filesz;
-				tmp = realloc(buf, buf_size);
-				if (tmp == NULL)
-					goto out_free;
-				buf = tmp;
-			}
-			fseek(fp, offset, SEEK_SET);
-			if (fread(buf, phdr->p_filesz, 1, fp) != 1)
+			buf_size = p_filesz;
+			tmp = realloc(buf, buf_size);
+			if (tmp == NULL)
 				goto out_free;
+			buf = tmp;
+		}
+		fseek(fp, elf32 ? hdrs.phdr32[i].p_offset : hdrs.phdr64[i].p_offset, SEEK_SET);
+		if (fread(buf, p_filesz, 1, fp) != 1)
+			goto out_free;
 
-			ret = read_build_id(buf, phdr->p_filesz, bid, need_swap);
-			if (ret == 0) {
-				ret = bid->size;
-				break;
-			}
+		ret = read_build_id(buf, p_filesz, bid, need_swap);
+		if (ret == 0) {
+			ret = bid->size;
+			break;
 		}
 	}
 out_free:
 	free(buf);
+	free(phdr);
 out:
 	fclose(fp);
 	return ret;
-- 
2.39.5



