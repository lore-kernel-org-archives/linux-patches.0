Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F06B19F473;
	Thu, 15 Aug 2024 14:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730807; cv=none; b=bUauKgx5f3IipK4jQgMPFDf1a3x5R/VBPcQJxmWQNoEhY/jpri9oUkyLoy+E+0KbDJnGKuN5s29VWQIKBsl9rZXFJfH7Iibz0XjlxX7FokElhrZKAcKvd0z3+Wx7nNodwasZozpiHAR4QgqNT8cT+7mosDgkvHccqpsw63tuwAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730807; c=relaxed/simple;
	bh=jr39QDXgwB3npO4sf7Md/WRToGIRzZwOBt+vS19+dy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XdtbJCqyG4SplchMlvSFQDSGQ1myqJEvOdOWWjl/zsDa2ZiMR8a7IwPOzOas/4UlugX4E++NPN93Iq6OI9em0WrKwfbX+fEEFBFxcWvBGBzD+vmMO6PQ5fDNKKix55OWV+QaVJXP2pt58LZDsa6g3ZEnZ4QKAz1lLbi+J4FjWx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ml4jFpu2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ml4jFpu2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A373CC32786;
	Thu, 15 Aug 2024 14:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730807;
	bh=jr39QDXgwB3npO4sf7Md/WRToGIRzZwOBt+vS19+dy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ml4jFpu2WHzQ1k0HhgvxPMaeQnRXO9Qzkg0+mTIuVpJqbcs1tsmO0Ji0ivDafOS+O
	 miijbeWMrGHBt+JukCmd8oCMLXepQa8s6USfu11Rw3QUe7xE8LLNyF/bFkQiLPQCFo
	 +FibWuHNouSulME6qm/b/zR6lTd++4LNYahlW3u4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Waiman Long <longman@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>
Subject: [PATCH 6.1 36/38] cgroup: Move rcu_head up near the top of cgroup_root
Date: Thu, 15 Aug 2024 15:26:10 +0200
Message-ID: <20240815131834.342572161@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131832.944273699@linuxfoundation.org>
References: <20240815131832.944273699@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waiman Long <longman@redhat.com>

commit a7fb0423c201ba12815877a0b5a68a6a1710b23a upstream.

Commit d23b5c577715 ("cgroup: Make operations on the cgroup root_list RCU
safe") adds a new rcu_head to the cgroup_root structure and kvfree_rcu()
for freeing the cgroup_root.

The current implementation of kvfree_rcu(), however, has the limitation
that the offset of the rcu_head structure within the larger data
structure must be less than 4096 or the compilation will fail. See the
macro definition of __is_kvfree_rcu_offset() in include/linux/rcupdate.h
for more information.

By putting rcu_head below the large cgroup structure, any change to the
cgroup structure that makes it larger run the risk of causing build
failure under certain configurations. Commit 77070eeb8821 ("cgroup:
Avoid false cacheline sharing of read mostly rstat_cpu") happens to be
the last straw that breaks it. Fix this problem by moving the rcu_head
structure up before the cgroup structure.

Fixes: d23b5c577715 ("cgroup: Make operations on the cgroup root_list RCU safe")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Closes: https://lore.kernel.org/lkml/20231207143806.114e0a74@canb.auug.org.au/
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Yafang Shao <laoar.shao@gmail.com>
Reviewed-by: Yosry Ahmed <yosryahmed@google.com>
Reviewed-by: Michal Koutný <mkoutny@suse.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -525,6 +525,10 @@ struct cgroup_root {
 	/* Unique id for this hierarchy. */
 	int hierarchy_id;
 
+	/* A list running through the active hierarchies */
+	struct list_head root_list;
+	struct rcu_head rcu;	/* Must be near the top */
+
 	/*
 	 * The root cgroup. The containing cgroup_root will be destroyed on its
 	 * release. cgrp->ancestors[0] will be used overflowing into the
@@ -538,10 +542,6 @@ struct cgroup_root {
 	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
 	atomic_t nr_cgrps;
 
-	/* A list running through the active hierarchies */
-	struct list_head root_list;
-	struct rcu_head rcu;
-
 	/* Hierarchy-specific flags */
 	unsigned int flags;
 


