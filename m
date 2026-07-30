Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97A27407597;
	Thu, 30 Jul 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785423791; cv=none; b=E+GTXkc9QTGCYkJqZFx09jJSBQdXYpi+U+e8QmjPA9yGycd+k1bWDEJ248hUWc2sZAg/SRQiyB4U80OIwAQApy48b+bH+3hSISDFFb4WKAnNnrHclkQH/wkqc+lLq/WWxXJxAwMYep6wnzKEyloUGokTPoWn9vO8CRdz4OabiHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785423791; c=relaxed/simple;
	bh=hxsmH8iaDZsqL8bGSebIjUvNWNAp7oFkbQw0hZQJaDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0pr3YR5OFAlQYR3IliiwmQZrfSgNZOlOVHjs4VfPluDXotEoTshMRhN77q2X9ZgY6i3CLytd5OwNRalrB5ObGgtZheWvMY/HMJHy5hJLV0hBVto/80rAdm3gix41lwpki+fLkl++dSZGjTWhiAsywtEvOlV6cT1axGdkZ9CZ4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cm/tLyTv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cm/tLyTv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C121F000E9;
	Thu, 30 Jul 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785423790;
	bh=oEXy5400y9oY8t+SLaNv5OMKc7UnJFO9czzb3hE0UOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cm/tLyTvSqh09PeFe6ghnqoUuzzsEDz0DzfBn9n28lRaPI2We/EMKFna+Iwhw4g4V
	 LkeO/1Jy3w+jA+VMzMA541NE+X0ndHNWZcCLylg3evuWX7mse0nItkHUC4oFoxIZ80
	 OpW3fMga7jEoNxBOZ3UFGL3scQjkpd0OYe27abKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 165/675] selftests/bpf: Keep verifier_map_ptr exercising ops pointer access
Date: Thu, 30 Jul 2026 16:08:15 +0200
Message-ID: <20260730141448.645673517@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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



