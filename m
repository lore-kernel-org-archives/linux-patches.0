Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21111515975;
	Thu, 17 Sep 2026 17:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665603; cv=none; b=DihFllzRvk1YUr9cFIeXHn19LnNv+LdBm8mreChf6V12WCSZFdibzp/fh8UoNdMntThP+JX+9s5uyS5+/TB9cHQRLD/KQOmV9xLTzTomsOL7zhBTdou7RAO9PUYkHWl/6rcdcbpy+lXQAcC+gERi4sSpmdaqsv2wIj4XpR4XrKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665603; c=relaxed/simple;
	bh=GJvzxQz6AN0zTad3LpObzOpkR6ko0/iygD5pRvvXLXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+SdNfG4/BwdtEBsmv5qaD1NRsFFyL+dHQU5J2wu/ZvAndM/IvVr1QgzfuA5o2c+51Sf+KHwr0bZlvzaV87umEmpxKQ+K72xMKpGJFg2XLsZ5QSFE1lgcKiZEv24mmt87/aIbp+k5VBqM2DboTJ2eMagmYBhvmmqO1B3fM7daQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ze0GOPqn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ze0GOPqn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46791F00893;
	Thu, 17 Sep 2026 17:20:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665602;
	bh=zk3VB4a5pZ0Hhc7a8kvty1bJdYVXzqSBS3yq8sELPFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ze0GOPqnC87q9+GNIfGqP0/NFiQYMvZjtn5z4MYWVzu180NpOPXQWnre61g0Vu+P3
	 rtLsNqHgND1GvDAGRGoD5jtNL0ZJxyWiWM/t0ej0GSn1PgqorQezAW/rXuSnzjt7nO
	 KGxy6ljlBwmwS/zJUnMQh9KcZqmJUJJrLpkSP9Z0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0759/1250] bpf: Mark sched_process_wait argument as nullable
Date: Thu, 17 Sep 2026 16:09:14 +0100
Message-ID: <20260917151612.448386643@linuxfoundation.org>
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
index 9f3a28cdbc345..d3fa25a315361 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6494,6 +6494,10 @@ struct bpf_raw_tp_null_args {
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



