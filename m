Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CC79432E65;
	Thu, 30 Jul 2026 14:27:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421632; cv=none; b=mkRxFqZhne4gl/kM2S4fjq2XrbuKNnqw+sZXvJpwvAXcoIkYExJg5tJT8avgLa8CKgAWHcH/Cj4myITJpR80J7ISR179hdOvtENyMrIk8+Wds21q+lp8FDLvFE6hZ7VQYkX7iJ0MsFE+gtv+lNsox5w8Z1JjnMrmqJjjzHNHL0g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421632; c=relaxed/simple;
	bh=2YAh/P5R+i3MeUJIQCYtf1kY6HQLe6X9LOZAXQYd6Rk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRArI8TjR5dl8QcFjijJo/uZq1uLGzCQP56dT1ZHcAbBzgobswztpsa9iGWpo1su2P17sIH7ONaxw9sizv6PPJ0bQEyph1TeAOImjtKAzcFpwWNvB5kPDEbOti5S8Y1a/M2nDMhISbNd7N4FDnHaqOlShJJ5BVrBoain5bPG0Zo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPo/MR9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPo/MR9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECE7A1F000E9;
	Thu, 30 Jul 2026 14:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421631;
	bh=tNdVtVH0bGVEeF/Ij3grzyK4+tO+yenLnBhnUxGLI60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPo/MR9P/6ofz6XkGKu7Uy3YrMTIZMbhFSacwLk4UU3wUTg6nDnd+oG76lO2D+t/N
	 Gl6AZ6JV40ZhpAMmY6wdKnevbWclhM0orYrlKScLi7mGBcF0rcwuUEBmcOVS8C1ejD
	 LdxjmAe3pWvZK81n33UCEaMYAeCQ1bKVXP3N4gps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 167/744] selftests/bpf: Keep verifier_map_ptr exercising ops pointer access
Date: Thu, 30 Jul 2026 16:07:20 +0200
Message-ID: <20260730141447.843205716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

From: Daniel Borkmann <daniel@iogearbox.net>

commit 082c412097716b93ff1365689fc4ddcd1ce8296f upstream.

sashiko complained that 38498c0ebacd ("selftests/bpf: Adjust verifier_map_ptr
for the map's excl field") would slightly decrease the test coverage given
before the test was against the verifier rejecting the ops pointer. Recover
the old test with the right offsets and add the existing one as an additional
test case.

  # LDLIBS=-static PKG_CONFIG='pkg-config --static' ./vmtest.sh -- ./test_progs -t verifier_map_ptr
  [    1.672932] bpf_testmod: module verification failed: signature and/or required key missing - tainting kernel
  #637/1   verifier_map_ptr/bpf_map_ptr: read with negative offset rejected:OK
  #637/2   verifier_map_ptr/bpf_map_ptr: read with negative offset rejected @unpriv:OK
  #637/3   verifier_map_ptr/bpf_map_ptr: write rejected:OK
  #637/4   verifier_map_ptr/bpf_map_ptr: write rejected @unpriv:OK
  #637/5   verifier_map_ptr/bpf_map_ptr: read non-existent field rejected:OK
  #637/6   verifier_map_ptr/bpf_map_ptr: read non-existent field rejected @unpriv:OK
  #637/7   verifier_map_ptr/bpf_map_ptr: read beyond excl field rejected:OK
  #637/8   verifier_map_ptr/bpf_map_ptr: read beyond excl field rejected @unpriv:OK
  #637/9   verifier_map_ptr/bpf_map_ptr: read ops field accepted:OK
  #637/10  verifier_map_ptr/bpf_map_ptr: read ops field accepted @unpriv:OK
  #637/11  verifier_map_ptr/bpf_map_ptr: r = 0, map_ptr = map_ptr + r:OK
  #637/12  verifier_map_ptr/bpf_map_ptr: r = 0, map_ptr = map_ptr + r @unpriv:OK
  #637/13  verifier_map_ptr/bpf_map_ptr: r = 0, r = r + map_ptr:OK
  #637/14  verifier_map_ptr/bpf_map_ptr: r = 0, r = r + map_ptr @unpriv:OK
  #637     verifier_map_ptr:OK
  [...]
  Summary: 2/20 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260602133052.423725-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_map_ptr.c    | 34 ++++++++++++++++---
 1 file changed, 30 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/bpf/progs/verifier_map_ptr.c b/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
index d8e822d1a8bab6..1661936598703c 100644
--- a/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
+++ b/tools/testing/selftests/bpf/progs/verifier_map_ptr.c
@@ -72,17 +72,43 @@ __naked void bpf_map_ptr_write_rejected(void)
 
 /*
  * struct bpf_map starts with the SHA256 hash sha[32] at offset 0 (a readable
- * byte array), followed by the u32 excl field at offset 32. Reading a u32 at
- * offset 33 runs past the end of excl and is rejected.
+ * byte array), the u32 excl field at offset 32, and the ops pointer at offset
+ * 40. Reading a u32 at offset 41 reaches into the middle of the ops pointer,
+ * i.e. a partial pointer access, which is rejected.
  */
 SEC("socket")
 __description("bpf_map_ptr: read non-existent field rejected")
 __failure
-__msg("access beyond the end of member excl (mend:36) in struct bpf_map with off 33 size 4")
+__msg("cannot access ptr member ops with moff 40 in struct bpf_map with off 41 size 4")
 __failure_unpriv
 __msg_unpriv("access is allowed only to CAP_PERFMON and CAP_SYS_ADMIN")
 __flag(BPF_F_ANY_ALIGNMENT)
 __naked void read_non_existent_field_rejected(void)
+{
+	asm volatile ("					\
+	r6 = 0;						\
+	r1 = %[map_array_48b] ll;			\
+	r6 = *(u32*)(r1 + 41);				\
+	r0 = 1;						\
+	exit;						\
+"	:
+	: __imm_addr(map_array_48b)
+	: __clobber_all);
+}
+
+/*
+ * The u32 excl field spans offsets 32..35 (mend 36). Reading a u32 at offset
+ * 33 starts inside excl but extends past its end, which the verifier rejects
+ * as an out-of-bounds scalar access.
+ */
+SEC("socket")
+__description("bpf_map_ptr: read beyond excl field rejected")
+__failure
+__msg("access beyond the end of member excl (mend:36) in struct bpf_map with off 33 size 4")
+__failure_unpriv
+__msg_unpriv("access is allowed only to CAP_PERFMON and CAP_SYS_ADMIN")
+__flag(BPF_F_ANY_ALIGNMENT)
+__naked void read_beyond_excl_field_rejected(void)
 {
 	asm volatile ("					\
 	r6 = 0;						\
@@ -105,7 +131,7 @@ __naked void ptr_read_ops_field_accepted(void)
 	asm volatile ("					\
 	r6 = 0;						\
 	r1 = %[map_array_48b] ll;			\
-	r6 = *(u64*)(r1 + 0);				\
+	r6 = *(u64*)(r1 + 40);				\
 	r0 = 1;						\
 	exit;						\
 "	:
-- 
2.53.0



