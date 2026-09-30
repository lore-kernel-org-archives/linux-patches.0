Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4E4B522F1F;
	Wed, 30 Sep 2026 18:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793711; cv=none; b=VCLc+Q8RZITQ/tXp1HGrFcd5+nyxpaVSkkrm3nDWhDOa03PYmOyH2ogfySXYh+yVrrwTvnXAauRADHkGZYAlmi9TAYdEqPA9QSPVTtEC0p3LtDVjPixutju2+VI3WsXZwhaZ+zKtUUweSavdKTvAihw8PLVP3FvXiTbzr8F2OnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793711; c=relaxed/simple;
	bh=CCJUnRXlnp6+vpn+0oVQ4cbsL1y7xpbdiFqyJPBpBzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=blYFiyrYbqmEiU3bn4JAPGfmKEifQsWIfYjoJsqiZ1Op9NBZ7K0+qgB23W4HEtYzNx7+Orzm4jbaN0KexAqppnn+UkakblKPu9nZBi80aejBNlU18Zgx0PgiJPqufAByFLoV1JRZRpLuNfkTzZqmhXFQgyoqzsnDYSelwaj8gQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kR6DJXms; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kR6DJXms"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7EC1F000FF;
	Wed, 30 Sep 2026 18:41:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793710;
	bh=OJLYolqMiMPGGeQcJKNQhcQNdv5E0WXh3wjOBgKBfT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kR6DJXms6QXVP1TtPEog+M9Is0X6JMUSz0dU07hI9zo1eHnbnztqJ/WNcC8SRE6lv
	 KCKrO+O9ztjFHJWwJU2yKCaFZOwyA7FlFEMOWy9uFNG+3jWsouJ0hmBnb1Ctb1Qy/w
	 g+MZCIpK8AD/gjTLf51YCyLYqVFyIfIcKlxb8aPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/395] cgroup/cpuset: Ensure domain isolated CPUs stay in root or isolated partition
Date: Wed, 30 Sep 2026 17:30:12 +0200
Message-ID: <20260930152348.271832016@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Waiman Long <longman@redhat.com>

[ Upstream commit b1034a690129acd8995137bf4462470b4a2aa690 ]

Commit 4a74e418881f ("cgroup/cpuset: Check partition conflict with
housekeeping setup") is supposed to ensure that domain isolated CPUs
designated by the "isolcpus" boot command line option stay either in
root partition or in isolated partitions. However, the required check
wasn't implemented when a remote partition was created or when an
existing partition changed type from "root" to "isolated".

Even though this is a relatively minor issue, we still need to add the
required prstate_housekeeping_conflict() call in the right places to
ensure that the rule is strictly followed.

The following steps can be used to reproduce the problem before this
fix.

  # fmt -1 /proc/cmdline | grep isolcpus
  isolcpus=9
  # cd /sys/fs/cgroup/
  # echo +cpuset > cgroup.subtree_control
  # mkdir test
  # echo 9 > test/cpuset.cpus
  # echo isolated > test/cpuset.cpus.partition
  # cat test/cpuset.cpus.partition
  isolated
  # cat test/cpuset.cpus.effective
  9
  # echo root > test/cpuset.cpus.partition
  # cat test/cpuset.cpus.effective
  9
  # cat test/cpuset.cpus.partition
  root

With this fix, the last few steps will become:

  # echo root > test/cpuset.cpus.partition
  # cat test/cpuset.cpus.effective
  0-8,10-95
  # cat test/cpuset.cpus.partition
  root invalid (partition config conflicts with housekeeping setup)

Reported-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Waiman Long <longman@redhat.com>
Reviewed-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Stable-dep-of: 31c88350b7dd ("cgroup/cpuset: Return PERR_NOCPUS in remote_partition_enable() on subpartitions_cpus conflict")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1627,8 +1627,9 @@ static int remote_partition_enable(struc
 	if (!cpumask_intersects(tmp->new_cpus, cpu_active_mask) ||
 	    cpumask_subset(top_cpuset.effective_cpus, tmp->new_cpus))
 		return PERR_INVCPUS;
-	if ((new_prs == PRS_ISOLATED) &&
-	    !isolated_cpus_can_update(tmp->new_cpus, NULL))
+	if (((new_prs == PRS_ISOLATED) &&
+	     !isolated_cpus_can_update(tmp->new_cpus, NULL)) ||
+	    prstate_housekeeping_conflict(new_prs, tmp->new_cpus))
 		return PERR_HKEEPING;
 
 	spin_lock_irq(&callback_lock);
@@ -3109,8 +3110,9 @@ static int update_prstate(struct cpuset
 		 * A change in load balance state only, no change in cpumasks.
 		 * Need to update isolated_cpus.
 		 */
-		if ((new_prs == PRS_ISOLATED) &&
-		    !isolated_cpus_can_update(cs->effective_xcpus, NULL))
+		if (((new_prs == PRS_ISOLATED) &&
+		     !isolated_cpus_can_update(cs->effective_xcpus, NULL)) ||
+		    prstate_housekeeping_conflict(new_prs, cs->effective_xcpus))
 			err = PERR_HKEEPING;
 		else
 			isolcpus_updated = true;


