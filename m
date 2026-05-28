Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F1B223328;
	Thu, 28 May 2026 20:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000255; cv=none; b=gE4XDqybpIuhr0xQi69FXe+vXqdUukTpZsppSAYM5XWzk7r+gUVQlRToSNfzJPZd+RfbVoChzx/hLvhGgpBVqiREwVb5jK+gaib9VOPcX12RYdurNnwVnJF4vmgjs80hPTuyZd0v3fet9jfLse4w8ycBmd6r7B/Qk1pRke7DL18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000255; c=relaxed/simple;
	bh=/Ir/0y8UEOtPzS7iA39NjedKtIqvQYDGDWWq3bVynYo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dr9kRclVwHmJ0BljE5omyWIScS3wWDl9aB1CIrN0II+7MDTACrKhN7md1dLb5anUDMpdcTQhmTNAI718YIXsh54enYhdP70eKrL6piAltfnB+/zXhbKCN7cq9dVW4aNVN7EmKg+OWlh1r46FWvk1ZxYXhJWy952DstV5dhY9JK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxfF9q01; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxfF9q01"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17CA1F000E9;
	Thu, 28 May 2026 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000254;
	bh=djIJBSZUXYabq6hObHfh5l3eB26tiG2CenoN1xGTQWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxfF9q01nV/DWotsWKz3w+CR/QOGWa5MuTmbZObwQnxuPMvP6XtlxBlr7E/0xhZzE
	 dVieiMkDNZiyXA9G7kIJsKMcLdr88Nf82eGqv2okSvM/X1RixJl+f02K4XUzf6AZnl
	 1RkMjFcONoLF5NnyYsfUFnZWunkiBUvvf3hEKc90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunlong Li <shenxiaogll@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/377] cgroup: rstat: relax NMI guard after switch to try_cmpxchg
Date: Thu, 28 May 2026 21:49:48 +0200
Message-ID: <20260528194648.561803667@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

From: Cunlong Li <shenxiaogll@gmail.com>

[ Upstream commit 22572dbcd3486e6c4dced877125bbf50e4e24edf ]

Commit 36df6e3dbd7e ("cgroup: make css_rstat_updated nmi safe") used
this_cpu_cmpxchg() for the lockless insertion, and therefore required
both ARCH_HAVE_NMI_SAFE_CMPXCHG and ARCH_HAS_NMI_SAFE_THIS_CPU_OPS in
the NMI guard: on archs without the latter, this_cpu_cmpxchg() falls
back to "local_irq_save() + plain cmpxchg", and local_irq_save()
cannot mask NMIs.

Commit 3309b63a2281 ("cgroup: rstat: use LOCK CMPXCHG in
css_rstat_updated") later replaced this_cpu_cmpxchg() with plain
try_cmpxchg() to fix cross-CPU lockless-list corruption, but left the
NMI guard untouched.  After that switch, css_rstat_updated() no longer
performs any this_cpu_*() RMW operations and only relies on the arch
having NMI-safe cmpxchg, so ARCH_HAS_NMI_SAFE_THIS_CPU_OPS is no
longer required in the guard.

Relax the guard accordingly so that archs which have HAVE_NMI and
ARCH_HAVE_NMI_SAFE_CMPXCHG but not ARCH_HAS_NMI_SAFE_THIS_CPU_OPS
(e.g. sparc, powerpc on PPC64/BOOK3S) can benefit from the existing
CONFIG_MEMCG_NMI_SAFETY_REQUIRES_ATOMIC path.  Without this, the css
is never queued in NMI on those archs, and the atomics staged by
account_{slab,kmem}_nmi_safe() are not drained by flush_nmi_stats().

Fixes: 3309b63a2281 ("cgroup: rstat: use LOCK CMPXCHG in css_rstat_updated")
Signed-off-by: Cunlong Li <shenxiaogll@gmail.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/rstat.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index ed60ba119c687..de816a43db9f0 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -81,11 +81,10 @@ void __css_rstat_updated(struct cgroup_subsys_state *css, int cpu)
 	lockdep_assert_preemption_disabled();
 
 	/*
-	 * For archs withnot nmi safe cmpxchg or percpu ops support, ignore
-	 * the requests from nmi context.
+	 * The lockless insertion below relies on NMI-safe cmpxchg;
+	 * bail out in NMI on archs that don't provide it.
 	 */
-	if ((!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) ||
-	     !IS_ENABLED(CONFIG_ARCH_HAS_NMI_SAFE_THIS_CPU_OPS)) && in_nmi())
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) && in_nmi())
 		return;
 
 	rstatc = css_rstat_cpu(css, cpu);
-- 
2.53.0



