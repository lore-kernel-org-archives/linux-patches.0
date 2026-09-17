Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B1A9455610;
	Thu, 17 Sep 2026 17:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665809; cv=none; b=l8hvH+7QTZYiSvsYnmXzXhOMZxW5WC0JlGa5uMVtTBz/oYOuDVuoLQqt+oFhB62hagBFalxfO9EtDMBAXu56RfE/v7uQAqGU6tDDLoYu72HZBNIadF0kYbEJIO6+U6XyEmzZQcIRiEEjOoBEyT4E+oo9zoMm2ep88zVk8xnxPe0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665809; c=relaxed/simple;
	bh=QbTP+ZTofUJEUH5SlGfOX8L36AQeCxPG641ZPi4fUfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bh8uBpUeRIdm9hUt7wtLuLi0vLtehJDwjLTpOBckW5TLVbgTgz0hyyPzr5e30NQ/On1Vw8LGnN72J54BDlzXqLHN0WrRm9Zymehzb/JLbmJLHv/4sADA1yDTeng1lVIuZhnLWGnJWjuyedqLXIIKWnAeWyfRnlponGxYcOS6jPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qZ7F324n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qZ7F324n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF671F000FF;
	Thu, 17 Sep 2026 17:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665807;
	bh=bHPZbTCqE740tpMXuP2DQ+ltRfy+08RluLdAi5DOGyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qZ7F324nGf0SdduJEpmO6HLLlinIIyGlY2QfUS0EmLNBTODe+/cvfLyFRbFNdePZ7
	 CyUsL3WZc0NTCWD3VBErffF4Ef4xjOCTAlwrloP29AjUnM2U3IdHWcPMPJTReDDwR4
	 nCxO1YMQnPFuQwvQvBqaCWRmZM1wYwdTlJrdgOok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7b47f87674e9a1569110@syzkaller.appspotmail.com,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0828/1250] bpf: Reject non-scalar bpf_loop iteration counts
Date: Thu, 17 Sep 2026 16:10:23 +0100
Message-ID: <20260917151614.379662529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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
index 7052507ed4517..862d6e0d5a287 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -821,6 +821,7 @@ enum bpf_arg_type {
 
 	ARG_PTR_TO_CTX,		/* pointer to context */
 	ARG_ANYTHING,		/* any (initialized) argument is ok */
+	ARG_SCALAR,		/* scalar argument */
 	ARG_PTR_TO_SPIN_LOCK,	/* pointer to bpf_spin_lock */
 	ARG_PTR_TO_SOCK_COMMON,	/* pointer to sock_common */
 	ARG_PTR_TO_SOCKET,	/* pointer to bpf_sock (fullsock) */
diff --git a/kernel/bpf/bpf_iter.c b/kernel/bpf/bpf_iter.c
index 6ac35430c5734..54596447fbca8 100644
--- a/kernel/bpf/bpf_iter.c
+++ b/kernel/bpf/bpf_iter.c
@@ -767,7 +767,7 @@ const struct bpf_func_proto bpf_loop_proto = {
 	.func		= bpf_loop,
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
-	.arg1_type	= ARG_ANYTHING,
+	.arg1_type	= ARG_SCALAR,
 	.arg2_type	= ARG_PTR_TO_FUNC,
 	.arg3_type	= ARG_PTR_TO_STACK_OR_NULL,
 	.arg4_type	= ARG_ANYTHING,
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index bef18a2cc95a6..9247549b5a772 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -9380,6 +9380,7 @@ static const struct bpf_reg_types *compatible_reg_types[__BPF_ARG_TYPE_MAX] = {
 	[ARG_CONST_SIZE]		= &scalar_types,
 	[ARG_CONST_SIZE_OR_ZERO]	= &scalar_types,
 	[ARG_CONST_ALLOC_SIZE_OR_ZERO]	= &scalar_types,
+	[ARG_SCALAR]			= &scalar_types,
 	[ARG_CONST_MAP_PTR]		= &const_map_ptr_types,
 	[ARG_PTR_TO_CTX]		= &context_types,
 	[ARG_PTR_TO_SOCK_COMMON]	= &sock_types,
-- 
2.53.0



