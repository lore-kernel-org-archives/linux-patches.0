Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E8A18E03A;
	Mon, 28 Oct 2024 06:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097790; cv=none; b=nNvZQiW6LxG3AecbAWSdhjzFUHxFeQB1KJetGp82CdnsgoRDJpnDT20tXXn+/YHDv1pvdeOUZL73D63lAQ6NBxngbJLCj/GATG3gdY58y6WdCrd3bHLnIx5kJliKG4XSYDLfdR9+b1E8jZMHobEOOZQCXn2gF6XrfBznSQ9cRCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097790; c=relaxed/simple;
	bh=sasILKbZ4Zw2fcSOTNGqGxva6G7f14cJYAYv0/GoSr8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NEiv4TAV9jLMwmJzLue2+/Hy7uvGOHZSzeywV+MR2pZsDZPezv1Ab4YSII/PmUchlTX/D6sh/sV7UQoVNiVJQr/vcaBorfj33xbEZSKLB/YT/9GAVTvJIQNRT3h8gChar/j93w++qbsblB8jAqnA1xEVC7oxMlkgTxn8pil6GIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cPfvakwG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cPfvakwG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48244C4CEC7;
	Mon, 28 Oct 2024 06:43:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097790;
	bh=sasILKbZ4Zw2fcSOTNGqGxva6G7f14cJYAYv0/GoSr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPfvakwG6BsXTtTm3lptIOhZ+md8hN2RcyNEj++WAPZ6gihSOSBtY30Eopw7YUkQy
	 j+BFNx0Urtyjli1ghKs3JM6Be4iXqLfNd35COaUROz0PtakKFPrDAfiXIh+EnxZEnT
	 VL+f4xXZpD3vFqaGV73Er8eqGmQFxVsGGMdv0+Bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Matei <andreimatei1@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/208] bpf: Simplify checking size of helper accesses
Date: Mon, 28 Oct 2024 07:25:29 +0100
Message-ID: <20241028062310.298229048@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

From: Andrei Matei <andreimatei1@gmail.com>

[ Upstream commit 8a021e7fa10576eeb3938328f39bbf98fe7d4715 ]

This patch simplifies the verification of size arguments associated to
pointer arguments to helpers and kfuncs. Many helpers take a pointer
argument followed by the size of the memory access performed to be
performed through that pointer. Before this patch, the handling of the
size argument in check_mem_size_reg() was confusing and wasteful: if the
size register's lower bound was 0, then the verification was done twice:
once considering the size of the access to be the lower-bound of the
respective argument, and once considering the upper bound (even if the
two are the same). The upper bound checking is a super-set of the
lower-bound checking(*), except: the only point of the lower-bound check
is to handle the case where zero-sized-accesses are explicitly not
allowed and the lower-bound is zero. This static condition is now
checked explicitly, replacing a much more complex, expensive and
confusing verification call to check_helper_mem_access().

Error messages change in this patch. Before, messages about illegal
zero-size accesses depended on the type of the pointer and on other
conditions, and sometimes the message was plain wrong: in some tests
that changed you'll see that the old message was something like "R1 min
value is outside of the allowed memory range", where R1 is the pointer
register; the error was wrongly claiming that the pointer was bad
instead of the size being bad. Other times the information that the size
came for a register with a possible range of values was wrong, and the
error presented the size as a fixed zero. Now the errors refer to the
right register. However, the old error messages did contain useful
information about the pointer register which is now lost; recovering
this information was deemed not important enough.

(*) Besides standing to reason that the checks for a bigger size access
are a super-set of the checks for a smaller size access, I have also
mechanically verified this by reading the code for all types of
pointers. I could convince myself that it's true for all but
PTR_TO_BTF_ID (check_ptr_to_btf_access). There, simply looking
line-by-line does not immediately prove what we want. If anyone has any
qualms, let me know.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20231221232225.568730-2-andreimatei1@gmail.com
Stable-dep-of: 8ea607330a39 ("bpf: Fix overloading of MEM_UNINIT's meaning")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                                  | 10 ++++------
 .../selftests/bpf/progs/verifier_helper_value_access.c |  8 ++++----
 tools/testing/selftests/bpf/progs/verifier_raw_stack.c |  2 +-
 3 files changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 28b09ca5525f0..f24d570d67ca5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7324,12 +7324,10 @@ static int check_mem_size_reg(struct bpf_verifier_env *env,
 		return -EACCES;
 	}
 
-	if (reg->umin_value == 0) {
-		err = check_helper_mem_access(env, regno - 1, 0,
-					      zero_size_allowed,
-					      meta);
-		if (err)
-			return err;
+	if (reg->umin_value == 0 && !zero_size_allowed) {
+		verbose(env, "R%d invalid zero-sized read: u64=[%lld,%lld]\n",
+			regno, reg->umin_value, reg->umax_value);
+		return -EACCES;
 	}
 
 	if (reg->umax_value >= BPF_MAX_VAR_SIZ) {
diff --git a/tools/testing/selftests/bpf/progs/verifier_helper_value_access.c b/tools/testing/selftests/bpf/progs/verifier_helper_value_access.c
index 692216c0ad3d4..3e8340c2408f3 100644
--- a/tools/testing/selftests/bpf/progs/verifier_helper_value_access.c
+++ b/tools/testing/selftests/bpf/progs/verifier_helper_value_access.c
@@ -91,7 +91,7 @@ l0_%=:	exit;						\
 
 SEC("tracepoint")
 __description("helper access to map: empty range")
-__failure __msg("invalid access to map value, value_size=48 off=0 size=0")
+__failure __msg("R2 invalid zero-sized read")
 __naked void access_to_map_empty_range(void)
 {
 	asm volatile ("					\
@@ -221,7 +221,7 @@ l0_%=:	exit;						\
 
 SEC("tracepoint")
 __description("helper access to adjusted map (via const imm): empty range")
-__failure __msg("invalid access to map value, value_size=48 off=4 size=0")
+__failure __msg("R2 invalid zero-sized read")
 __naked void via_const_imm_empty_range(void)
 {
 	asm volatile ("					\
@@ -386,7 +386,7 @@ l0_%=:	exit;						\
 
 SEC("tracepoint")
 __description("helper access to adjusted map (via const reg): empty range")
-__failure __msg("R1 min value is outside of the allowed memory range")
+__failure __msg("R2 invalid zero-sized read")
 __naked void via_const_reg_empty_range(void)
 {
 	asm volatile ("					\
@@ -556,7 +556,7 @@ l0_%=:	exit;						\
 
 SEC("tracepoint")
 __description("helper access to adjusted map (via variable): empty range")
-__failure __msg("R1 min value is outside of the allowed memory range")
+__failure __msg("R2 invalid zero-sized read")
 __naked void map_via_variable_empty_range(void)
 {
 	asm volatile ("					\
diff --git a/tools/testing/selftests/bpf/progs/verifier_raw_stack.c b/tools/testing/selftests/bpf/progs/verifier_raw_stack.c
index f67390224a9cf..7cc83acac7271 100644
--- a/tools/testing/selftests/bpf/progs/verifier_raw_stack.c
+++ b/tools/testing/selftests/bpf/progs/verifier_raw_stack.c
@@ -64,7 +64,7 @@ __naked void load_bytes_negative_len_2(void)
 
 SEC("tc")
 __description("raw_stack: skb_load_bytes, zero len")
-__failure __msg("invalid zero-sized read")
+__failure __msg("R4 invalid zero-sized read: u64=[0,0]")
 __naked void skb_load_bytes_zero_len(void)
 {
 	asm volatile ("					\
-- 
2.43.0



