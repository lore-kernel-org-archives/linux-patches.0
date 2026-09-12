Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1DFE3FC5B5;
	Sat, 12 Sep 2026 08:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789201990; cv=none; b=rHhHAAp0X7g/UK3Ds7MZ5X+B0kz8Qcv7rcntutAov38UyY7DOZP0f4HrcPjZY3Wi03KarGECuIwsr8Igw1y0KOcimpruldHh+O22CQOoBUtQBKYxX2WjhbP9xq1pEBONHMamYc+b/dbPWroPUllpv5cCpu3zDf41rqfN0ZRtbn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789201990; c=relaxed/simple;
	bh=QHjHqo8Fatz5OgqifRzAtdY5iKRtILKP/0vezqZIvFw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cihp+9qwR/64XiIWbb9tgwVQStsh7CBDvjROqMuh0TvVG5VmrVmtTFYpwYmQLDS1qKPFmmh14Fdx4CZ9ytDGUU+Y/FW6N8KcGxtpeCIOUM4tMpTCERZql8k+A6jnRl6uAUrP+ZcoambZ2Y5mO1LuFS0w83EwYbQ3klUsIU+fy5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aIA56N/I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aIA56N/I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D86201F000FF;
	Sat, 12 Sep 2026 08:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789201988;
	bh=TUdTG9aYd7o22IUDNwhob7W1uNWauUHjm9RecHWSu1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aIA56N/ImLAK82Z15ZZffJHEaRIHHag5CXGfN2JeTbVajAgBwa8Tu0QVYKrUZFX+d
	 HOfg+HYiD+dOlqSQnzWExhLa7dyvztGo9vMhQNj3sYg73lZcpNHqna4weA8atrAnqu
	 dJ15J6HiAqsh9C1mHx0zxLa2jE7jZwXqBo/ac7nk=
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
Subject: [PATCH 7.2 1111/1815] perf libbfd: Validate BPF prog info arrays before pointer cast
Date: Sat, 12 Sep 2026 08:47:41 +0200
Message-ID: <20260912065715.100017351@linuxfoundation.org>
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
index c1c12308cc12f..d6c2d9807fc9c 100644
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



