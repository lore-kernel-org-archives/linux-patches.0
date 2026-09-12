Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D454385521;
	Sat, 12 Sep 2026 08:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789202009; cv=none; b=KNP2HUj7kwyMAaBd+dvs5tyZmbQ4YLOuXOF9Hs9TR5DnGVtA8ESIJkS7oNpaknqBQ6nj0ltbQI1CozHL3ZR78kVnqv72Js9d4HNAU/ldcBftYCqXr/YoJuPSsql21ywr6DjL2VGluG3i/6U3yotuFlC5PxyAjiH/jKIs3VDho8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789202009; c=relaxed/simple;
	bh=qbG46cLTFUdZEBOz1TVWlZUIoYOeTxoru6IWQGgFeJ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ms28oKhB10pS32ZjUumuyyeQoZxDOZOUK1LpU1yb2BGc5W/wrWGbwb2a/cau7pJSBmy35AhUTY+r6Wjw2K5LWagEeUzdpOjMi1ptNbNFgtL8/kYjELdA29lEIZcU03v32ti34schSy6Ljf0Vuy6yK1CW89n68VJ6sw1c+NzRU10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1pi1v1TB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1pi1v1TB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 530151F000FF;
	Sat, 12 Sep 2026 08:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789202008;
	bh=6DqbLHu74bmzPyw+8B9pmOod2MUhhoIIxBEU5R4lsyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1pi1v1TB/JkhDcRoCx7Vl9w4AtbXffTTJn3ITYC3LZ22BRAWf5A3b3y7w4kp7wUkC
	 1EAHvZUmZ7f6HmVldic9ctDmQx4Tj978mjy2iE/USUfGbudgsq/zZy4EeYEIG3c+Xx
	 ApYbpFAzOjKLdNzyC12Ud0DvGwRBtKdE4mlJz3jM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Ian Rogers <irogers@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1114/1815] perf libbfd: Fix memory leaks and NULL fclose in BPF disassembly
Date: Sat, 12 Sep 2026 08:47:44 +0200
Message-ID: <20260912065715.171185141@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit fe3ab00d55aa56b4d55cbc1150448f0aadd6732c ]

symbol__disassemble_bpf_libbfd() has four resource management bugs:

1. free(prog_linfo) leaks internal arrays.  bpf_prog_linfo contains
   raw_linfo, raw_jited_linfo, nr_jited_linfo_per_func, and
   jited_linfo_func_idx pointers that are only freed by the proper
   destructor bpf_prog_linfo__free().

2. open_memstream(&buf, &buf_size) allocates a dynamic buffer that the
   caller must free after fclose().  The function calls fclose(s) but
   never free(buf), leaking the stream buffer on every call.

3. args->line = strdup(srcline) is immediately consumed by
   disasm_line__new(args) which internally calls strdup(args->line)
   again via annotation_line__init().  The first strdup result is then
   overwritten by args->line = buf + prev_buf_size without being freed.

4. If open_memstream() fails, the error path jumps to 'out:' which
   calls fclose(s) with s == NULL — undefined behavior.

Fix by using bpf_prog_linfo__free(), initializing buf to NULL, adding
free(buf) after fclose(s), guarding fclose() against NULL, and removing
the redundant strdup since annotation_line__init() makes its own copy.

Fixes: 6987561c9e86eace ("perf annotate: Enable annotation of BPF programs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index d6c2d9807fc9c..118f973298ea8 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -15,6 +15,7 @@
 #ifdef HAVE_LIBBPF_SUPPORT
 #include <bpf/bpf.h>
 #include <bpf/btf.h>
+#include <bpf/libbpf.h>
 #endif
 #include <fcntl.h>
 #include <stdio.h>
@@ -510,7 +511,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 	char tpath[PATH_MAX];
 	size_t buf_size;
 	int nr_skip = 0;
-	char *buf;
+	char *buf = NULL;
 	bfd *bfdf;
 	int ret;
 	FILE *s;
@@ -620,7 +621,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 
 		if (!annotate_opts.hide_src_code && srcline) {
 			args->offset = -1;
-			args->line = strdup(srcline);
+			args->line = (char *)srcline;
 			args->line_nr = 0;
 			args->fileloc = NULL;
 			args->ms->sym = sym;
@@ -645,9 +646,12 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 
 	ret = 0;
 out:
-	free(prog_linfo);
+	bpf_prog_linfo__free(prog_linfo);
 	btf__free(btf);
-	fclose(s);
+	if (s) {
+		fclose(s);
+		free(buf);
+	}
 	bfd_close(bfdf);
 	return ret;
 #else
-- 
2.53.0



