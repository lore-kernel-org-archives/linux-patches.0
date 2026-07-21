Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27D4B46AA60;
	Tue, 21 Jul 2026 15:34:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648088; cv=none; b=f26q0O2uPp2puTgByHeD6QkhN1ySiIuDRUhAfVm1Rze5rW1lJmx+7DPscFS5XUtovIQv8OcF/5QWl7rDYJJtff5faeiLZSAKLydiXpHAlvtxHJ4sV1C/Srx1/+YNK8ITUJCe5Au36anrz/uTFflioRauZerg2eZKWz09MWADyA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648088; c=relaxed/simple;
	bh=69cVB5kCI4Ui496vAgDBBGa68+9H3Y6mDlreCvcXYLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bMCHMgUOxWH/Czi2DinVQ0dPzpy0aLtuCqRMCLvbVoWKzmG37ov6626aev0Gdw+rfUVg+4fKieHgZpcdiYKZsEaCo6YfZOHluV0JijA7NBNin++LlnuKueI4bXY8sweoGQ7bYQKV2hGfdmnjaVHexy61S2gyNA0JMQkG50w4JCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UHvQUuHS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UHvQUuHS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B91A1F000E9;
	Tue, 21 Jul 2026 15:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648086;
	bh=Y9cifEmUvFla2cmiswdLMpop2RZ5CsiEwHn0qe9g1JY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UHvQUuHSWcJ6YAbRXA4Y3ESh87R/WJG5JppfU3FrUKKhDqxvoajFlOU0us9BSu8Rj
	 T9/q0KHi3ZsME+6Zwpi2za6LqYswC0RuYN7cbsN571O4RhiP718QIrbVlrw1XEm0gG
	 B8EXUEOa2PzCrVea7WsgRb9oGJMi3Dlie1IW2c98=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Bobrowski <mattbobrowski@google.com>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0066/2077] selftests/bpf: Fix off-by-one in bpf_cpumask_populate related selftest
Date: Tue, 21 Jul 2026 16:55:39 +0200
Message-ID: <20260721152554.249157121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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



