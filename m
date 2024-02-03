Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAE691BF32;
	Sat,  3 Feb 2024 04:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933802; cv=none; b=XmlPEu2ilcbfvVC56yD4pqVQ/KKjq4Iagqw/WXMlqWaH+ByFysa+ONyAhKEmMak6DYG1gVB1jaUYfbYAf1os02UqdknMGJrKXW/U4wzGJ0Q5s7NhJmqNirKi89/THCKqedcZGcwfFc5UZtdYO9+AG9HFc+aDfuhVWs/pfZ0HRTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933802; c=relaxed/simple;
	bh=EVa38D6G4TIdXBE8HFQVq2hTKfuY6eiB34uQuJkrfIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYyL9lV3o3R5J8wy499BfBllKyHq/ElRBeeOCihcQJECfJpoUL1HelB40CunvTWE46AyyyxM+F+nhwTggSsJ3E6/U3BDV53fAhXek8H8GkscrHLNzD/4TB8KstTlZSlOJZBmho/9jHIAudGqqLGwPtRDkwBplUNTrwrXFmcQ3uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0ZhLb+qD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0ZhLb+qD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DD1C433F1;
	Sat,  3 Feb 2024 04:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933802;
	bh=EVa38D6G4TIdXBE8HFQVq2hTKfuY6eiB34uQuJkrfIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0ZhLb+qDSsa1vnEfFCCgwIZufTfIYvwOFELxS7D73uDqSY/KZEVQzESOkdQE/39e4
	 tXsRgNx7ieDvMRpgkc+kMLalMjJaxJuFmkpqoLdDhEtDQV7JFDEL5IObWqDcX40th+
	 rNTJJ8r9nMYDDtcTGdE5AKIFZbJEWL1bLTABeFNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 090/353] bpf: Fix a few selftest failures due to llvm18 change
Date: Fri,  2 Feb 2024 20:03:28 -0800
Message-ID: <20240203035406.647619214@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit b16904fd9f01b580db357ef2b1cc9e86d89576c2 ]

With latest upstream llvm18, the following test cases failed:

  $ ./test_progs -j
  #13/2    bpf_cookie/multi_kprobe_link_api:FAIL
  #13/3    bpf_cookie/multi_kprobe_attach_api:FAIL
  #13      bpf_cookie:FAIL
  #77      fentry_fexit:FAIL
  #78/1    fentry_test/fentry:FAIL
  #78      fentry_test:FAIL
  #82/1    fexit_test/fexit:FAIL
  #82      fexit_test:FAIL
  #112/1   kprobe_multi_test/skel_api:FAIL
  #112/2   kprobe_multi_test/link_api_addrs:FAIL
  [...]
  #112     kprobe_multi_test:FAIL
  #356/17  test_global_funcs/global_func17:FAIL
  #356     test_global_funcs:FAIL

Further analysis shows llvm upstream patch [1] is responsible for the above
failures. For example, for function bpf_fentry_test7() in net/bpf/test_run.c,
without [1], the asm code is:

  0000000000000400 <bpf_fentry_test7>:
     400: f3 0f 1e fa                   endbr64
     404: e8 00 00 00 00                callq   0x409 <bpf_fentry_test7+0x9>
     409: 48 89 f8                      movq    %rdi, %rax
     40c: c3                            retq
     40d: 0f 1f 00                      nopl    (%rax)

... and with [1], the asm code is:

  0000000000005d20 <bpf_fentry_test7.specialized.1>:
    5d20: e8 00 00 00 00                callq   0x5d25 <bpf_fentry_test7.specialized.1+0x5>
    5d25: c3                            retq

... and <bpf_fentry_test7.specialized.1> is called instead of <bpf_fentry_test7>
and this caused test failures for #13/#77 etc. except #356.

For test case #356/17, with [1] (progs/test_global_func17.c)), the main prog
looks like:

  0000000000000000 <global_func17>:
       0:       b4 00 00 00 2a 00 00 00 w0 = 0x2a
       1:       95 00 00 00 00 00 00 00 exit

... which passed verification while the test itself expects a verification
failure.

Let us add 'barrier_var' style asm code in both places to prevent function
specialization which caused selftests failure.

  [1] https://github.com/llvm/llvm-project/pull/72903

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20231127050342.1945270-1-yonghong.song@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c                                     | 2 +-
 tools/testing/selftests/bpf/progs/test_global_func17.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c9fdcc5cdce1..711cf5d59816 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -542,7 +542,7 @@ struct bpf_fentry_test_t {
 
 int noinline bpf_fentry_test7(struct bpf_fentry_test_t *arg)
 {
-	asm volatile ("");
+	asm volatile ("": "+r"(arg));
 	return (long)arg;
 }
 
diff --git a/tools/testing/selftests/bpf/progs/test_global_func17.c b/tools/testing/selftests/bpf/progs/test_global_func17.c
index a32e11c7d933..5de44b09e8ec 100644
--- a/tools/testing/selftests/bpf/progs/test_global_func17.c
+++ b/tools/testing/selftests/bpf/progs/test_global_func17.c
@@ -5,6 +5,7 @@
 
 __noinline int foo(int *p)
 {
+	barrier_var(p);
 	return p ? (*p = 42) : 0;
 }
 
-- 
2.43.0



