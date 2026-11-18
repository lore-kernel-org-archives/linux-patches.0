Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021174;
	b=OLic0QGesHnTzMn4HO4k0PKua7E2O3ufsaxy8JgPR/B5nJJ0CEGFCofxkyJgs+Rtgt05
	 Yvdl/I1nvHr6NOun69pTtTpg75u573pU8uA7aLpMzz8HUoe5rtFxT6EctjD3daHyGbhUQ
	 UZ5hbymkgsYKutJntr8dDWGnungImIeeifS6a9Wm7LyYJUyq3Q+xUy66WQ1Fv7QqObx49
	 E/n6f/YBszEb8N40U4mqM+/ISIjpgk6hJHnJH3AoqlJz1rkJdKMem1G4RBjXH0eBxXvb3
	 pq2rj6iLtAVLbzEGWUu0V6SOCSTuvX7LxyvtRCoULgc9y6L0KH6RF2jHaEXhjKuRZJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021174;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=F7fKmBR5mIdS8aqknHWRGprioJPAr4c23sWZuqI1PwY=;
	b=Egngjjf4MBqodQB1GLlRJtds8lF/yD//c03fc5m16XLTldR4RVTTj7fYMOipgenH+9Za
	 fytdXwAWBBeozKgmXrHPQJG74nQjb2oAQwoJwtcpJVXtiyUdv+duSRfkJ3ylGGkhajlN+
	 r4+7AxQv9l3//YV9vzpszj3L1N546lO91skqITZyh8qRP5dOYE7UddM3bPhwIMaXPcEN4
	 muRteZiWVdzOLJ1C6dW0nvAA7WZFeNLhymweuN9FwbAqNLk+/tnY7gdbAFtdzNOAOlMru
	 3d5A796plbFudMcGoGSZnOZTnnrrcmLWpCvyjGZfSJKtdQj5mm5JHt3Wbp2dGX7PfXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mb/QqY9N";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EFA2606A320;
	Wed, 18 Nov 2026 16:59:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mb/QqY9N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96A641F000C9;
	Wed, 18 Nov 2026 16:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021174;
	bh=F7fKmBR5mIdS8aqknHWRGprioJPAr4c23sWZuqI1PwY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb/QqY9N4lqjZXqGSzg0+qbJCt4yr/HXUNF/B+1rezQvuKfbk54RXQhnqLtv87yaF
	 5qBj5bbOiMu8mD2hxyuN/HTA+3TunFYi0ogUzQQMxDoaTKrP1k7MaNbt36Hv6ob7u2
	 PdDq7EdkqAxWiHc8wgx7Bf9N5KoW1Rh3o+9GXdNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2186/2651] cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
Date: Wed, 18 Nov 2026 15:57:06 +0100
Message-ID: <20261118150404.453763306@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 2c0a5742fc459cd8416607acff4a38a1abcb2e1b ]

When a hotplug event happens or when update_cpumasks_hier() is called, an
invalid partition may be converted back to valid. However check against
housekeeping conflict isn't being done which can lead to a partition
state that violates the housekeeping rules. Update the code to allow
reviving an invalid partition only if it can pass the housekeeping check.

Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 4080e08428c4e..7443ee44d4d4e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2006,9 +2006,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			bool exclusive = true;
 
 			/*
-			 * Convert invalid partition to valid has to
-			 * pass the cpu exclusivity test.
+			 * Convert invalid partition to valid has to pass the
+			 * cpu exclusivity test as well as the housekeeping
+			 * check.
 			 */
+			if (prstate_housekeeping_conflict(cs->partition_root_state,
+							  parent_prs, xcpus, NULL)) {
+				part_error = PERR_HKEEPING;
+				goto write_error;
+			}
 			rcu_read_lock();
 			cpuset_for_each_child(child, css, parent) {
 				if (child == cs)
-- 
2.53.0



