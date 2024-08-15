Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DACA1DFFB;
	Thu, 15 Aug 2024 14:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732481; cv=none; b=B/XZZxGnnv8ZRfnyE12cQRRC4y/A/btYxpxH5pWyLCZ5OniZoBnsxYg/N2FXhCuZW25a9/LVA+I+H2THSOfs7qccCmDcuQtSK2/BCn9XW8eqIiik4A3GsAUP1kLqIeeYQyqfWkZHQPEmWtYC7P7Fh7lVedv38DibCOooMHF5ARE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732481; c=relaxed/simple;
	bh=XiAmWHeieS8pswtjn6w4v4CSr8cfK5skCRnxiYnm01o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZI6Tpl3V+3+p3YkSyK58VttD8ztbGZKvaCBz7LK9NoKds1mROo8TVcFwXR0g1csut16x90EJ0F/pyv8ZS3xfsDbVh+mhFwEa718yP2iaRjMyDtRtbStLNn/H23mlMhb86PE8XrAZZgleP6obq5bh5rie4LLkZ4cyv5nDV8zZmGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1zFn/Th; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1zFn/Th"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DEBC32786;
	Thu, 15 Aug 2024 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732481;
	bh=XiAmWHeieS8pswtjn6w4v4CSr8cfK5skCRnxiYnm01o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1zFn/ThGTnWFcX+rp+tB7cCotFvvrfBiKs+QaW9cXehTD2LgoP0NNuFmDxJ4Ckfb
	 +npCKp2fnvrQjTGznjobw/c3kHR6ZoULDdY1qvMLeCPZaiZyAL+QUFVVB7FH81Dcnb
	 V7oLv4p10XRSHYz0O+WGJM0JPNj14pRuvkoKq6ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 193/352] libbpf: Fix no-args func prototype BTF dumping syntax
Date: Thu, 15 Aug 2024 15:24:19 +0200
Message-ID: <20240815131926.736657354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 189f1a976e426011e6a5588f1d3ceedf71fe2965 ]

For all these years libbpf's BTF dumper has been emitting not strictly
valid syntax for function prototypes that have no input arguments.

Instead of `int (*blah)()` we should emit `int (*blah)(void)`.

This is not normally a problem, but it manifests when we get kfuncs in
vmlinux.h that have no input arguments. Due to compiler internal
specifics, we get no BTF information for such kfuncs, if they are not
declared with proper `(void)`.

The fix is trivial. We also need to adjust a few ancient tests that
happily assumed `()` is correct.

Fixes: 351131b51c7a ("libbpf: add btf_dump API for BTF-to-C conversion")
Reported-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://lore.kernel.org/bpf/20240712224442.282823-1-andrii@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/btf_dump.c                                  | 8 +++++---
 .../selftests/bpf/progs/btf_dump_test_case_multidim.c     | 4 ++--
 .../selftests/bpf/progs/btf_dump_test_case_syntax.c       | 4 ++--
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/tools/lib/bpf/btf_dump.c b/tools/lib/bpf/btf_dump.c
index 61aa2c47fbd5e..2342aec3c5a3e 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1426,10 +1426,12 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
 			 * Clang for BPF target generates func_proto with no
 			 * args as a func_proto with a single void arg (e.g.,
 			 * `int (*f)(void)` vs just `int (*f)()`). We are
-			 * going to pretend there are no args for such case.
+			 * going to emit valid empty args (void) syntax for
+			 * such case. Similarly and conveniently, valid
+			 * no args case can be special-cased here as well.
 			 */
-			if (vlen == 1 && p->type == 0) {
-				btf_dump_printf(d, ")");
+			if (vlen == 0 || (vlen == 1 && p->type == 0)) {
+				btf_dump_printf(d, "void)");
 				return;
 			}
 
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
index ba97165bdb282..a657651eba523 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_multidim.c
@@ -14,9 +14,9 @@ typedef int *ptr_arr_t[6];
 
 typedef int *ptr_multiarr_t[7][8][9][10];
 
-typedef int * (*fn_ptr_arr_t[11])();
+typedef int * (*fn_ptr_arr_t[11])(void);
 
-typedef int * (*fn_ptr_multiarr_t[12][13])();
+typedef int * (*fn_ptr_multiarr_t[12][13])(void);
 
 struct root_struct {
 	arr_t _1;
diff --git a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
index fe43556e1a611..956b24ce81456 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -67,7 +67,7 @@ typedef void (*printf_fn_t)(const char *, ...);
  *   `int -> char *` function and returns pointer to a char. Equivalent:
  *   typedef char * (*fn_input_t)(int);
  *   typedef char * (*fn_output_outer_t)(fn_input_t);
- *   typedef const fn_output_outer_t (* fn_output_inner_t)();
+ *   typedef const fn_output_outer_t (* fn_output_inner_t)(void);
  *   typedef const fn_output_inner_t fn_ptr_arr2_t[5];
  */
 /* ----- START-EXPECTED-OUTPUT ----- */
@@ -94,7 +94,7 @@ typedef void (* (*signal_t)(int, void (*)(int)))(int);
 
 typedef char * (*fn_ptr_arr1_t[10])(int **);
 
-typedef char * (* (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+typedef char * (* (* const fn_ptr_arr2_t[5])(void))(char * (*)(int));
 
 struct struct_w_typedefs {
 	int_t a;
-- 
2.43.0



