Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C819D47010C;
	Tue, 21 Jul 2026 19:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662846; cv=none; b=XBTTOWle4cxK6ykMIGMAYz2HWj+TugX4Am12dM/VH+rdFWXGwRHyQ+XrKbPl0bvecouienSmm6e2e5Yf5ehWzzmgUxsUg7ZHjin8ziPVFlmB4s0Rwreu/DmJsndUJeZ6W19ULot/81vhZ+lGHv5fOZK5V8NrTkbckKtPYk+L2ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662846; c=relaxed/simple;
	bh=shJHpP0WZ+o4jwDOiJZfnA6rCKkYAaMdFfRfbW46V1I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y6D3aZ1PG4Lp65vXnyDxB0+qg/w/UruCgmnQOfUCQVVZkvTM9c+msbJlmIg4kXCwFGav9AbBO7p+PmBxkkbMuEueCDs4qEsrcyz2KMTNP3ty7515p+RBI3spD9MeYnK+nZna/ooduvsrCAm6AWM5sNgEFEc3UUyNOaCeq7w/uxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QM4jHMM7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QM4jHMM7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A2C11F00A3A;
	Tue, 21 Jul 2026 19:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662845;
	bh=YtSXtus0NzSj9fm4ynzoOGfvPHafazg0CWX/nAG6dYM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QM4jHMM7+FT7n8lza4cqGF+LEQxnb5Pdx4EIozE7M7DOK7JAa2AHHchtJaCDTh+HM
	 geTvKmd6KZmf4JQ4OP3+N8r4AQgSPKC818SxtzQftq9juVpkyCQnc5Au/i7Axjd7WC
	 SiHuVk41WcywSGEFyEL/WtBp46UH/h/R+jj8wvwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0556/1276] perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:16:39 +0200
Message-ID: <20260721152458.559434067@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 10b3c3d63ecc17c6acb855bac5f40367f1115765 ]

synthesize_bpf_prog_name() computes a pointer into the func_info array
using sub_id * info->func_info_rec_size without validating either value.
Both come from perf.data and are untrusted:

- A func_info_rec_size smaller than sizeof(struct bpf_func_info) means
  the finfo pointer would reference a truncated entry, reading past it
  into adjacent data.

- A sub_id >= nr_func_info computes an offset past the func_info buffer,
  causing an out-of-bounds read.

Add bounds checks for both values before computing the pointer offset.
When validation fails, fall through to the non-BTF name path instead
of reading garbage.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: 7b612e291a5affb1 ("perf tools: Synthesize PERF_RECORD_* for loaded BPF programs")
Cc: Song Liu <songliubraving@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index 6c9a4a1b80a24c..db89053ce96808 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -135,7 +135,9 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	name_len = scnprintf(buf, size, "bpf_prog_");
 	name_len += snprintf_hex(buf + name_len, size - name_len,
 				 prog_tags[sub_id], BPF_TAG_SIZE);
-	if (btf) {
+	if (btf &&
+	    info->func_info_rec_size >= sizeof(*finfo) &&
+	    sub_id < info->nr_func_info) {
 		finfo = func_infos + sub_id * info->func_info_rec_size;
 		t = btf__type_by_id(btf, finfo->type_id);
 		if (t)
-- 
2.53.0



