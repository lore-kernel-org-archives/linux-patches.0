Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4EAA369D56;
	Sat, 12 Sep 2026 09:57:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207043; cv=none; b=mF4WS6YgvwPpZactNf2pHeali5ZK97Aon9I3aYs2QFZQMuUBkVKLnDw51wx1IBn//oZkS6EYHIR3+LT9PYHN8sPcXdlApjVUX7h3i8zX4Jt77IJN1QtYuk4dKa1iwUozqAMsqiireNM+1ioR6OqvmIkBsG+D1qvKmXJGaM7qrd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207043; c=relaxed/simple;
	bh=Epvitdz+v/ADp3CMVoWKEl31QjIzw28e2sJLJmVUNcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DukcQrePjk+yOhWYDpZ/cZ0WEKntewMnnILeDAKt12m6A0+2V5wuN/pdsYMzCHDvnRqpPjPCkaYMPvXoAR9ir4E6KVhCOY2UUmFQ20AU9Pur2VclNxjX0g586FNeAXz7gLAPEGuEgtC5RpWsi8Kc2VAt7GrR/9FcrB6H3IQl0OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnILgQTT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnILgQTT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E733D1F000FF;
	Sat, 12 Sep 2026 09:57:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207041;
	bh=twmeCSe34MAjaTXs2kNQTd0JMm40DZXLt2wGNvo/Rzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hnILgQTTitvXAaPuEK4Tk3kEWB4Qp5oYx99s435XpJrYk4+Z9LgU0gIGEnD+vac3G
	 Fsh4lbhgXj63JrymVzIH2JVhKB1zJHaPjHJINMMsm75GaqpyZZhXMPF4Beo3dC6MOU
	 NxMKOSY+aQtL65rLBY6ccawPPYmGpQskkTg8hc10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0332/1518] bpf: Require a BPF cpumask for bpf_cpumask_populate()
Date: Sat, 12 Sep 2026 08:41:41 +0200
Message-ID: <20260912065630.981173321@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit 8740156ad33be5071b588b594c55f279457f667c ]

bpf_cpumask_populate() writes to its destination with bitmap_copy(), but
the destination is typed as struct cpumask *. That allows the verifier to
accept borrowed cpumask pointers returned by read-only kfuncs, such as
scx_bpf_get_online_cpumask(), as a writable destination.

Make the destination a struct bpf_cpumask * so populate follows the same
ownership rule as the other mutating cpumask kfuncs. Query kfuncs continue
to accept const struct cpumask * inputs.

Fixes: 950ad93df2fc ("bpf: add kfunc for populating cpumask bits")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Acked-by: Tejun Heo <tj@kernel.org>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/20260709182800.2037938-2-main.kalliope@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cpumask.c                     | 6 +++---
 tools/sched_ext/include/scx/compat.bpf.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/cpumask.c b/kernel/bpf/cpumask.c
index 9876c5fe6c2a2..341f80bb72ff2 100644
--- a/kernel/bpf/cpumask.c
+++ b/kernel/bpf/cpumask.c
@@ -449,12 +449,12 @@ __bpf_kfunc u32 bpf_cpumask_weight(const struct cpumask *cpumask)
  * @src__sz: Length of the BPF memory region in bytes.
  *
  * Return:
- * * 0 if the struct cpumask * instance was populated successfully.
+ * * 0 if the struct bpf_cpumask * instance was populated successfully.
  * * -EACCES if the memory region is too small to populate the cpumask.
  * * -EINVAL if the memory region is not aligned to the size of a long
  *   and the architecture does not support efficient unaligned accesses.
  */
-__bpf_kfunc int bpf_cpumask_populate(struct cpumask *cpumask, void *src, size_t src__sz)
+__bpf_kfunc int bpf_cpumask_populate(struct bpf_cpumask *cpumask, void *src, size_t src__sz)
 {
 	unsigned long source = (unsigned long)src;
 
@@ -467,7 +467,7 @@ __bpf_kfunc int bpf_cpumask_populate(struct cpumask *cpumask, void *src, size_t
 		!IS_ALIGNED(source, sizeof(long)))
 		return -EINVAL;
 
-	bitmap_copy(cpumask_bits(cpumask), src, nr_cpu_ids);
+	bitmap_copy(cpumask_bits(&cpumask->cpumask), src, nr_cpu_ids);
 
 	return 0;
 }
diff --git a/tools/sched_ext/include/scx/compat.bpf.h b/tools/sched_ext/include/scx/compat.bpf.h
index d979f16a3ae2b..3ffd14e9c948f 100644
--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -20,7 +20,7 @@
  *
  * Compat macro will be dropped on v6.19 release.
  */
-int bpf_cpumask_populate(struct cpumask *dst, void *src, size_t src__sz) __ksym __weak;
+int bpf_cpumask_populate(struct bpf_cpumask *dst, void *src, size_t src__sz) __ksym __weak;
 
 #define __COMPAT_bpf_cpumask_populate(cpumask, src, size__sz)		\
 	(bpf_ksym_exists(bpf_cpumask_populate) ?			\
-- 
2.53.0



