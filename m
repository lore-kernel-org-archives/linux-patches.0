Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032893;
	b=Iz4GqfAnICO3aGaVt6hTb4cRq5PN4BbSOQMOTjXlYcI2lcefHqZiFjQ1+2LAmORy/xk1
	 O3ncRenphsSAL0b9tqnQhLWnmJab6sGUFM2tOmGRBM8UIuhddymbIsHUkCx3pwowpXmPZ
	 6Eg/mv7WhlPGwvWidAtkwDiQon4xXDBzi6d4Cqgl0B/GF+EAGpACrODAE3FeO6wyuqGkO
	 Y3snJVnEb2qt4PPS5Iosw2RjWsBh/7Zv21gXHLQCmbEA6WRYiQPNx5/vVxaFGKBVdV9lH
	 r/z06ArhzJ4UedpeDyIY1d1utwTknN8AIHw7Mzm9EBUx1YPE6Qq5lBMrZ04yuKX1Sew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032893;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=eistNpQDkq35NzbDikjTm91kWSGQ4gl1HSNzrpXp+JA=;
	b=hvMthoCLvMLUvkIXf8N38AnrwN8AmYBg86QxXC+APs2bfqxGJlmMPclU12GZC0UpBx2f
	 imFeU7ww/v+/8QX6J+VQnGPIsMly9naSd5YR+ZAw9eBBIdUGDpSx5Hot3H1iJ1j1nmSvs
	 NNwQWIhWKPoxIaALjVFvJIWVKrYbgLLFva9Q1lzG6xXmU28EilApT128MKs9SjpCRhqor
	 edtjiNAdOZZQkBzBHB7b+T4RjmBTLfkDIVWl1797Aq5oaaFRLVJrXwg3iY/6fnP3ikX8N
	 +6ZT9txsQ6wGupCdPoJcIi2dAma2qWQlR+FuMsK249eyBJ6bDu1QCNvpfEG56YBf8wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3f7dAPY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BD9606A33A;
	Wed, 18 Nov 2026 20:14:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d3f7dAPY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A59B1F000C4;
	Wed, 18 Nov 2026 20:14:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032892;
	bh=eistNpQDkq35NzbDikjTm91kWSGQ4gl1HSNzrpXp+JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d3f7dAPYX6TS4OgI17DAMuRJxG05rteKFRwi4EQ31KzubHAjHUzJYio6CQhTmASLd
	 xIPgPqNLYiFKSoSGtjTE31Q0jJ0WBzJwdHPvAgGCBj258/5yHJZKabNy23xXHdxe6f
	 WMcdTVAUy9dpo1JbWX0dJ6nao5kuA9Cs9SLTCiGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1574/1756] cgroup/cpuset: Make sure compute_partition_effective_cpumask() is only called for valid partition
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150112.425889980@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 356a3aa7404e420e6f19c5ed42db7b8bd0c7ee9f ]

With visual inspection to make sure that
compute_partition_effective_cpumask() is only called for valid partition
root, it was found that the function can be called for an invalidated
partition near the end of cpuset_hotplug_update_tasks(). When partcmd is
set, update_parent_effective_cpumask() is called to either invalidate a
valid partition or with partcmd_update to check if an invalid partition
can be switched back to valid. In both cases, cpuset_force_rebuild()
should be invoked. However, compute_partition_effective_cpumask()
should only be called when an invalid partition is switched back to
valid. When a partition is invalidated, compute_effective_cpumask()
should be called instead.

Also add a WARN_ON_ONCE() in compute_partition_effective_cpumask() to
ensure that a valid partition root is passed in.

Fixes: 72c6303acfa1 ("cgroup/cpuset: Take isolated CPUs out of workqueue unbound cpumask")
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index e11c70729e0a4..3662acc2cff89 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1988,6 +1988,8 @@ static void compute_partition_effective_cpumask(struct cpuset *cs,
 	struct cpuset *child;
 	bool populated = partition_is_populated(cs, NULL);
 
+	WARN_ON_ONCE(!is_partition_valid(cs));
+
 	/*
 	 * Check child partition roots to see if they should be
 	 * invalidated when
@@ -3879,9 +3881,12 @@ static void cpuset_hotplug_update_tasks(struct cpuset *cs, struct tmpmasks *tmp)
 
 	if (partcmd >= 0) {
 		update_parent_effective_cpumask(cs, partcmd, NULL, tmp);
-		if ((partcmd == partcmd_invalidate) || is_partition_valid(cs)) {
+		if (is_partition_valid(cs)) {
 			compute_partition_effective_cpumask(cs, &new_cpus);
 			cpuset_force_rebuild();
+		} else if (partcmd == partcmd_invalidate) {
+			compute_effective_cpumask(&new_cpus, cs, parent);
+			cpuset_force_rebuild();
 		}
 	}
 
-- 
2.53.0



