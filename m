Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625449;
	b=Y3ZvyzylczD04YNsZQe709bZVcEI/bPABas9hXRJYwXjBV+jtdg8PTwpJUOrKQq/AT3I
	 ZshR947ij11mmdghms681nyigl4HTxg0UwCfk0ZBMtUyNtdLyc0i5Fc5S+yMPUo2vWBnf
	 V5dy4C9biF8TGGD2EdQbPJPo57Bj4N18G+H5Ays1lMPIKkO0yRQR8H6yOF/CvsMXk+MVY
	 uWHUHPLBpw0f8sxVt/cVuQWukfx3BbNl7NVFltrf36lG/zBsLVblu9/EzbysiGgGywBQp
	 4SDy0jDjt5pm88URYwgcWaKNWs/nbafiQRO/yuzu1VPVhPDIq5oV9lh32fw9Q62kZXA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625449;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bvWIhaxphOouPFBZ94/kQ9TOF9E/f50rOp28ucVq9G4=;
	b=tOz02vZZvR1Sn5mn2uif8kteKv4EJx0DzYtSj3VJKHZsBXcJSwz6Wiirjyyw7m0Qpw7h
	 AtfqKjatMRLtONXjm8mDi53We5GMiQfWxhk65C3WvPwR7M2LtnBQ82Z6qQqg2mopT0aoR
	 +guo9w5wa64HGdxGUhRkNg8yP/LP1ZvArEUX6B2NdQK3FM4q8lBCgWY8+P0hyJ4VWlBXY
	 BDCFKZiCjs4Tb1oxb98kKO9AUyA13GS8vB1Twa/lylV2Yw/UDzeaRsDHRLpckZxTSwYUZ
	 i2UW0L2Fm/lqblOAYFa4Y8eZQisGfiKz84h+FDvZnztkSa0vTwpQPk/jpKgNWGnI88Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSesNWE9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8538B606A321;
	Wed, 25 Nov 2026 16:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HSesNWE9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6194E1F000C6;
	Wed, 25 Nov 2026 16:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625448;
	bh=bvWIhaxphOouPFBZ94/kQ9TOF9E/f50rOp28ucVq9G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSesNWE9wMnDMjlntNPbsrHLDH7hTIcPOq/LV5aDuD7vDznIaOl0v13KJ459ySyog
	 jxF8uu3M3Vnq3z9bvzw9EBPlsvRhfiiqwHa3SJN8lP10ANQAlF3GIpyEuOaLiAWUMw
	 RcGQIVFf78KJ/orXumwd/0Ik3g/Hh85qkKpNU9C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guopeng Zhang <zhangguopeng@kylinos.cn>,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 521/816] cgroup/cpuset: Do housekeeping check before converting invalid partition to valid
Date: Wed, 25 Nov 2026 15:34:29 +0100
Message-ID: <20261125143901.246709643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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
[ sashal: Adapted the call to the older two-argument prstate_housekeeping_conflict() helper, passing the negated partition_root_state so an invalid isolated partition is checked as isolated. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3662acc2cff89..b1af98c19891e 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -1850,9 +1850,15 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 			bool exclusive = true;
 
 			/*
-			 * Convert invalid partition to valid has to
-			 * pass the cpu exclusivity test.
+			 * Convert invalid partition to valid has to pass the
+			 * cpu exclusivity test as well as the housekeeping
+			 * check.
 			 */
+			if (prstate_housekeeping_conflict(-cs->partition_root_state,
+							  xcpus)) {
+				part_error = PERR_HKEEPING;
+				goto write_error;
+			}
 			rcu_read_lock();
 			cpuset_for_each_child(child, css, parent) {
 				if (child == cs)
-- 
2.53.0



