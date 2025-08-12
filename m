Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 254A1305E08;
	Tue, 12 Aug 2025 18:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022222; cv=none; b=M64cz3M3DFDNeZ/ZOOpTY3MKydHbRYSkrBVJHbpQCGO4k37qW+yxJWfuiyDBku7SLKxC0eDNjxgTbjs8Q85vd/B5nN3jmg4TVZyBzFc6AM7YQeipx7cWUgdocAZzmzsWi51kWQVlfgGMeZ9D8cqXJLarRr2Mqu6LeBOYYnzcNwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022222; c=relaxed/simple;
	bh=CUv5/hizawQt55LGG15Bd+79KF3Jhl8X3W1qyK1cmRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hQNqPlS2+Em2LcTamhrp+Fjz0+n9TRYe/iAere/ReAu1oG9XwTHPIyW+oFKOe0xdG/4lJBTkXTkLpt29kD9HGNkdlDx5fMoy/vA1ExNRIH29a8U6949F9/3hCFwbTrAaNvwkHJueW1nzFzr0FBzGpPNxa/LGdadEBYXOkZj8lOs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rJdS/4E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rJdS/4E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ABABC4CEF0;
	Tue, 12 Aug 2025 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022222;
	bh=CUv5/hizawQt55LGG15Bd+79KF3Jhl8X3W1qyK1cmRs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rJdS/4E0g6Zm084HKRkYiZieMrnba9cHwNyUi/xp8Jhi7pXuJRTTwx9kwjUlMolUQ
	 6oZOePtt8H8x6lVCo3UIG7HRZVH1GJau1jeX0i5m0q5acc+tjr1PDvMW1Ipn+w9WVu
	 tUw8e1klHm3B2HLZmglmXT3P6kKK13yR0WMFALpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/369] bpf: Ensure RCU lock is held around bpf_prog_ksym_find
Date: Tue, 12 Aug 2025 19:26:28 +0200
Message-ID: <20250812173018.198892364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit d090326860096df9dac6f27cff76d3f8df44d4f1 ]

Add a warning to ensure RCU lock is held around tree lookup, and then
fix one of the invocations in bpf_stack_walker. The program has an
active stack frame and won't disappear. Use the opportunity to remove
unneeded invocation of is_bpf_text_address.

Fixes: f18b03fabaa9 ("bpf: Implement BPF exceptions")
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20250703204818.925464-5-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/core.c    |  5 ++++-
 kernel/bpf/helpers.c | 11 +++++++++--
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
index 68a327158989..767dcb8471f6 100644
--- a/kernel/bpf/core.c
+++ b/kernel/bpf/core.c
@@ -778,7 +778,10 @@ bool is_bpf_text_address(unsigned long addr)
 
 struct bpf_prog *bpf_prog_ksym_find(unsigned long addr)
 {
-	struct bpf_ksym *ksym = bpf_ksym_find(addr);
+	struct bpf_ksym *ksym;
+
+	WARN_ON_ONCE(!rcu_read_lock_held());
+	ksym = bpf_ksym_find(addr);
 
 	return ksym && ksym->prog ?
 	       container_of(ksym, struct bpf_prog_aux, ksym)->prog :
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 6cf165c55bda..be4429463599 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -2781,9 +2781,16 @@ static bool bpf_stack_walker(void *cookie, u64 ip, u64 sp, u64 bp)
 	struct bpf_throw_ctx *ctx = cookie;
 	struct bpf_prog *prog;
 
-	if (!is_bpf_text_address(ip))
-		return !ctx->cnt;
+	/*
+	 * The RCU read lock is held to safely traverse the latch tree, but we
+	 * don't need its protection when accessing the prog, since it has an
+	 * active stack frame on the current stack trace, and won't disappear.
+	 */
+	rcu_read_lock();
 	prog = bpf_prog_ksym_find(ip);
+	rcu_read_unlock();
+	if (!prog)
+		return !ctx->cnt;
 	ctx->cnt++;
 	if (bpf_is_subprog(prog))
 		return true;
-- 
2.39.5



