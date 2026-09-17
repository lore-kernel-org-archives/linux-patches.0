Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE40579821;
	Thu, 17 Sep 2026 15:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659378; cv=none; b=qpoEv19a7FdHya1woIpQyqmR7XPqKIO6SjzyUwM5BbnsrdXxJZvz1afeElUDUUwfhwqqke9B3bWxlEGLiEIyYKAHXP2DEoM2RmXqV3EKcz/qeL4PFLTfzir/V47hplLbhX9mM/2Q23VYqFH1UqOE3cTqX7AD89j+cPR6Sj8uaqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659378; c=relaxed/simple;
	bh=H+kp96HBcfgfMAb898ec3UniWNyn3W9zFkKl34SMy8k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ErRJOQ/16SmJIh1C5+hW/SGM9+rNkIEBr4/CufYahUE1T3tNaDpbZunx0nPIeTZujtcrR+Z7Hrw0iwCTCOdGEIoctokCqQc1RD3IvWRWkw7jhKp1NxUAjZBHQ+cU5IRgWHATJGxKKNjvNQdZGvsl8y/5L9lIT59eCuzxRl/JxuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YPdlBV0u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YPdlBV0u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B2D1F00898;
	Thu, 17 Sep 2026 15:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659368;
	bh=MuLchGl7QMuqwmnn4DWw9/DaAMDAAsRZfBFqA5SYgbs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YPdlBV0utjkxQ85HKFwg0lfULGGH5QbRj7+YUyyB3Coh0IZIouMVLDR0aFUG0cu0J
	 HpPYvt++FyRJiQxxuMxeKZdb4ng/g7bjB6UlRA6mENPaWl6TeIr9paKneQPHXw/PJy
	 5gIvXzfgb4qR0t1hjimRtYY5rfM/AOd/1mXqlATk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 232/733] bpf: Mark sched_process_wait argument as nullable
Date: Thu, 17 Sep 2026 16:09:00 +0100
Message-ID: <20260917151357.013364895@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit a453d6e3b8e8e1a321c8744d6189d763af9287d0 ]

do_wait() passes wo->wo_pid to the sched_process_wait tracepoint.
kernel_wait4() leaves wo_pid NULL for wait4(-1), and
kernel_waitid_prepare() does likewise for waitid(P_ALL).

btf_ctx_access() currently types argument 0 as PTR_TO_BTF_ID |
PTR_TRUSTED. Without PTR_MAYBE_NULL, the verifier accepts an unchecked
dereference. Trusted pointer loads have no fault protection, so a wait for
any child can then cause a NULL pointer dereference in JITed BPF code.

Add sched_process_wait to raw_tp_null_args[] with argument 0 marked
nullable. The verifier rejects an unchecked dereference while preserving
access after the program checks the pointer for NULL.

Fixes: 838a10bd2ebf ("bpf: Augment raw_tp arguments with PTR_MAYBE_NULL")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-8-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index 0f7b4006a08f4..96b38fce885d3 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6673,6 +6673,10 @@ struct bpf_raw_tp_null_args {
 static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	/* sched */
 	{ "sched_pi_setprio", 0x10 },
+	/*
+	 * do_wait() passes NULL for wait4(-1) and waitid(P_ALL).
+	 */
+	{ "sched_process_wait", 0x1 },
 	/* ... from sched_numa_pair_template event class */
 	{ "sched_stick_numa", 0x100 },
 	{ "sched_swap_numa", 0x100 },
-- 
2.53.0



