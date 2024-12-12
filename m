Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C5602288EF;
	Thu, 12 Dec 2024 17:44:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025453; cv=none; b=KG7rO5D0gwrEUWobsHUkwqRQPfIvYXV1Kq2EVCxI2X0wefxP42BuMBQncXDR9lrJTgW5PhwqNNFVevKKtW1SaPhsGvb/s+5wiRa1HRPpbH1VWyHu8ZRTnaa9cqLKAdEjZEyWKzqYxFHAPR49Rcs8NWYFHsTtj9celwdd47H4bls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025453; c=relaxed/simple;
	bh=BvOdhKEWE+VdP8BPmOyC8jU1SiHZ9ZOh20uzJGd05SM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=StYqApngoY2G/+353dcUeLlQ02yd9GaaJ4TLlLQRb0JXsCRpEY9UJweNrIdeMXOz7D11+9EEpUa3k9ybh+X3imrFeQ/sKj5KOF8FVsSIwn7Q8j58O4+ZT6srzvl5EKnzu4XH/AA7iPAM1ADcpL4viVBSQF8RjgVo5fSKUDPxeWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFBaSkZ7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFBaSkZ7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73736C4CED3;
	Thu, 12 Dec 2024 17:44:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025452;
	bh=BvOdhKEWE+VdP8BPmOyC8jU1SiHZ9ZOh20uzJGd05SM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFBaSkZ70ZrZafiS9QIMlBSq4uadghX4wMFqLWD6+1nhK/VD97SOvrZCooRgJ6qG9
	 Bx31PS44OWrF8ylBcAqnKihoQ9iSPE/TQS7HQLjY4Px+YVDjxLvmv67eqZvr9mhkqx
	 JwyuU4JX0ec0qSvInJ7hAM4JZPk5bRwANzOERVJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Waiman Long <longman@redhat.com>,
	Yafang Shao <laoar.shao@gmail.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Shivani Agarwal <shivani.agarwal@broadcom.com>,
	Siddh Raman Pant <siddh.raman.pant@oracle.com>
Subject: [PATCH 5.4 143/321] cgroup: Move rcu_head up near the top of cgroup_root
Date: Thu, 12 Dec 2024 16:01:01 +0100
Message-ID: <20241212144235.627989173@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
[Shivani: Modified to apply on v5.4.y]
Signed-off-by: Shivani Agarwal <shivani.agarwal@broadcom.com>
Reviewed-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Siddh Raman Pant <siddh.raman.pant@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/cgroup-defs.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -506,6 +506,10 @@ struct cgroup_root {
 	/* Unique id for this hierarchy. */
 	int hierarchy_id;
 
+	/* A list running through the active hierarchies */
+	struct list_head root_list;
+	struct rcu_head rcu;
+
 	/* The root cgroup.  Root is destroyed on its release. */
 	struct cgroup cgrp;
 
@@ -515,10 +519,6 @@ struct cgroup_root {
 	/* Number of cgroups in the hierarchy, used only for /proc/cgroups */
 	atomic_t nr_cgrps;
 
-	/* A list running through the active hierarchies */
-	struct list_head root_list;
-	struct rcu_head rcu;
-
 	/* Hierarchy-specific flags */
 	unsigned int flags;
 


