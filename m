Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00DFD36606A;
	Sat, 12 Sep 2026 07:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199752; cv=none; b=YlmQfJiyIpBtB3xUff4RqbhFRldgYV4Mfs4ZIcgfQeOPKuMhZK8bhpr4IK4zI9YTf6OB0wY0+OC0K2MjvPR9jfwxOVYKai1xUN0cB67qFx0skGfrLZYZvhpDFvmj0yrT34YzSzuFbg+0qOQAS7JGMj25RYXeBWjN3enEJAjBjfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199752; c=relaxed/simple;
	bh=R4RR04HrTXjmhrT0nzmWOe426fv2XiZNsYjO6oB/nTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dO1OgSMJV886MfW/hWiV2VY67hrXHX6GOn8E9QO8epF1HUW2P9oxO8YjebIvSZsCGgVqG5kwd3n6cTQdmAk8PsCuprp5xiEF+FExhElU+H5WcXhpxg4mOeJFhKKfO+SCNQhBqA5geByHj6zM4VId/9xglEQiGyv6fa++bpkOQ+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HX4gqila; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HX4gqila"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C854B1F000FF;
	Sat, 12 Sep 2026 07:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199750;
	bh=bN2i8VJ9Yi9zUDCKyGmSHt3VWK/mIyNfSu2oOLlXc1c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HX4gqila8qAnLBTtekmLREzgwNXDTWZAPBK7YkOB0HXWoMHAZGptqZaNHh2yC/7pv
	 nlUKLXNAqIWVkZTOc5YsP0cxMwund4TGskOecNLAfnhOA+xIGL1bSX65A0/vpDOYrt
	 XHVpN4wAT9iyRIIVzZ4sH8lxKuvgQiyj672YNH5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Feng Yang <yangfeng@kylinos.cn>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0650/1815] selftests/bpf: Fix missing allocation null checks in test_progs.c
Date: Sat, 12 Sep 2026 08:40:00 +0200
Message-ID: <20260912065704.139050497@linuxfoundation.org>
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

From: Feng Yang <yangfeng@kylinos.cn>

[ Upstream commit 12b362b2f06b283b7d8a2450f702f9b6a0f94aed ]

Add null checks after memory allocations to prevent potential segmentation faults.

Fixes: 79b453501310 ("tools/bpf: add a test for bpf_get_stack with tracepoint prog")
Fixes: 0925225956bb ("bpf/selftests: Add granular subtest output for prog_test")
Signed-off-by: Feng Yang <yangfeng@kylinos.cn>
Link: https://lore.kernel.org/bpf/20260723085100.482147-4-yangfeng59949@163.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/test_progs.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/test_progs.c b/tools/testing/selftests/bpf/test_progs.c
index 643c199c3e0c1..ded892f8777b7 100644
--- a/tools/testing/selftests/bpf/test_progs.c
+++ b/tools/testing/selftests/bpf/test_progs.c
@@ -730,11 +730,14 @@ int compare_map_keys(int map1_fd, int map2_fd)
 int compare_stack_ips(int smap_fd, int amap_fd, int stack_trace_len)
 {
 	__u32 key, next_key, *cur_key_p, *next_key_p;
-	char *val_buf1, *val_buf2;
-	int i, err = 0;
+	char *val_buf1 = NULL, *val_buf2 = NULL;
+	int i, err = -ENOMEM;
 
 	val_buf1 = malloc(stack_trace_len);
 	val_buf2 = malloc(stack_trace_len);
+	if (!val_buf1 || !val_buf2)
+		goto out;
+	err = 0;
 	cur_key_p = NULL;
 	next_key_p = &key;
 	while (bpf_map_get_next_key(smap_fd, cur_key_p, next_key_p) == 0) {
@@ -1514,6 +1517,10 @@ static int dispatch_thread_send_subtests(int sock_fd, struct test_state *state)
 	int subtest_num = state->subtest_num;
 
 	state->subtest_states = malloc(subtest_num * sizeof(*subtest_state));
+	if (!state->subtest_states) {
+		state->subtest_num = 0;
+		return -ENOMEM;
+	}
 
 	for (int i = 0; i < subtest_num; i++) {
 		subtest_state = &state->subtest_states[i];
-- 
2.53.0



