Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C8D3F1655;
	Thu, 12 Mar 2026 20:14:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346461; cv=none; b=QMQJ70octmdutr/eBrnyIugelKZ+1achzRQY6KlGEtM+A3feRyUZeL9HW18Z/s5oMPIN2ErArY3fqQZMfit8mnoKMUXLfC1Fd+s4BFVPyvG2bXH+Oy5Ml9WoofYg2alASYB5HM/BICJ79ImZHmBFJpbzy9JQYGcZjdX5xWYrBLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346461; c=relaxed/simple;
	bh=4KpcjnF6ElP/ys7PrTUNcLXXnzNSSDMi+8KPZLSDDa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fqvwqe1tz8hnudVaIEk+t6P5yTS2GOr4kCnhGTz/cYBDbU4G+wLYuAcPeLOHNd38ijS6Djd8Zsi0aKPXT4gQ6l3UBdeF8UD460mQWdrCuVDRrEPa/wP0NKUaLDWv11nHzfCtX65Q0eu5LBlFcaHPFvzgsL7RBUHXNIgeB6TLLYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2js9vQnk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2js9vQnk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960E2C4CEF7;
	Thu, 12 Mar 2026 20:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346461;
	bh=4KpcjnF6ElP/ys7PrTUNcLXXnzNSSDMi+8KPZLSDDa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2js9vQnkQ7w4fWTCfAgHplytLLwofsvpazAhZz7FBhGe4Hk/nE3J7weUqLEusSGcO
	 Zkr6YpZnSI7SthwtwJouC0CKqu6DxBLAOJwhji/1gacUNvfkbWLEUnF/CygsMtxRpk
	 bPhxtR7z6QlgVxq1SX2o6pBDCGSKo8DmpQ0ZT5jY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 016/265] cgroup/cpuset: Fix incorrect use of cpuset_update_tasks_cpumask() in update_cpumasks_hier()
Date: Thu, 12 Mar 2026 21:06:43 +0100
Message-ID: <20260312201018.762242379@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 68230aac8b9aad243626fbaf3ca170012c17fec5 ]

Commit e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
incorrectly changed the 2nd parameter of cpuset_update_tasks_cpumask()
from tmp->new_cpus to cp->effective_cpus. This second parameter is just
a temporary cpumask for internal use. The cpuset_update_tasks_cpumask()
function was originally called update_tasks_cpumask() before commit
381b53c3b549 ("cgroup/cpuset: rename functions shared between v1
and v2").

This mistake can incorrectly change the effective_cpus of the
cpuset when it is the top_cpuset or in arm64 architecture where
task_cpu_possible_mask() may differ from cpu_possible_mask.  So far
top_cpuset hasn't been passed to update_cpumasks_hier() yet, but arm64
arch can still be impacted. Fix it by reverting the incorrect change.

Fixes: e2ffe502ba45 ("cgroup/cpuset: Add cpuset.cpus.exclusive for v2")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1b93eb7b29c58..77b07548c3027 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2126,7 +2126,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		WARN_ON(!is_in_v2_mode() &&
 			!cpumask_equal(cp->cpus_allowed, cp->effective_cpus));
 
-		cpuset_update_tasks_cpumask(cp, cp->effective_cpus);
+		cpuset_update_tasks_cpumask(cp, tmp->new_cpus);
 
 		/*
 		 * On default hierarchy, inherit the CS_SCHED_LOAD_BALANCE
-- 
2.51.0



