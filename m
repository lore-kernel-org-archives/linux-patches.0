Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DBC6371889;
	Sat, 12 Sep 2026 10:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789209829; cv=none; b=njAxnprNL/rxyxSLDYJsnqaZaIfZLYjWUvtPeQ4SXM55PWCZxrFl9ejK8YvDnQpztzUwLvrDKMi059boTQbmr6OzevDrbpIHjI8ycBwB2L6bEAdEf9g0k8m+JzhzhRrHMymoOkk6HJNOklS5QzD6WasOop8jq+WM2YNrtNxO1+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789209829; c=relaxed/simple;
	bh=Tdfigm3KlAwReg07s/Vk0k7GgYsF3QyDRO1RQNcjSgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jJWKU+4wivKkDFXeH+wbzMh3bX9u4EtMEHP5i0Y25dGcf+ArKPuCmI6qAf1ReajrUhKyS4EI65udJx+mJVqHMkAkgFs2Gbhv5zWJB72z09iQqtwDJJC/iRbaKYcmmo6PTJdShUHph9dMIULq3sAAUGlMxYzR7qPUh2QkB8+lfgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mMANpCEp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mMANpCEp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40E6B1F000FF;
	Sat, 12 Sep 2026 10:43:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789209828;
	bh=fOnbilOdg9ttZ7oOHHDxZGP8vrMfULnJd5cRU5IQack=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mMANpCEpwrI3ZeLHgS+g7hJbCOg2ecK4NNJ8XhOcI+CZXrAcC2LjRw0bhIEYn3MeF
	 sXxaTcgOi2SZBUPXOsaN78hirzU9Mdx1C8gdYkJlKes9hHKkaXjKske5POGGusgxfv
	 CtFZiMOQP8EXv203xDDT6bRD8S5QN5SsiAIJN1S4=
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
Subject: [PATCH 6.18 0901/1518] perf bpf: Add PROG_TAGS to required arrays in __bpf_event__print_bpf_prog_info()
Date: Sat, 12 Sep 2026 08:51:10 +0200
Message-ID: <20260912065643.835544183@linuxfoundation.org>
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

[ Upstream commit 38ba525335c4399b15c9be0f81de304e94ccb462 ]

synthesize_bpf_prog_name() unconditionally dereferences prog_tags[sub_id]
(line: u8 (*prog_tags)[BPF_TAG_SIZE] = (void *)(uintptr_t)(info->prog_tags))
but __bpf_event__print_bpf_prog_info() only requires JITED_KSYMS and
JITED_FUNC_LENS in its required_arrays bitmask.

If a crafted perf.data has the PROG_TAGS bit cleared (or the array was
invalidated by bpil_offs_to_addr() bounds checking), info->prog_tags
contains either zero or a raw file offset.  Dereferencing it causes a
NULL pointer dereference or an arbitrary memory read.

Add PERF_BPIL_PROG_TAGS to required_arrays so the function returns early
when prog_tags was not present or failed validation.

Fixes: f8dfeae009effc0b ("perf bpf: Show more BPF program info in print_bpf_prog_info()")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Cc: Song Liu <songliubraving@fb.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 2294336f6e60b..195516356f62b 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -969,7 +969,8 @@ void __bpf_event__print_bpf_prog_info(struct perf_bpil *info_linear,
 {
 	struct bpf_prog_info *info = &info_linear->info;
 	__u64 required_arrays = (1UL << PERF_BPIL_JITED_KSYMS) |
-				(1UL << PERF_BPIL_JITED_FUNC_LENS);
+				(1UL << PERF_BPIL_JITED_FUNC_LENS) |
+				(1UL << PERF_BPIL_PROG_TAGS);
 	__u32 *prog_lens;
 	__u64 *prog_addrs;
 	char name[KSYM_NAME_LEN];
-- 
2.53.0



