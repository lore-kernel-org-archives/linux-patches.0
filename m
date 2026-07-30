Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4724244C51F;
	Thu, 30 Jul 2026 15:29:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425382; cv=none; b=elZ1wxM/0AnHySLmn1SChCdkmsXIIp5wghWvtDkbtgJLePkmQ+hWzbdpWawQ/ZxfbzoIfq2V2NN8b31Nms/SRYS37hfhYKhsL2R2iL9FjVtxVZo2Lw2mvxluhBwsp1lU53yzNIc7d50C79UEzrmRSXxR8QD6l3/885q7hyjpZHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425382; c=relaxed/simple;
	bh=H1KKWlxXU/ZjVm0MNAAUKrQnccUuHc8s1fzL9DwsLLI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iDVeP0JrPFNW3RJ5WJO25yV5y8NfITz9m+sPXR6MGgrre1R/fKsz9wkMKbQ9nHcA2JaTdWJ9opDg5WqIFWr5+XsLcqy1n0NTazX34Lq+Tmeiqr7pGRQ2bXLIIro5w+01mv31vUhIKAfCXWgG33oLli4wK4uDsg3gm/HGEZUhdKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jHk+bnRf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jHk+bnRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97D6B1F000E9;
	Thu, 30 Jul 2026 15:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425378;
	bh=6m18tg3oW2HaixSoQYq6Wd6YJWJgpNFMUGvU6SC6gtg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jHk+bnRfQ+HJpY708g7wPqvZyeiaMsdJkF6jmbJslfN5WhgbfeVDSHG7xrmaZOyGi
	 lktfGuyNX6MrbAlTIfR+0IGg5xZajZFrUfwI3qnKbJE++MXJ4y8utFeroRh7vBg19/
	 +jBiQ5SQBoYZaEfNNGjpcFBFjWAow0pgzupscKXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Philo Lu <lulie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/602] selftests/bpf: Add tests for ld_{abs,ind} failure path in subprogs
Date: Thu, 30 Jul 2026 16:06:37 +0200
Message-ID: <20260730141436.104025736@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit e0fcb42bc6f41bab2895757d6610616b3820eff7 upstream.

Extend the verifier_ld_ind BPF selftests with subprogs containing
ld_{abs,ind} and craft the test in a way where the invalid register
read is rejected in the fixed case. Also add a success case each,
and add additional coverage related to the BTF return type enforcement.

  # LDLIBS=-static PKG_CONFIG='pkg-config --static' ./vmtest.sh -- ./test_progs -t verifier_ld_ind
  [...]
  #611/1   verifier_ld_ind/ld_ind: check calling conv, r1:OK
  #611/2   verifier_ld_ind/ld_ind: check calling conv, r1 @unpriv:OK
  #611/3   verifier_ld_ind/ld_ind: check calling conv, r2:OK
  #611/4   verifier_ld_ind/ld_ind: check calling conv, r2 @unpriv:OK
  #611/5   verifier_ld_ind/ld_ind: check calling conv, r3:OK
  #611/6   verifier_ld_ind/ld_ind: check calling conv, r3 @unpriv:OK
  #611/7   verifier_ld_ind/ld_ind: check calling conv, r4:OK
  #611/8   verifier_ld_ind/ld_ind: check calling conv, r4 @unpriv:OK
  #611/9   verifier_ld_ind/ld_ind: check calling conv, r5:OK
  #611/10  verifier_ld_ind/ld_ind: check calling conv, r5 @unpriv:OK
  #611/11  verifier_ld_ind/ld_ind: check calling conv, r7:OK
  #611/12  verifier_ld_ind/ld_ind: check calling conv, r7 @unpriv:OK
  #611/13  verifier_ld_ind/ld_abs: subprog early exit on ld_abs failure:OK
  #611/14  verifier_ld_ind/ld_ind: subprog early exit on ld_ind failure:OK
  #611/15  verifier_ld_ind/ld_abs: subprog with both paths safe:OK
  #611/16  verifier_ld_ind/ld_ind: subprog with both paths safe:OK
  #611/17  verifier_ld_ind/ld_abs: reject void return subprog:OK
  #611/18  verifier_ld_ind/ld_ind: reject void return subprog:OK
  #611     verifier_ld_ind:OK
  Summary: 1/18 PASSED, 0 SKIPPED, 0 FAILED

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260408191242.526279-4-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../selftests/bpf/progs/verifier_ld_ind.c     | 142 ++++++++++++++++++
 1 file changed, 142 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/verifier_ld_ind.c b/tools/testing/selftests/bpf/progs/verifier_ld_ind.c
