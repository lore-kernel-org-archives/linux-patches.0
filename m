Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62FB14BFA2;
	Sun,  7 Sep 2025 20:19:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757276381; cv=none; b=K2qfbs3D1azbENTTwlOOiSeYMJtiLBjIRDrYFFj8taNyMH6WAcBUS/wx3ZZTCzzqgdJE//GvXyl/4lq9fDsAuKHoA1xdcPw72/EXxp5G9YJoF85eUhmpOE5XBzoa6qtCNsBku/wpzfvws/AyMy21zYk7gENv5oOlv3bmtPmbAds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757276381; c=relaxed/simple;
	bh=ssaiwajrfMlwhUivW9ETHeYzqQ81UOBvTjeta0QzNTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAUUS73ku3eoYLZdKG9bG6I0HP3Gzb/yEz/6VMag+sFdaWcpp3zEIusWYWb3xD9KRn9XIptVdSJrQH7FASUYmgcTtxj4GqhbWLIXvIu/m03XTS8Xrgc43nGkqM+BkLrRm6mml1QmDdJmh2XaiqJTygANpS6gO7LDBE/+U0gWMNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fQXfGgZb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fQXfGgZb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED15AC4CEF0;
	Sun,  7 Sep 2025 20:19:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757276381;
	bh=ssaiwajrfMlwhUivW9ETHeYzqQ81UOBvTjeta0QzNTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQXfGgZb0+32ANZkxGRZSL60Qw7TwfDq6/efYX/NECEVvltFkHbMWVggxJY/RgMNi
	 6EtJ7JIBcm8fpVNuzxqizsHkPu7FgexUMoabHPgUildh5QjHA0EWUBjcnRhNZI0RZ1
	 1xoDOBrZI0OZOwOuTsQHTv6yj2QBoFwSQew+wKto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Namhyung Kim <namhyung@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 087/104] perf bpf-utils: Harden get_bpf_prog_info_linear
Date: Sun,  7 Sep 2025 21:58:44 +0200
Message-ID: <20250907195609.929521679@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195607.664912704@linuxfoundation.org>
References: <20250907195607.664912704@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit 01be43f2a0eaeed83e94dee054742f37625c86d9 ]

In get_bpf_prog_info_linear two calls to bpf_obj_get_info_by_fd are
made, the first to compute memory requirements for a struct perf_bpil
and the second to fill it in. Previously the code would warn when the
second call didn't match the first. Such races can be common place in
things like perf test, whose perf trace tests will frequently load BPF
programs. Rather than a debug message, return actual errors for this
case. Out of paranoia also validate the read bpf_prog_info array
value. Change the type of ptr to avoid mismatched pointer type
compiler warnings. Add some additional debug print outs and sanity
asserts.

Closes: https://lore.kernel.org/lkml/CAP-5=fWJQcmUOP7MuCA2ihKnDAHUCOBLkQFEkQES-1ZZTrgf8Q@mail.gmail.com/
Fixes: 6ac22d036f86 ("perf bpf: Pull in bpf_program__get_prog_info_linear()")
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250902181713.309797-4-irogers@google.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf-utils.c | 43 ++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/bpf-utils.c b/tools/perf/util/bpf-utils.c
index 64a5583446964..5a66dc8594aa8 100644
--- a/tools/perf/util/bpf-utils.c
+++ b/tools/perf/util/bpf-utils.c
@@ -115,7 +115,7 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 	__u32 info_len = sizeof(info);
 	__u32 data_len = 0;
 	int i, err;
-	void *ptr;
+	__u8 *ptr;
 
 	if (arrays >> PERF_BPIL_LAST_ARRAY)
 		return ERR_PTR(-EINVAL);
@@ -126,6 +126,8 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 		pr_debug("can't get prog info: %s", strerror(errno));
 		return ERR_PTR(-EFAULT);
 	}
+	if (info.type >= __MAX_BPF_PROG_TYPE)
+		pr_debug("%s:%d: unexpected program type %u\n", __func__, __LINE__, info.type);
 
 	/* step 2: calculate total size of all arrays */
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
@@ -173,6 +175,8 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 					     desc->count_offset, count);
 		bpf_prog_info_set_offset_u32(&info_linear->info,
 					     desc->size_offset, size);
+		assert(ptr >= info_linear->data);
+		assert(ptr < &info_linear->data[data_len]);
 		bpf_prog_info_set_offset_u64(&info_linear->info,
 					     desc->array_offset,
 					     ptr_to_u64(ptr));
@@ -186,26 +190,45 @@ get_bpf_prog_info_linear(int fd, __u64 arrays)
 		free(info_linear);
 		return ERR_PTR(-EFAULT);
 	}
+	if (info_linear->info.type >= __MAX_BPF_PROG_TYPE) {
+		pr_debug("%s:%d: unexpected program type %u\n",
+			 __func__, __LINE__, info_linear->info.type);
+	}
 
 	/* step 6: verify the data */
+	ptr = info_linear->data;
 	for (i = PERF_BPIL_FIRST_ARRAY; i < PERF_BPIL_LAST_ARRAY; ++i) {
 		const struct bpil_array_desc *desc = &bpil_array_desc[i];
-		__u32 v1, v2;
+		__u32 count1, count2, size1, size2;
+		__u64 ptr2;
 
 		if ((arrays & (1UL << i)) == 0)
 			continue;
 
-		v1 = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
-		v2 = bpf_prog_info_read_offset_u32(&info_linear->info,
+		count1 = bpf_prog_info_read_offset_u32(&info, desc->count_offset);
+		count2 = bpf_prog_info_read_offset_u32(&info_linear->info,
 						   desc->count_offset);
-		if (v1 != v2)
-			pr_warning("%s: mismatch in element count\n", __func__);
+		if (count1 != count2) {
+			pr_warning("%s: mismatch in element count %u vs %u\n", __func__, count1, count2);
+			free(info_linear);
+			return ERR_PTR(-ERANGE);
+		}
 
-		v1 = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
-		v2 = bpf_prog_info_read_offset_u32(&info_linear->info,
+		size1 = bpf_prog_info_read_offset_u32(&info, desc->size_offset);
+		size2 = bpf_prog_info_read_offset_u32(&info_linear->info,
 						   desc->size_offset);
-		if (v1 != v2)
-			pr_warning("%s: mismatch in rec size\n", __func__);
+		if (size1 != size2) {
+			pr_warning("%s: mismatch in rec size %u vs %u\n", __func__, size1, size2);
+			free(info_linear);
+			return ERR_PTR(-ERANGE);
+		}
+		ptr2 = bpf_prog_info_read_offset_u64(&info_linear->info, desc->array_offset);
+		if (ptr_to_u64(ptr) != ptr2) {
+			pr_warning("%s: mismatch in array %p vs %llx\n", __func__, ptr, ptr2);
+			free(info_linear);
+			return ERR_PTR(-ERANGE);
+		}
+		ptr += roundup(count1 * size1, sizeof(__u64));
 	}
 
 	/* step 7: update info_len and data_len */
-- 
2.51.0



