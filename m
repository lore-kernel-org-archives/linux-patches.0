Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1412C320CA0;
	Mon, 18 Aug 2025 13:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523123; cv=none; b=ZPVUmVvvrwy7Yh+oFLz3GoE83z7eBoFycxOmtLPROpHh6L+tJv1u9fhPrW4lZRB02RyCRuJF6pyHEgZfrBVeBPP0rPKZqdmvh1mVpkjcigAIWGH8X99wE3XLmU9hL0P6mBwNwb7nZvwtvaPLv3uA9VsRzeiA9CgONhAdfDP7ghE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523123; c=relaxed/simple;
	bh=Gpz2uVS4iBAsPfAT15SE8qLSZOmuw0xwvTKNJLiNs3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk2rcN9jNkxtK/7x5jFN5C+F3e6QCa2YpNab2kzrGyBabJRxksrKFQz7Lpo1WVaibXEYrjJ48+Wbt2DxBPn+SD+17g//OjY8vgoBvI1GavhnrtL5Xkv6lGJ/xcDVpVi4XTPznbqvZ6rAsowIcyl8chPagvBLh7mOxNLalK37LA0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmMxW7GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmMxW7GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CF1DC4CEEB;
	Mon, 18 Aug 2025 13:18:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523122;
	bh=Gpz2uVS4iBAsPfAT15SE8qLSZOmuw0xwvTKNJLiNs3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmMxW7GSjVkDNnGhPDAd6JnKTURANNRMLLUjjj+FE+BU89dU2POIdrGpTQ8G2QGyh
	 1CUg2vxzzA5mr/CQ6dRiXUmPKdV2pHkPkaU6TwAtX30cHKhWfdnkgR/2d4I/t7Rep6
	 ohid1xk8F9dRvVFC7CoP9W8ljxCWZe0YsgVd2aBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 076/515] ipvs: Fix estimator kthreads preferred affinity
Date: Mon, 18 Aug 2025 14:41:02 +0200
Message-ID: <20250818124501.308351252@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit c0a23bbc98e93704a1f4fb5e7e7bb2d7c0fb6eb3 ]

The estimator kthreads' affinity are defined by sysctl overwritten
preferences and applied through a plain call to the scheduler's affinity
API.

However since the introduction of managed kthreads preferred affinity,
such a practice shortcuts the kthreads core code which eventually
overwrites the target to the default unbound affinity.

Fix this with using the appropriate kthread's API.

Fixes: d1a89197589c ("kthread: Default affine kthread to its preferred NUMA node")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Acked-by: Julian Anastasov <ja@ssi.bg>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/ip_vs.h            | 13 +++++++++++++
 kernel/kthread.c               |  1 +
 net/netfilter/ipvs/ip_vs_est.c |  3 ++-
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/net/ip_vs.h b/include/net/ip_vs.h
index ff406ef4fd4a..29a36709e7f3 100644
--- a/include/net/ip_vs.h
+++ b/include/net/ip_vs.h
@@ -1163,6 +1163,14 @@ static inline const struct cpumask *sysctl_est_cpulist(struct netns_ipvs *ipvs)
 		return housekeeping_cpumask(HK_TYPE_KTHREAD);
 }
 
+static inline const struct cpumask *sysctl_est_preferred_cpulist(struct netns_ipvs *ipvs)
+{
+	if (ipvs->est_cpulist_valid)
+		return ipvs->sysctl_est_cpulist;
+	else
+		return NULL;
+}
+
 static inline int sysctl_est_nice(struct netns_ipvs *ipvs)
 {
 	return ipvs->sysctl_est_nice;
@@ -1270,6 +1278,11 @@ static inline const struct cpumask *sysctl_est_cpulist(struct netns_ipvs *ipvs)
 	return housekeeping_cpumask(HK_TYPE_KTHREAD);
 }
 
+static inline const struct cpumask *sysctl_est_preferred_cpulist(struct netns_ipvs *ipvs)
+{
+	return NULL;
+}
+
 static inline int sysctl_est_nice(struct netns_ipvs *ipvs)
 {
 	return IPVS_EST_NICE;
diff --git a/kernel/kthread.c b/kernel/kthread.c
index 77c44924cf54..800c8fc46b08 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -894,6 +894,7 @@ int kthread_affine_preferred(struct task_struct *p, const struct cpumask *mask)
 
 	return ret;
 }
+EXPORT_SYMBOL_GPL(kthread_affine_preferred);
 
 /*
  * Re-affine kthreads according to their preferences
diff --git a/net/netfilter/ipvs/ip_vs_est.c b/net/netfilter/ipvs/ip_vs_est.c
index f821ad2e19b3..15049b826732 100644
--- a/net/netfilter/ipvs/ip_vs_est.c
+++ b/net/netfilter/ipvs/ip_vs_est.c
@@ -265,7 +265,8 @@ int ip_vs_est_kthread_start(struct netns_ipvs *ipvs,
 	}
 
 	set_user_nice(kd->task, sysctl_est_nice(ipvs));
-	set_cpus_allowed_ptr(kd->task, sysctl_est_cpulist(ipvs));
+	if (sysctl_est_preferred_cpulist(ipvs))
+		kthread_affine_preferred(kd->task, sysctl_est_preferred_cpulist(ipvs));
 
 	pr_info("starting estimator thread %d...\n", kd->id);
 	wake_up_process(kd->task);
-- 
2.50.1



