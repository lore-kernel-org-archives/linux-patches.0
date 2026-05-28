Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664BB352019;
	Thu, 28 May 2026 20:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999125; cv=none; b=OgXbQTEmhVRqOFwAzeDbIiXIJTDEi/thJNzqqUj0InhcJePzn+rOHDjyku2sJqjErm8yu/0hk3XU7e7R/gPQCiwVRuoJQVlfKWle2wgM5Hj2oT1uZTH05PDWlNMoVlV/dhMrTol3uIXWicvjmxl9IpddXTIHVGxG88R/DH4xaNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999125; c=relaxed/simple;
	bh=3s8GaQdNlhkYAUp5KdGuahhUlm9ynI7bN3DEGIeELtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8LoAdDgdoCzoFfHqeNbHfRgE9YAeDw5V+HF52t6scTZ93ykUQ6FbxwAXZvW4jbv2UTFpj0OUDj0OM5wdv15HcXUZQCarzOJCiVb/o55IPy1iEJikis79Jn2tCzykWa2aU8ruy5GF0nwPaR6pdElgU2gnLI9wZGPqsB3TwayYCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x+IH4erl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x+IH4erl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE9D61F000E9;
	Thu, 28 May 2026 20:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999124;
	bh=Z0piLGsJ5Xst/nLi0o9yMRvz1WLxRSuDj7hUmMJPwdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=x+IH4erluLKsoGeux74/qKWsciY03ImPNk9yT3NKvPRz1E1zB5m6T1179jwvUP+ad
	 a6VfxuEQjkAgFsdSD/2WQGKirdxVAQn1Vl3Vp2o/2l48Z2FdZwxlFe2QbwpOCwxYgs
	 QpjI8zQt5q0Sm+/fUmW1peK6cjJESW7ZJlbVg6No=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cunlong Li <shenxiaogll@gmail.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 417/461] cgroup: rstat: relax NMI guard after switch to try_cmpxchg
Date: Thu, 28 May 2026 21:49:06 +0200
Message-ID: <20260528194659.568445694@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



