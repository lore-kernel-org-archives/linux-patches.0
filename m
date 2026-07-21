Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476BC40683D;
	Tue, 21 Jul 2026 19:04:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660696; cv=none; b=oJcPAQgu/u2IFT8SNTPHZhuJ2L5bKkLb3GJZaAaxr4mn85swnRM2vBTu+2voEO7P0jYB29jwzIazoOJ9VND9d+yD93JXVoiXQgdHQhY8P2UbFcL/k2GOaG/Zyl0InNmExwarRQtW67jhgiuD0wg1dUrfxAsDNoVSh7nTvHPyAHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660696; c=relaxed/simple;
	bh=2GwIg2i1cCsb97qEiS5mVDaNntA0x9pkuodXGbYqmK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d657YAZoykEHbyiY2SE6swuemxdbF6gp+qyWua1nqFxrCR96dsjapg4b8F1lRkZpDFIUEl5xLF8etvQ97YdhnAjFV6SXS1+2A6/w7VK56MJq1pCLPhBH3EMnQ0bWwqONl7NIG3LMDJUp+UU43lpWYnMhzem/lQnF3i7BAbuu/PI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GVzT0A9B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GVzT0A9B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB2C1F000E9;
	Tue, 21 Jul 2026 19:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660695;
	bh=KCSTBImZgclWMuBAoFxtoVZZEYYzh04Xf4OqLtwYeoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GVzT0A9Bib4ufNaqsdyq7cgwHupDHzSrtTQPegLcTZ0VJ/fQskdFS6Z8YwIYSGkuJ
	 gesQZyf2gn1noGGKvK8ABXY85+MuzryDq0mDYiwSMasF6zIIwH80wmIHQiedzhrVSb
	 t/gCJGeX/Hr3BBiYFSzQUbz8If0BJddIj0OUCfaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1077/2077] perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:12:30 +0200
Message-ID: <20260721152618.224983458@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index c4594969d76772..fe6fbca508c513 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -143,7 +143,9 @@ static int synthesize_bpf_prog_name(char *buf, int size,
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



