Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D5C75801;
	Tue, 21 Jul 2026 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657482; cv=none; b=bLkLnA44o1O4u/bqYDAerxxvsiqm+YTXyh5RQwEWSIL/ooNUHeY20PUTwWvPLrbJrpXqWOi9DJKHvOhbmnfGXEZCMVbjK0qX/QwzoFE9LKJWp8te+Ou+/3PHNH+tRWQk4jKoE+jHX0mh54IyMS9NH7rFY6GCOdA0gOtLlzj9ypQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657482; c=relaxed/simple;
	bh=1EWgLOrJNa6ZQWJFlpLrmqfQ7Xek5g+vIodKzipL3Yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cIs0yqKjL+nDpd7RzR0UFgX2KEj1ECLVLGXE9xg3JFSZFlivBQCL1kidr3WAXUr9ZSuftO95fc1xdzfLfR4wLTwE8HoXa1gNqJ070KOkmrK8+loTxOam6TsxpvYE6ePzwwE4lnO14gX08YS4ZQHeLC6FzqNWHSQElRSBskW0NMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hACDBw9k; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hACDBw9k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E605F1F000E9;
	Tue, 21 Jul 2026 18:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657481;
	bh=f8G7dUlQrbfdX1+FgdAqVW4HF88uY3T8Y3gSbZMVCKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hACDBw9kPvxgxSzD93SLx/kE4fy/ZrmVhbo6qW2HhUsJy8PjKdoe9TUeu2ow5NuoU
	 F2v9xU3Wvm5Ff8vhUhfNHlsGFSXPELeZanVvAjWUq8UoT4mCEzQDr1o2uX0lXauATn
	 HUIQvzDRbVH9jc5G5dcW5gKNBFOZNpwXridjz0LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Song Liu <songliubraving@fb.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0780/1611] perf bpf: Validate func_info_rec_size and sub_id in synthesize_bpf_prog_name()
Date: Tue, 21 Jul 2026 17:14:56 +0200
Message-ID: <20260721152532.930406619@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index 2f5908cc8bd6f5..d5ae6a157ac62b 100644
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



