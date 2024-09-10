Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72CD1188CC1;
	Tue, 10 Sep 2024 09:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961843; cv=none; b=uX1IQEeym81hEDXvH+ZNNH4XPbY/mPeaBdl2gV4nQgrlEe8wa5yRn1MSh43rnOHRolL7yMQ91eJ2B4MxA53jhVk03LJ+T8J/mr4pDs8/5x6d4Cfq0QaUJbGgBwQkOGYsd6OyjBtxXgQA+JXbO1ViySSvsM8wEvu2dShyg20cWss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961843; c=relaxed/simple;
	bh=nA3olkvI+lWlF1BrjGr+B8DP/suqe+aXMf/NCQYpefM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S42zmmXeVpxIon771VQuufrtx0RzlZ6nCqpidCF3/aOsKzesU7g3ZRU69cC0eWs5Yf0LUR+FTjxrfrUUYDTa7SvOiDFsqpUc1loH9/+L9KjbpxCosZ9lMv4rlRdhNEoC+CNekYeirTRcvCz+5bnXWUtN1NAClTvN+rD0+EQJTkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QD0Y3vXM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QD0Y3vXM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEFE3C4CEC6;
	Tue, 10 Sep 2024 09:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961843;
	bh=nA3olkvI+lWlF1BrjGr+B8DP/suqe+aXMf/NCQYpefM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QD0Y3vXMw9kWjgM609OVQkSXQLYhCw9tIA4VPE2npl7ZP4sO8QPZrMFfeXCYIENgB
	 jew5myJPRAC3VpIV8KDDqYyCrT7/LmKoQgp4pE9B/Cm+laEjN3Cue2m2eZkCOm3oTr
	 h5v1dB6oYHDOJZiBGA7SZK0AusIhERjz0cc4+Eqs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 208/375] cgroup: Protect css->cgroup write under css_set_lock
Date: Tue, 10 Sep 2024 11:30:05 +0200
Message-ID: <20240910092629.496448412@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

[ Upstream commit 57b56d16800e8961278ecff0dc755d46c4575092 ]

The writing of css->cgroup associated with the cgroup root in
rebind_subsystems() is currently protected only by cgroup_mutex.
However, the reading of css->cgroup in both proc_cpuset_show() and
proc_cgroup_show() is protected just by css_set_lock. That makes the
readers susceptible to racing problems like data tearing or caching.
It is also a problem that can be reported by KCSAN.

This can be fixed by using READ_ONCE() and WRITE_ONCE() to access
css->cgroup. Alternatively, the writing of css->cgroup can be moved
under css_set_lock as well which is done by this patch.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index e32b6972c478..278889170f94 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1839,9 +1839,9 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 		RCU_INIT_POINTER(scgrp->subsys[ssid], NULL);
 		rcu_assign_pointer(dcgrp->subsys[ssid], css);
 		ss->root = dst_root;
-		css->cgroup = dcgrp;
 
 		spin_lock_irq(&css_set_lock);
+		css->cgroup = dcgrp;
 		WARN_ON(!list_empty(&dcgrp->e_csets[ss->id]));
 		list_for_each_entry_safe(cset, cset_pos, &scgrp->e_csets[ss->id],
 					 e_cset_node[ss->id]) {
-- 
2.43.0



