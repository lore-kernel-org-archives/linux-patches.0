Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8963346A6;
	Tue, 21 Jul 2026 17:39:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655600; cv=none; b=UI3fLRoKCLAtyTGLIUOwsXroerwSDymGIONpr1HmqQunb6/f7/iG5KShGhRX9Su7YOYp9t9AX6QZ0xuhxJf9camP3aa0XnKYLFmEDKf+ZOanM0oT2WLVrLAEvVPMS8fThmhXLoX0jkWtTtmJXDJCp4kSpDr69DyB90EBDJdr4Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655600; c=relaxed/simple;
	bh=/op7Vu/WusLKm8J9Mmtii/v0hZ57imT3xvXwDXMkB5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XD37ssb15NzVcnTtjBhpU9j+YETe5CWvPPx0aCYvxW9NSDrHma0EB8aLjXwY2LyifLfFIJYa0Vqoo8JgZhMC+ZlqLoz3k745cdHFgoF7qcBKf30ZeBzx5m4GSeugHyDOppQEoPk2URppfULTMPMjBCIm4ysqFUfwqORmCoXT+8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JrlODxSL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JrlODxSL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D21DD1F000E9;
	Tue, 21 Jul 2026 17:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655599;
	bh=EpTVodzfDZYZ2kZExdkkFjlLoaNpt7GzD3HkM+BZ7IU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JrlODxSL900K7m1wAJTlyApwXfSGRp/C+fBmSS+l68hEP/P1FPsHA7Xno76uxvZOe
	 w03PaxBqLv15dp29KOF7LEX11wsCD9KdCp6jczfwkeN92YFyVh5rrDI//TPvF5Pk/j
	 PMdPLiSmfAi7dQzKhTn4f37B85s+SCtmeNQt67FM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0070/1611] selftests/bpf: Fix off-by-one in bpf_cpumask_populate related selftest
Date: Tue, 21 Jul 2026 17:03:06 +0200
Message-ID: <20260721152516.410630266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit 0aa6378695b8c67146130812f635f07c4898f171 ]

The test_populate test uses >= instead of > when checking if the
runtime nr_cpus exceeds the bit capacity of a cpumask_t.

On a system where the physical CPU core count perfectly matches the
CONFIG_NR_CPUS upper bound (e.g. nr_cpus = 512 and CONFIG_NR_CPUS =
512), the condition nr_cpus >= CPUMASK_TEST_MASKLEN * 8 evaluates to
true (512 >= 512). This incorrectly causes the test to fail with an
error value of 3.

A 512-bit cpumask_t provides enough bits (indices 0 through 511) to
represent 512 CPUs. The subsequent bpf_for(i, 0, nr_cpus) loop
iterates up to nr_cpus - 1 (511), which perfectly aligns with the
maximum valid index of the bitmask.

Change the condition to nr_cpus > CPUMASK_TEST_MASKLEN * 8 to fix the
false positive failure on these systems.

Fixes: 918ba2636d4e ("selftests: bpf: add bpf_cpumask_populate selftests")
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Acked-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/bpf/20260420093734.2400330-1-mattbobrowski@google.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/cpumask_success.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/progs/cpumask_success.c b/tools/testing/selftests/bpf/progs/cpumask_success.c
index 0e04c31b91c0c0..774706e7b058b9 100644
--- a/tools/testing/selftests/bpf/progs/cpumask_success.c
+++ b/tools/testing/selftests/bpf/progs/cpumask_success.c
@@ -866,7 +866,7 @@ int BPF_PROG(test_populate, struct task_struct *task, u64 clone_flags)
 	 * access NR_CPUS, the upper bound for nr_cpus, so we infer
 	 * it from the size of cpumask_t.
 	 */
-	if (nr_cpus < 0 || nr_cpus >= CPUMASK_TEST_MASKLEN * 8) {
+	if (nr_cpus < 0 || nr_cpus > CPUMASK_TEST_MASKLEN * 8) {
 		err = 3;
 		goto out;
 	}
-- 
2.53.0



