Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04308157466;
	Tue, 30 Jul 2024 17:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360625; cv=none; b=hz4CuSj9i9rx38GcWHds18nf29zsnSxLP4h/aqT1/sDvO8t2eIiX4EXf8/ZHlQJ8DYX8Ol720LHe2MnZYXFwBvlczV2vhWVoecAXywuolOtawc5eh+6EDLMR/PzggiqAdiJxZCVT0dm3PIHwfIyTxVNmhkn48zJYvc/tpjT1bRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360625; c=relaxed/simple;
	bh=+t4pyM/m8qGFlSiXyF9gIhMW4YfHqsGupZ0xrWvnTP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXF95ZaL3hci/pfXepnT/lpho5JqPj0NgZst74eM5DEvnZ5W70meFGrkhlI3A/6cElavIk+E7CAtRS5HUbHezKQGJ0iXjquoXdS4rnnhDRktCag2UbD9Ymjuy6WFPjZ2mzQA7TntD4R6XxcKv0n2kgwKQCTI4Ot8TeSSCj8+35E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=00+v4NMw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="00+v4NMw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80942C4AF0A;
	Tue, 30 Jul 2024 17:30:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360624;
	bh=+t4pyM/m8qGFlSiXyF9gIhMW4YfHqsGupZ0xrWvnTP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=00+v4NMwkVm7RVl9jftAGXxQfcC5h2UCcqSZkmFIPiMHZQv4y6yzdJVq0ypDmMPa3
	 nPv7CFjqNl7btl3/Ge4uZ+t5eyd8/sUGcZpfnytF336NWb5HRm6MR0LHlZRuKL8fpV
	 gSAqXF54TTkfpepQnqsAXKJoImiEr4T+cLleTRd8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 755/809] libbpf: Fix no-args func prototype BTF dumping syntax
Date: Tue, 30 Jul 2024 17:50:31 +0200
Message-ID: <20240730151754.779458690@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 5dbca76b953f4..894860111ddb2 100644
--- a/tools/lib/bpf/btf_dump.c
+++ b/tools/lib/bpf/btf_dump.c
@@ -1559,10 +1559,12 @@ static void btf_dump_emit_type_chain(struct btf_dump *d,
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
index ad21ee8c7e234..29d01fff32bd2 100644
--- a/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
+++ b/tools/testing/selftests/bpf/progs/btf_dump_test_case_syntax.c
@@ -100,7 +100,7 @@ typedef void (*printf_fn_t)(const char *, ...);
  *   `int -> char *` function and returns pointer to a char. Equivalent:
  *   typedef char * (*fn_input_t)(int);
  *   typedef char * (*fn_output_outer_t)(fn_input_t);
- *   typedef const fn_output_outer_t (* fn_output_inner_t)();
+ *   typedef const fn_output_outer_t (* fn_output_inner_t)(void);
  *   typedef const fn_output_inner_t fn_ptr_arr2_t[5];
  */
 /* ----- START-EXPECTED-OUTPUT ----- */
@@ -127,7 +127,7 @@ typedef void (* (*signal_t)(int, void (*)(int)))(int);
 
 typedef char * (*fn_ptr_arr1_t[10])(int **);
 
-typedef char * (* (* const fn_ptr_arr2_t[5])())(char * (*)(int));
+typedef char * (* (* const fn_ptr_arr2_t[5])(void))(char * (*)(int));
 
 struct struct_w_typedefs {
 	int_t a;
-- 
2.43.0



