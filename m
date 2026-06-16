Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FB944BCBE;
	Tue, 16 Jun 2026 17:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781630601; cv=none; b=sf2lsfFgJJhEUcR5e3oGlBON3xcCFPdiW+MzT6AYfgs49OADjg8XPMiVSWzXhCsoBXvwTRMXRGKQXObOfqPfxGhuzLiCWJ1yroZYK1UqRKhwk/I9u08uNFB4F4nAqOOHr7TWd5SXKpxHkJdh7maLPSN62m3ooi76jcDB+1KNU0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781630601; c=relaxed/simple;
	bh=qdsqpWnWQpY4EWPNOrrYHESKc6uSfLMk4WaLCY6qlhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a06WTFiNpyP2zvxmKtQejLPBgdX8ZDZJUe7+McgqGqP57fIyKm2v9zPh60lxKpZvS60/rWiUeOO467VzTucShd/26J1zHRbBcUOGNYtlG2wMGfjtpC5BD8jpSR4L0wOMyp5wjzvwYvg5LADtc6kNS2cYOMTrEq4BLPXz/l2lIdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kmos1xBv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kmos1xBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319C71F000E9;
	Tue, 16 Jun 2026 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781630600;
	bh=X0w3MdY3/JQqWH6VVX1I71nFEabt0+6FzP4WIGUhnWc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kmos1xBv2f1tW/cLPCEq6SoDVAwvrqOM2KJB5nYeaNW2+3XcDeTWsY1wKchc3xqu6
	 eGKEzl7rbPC6Tp/w4Qi6uScE2e+sr3QdaYoOjH9+lozmswdZH6tFs5J546v7qzLG4l
	 cy9bEbUiJHCFtATf1KNjThaLa5Rp+9WYC5HlganU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 059/522] bpf: Fix a few selftest failures due to llvm18 change
Date: Tue, 16 Jun 2026 20:23:26 +0530
Message-ID: <20260616145128.548873584@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ Note: The change to test_run.c conflicted and was dropped. The related
  tests are not failing anyway. ]
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/test_global_func17.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/bpf/progs/test_global_func17.c b/tools/testing/selftests/bpf/progs/test_global_func17.c
index a32e11c7d933ee..5de44b09e8ec17 100644
--- a/tools/testing/selftests/bpf/progs/test_global_func17.c
+++ b/tools/testing/selftests/bpf/progs/test_global_func17.c
@@ -5,6 +5,7 @@
 
 __noinline int foo(int *p)
 {
+	barrier_var(p);
 	return p ? (*p = 42) : 0;
 }
 
-- 
2.53.0



