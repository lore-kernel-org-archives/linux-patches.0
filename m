Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 287BA3AA4F9;
	Tue, 21 Jul 2026 22:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784673897; cv=none; b=DPvqmpWVD7PKa8VkZ3c03vMk+H6LheBJwqmgBaSGw5mru+nYi8SS09zFIC3uAiVtByPrOE1KneRENAci0jOk7auyyA4WFBbAk2EEx1t4OT4MAjkQyBuzl3GrD+Z8ms+SM07snpgRpVUtA/C+qwDAlAl7DD5wINuAjaAMrUR+Vc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784673897; c=relaxed/simple;
	bh=fmi5V7J4ZfDkpjmujVIXUuYugXIp0mYC7Hco/+5OxJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gAo+/eOGRZfRbR1ml9ylQh4mGd3TlIrk1WYZWXIEbsxHTvO6Tq921JhVApVQghF73PDcfhbnN8aMSFpfs2A1sQvp83PL95QaP7CpEGmMebhpV5DwnbgaIqRM9n7avSrvp77mxqu4B60qMBCU4YJnq5szeEd98q82pw6+yvXebcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=skiMu1Py; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="skiMu1Py"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE081F000E9;
	Tue, 21 Jul 2026 22:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784673896;
	bh=5KG+fEmR5ROGnXSglWyGkm2d6XTEqRqdCSk+hHExEfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=skiMu1PyBdS4SnpuiV6mIwAWNKvX5X2nC56MS85218SnsAS5AMxs5NFrwQTceBrEF
	 AwhY7XdhkbPqfpCGNMxa0si+xNepRNrJqMOfXsHB8YyA5j+2Ufpm5q0WPUAKpyKR4Q
	 RPTZrmoFNlHT4az3SdIIdWZHMc2loAICU3HB3vDE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 336/699] perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:21:35 +0200
Message-ID: <20260721152403.270025265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152355.667394603@linuxfoundation.org>
References: <20260721152355.667394603@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 386afcefbc30dd..f4d35213c90502 100644
--- a/tools/perf/util/bpf-event.c
+++ b/tools/perf/util/bpf-event.c
@@ -133,7 +133,9 @@ static int synthesize_bpf_prog_name(char *buf, int size,
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



