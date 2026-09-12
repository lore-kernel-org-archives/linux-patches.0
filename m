Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D40092F9D82;
	Sat, 12 Sep 2026 07:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789198249; cv=none; b=mPxh7cfHWjtvjMCqQiwECM2CE1mRkq+q+/WHwCACRSc2mF9Y71MUTFxRSEAHnoqbPeG+5Xv3p99fyRJmPBj+vpKmEOpt3azv+nTHaUkrYljLgWiyL94CRhoz+ri/JWMdMLCm0sWKHBh2N2uEgADHt+znj9dWe8S1Ae4bt+oJSG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789198249; c=relaxed/simple;
	bh=IO/BcjePld4OF4G/Sh0dlQmTf4ZU39oYBwhSPmUxai4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GNCyquZcAg2+TOtDFXxtbls7HIAuZY2iCVmH4VNpWnGOExKKzHcPikLfqm0iwE+9kYiRYpNf8BuDhfA59/ZdpkWk7uXblzKs/V40ecF/SDV6puXNVa6/J+OMIAygP04sbd1JaTOg/xD91nK0UCTjJnC5SMoepIjExelJdxxwbr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pO3G4N/K; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pO3G4N/K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AB6B1F000FF;
	Sat, 12 Sep 2026 07:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789198247;
	bh=iTfcNbUJJkXV9u8gU9ar5Db8mq5sXlRxCftiQuRYDTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pO3G4N/K2IlgwyHi5lOignuT9GkHCoqCkrWVhNm4qh32occKnnBNVncggTAF1EHhz
	 Zd5diUpm8NXS1/5dX8zG2wwgcR9hDhLDPEiZ+jSJD11ATOPGXPeA8160WKcSHV7aAJ
	 7lGQhO6JHhR5MR2hFmSbbM4kxddTxM3hrrswtR64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0341/1815] bpf: Require a BPF cpumask for bpf_cpumask_populate()
Date: Sat, 12 Sep 2026 08:34:51 +0200
Message-ID: <20260912065656.920225956@linuxfoundation.org>
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
index b8c805b4b06a0..1336a4efa7553 100644
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
index bcc0b4c84fc09..09149c32c41c6 100644
--- a/tools/sched_ext/include/scx/compat.bpf.h
+++ b/tools/sched_ext/include/scx/compat.bpf.h
@@ -84,7 +84,7 @@ bool scx_bpf_dispatch_vtime_from_dsq___old(struct bpf_iter_scx_dsq *it__iter, st
  *
  * Compat macro will be dropped on v6.19 release.
  */
-int bpf_cpumask_populate(struct cpumask *dst, void *src, size_t src__sz) __ksym __weak;
+int bpf_cpumask_populate(struct bpf_cpumask *dst, void *src, size_t src__sz) __ksym __weak;
 
 #define __COMPAT_bpf_cpumask_populate(cpumask, src, size__sz)		\
 	(bpf_ksym_exists(bpf_cpumask_populate) ?			\
-- 
2.53.0



