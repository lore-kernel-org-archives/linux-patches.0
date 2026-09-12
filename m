Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6136E1FC110;
	Sat, 12 Sep 2026 07:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199155; cv=none; b=GQ44zLo/SajjQ/GJiMGqp9iDYwRIgThG+fIOma1SjyoClAr6lfUyO5OzeBk84uqBHcUUNUCbbbmAOmtubLySghrlpULrNAodRUKQqw6thtaIgi0q7GuGk7+1bBRQiROAO9AIW0XqdbIpd+KUCxDEDj5BRmlzC+XPbm73NwAW7CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199155; c=relaxed/simple;
	bh=2vu6hh57DLuPW53dextD3MKfjS/Bwe6eAL3GbaXHHp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Azbh+PrBf0U86JX0ogIqqqmsppU2+jp9vq788SBHVfJNKqrhYvLpvAqaX1o48i6dnqy9aHjrCnyl9oVmEeihZ8tl72hSS26iNIWhkPZGvmpUJCJrPibUPuYtCuPcxG3vFY7uEYIr0KeyT63oBvOpojeU0oUrm+ZgMl3Ah/xDWiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kv+S80Qn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kv+S80Qn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E379B1F000FF;
	Sat, 12 Sep 2026 07:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199154;
	bh=DcMSQ3b8qUb3o99RL4eD5AGq0TsLWX5mjbFDDHKqfTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kv+S80QnQ1JOkvitq8OGNkYuG9Am1PQPVRQPQhos4WcBRQOkv2h+0QNwaeOEqZzaa
	 vTit7Ua66kxVQ2s1xvZNUWtvZrQmPOIg6GfQaLNU3+ZvkReZWqrfdTHgj0/3gUwkQn
	 z6m4uUV1FyL2GyuzAKK+kV1G3fgx6ZDn25fU/B/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Hwang <leon.hwang@linux.dev>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0527/1815] bpf: Disallow interpreter fallback for arena-related insns
Date: Sat, 12 Sep 2026 08:37:57 +0200
Message-ID: <20260912065701.259432301@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Hwang <leon.hwang@linux.dev>

[ Upstream commit 34746b5a84ec37c0ea2bf6808c65c5ed8790eb51 ]

Since the interpreter does not support the arena-related insns,
interpreter fallback should not be allowed for these insns in
core.c::__bpf_prog_select_runtime().

Currently, when the interpreter executes the arena ST/LDX/STX insns,
it would hit the BUG_ON() in ___bpf_prog_run() at run time.

[    2.579196] BPF interpreter: unknown opcode a2 (imm: 0x0)
[    2.579998] ------------[ cut here ]------------
[    2.580652] kernel BUG at kernel/bpf/core.c:2349!
[    2.581314] Oops: invalid opcode: 0000 [#1] SMP PTI

Set jit_required as true when arena map is used in the prog to disallow
interpreter fallback for arena-related insns.

Fixes: 6082b6c328b5 ("bpf: Recognize addr_space_cast instruction in the verifier.")
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Link: https://lore.kernel.org/bpf/20260715141122.15783-2-leon.hwang@linux.dev
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index b8b45044ab65a..2c4b52ba52413 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17851,6 +17851,7 @@ static int check_map_prog_compatibility(struct bpf_verifier_env *env,
 			return -EOPNOTSUPP;
 		}
 		env->prog->aux->arena = (void *)map;
+		env->prog->jit_required = true;
 		if (!bpf_arena_get_user_vm_start(env->prog->aux->arena)) {
 			verbose(env, "arena's user address must be set via map_extra or mmap()\n");
 			return -EINVAL;
-- 
2.53.0



