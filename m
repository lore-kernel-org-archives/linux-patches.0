Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B098A3E1694;
	Wed, 30 Sep 2026 19:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795328; cv=none; b=aCSoUXN5NHeUlpRVMKbpzs5PEp558CG1YjTUXQzdD574obAzjF8PbbPQNgt83C5U4OsmRP8peTRhORbPCojXQVnNKam8CwBazNnDNZUnK+wOf/odm0Tvr0BoChCUKXPbJGK4fNUDo6EGqqTjAIVOrmUb47wAB1IV0efoo1sCCrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795328; c=relaxed/simple;
	bh=rbYF9DHQ7hHOSq2z4aQ2jAH/97eFq6S9TlrtrTiBa98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oBYG4KiQ+r1UQKFHIx0eZxgV7fnUuouycSjsxrWL/lLqFMhhcVl4d8AToff6YFCNLDviZVHoRwbW7Z58xp5cPoqYfaAUFh7nhrGNeeOAXMjWaMz0ssZMinW2yGHNTwW9LE+SwSrfPmLRBSl5x7UxkaLlBYGj7zfIlNxtSS3YKPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WCBAhmGW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WCBAhmGW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F131F000FF;
	Wed, 30 Sep 2026 19:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795327;
	bh=8Flko/hBTBzkPcwWPYVXxUlZGH23y2qE9Cybh6+HPqo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WCBAhmGWjaLK8FbC1lUoipMAZLydedck3vQ634/DfuKNZ5NYAd72Yyv0MvEMawJTI
	 BP1DBhPUU4w+OeiT1cIEFieLMlWdBwaOa0cM98EnAuDULRk22NZD1gGD41TskORvW3
	 Daq3CpBx6qS/8VSGtbG7fxLnyuzdUxWS66jhWG0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7b47f87674e9a1569110@syzkaller.appspotmail.com,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0516/1193] bpf: Reject non-scalar bpf_loop iteration counts
Date: Wed, 30 Sep 2026 17:20:00 +0200
Message-ID: <20260930152445.637134092@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit c3fd8e5fd100f122bad503bdc0e9277219533253 ]

bpf_loop() declares its nr_loops argument as ARG_ANYTHING. Privileged
programs may pass pointer values to such arguments, so check_func_arg()
lets a pointer-valued R1 reach the helper-specific checks.

Since commit bb124da69c47 ("bpf: keep track of max number of bpf_loop
callback iterations"), the verifier marks R1 precise and reads its upper
bound to limit callback simulation. Precision backtracking only accepts
scalar registers, so passing a pointer instead triggers the "backtracking
misuse" verifier warning. Kernels with panic_on_warn enabled subsequently
panic.

Introduce ARG_SCALAR for helper arguments that only accept scalar values
and use it for bpf_loop() nr_loops. Generic helper argument validation then
rejects pointers before loop inlining and precision processing.

Fixes: bb124da69c47 ("bpf: keep track of max number of bpf_loop callback iterations")
Reported-by: syzbot+7b47f87674e9a1569110@syzkaller.appspotmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://patch.msgid.link/20260905014735.1452988-2-memxor@gmail.com
Closes: https://lore.kernel.org/bpf/6a9ad24c.b5d4176b.238c3e.0001.GAE@google.com/
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf.h   | 1 +
 kernel/bpf/bpf_iter.c | 2 +-
 kernel/bpf/verifier.c | 1 +
 3 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fd20812cbcc33..5b58c95dbf192 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -742,6 +742,7 @@ enum bpf_arg_type {
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
+	ARG_SCALAR,		/* scalar argument */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 96856f130cbff..55bc98a02c56f 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -771,7 +771,7 @@ const struct bpf_func_proto bpf_loop_proto = {
 	.func		= bpf_loop,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_ANYTHING,
+	.arg1_type	= ARG_SCALAR,
 	.arg2_type	= ARG_PTR_TO_FUNC,
 	.arg3_type	= ARG_PTR_TO_STACK_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 0f85d5f3ecf9a..13d66523f8428 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8243,6 +8243,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE]		= &scalar_types,
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
+	[ARG_SCALAR]			= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
-- 
2.53.0



