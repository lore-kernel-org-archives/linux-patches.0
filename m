Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EC5A335BA9;
	Mon, 18 Aug 2025 13:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524860; cv=none; b=jXnPcp4i4GGG6Py135zD6sX6u8S9xu/eKak5uNmiUMSiqvvxktiJy9lSoAma4vvhbs+ihMtgPdKHFJtFSxBsK+S3YWI2F/pKVM6phRWZbaEv2Y6VlEFqc63M2YMAj/yO8lE58Zh6o8Hh6j51eQqWGL/l1miR8W63C1+K7PCf7KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524860; c=relaxed/simple;
	bh=aP0Xix6d8jPcoaOjI4x+W67NfHqhMFaQnNeU/LkYkec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bit5XnlfD80XdkHb+MM0bAoDM9zt4leo0/IMbIKvR1Fibqf8ZE1lUUqnklMK14nuuJ/s7hrB7EHfIq6/uIdRkK6oMN+4LvXRw+MkVeYBDrtbf6Z7zbZFDRMKkuJ9gtydBNPVO15HKV8BfAZW1BXDGd6Vjzp5bupBP7LdDiMozts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFnc1u5A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFnc1u5A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E60C4CEEB;
	Mon, 18 Aug 2025 13:47:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524860;
	bh=aP0Xix6d8jPcoaOjI4x+W67NfHqhMFaQnNeU/LkYkec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFnc1u5ACd43O4mhsRWBcrJ00g8It8KkFDKUgiGjazvbNXGo/gB0+2qZyWbAn0MLh
	 6gYCvnHmtu0menZ0PvtzevmcsL3Kut+d/DY6r7kF8lEaR+VScp7cjs+fhjqrV5sRLx
	 IDPLSTKkIY9DCJstiYC9ikXgVm85k1BcoCxJQbQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Julian Anastasov <ja@ssi.bg>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 085/570] ipvs: Fix estimator kthreads preferred affinity
Date: Mon, 18 Aug 2025 14:41:12 +0200
Message-ID: <20250818124509.092675107@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 85fc068f0083..8d5e87b03d1e 100644
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



