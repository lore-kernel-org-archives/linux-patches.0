Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D96F0428475;
	Sat, 12 Sep 2026 10:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209825; cv=none; b=Pkf6i3G4b9nT2duIbYMAUgsIbJgh9QyHZsuFoVclIVLWV0n+CLT+2WcGzOl2AfzdGCxr4od4PLpOYuWwUle4b2Z/6D+EWw1su6aRszNndR5iQ+++KJvuoVDTPPBRKrIYKlkMIZO2tKokGYuYvnczbJAbLq+SMbHoW/S5kPgfO2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209825; c=relaxed/simple;
	bh=XQx/TyGFE+hDsLl4dz7XJalaLXD7hET8Xi8+wg8gPeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a0Mz00RrfueUnAqsxttoGH9WxF5ia+CPQSXKZKWvbwHp1o8cf2U3TpBIdEOyRW1W3ctRW56kEf70EDsmOuF29zGoiReeFxE7bEBEFqy6XQu1SYV0Z42Bu09Ss2naEDa2H+BNJT+czPnLk5FreC1PyFTzK71Y9RNkNpB9ZC947P0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NV5H0/ue; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NV5H0/ue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0F291F000FF;
	Sat, 12 Sep 2026 10:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209823;
	bh=WRof4aPltQLtOpLAXhpqRpLwVRk89z4ptrwVP/8WgZE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NV5H0/uenPXCv1/qssKowt9FUpQuFdolm2MbCp4+STmH2qmVj/7WajJSbbJGf8dZk
	 nhlevR5IzwcOCLniIygODMvy0PIgt7jQ+7QHO59By4hKRbK35ye6LN4fFdZYzXs/nf
	 4WxL+w/+n90lezdqmzWha2Z7JtImF6slTKqCbmBU=
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
Subject: [PATCH 6.18 0900/1518] perf libbfd: Validate BPF prog info arrays before pointer cast
Date: Sat, 12 Sep 2026 08:51:09 +0200
Message-ID: <20260912065643.813118642@linuxfoundation.org>
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

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 01765b456f850aed7475b37111f1c50bf76aaf51 ]

symbol__disassemble_bpf_libbfd() casts info_linear->info.jited_prog_insns
and info_linear->info.jited_ksyms to pointers without checking whether
bpil_offs_to_addr() actually converted the file offsets.  A crafted
perf.data with PERF_BPIL_* bits unset but non-zero counts causes raw
file offsets to be dereferenced as pointers.

Add bitmask checks for PERF_BPIL_JITED_INSNS and PERF_BPIL_JITED_KSYMS
before the casts, matching the validation added to bpf-event.c call
sites.

Fixes: 6987561c9e86 ("perf annotate: Enable annotation of BPF programs")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 63ea3fb53e77d..cbd4adb8a1c43 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -552,6 +552,11 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 	info_linear = info_node->info_linear;
 	sub_id = dso__bpf_prog(dso)->sub_id;
 
+	/* jited_prog_insns is only valid if bpil_offs_to_addr() converted it */
+	if (!(info_linear->arrays & (1UL << PERF_BPIL_JITED_INSNS))) {
+		ret = SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
+		goto out;
+	}
 	info.buffer = (void *)(uintptr_t)(info_linear->info.jited_prog_insns);
 	info.buffer_length = info_linear->info.jited_prog_len;
 
@@ -581,6 +586,12 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 	if (disassemble == NULL)
 		abort();
 
+	/* jited_ksyms is only valid if bpil_offs_to_addr() converted it */
+	if (!(info_linear->arrays & (1UL << PERF_BPIL_JITED_KSYMS))) {
+		ret = SYMBOL_ANNOTATE_ERRNO__BPF_MISSING_BTF;
+		goto out;
+	}
+
 	fflush(s);
 	do {
 		const struct bpf_line_info *linfo = NULL;
-- 
2.53.0