index c925ba9a2e74c2..09e81b99eecb4e 100644
--- a/tools/testing/selftests/bpf/progs/verifier_ld_ind.c
+++ b/tools/testing/selftests/bpf/progs/verifier_ld_ind.c
@@ -107,4 +107,146 @@ __naked void ind_check_calling_conv_r7(void)
 	: __clobber_all);
 }
 
+/*
+ * ld_{abs,ind} subprog that always sets r0=1 on the success path.
+ * bpf_gen_ld_abs() emits a hidden exit with r0=0 when the load helper
+ * fails. The verifier must model this failure return so that callers
+ * account for r0=0 as a possible return value.
+ */
+__naked __noinline __used
+static int ldabs_subprog(void)
+{
+	asm volatile (
+	"r6 = r1;"
+	".8byte %[ld_abs];"
+	"r0 = 1;"
+	"exit;"
+	:
+	: __imm_insn(ld_abs, BPF_LD_ABS(BPF_W, 0))
+	: __clobber_all);
+}
+
+__naked __noinline __used
+static int ldind_subprog(void)
+{
+	asm volatile (
+	"r6 = r1;"
+	"r7 = 0;"
+	".8byte %[ld_ind];"
+	"r0 = 1;"
+	"exit;"
+	:
+	: __imm_insn(ld_ind, BPF_LD_IND(BPF_W, BPF_REG_7, 0))
+	: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_abs: subprog early exit on ld_abs failure")
+__failure __msg("R9 !read_ok")
+__naked void ld_abs_subprog_early_exit(void)
+{
+	asm volatile (
+	"call ldabs_subprog;"
+	"if r0 != 0 goto l_exit_%=;"
+	"r0 = r9;"
+	"l_exit_%=:"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_ind: subprog early exit on ld_ind failure")
+__failure __msg("R9 !read_ok")
+__naked void ld_ind_subprog_early_exit(void)
+{
+	asm volatile (
+	"call ldind_subprog;"
+	"if r0 != 0 goto l_exit_%=;"
+	"r0 = r9;"
+	"l_exit_%=:"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_abs: subprog with both paths safe")
+__success
+__naked void ld_abs_subprog_both_paths_safe(void)
+{
+	asm volatile (
+	"call ldabs_subprog;"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_ind: subprog with both paths safe")
+__success
+__naked void ld_ind_subprog_both_paths_safe(void)
+{
+	asm volatile (
+	"call ldind_subprog;"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+/*
+ * ld_{abs,ind} in subprogs require scalar (int) return type in BTF.
+ * A test with void return must be rejected.
+ */
+__naked __noinline __used
+static void ldabs_void_subprog(void)
+{
+	asm volatile (
+	"r6 = r1;"
+	".8byte %[ld_abs];"
+	"r0 = 1;"
+	"exit;"
+	:
+	: __imm_insn(ld_abs, BPF_LD_ABS(BPF_W, 0))
+	: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_abs: reject void return subprog")
+__failure __msg("LD_ABS is only allowed in functions that return 'int'")
+__naked void ld_abs_void_subprog_reject(void)
+{
+	asm volatile (
+	"call ldabs_void_subprog;"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
+__naked __noinline __used
+static void ldind_void_subprog(void)
+{
+	asm volatile (
+	"r6 = r1;"
+	"r7 = 0;"
+	".8byte %[ld_ind];"
+	"r0 = 1;"
+	"exit;"
+	:
+	: __imm_insn(ld_ind, BPF_LD_IND(BPF_W, BPF_REG_7, 0))
+	: __clobber_all);
+}
+
+SEC("socket")
+__description("ld_ind: reject void return subprog")
+__failure __msg("LD_ABS is only allowed in functions that return 'int'")
+__naked void ld_ind_void_subprog_reject(void)
+{
+	asm volatile (
+	"call ldind_void_subprog;"
+	"r0 = 0;"
+	"exit;"
+	::: __clobber_all);
+}
+
 char _license[] SEC("license") = "GPL";
-- 
2.53.0



