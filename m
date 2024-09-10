Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5E218FC9C;
	Tue, 10 Sep 2024 10:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725965081; cv=none; b=Kv5ENtLCxHng1lL05bG79SZs5yLlPz9zZHvQALhuUpYXlfWLxF2RGv4I7MZ1JngPekOC9MOtwpWCptzrpkoZutKjq56WEKfA/7NvP/ybbmZ8C9hJDdQGsPmvJixIGibPyJUh0Nxhqp6vJKlgYWZf3WB9BLwgbEv0VnSCqkwdxHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725965081; c=relaxed/simple;
	bh=uBGU2fK8zcCEPXUR1U2/fxFOIKmqnYmueRoFdxHNyXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mzFYMzjepFiTp0gy6oZCgyzJp76MMfAI1v0nMqi0uTuDfCArg9KK8iblErV9QZXyEaxM45JaDkkwsroN2dM1MP5oTEPL5zuCyJHdyy977/qcgSLsu5U/5ry2wt8ykpCrmIvRNeVWLEkFnb/u1fxjGQ0W5fbUkGfudzULD4J8834=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u9MpHFZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u9MpHFZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 156C8C4CEC3;
	Tue, 10 Sep 2024 10:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725965081;
	bh=uBGU2fK8zcCEPXUR1U2/fxFOIKmqnYmueRoFdxHNyXM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u9MpHFZYu4vpq7or49sC35wzYmWzR9+k/9Zsx/csoNV2P221vLUhx0+4yMyt5/L/Q
	 lhYdS+bWxfY+wD8qZNKr6V6aOVAmvHX6mg4X1X5QESyMmkEPNCIaWT3vSyWWfoE6px
	 LlLcNufFEDB2OA5eu1FTJ3XcaoBTgDoh7kD/xHn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 131/186] cgroup: Protect css->cgroup write under css_set_lock
Date: Tue, 10 Sep 2024 11:33:46 +0200
Message-ID: <20240910092559.978572661@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092554.645718780@linuxfoundation.org>
References: <20240910092554.645718780@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 030eaed1f06b..643d8e178f7b 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1773,9 +1773,9 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
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



