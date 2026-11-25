Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622684;
	b=HGrK6Y07SKbXDLfmnxHnFMd97xUVa0SVuFLeNCKK503J9h9CAPr9pm1FwLh0nu4h8/us
	 ArbIoDEBweVgPIG7m0IQQJu8XyF5T+z1yc1rLRvewtBvRTPxuIQf2VWaA6kPeyCztjWfP
	 y/0HjtNdvALnZns9adQOLHJstFpZdk+c/cbVHwLlgucWEQsD615Lvozvi3tQOp6r7RTvm
	 wZkHyMyjHXsdFSe2zNYMOftSTCykehsjGSSgoQBbqbsc2vEHynlUxdUwDImZtJRPT7ypa
	 c8Ups/DXKReF198fBm2LcFAf6lYKGj0qp704CG/E2pYPvc80Uu2rF1a0T8IBJlYmGxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622684;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Qu8hZKsOeR/YbMeZeyGkLTky1+5LzWUsahekaOvHW40=;
	b=U2fQhH0i69Y58t+RZkr4DfxD/YLRL33ckK/rDol3WYvZkrlWECCTY3TX875HXD8xfPsF
	 v1Weg8NzqH3yPFGD1UrHXkhNHG+t+WT4FmdPRPaZTH6mlz/8+vAHAvzd0NJ0wBSDrPYyL
	 s1c6+S48+Lxsj6lStXrBG+AW9A0vpO8Lj8m5WM5qyumwdJyWJQQbt6plwJ4ofUt8vlW97
	 vwrEKHYiswnbqTpDad36yMMOk3dWYDXI4Ou1JYET6DFIbFLvUnFWA+nDxiozFVzSwa3vL
	 ajg+l69kmDbOJUWaXofwLHI2THwIebfbSIvWfOsLi3BbySVK0U7q3uZl/sT5myL//OQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYdssIon;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDA0606A321;
	Wed, 25 Nov 2026 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FYdssIon
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2043F1F000C0;
	Wed, 25 Nov 2026 16:04:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622683;
	bh=Qu8hZKsOeR/YbMeZeyGkLTky1+5LzWUsahekaOvHW40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYdssIonRMOvB2t4juNfpCWyT52LEIMvS6H7OPKdvNV7nsSkRQpTjp0aUbuqrsOIK
	 B4t5YMgVMb9l2scl/bqdKidDrdE2jtRCX+xb2tSMu++otYb+wFoo7/PsLt77EJLAK9
	 l/IQcMANEn7PNkD8SaBVFhKsIABvVFQxZs21pldw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 615/990] cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
Date: Wed, 25 Nov 2026 15:33:02 +0100
Message-ID: <20261125143836.498359790@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index ee5ee72b8590d..4a38da24c3612 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -2044,9 +2044,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
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



