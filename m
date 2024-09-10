Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C1C1885A6;
	Tue, 10 Sep 2024 09:38:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961101; cv=none; b=WjT4Ps6kUaVkMToZxu+9ane2AGSR80hx0gd4Y0f2ed/yUIRXvqvTeU+HUZkmEOBFdAomN3LgTXDNh/fFhqfHHuKyoQaLCRSQ5TAOeCrnES3pB/Ccjn+PBEFE7RPI1JAZgvq0v5vKGv0zhl2Gjxbm6k3KQ9GFMz8OimezEfFbKSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961101; c=relaxed/simple;
	bh=YBLOBL1VrZioOKmOzE46RTVZBoEyezkPubZTkDDIy4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A2zN9t45c6VXs/QzDbgUJyAi9HsbYsyYo198jLBO7fXVWTef4FHJT1/FemFMbNkbTwYxY6OhGVY9AaCKCk0qeqdGxOizGoN3Oi65ph9qNzIaRtYiJKepIATp50cs1vX/YhVl1Af0WFX+x1c74hbWP6+1t55pW8PJ1RuSO1xhJBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m5zLI0pN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m5zLI0pN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A0E1C4CECC;
	Tue, 10 Sep 2024 09:38:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961100;
	bh=YBLOBL1VrZioOKmOzE46RTVZBoEyezkPubZTkDDIy4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m5zLI0pN11n/lew8vMtvTRnnxzh9lxnA0IWVRIiLWXa3C5/5JB303xNJEv6yB+pmo
	 0I0hNHwSM4B1K6r8t/JFg3GdcVIKclLjZ/ooz+xaIXxRYWw4g2uY0CW+6JXD00YYCs
	 +CT8U+p6f0nSa9+4J4ixVdhCJPnbCZiLGa3xCikM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 53/96] cgroup: Protect css->cgroup write under css_set_lock
Date: Tue, 10 Sep 2024 11:31:55 +0200
Message-ID: <20240910092543.863051822@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6322b56529e9..30c058806702 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1712,9 +1712,9 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
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



