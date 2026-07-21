Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B603B47DF;
	Tue, 21 Jul 2026 21:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669420; cv=none; b=IH3o5NM4gOXUAAQFJ3ynodyqhFZsNh2zPVPZJiNnlT8zG1qoBfz1YNSREfig+J9crW2giar5TesefE0alOLx1oeeqGCSNH+RK7f77aPnrm03WkmYW5/0xtXMUPsNMwqyvYTfcOuV6Sj31HIZvVcIGIQt0FDCgqXjW1w2T2kOIpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669420; c=relaxed/simple;
	bh=/dYzJXnX2aZix3uSSiIegHU13T0+XPcKuIll3Pgsi1c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YilsNT3066+3Mg0FJ+sUHIxWd7s/9wOYU7dNSKsGwe4sOo+9Ci+P4vwvDc+nBpXL5hT3tUiZUhNgNGrQby7aNtNn8F+CmDOFwRzbiEOqaRgTIGavlZ2Ux1Gp6gteckyJjO4NkduoHb2Da10XxLgii1TDXTTmuqCFJI9AWrn1SLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G5SrHs2/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G5SrHs2/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05D611F000E9;
	Tue, 21 Jul 2026 21:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669417;
	bh=hQQXUL107unKM6YeMlMwSqt4ajM5d6NDtnG7D2Ebi/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G5SrHs2/VI+LKhrtEWit5gzEkwygDjz88f4M7V6GG6UsRXwOSevOeZzsfxXLmc0R+
	 /3UqyVh4IxFOHPwtZLWeCXFYyGnrq9myi9YLWepbrzQdyGuLDtK3wkBYbIAatwcsON
	 PpaTnILGz8rxJ94y6EEESaLBgRtV4TH11/1o+SeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0546/1067] perf bpf: Add NULL check for btf__type_by_id() in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:19:07 +0200
Message-ID: <20260721152436.825000592@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 903b0526dcf86d030c5970b4b0a67f9c227368e2 ]

synthesize_bpf_prog_name() calls btf__type_by_id() and immediately
dereferences the result via t->name_off without checking for NULL.
btf__type_by_id() returns NULL when the type_id is invalid or out
of range.  When processing perf.data files, finfo->type_id comes from
untrusted input, so an invalid ID causes a NULL pointer dereference.

Fix by checking t for NULL before dereferencing.

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Fixes: fc462ac75b36daaa ("perf bpf: Extract logic to create program names from perf_event__synthesize_one_bpf_prog()")
Cc: Song Liu <songliubraving@fb.com>
Assisted-by: Claude:claude-opus-4.6
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-event.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/bpf-event.c b/tools/perf/util/bpf-event.c
index d94e523b2cebbb..5a4138cbba89a0 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -201,7 +201,8 @@ static int synthesize_bpf_prog_name(char *buf, int size,
 	if (btf) {
 		finfo = func_infos + sub_id * info->func_info_rec_size;
 		t = btf__type_by_id(btf, finfo->type_id);
-		short_name = btf__name_by_offset(btf, t->name_off);
+		if (t)
+			short_name = btf__name_by_offset(btf, t->name_off);
 	} else if (sub_id == 0 && sub_prog_cnt == 1) {
 		/* no subprog */
 		if (info->name[0])
-- 
2.53.0



