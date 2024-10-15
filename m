Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70D481E7669;
	Tue, 15 Oct 2024 11:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992334; cv=none; b=H0F+vG8ptMWk/vxUlSBJBVAU8u2s0sCfroN215kkmQQFuAEuBTths5p9BOwNhK7MQppWBtW5cM8sCunsuFNFBpeR/JUXDuK1USRjgzg6naaSExgKMZwYw8Z8Ydi+Ztyb+izG+Kyd7AjiTz4JKekZ8p1CFOy6J6t6WYTX+Z171hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992334; c=relaxed/simple;
	bh=Un5gbO0mYqgdWbQ6lau6lzJ91bpzpIXa8iWT25Ok+AQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TJXsHdc4qQV7QKtVBjXL1d6zzZo4nckgcA3K3zoBXbOm8T7HLBQS4CL2dce95EJ2SmRUeYCE7lzQaVNfs8C4J+HcZA2J0gssDBmGAGfdYDsU1ccOUobRHQKZwqLGKCydGZIKTFZkWh/4F5KG3+eabqzqt0BeB47MUatZzoCg0gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AE8GmwdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AE8GmwdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5C69C4CEC6;
	Tue, 15 Oct 2024 11:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992334;
	bh=Un5gbO0mYqgdWbQ6lau6lzJ91bpzpIXa8iWT25Ok+AQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AE8GmwdI+6xsRfvHrfffk3W0rYagGmXXewMY90qomC5IVl0wD9+SBlQfQntU66yrA
	 ElCaTuF6JE+cK2O1j4YZipZdAaxSmC7TGcjEKzaYHLXF5NGPqMVi9pzOTH78sM2KWv
	 Id+Gy/NZoZtSnIVDC8uMpYSkHTc6xAfE+qg0mhoE=
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
Subject: [PATCH 5.15 087/691] cgroup: Move rcu_head up near the top of cgroup_root
Date: Tue, 15 Oct 2024 13:20:35 +0200
Message-ID: <20241015112443.818158083@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -505,6 +505,10 @@ struct cgroup_root {
 	/* Unique id for this hierarchy. */
 	int hierarchy_id;
 
+	/* A list running through the active hierarchies */
+	struct list_head root_list;
+	struct rcu_head rcu;	/* Must be near the top */
+
 	/* The root cgroup.  Root is destroyed on its release. */
 	struct cgroup cgrp;
 
@@ -514,10 +518,6 @@ struct cgroup_root {
 	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
 	atomic_t nr_cgrps;
 
-	/* A list running through the active hierarchies */
-	struct list_head root_list;
-	struct rcu_head rcu;
-
 	/* Hierarchy-specific flags */
 	unsigned int flags;
 


