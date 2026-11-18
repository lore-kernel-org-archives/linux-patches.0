Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021206;
	b=QT37oB3l8aamWcoNzDAfhiBeryPxa37NDwjnfHRvduJyNVvpOD1S9Wce8S6oFIgIChMS
	 zLuPDJX2439yXGMbU/rR1/I9cGe4Nid3gbVJJYiuAEDTMYLR5MMCgh5zBTOAH9CLeIgb1
	 NdF7aTCemxcVfyBaMgW7IHEYAulYrrFbbS+vW8kDck2o/gP5w8xDnSqZO21PM9QGb2xjH
	 P4neADvdQPo21Rcy5uQ55BGOrCHdn1KrVw9dPsptsiYOIoonPUyGtjAH7mo0QYAWmNRv/
	 MEIM6/bIu5hus4UnO0z+yZpFwkQx1DyxqQG6hNKzaxKs0A6H2o2hgaiRxNySh2P+afQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021206;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=q4Ltbrtwf646Xqknptt6Cz8gGz8u+6YmLD+4AkitC0E=;
	b=yFAWfVkCefv2SUtSeLgTlXy/f6oh/nKNv9u2WkutCQ6TdMglYWN+Wd5aIT/GNh/UQsFl
	 WWIGjcXQpAbXnvqKpGnmuzmuqW1VpSwQ9mQ/Annz8VWkSbCTHmtISRkQ2g2DWHEgeBVJs
	 lslWljwbzyuq0CNwUSi8uZ2ivyTOkX8T2hFyFVEdiIK5FvuHW979mXgiQpWHlsw6pq9Lv
	 3KxHOXlvoqW/kBSZoGlqnKMiPeEIHPIrPOSd0hk44rvyM8QXrYPwASzVsMjbQDErMvHfa
	 5c/TcCRG/R7kPo+5RYdKism/Fv34FDIS51pPuN1QYGs0yV6sQlsVKiWYWMF70qwuaVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=js6mchZ+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F26AC606A338;
	Wed, 18 Nov 2026 17:00:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=js6mchZ+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D911F000C7;
	Wed, 18 Nov 2026 17:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021205;
	bh=q4Ltbrtwf646Xqknptt6Cz8gGz8u+6YmLD+4AkitC0E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=js6mchZ+Lmk1mc4M/wqYqi1zEKPZidNT69Odlxy4s2os5dJeKDj+UHEpcpKOxl56K
	 vgb55tsHK2c2MlRhz/XVR/HJSRmc1xfxMvg9dLHoefVeu8+F4hWzro+JMGXrKXEfwm
	 pQG19w6xVks78IdUX1H0SQi1Clv3LWXjeWg3Xx+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2187/2651] cgroup/cpuset: Properly disabling partition when partition state switching fails
Date: Wed, 18 Nov 2026 15:57:07 +0100
Message-ID: <20261118150404.482677432@linuxfoundation.org>
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

[ Upstream commit db27a748a399e24af715c54c12a7e928e32d15b0 ]

Before commit 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full
don't leave any housekeeping"), the partition state can be freely switched
from "root" to "isolated" and vice versa. After that commit, the switch
from "root" to "isolated" can fail if it exhausts all the housekeeping
CPUs. Later on, the switch from "isolated" to "root" can also fail if
some of the partition CPUs are boot-time isolated by "isolcpus".

A local or remote partition is made invalid when the switch fails.
However there are 2 problems with the existing invalidation code.

 1) Both the subpartitions_cpus and isolated_cpus are not properly
    updated.
 2) In the case of remote partition with remote_partition flag set, it
    is not cleared.

Fix this by calling the proper partition disabling function in this case.

On an x86 test system with boot option "isolcpus=10 cgroup_debug" set
and more than 16 cores, the following commands were executed after boot.

  # cd /sys/fs/cgroup
  # echo +cpuset > cgroup.subtree_control
  # cat cpuset.cpus.isolated
  10
  # mkdir A
  # echo 10-12 > A/cpuset.cpus
  # echo isolated > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  isolated

Before the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10-12
  10-12

After the patch:

  # echo root > A/cpuset.cpus.partition
  # cat A/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)
  # cat cpuset.cpus.isolated .__DEBUG__.cpuset.cpus.subpartitions
  10

Reported-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/lkml/7f4c57b26ad120ab30adf35653f1dd94@kernel.org/
Fixes: 4a74e418881f ("cgroup/cpuset: Check partition conflict with housekeeping setup")
Fixes: 103b08709e8a ("cgroup/cpuset: Fail if isolated and nohz_full don't leave any housekeeping")
Reviewed-by: Guopeng Zhang <zhangguopeng@kylinos.cn>
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 17 ++++++++++++-----
 1 file changed, 12 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7443ee44d4d4e..5d1883d19319b 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3024,6 +3024,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 	bool isolcpus_updated = false;
+	bool disable_partition = false;
 
 	if (old_prs == new_prs)
 		return 0;
@@ -3084,15 +3085,21 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		 * Need to update isolated_cpus.
 		 */
 		if (prstate_housekeeping_conflict(new_prs, parent_prs,
-						  cs->effective_xcpus, NULL))
+						  cs->effective_xcpus, NULL)) {
+			disable_partition = true;
 			err = PERR_HKEEPING;
-		else
+		} else {
 			isolcpus_updated = true;
+		}
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
 		 * disables child partitions.
 		 */
+		disable_partition = true;
+	}
+
+	if (disable_partition) {
 		if (is_remote_partition(cs))
 			remote_partition_disable(cs, &tmpmask);
 		else
@@ -3101,7 +3108,7 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/*
 		 * Invalidation of child partitions will be done in
-		 * update_cpumasks_hier().
+		 * update_cpumasks_hier() below.
 		 */
 	}
 out:
@@ -3123,8 +3130,8 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 		isolated_cpus_update(old_prs, new_prs, cs->effective_xcpus);
 	spin_unlock_irq(&callback_lock);
 
-	/* Force update if switching back to member & update effective_xcpus */
-	update_cpumasks_hier(cs, &tmpmask, !new_prs);
+	/* Force update if partition is disabled & update effective_xcpus */
+	update_cpumasks_hier(cs, &tmpmask, disable_partition);
 
 	/* A newly created partition must have effective_xcpus set */
 	WARN_ON_ONCE(!old_prs && (new_prs > 0)
-- 
2.53.0



