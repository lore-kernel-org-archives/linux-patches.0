Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C07136166F;
	Wed,  8 Apr 2026 18:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673189; cv=none; b=Q0gootrJIIFTjPfqEFKDo/WeXat0eangbdOuyCMooShyAzIN+WzK1himjjkM0VS8Hb8J3GFQZMjfHJkv//dMHY9Efv48icJDp4Nu6yJjZ+vcIS/SuoiNtyt8JnOkZKKkq5i/qIbyCYcscpRzwqxygOvQbWHuwrXdDEFtKtIeaF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673189; c=relaxed/simple;
	bh=GZbfwmKxFLJO1ywtSJ8T+xuCa1mcOuLj/Wpv9BQNSb8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BGbSvxb9uqoh5SkgkuZIGZUOiFXxIKXRQscUykof8JBKQEdpbL2SBnFoFYi2RMzrRAP8safP1BiEAl8Seutyv9lMBdjHmfOHvvrqnGBegl8jgtyjONz+eSHw0bxOU/+FfeZLwZw5GAYD2Qa7MZTevvgtI10yPJQGGzzmWYc3AvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgyRgLrr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgyRgLrr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D2DC19421;
	Wed,  8 Apr 2026 18:33:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673189;
	bh=GZbfwmKxFLJO1ywtSJ8T+xuCa1mcOuLj/Wpv9BQNSb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgyRgLrrrArgqA2FTvzfio14CYs/so1XaKLxszlraeSeCvL1TYWdPcmhWI+/zmOAp
	 6Bzy23GqqiiMvjIQORMoQS7masjDrcNUvBnul7lPwlsN5P3lAD/8WZ2Mj5sG4bSHgM
	 WDqkNrjBegs6D4mgD4MTOrNAX9UA4Wp7WMPDrnrA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng-Yang Chou <yphbchou0911@gmail.com>,
	Andrea Righi <arighi@nvidia.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.18 135/277] sched_ext: Fix inconsistent NUMA node lookup in scx_select_cpu_dfl()
Date: Wed,  8 Apr 2026 20:02:00 +0200
Message-ID: <20260408175938.915489578@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
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

From: Cheng-Yang Chou <yphbchou0911@gmail.com>

commit db08b1940f4beb25460b4a4e9da3446454f2e8fe upstream.

In the WAKE_SYNC path of scx_select_cpu_dfl(), waker_node was computed
with cpu_to_node(), while node (for prev_cpu) was computed with
scx_cpu_node_if_enabled(). When scx_builtin_idle_per_node is disabled,
idle_cpumask(waker_node) is called with a real node ID even though
per-node idle tracking is disabled, resulting in undefined behavior.

Fix by using scx_cpu_node_if_enabled() for waker_node as well, ensuring
both variables are computed consistently.

Fixes: 48849271e6611 ("sched_ext: idle: Per-node idle cpumasks")
Cc: stable@vger.kernel.org # v6.15+
Signed-off-by: Cheng-Yang Chou <yphbchou0911@gmail.com>
Reviewed-by: Andrea Righi <arighi@nvidia.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/sched/ext_idle.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/sched/ext_idle.c b/kernel/sched/ext_idle.c
index ba298ac3ce6c..0ae93cd64004 100644
--- a/kernel/sched/ext_idle.c
+++ b/kernel/sched/ext_idle.c
@@ -543,7 +543,7 @@ s32 scx_select_cpu_dfl(struct task_struct *p, s32 prev_cpu, u64 wake_flags,
 		 * piled up on it even if there is an idle core elsewhere on
 		 * the system.
 		 */
-		waker_node = cpu_to_node(cpu);
+		waker_node = scx_cpu_node_if_enabled(cpu);
 		if (!(current->flags & PF_EXITING) &&
 		    cpu_rq(cpu)->scx.local_dsq.nr == 0 &&
 		    (!(flags & SCX_PICK_IDLE_IN_NODE) || (waker_node == node)) &&
-- 
2.53.0



