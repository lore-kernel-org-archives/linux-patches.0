Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E51E1155389;
	Tue,  9 Jul 2024 11:13:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523617; cv=none; b=eixHQOVK96UP2hOlQnV7hkTDcbILXNNdGgqMW7BCLcUytD2kEv9iVa67lq3SeoublpS4TrvAk4HGZ46LFzrVN305WtoI9223kLUYF5Q844VTQnGCfZBWhAWxSUnFuBlkrxHoaLkvQ1YPsjNeRnEoP9N9Tnk+8GcGxLaTICsTac4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523617; c=relaxed/simple;
	bh=D0QP0jDVYKQKBRRoMdmQ4qlnulyI4wnqs/9ctiGohjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h3kCCkOa6JnvhRJeLE2NJzFH/q/RQyQOrIPKGzYJiP9pREr6yDuGg+8aI/DL0OLL7jHrQe9ebOsEuLosU7OMA7lWoCLa32pw53SnxFpbl5GD+4+yMNWxz+WLxbkVw7vCbIy+tM8pNbT5B54I8DZGQLqxmy6zrdoHJEWfVNUUqrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nd9oOhmb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nd9oOhmb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6C1C3277B;
	Tue,  9 Jul 2024 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523616;
	bh=D0QP0jDVYKQKBRRoMdmQ4qlnulyI4wnqs/9ctiGohjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nd9oOhmbBcr3u5miiWG12SK6SFWmCIbSR0ZF2OxOKsn6wpT+2bxqeXRtkRYxkeGXw
	 nmGv6MD5AZqyEidCa4Jt5JmhWBsEtxqn6F/qMevEdHz+V9a8qEkxn5QdNkoVpf/rH5
	 pdNDInhbYbJW/Sv8uPgt9RUQjU8IlyZToz88qrso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 012/139] selftests/bpf: do not pass NULL for non-nullable params in dummy_st_ops
Date: Tue,  9 Jul 2024 13:08:32 +0200
Message-ID: <20240709110658.628185407@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit f612210d456a0b969a0adca91e68dbea0e0ea301 ]

dummy_st_ops.test_2 and dummy_st_ops.test_sleepable do not have their
'state' parameter marked as nullable. Update dummy_st_ops.c to avoid
passing NULL for such parameters, as the next patch would allow kernel
to enforce this restriction.

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240424012821.595216-4-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c    | 7 +++++--
 tools/testing/selftests/bpf/progs/dummy_st_ops_success.c | 2 +-
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
index f43fcb13d2c46..dd926c00f4146 100644
--- a/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
+++ b/tools/testing/selftests/bpf/prog_tests/dummy_st_ops.c
@@ -98,7 +98,8 @@ static void test_dummy_init_ptr_arg(void)
 
 static void test_dummy_multiple_args(void)
 {
-	__u64 args[5] = {0, -100, 0x8a5f, 'c', 0x1234567887654321ULL};
+	struct bpf_dummy_ops_state st = { 7 };
+	__u64 args[5] = {(__u64)&st, -100, 0x8a5f, 'c', 0x1234567887654321ULL};
 	LIBBPF_OPTS(bpf_test_run_opts, attr,
 		.ctx_in = args,
 		.ctx_size_in = sizeof(args),
@@ -115,6 +116,7 @@ static void test_dummy_multiple_args(void)
 	fd = bpf_program__fd(skel->progs.test_2);
 	err = bpf_prog_test_run_opts(fd, &attr);
 	ASSERT_OK(err, "test_run");
+	args[0] = 7;
 	for (i = 0; i < ARRAY_SIZE(args); i++) {
 		snprintf(name, sizeof(name), "arg %zu", i);
 		ASSERT_EQ(skel->bss->test_2_args[i], args[i], name);
@@ -125,7 +127,8 @@ static void test_dummy_multiple_args(void)
 
 static void test_dummy_sleepable(void)
 {
-	__u64 args[1] = {0};
+	struct bpf_dummy_ops_state st;
+	__u64 args[1] = {(__u64)&st};
 	LIBBPF_OPTS(bpf_test_run_opts, attr,
 		.ctx_in = args,
 		.ctx_size_in = sizeof(args),
diff --git a/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c b/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
index cc7b69b001aae..ec0c595d47af8 100644
--- a/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
+++ b/tools/testing/selftests/bpf/progs/dummy_st_ops_success.c
@@ -34,7 +34,7 @@ SEC("struct_ops/test_2")
 int BPF_PROG(test_2, struct bpf_dummy_ops_state *state, int a1, unsigned short a2,
 	     char a3, unsigned long a4)
 {
-	test_2_args[0] = (unsigned long)state;
+	test_2_args[0] = state->val;
 	test_2_args[1] = a1;
 	test_2_args[2] = a2;
 	test_2_args[3] = a3;
-- 
2.43.0



