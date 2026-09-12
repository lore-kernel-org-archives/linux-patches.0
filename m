Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90D4E3A1690;
	Sat, 12 Sep 2026 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201999; cv=none; b=dRuw7mOwm3rN0Bgc29sgugdzMFTnc5FhwL+rYx+5BdNLGVyl45iUWDV+60b3elRWbRD1aYZQf2axvKSEnMxsLZWfzkKnQoKK+pjB1mEpbfZdEpahaBxNFrsXgN+0JGFigKBhhm86ElayFnaw/HJyBSnqk2fYI2mZR5J0b8I9sfE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201999; c=relaxed/simple;
	bh=lINRQKmBGge6j5FQ5Nkrzr4BCFqC3IrukSS46tkHVu8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=efAAueFAEVxpvGgask8vf/uUETwYgy9JLjii5ka8+BARcZMcXhE/urrcr3o4G/prWXTyH9oBAZaZhlsS3crYkuXnotsp4rcFG/fUIHobwCpl+59FDxFouNrI12hyPhLBR8pKwMffn6u1dAZMBnz8cyCQkB11+BHmkUX8ScPORGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vDxL4wtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vDxL4wtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96FF21F000FF;
	Sat, 12 Sep 2026 08:33:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201998;
	bh=ufEMNm/yjXZBEEoiBUSWtkVxZg4lSGpUNqfZrR+Y4Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vDxL4wtnbyW/DjjMk/sb/o+RvDDwMGl4lzca+7awOLBO+xW5IZJ+DP2tsZy16WcWV
	 FRfE+AKeSawaMPDaNY3RUAqbmgYYVg9faZQz58Sa3N2bxOZoWVVodTXMN1sfOw4SfD
	 DaOxnHFAysq6mq8JOdb+KhawFbd4eVT6zosrRzO4=
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
Subject: [PATCH 7.2 1113/1815] perf bpf: Add PROG_TAGS to required arrays in __bpf_event__print_bpf_prog_info()
Date: Sat, 12 Sep 2026 08:47:43 +0200
Message-ID: <20260912065715.147551808@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index fa3ebc8ea7f09..e67f28a8e92bd 100644
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



