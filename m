Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EFE4377563;
	Tue, 17 Feb 2026 20:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771360835; cv=none; b=RPMJH9GOE1sqRm3/abNR/vK0kKr6UACUKg9pO7BMROT/SB8+2MJJF6XOmoPvkKjUpDvIjpP06SEF7tcmBVu4hp4r9puwKCRHFWA8rLbRbkVyvX6/r0cKUQHMnUJ4sdcUfaBMYEBXdcKPnvIY+gQ9MOTt8k7/ig78PMQ0BkpYDhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771360835; c=relaxed/simple;
	bh=jQah4weuvYzTk8A1usjF/7OtP6BrC1n92SKss6MdEaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=O+Kc93NKeISJ6IOgryPdtlkL097Op8T7q1IEKmYQog7KCOA8fUaGTOU6qBBfjIih04lwwUfvhZMICf674P4D+ChjTthUWoki1PfpC3xxJJ3n3rT9Vd5P2SL9/j+Wg/CzIZ61KqmU+YLUJGvNPug7MGuD0HI3hnpUBJWNC/uEhMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ye7iRdi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ye7iRdi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4704C4CEF7;
	Tue, 17 Feb 2026 20:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771360835;
	bh=jQah4weuvYzTk8A1usjF/7OtP6BrC1n92SKss6MdEaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ye7iRdiL2RmRZXyWPjXeQ6931AlO4cMbF/iSBsVLRu+FGZvhDG+bIrw8oXdQNWJn
	 B2jZgOwN37PIb5FezOWztGxl5fyUxBoDlrpc6az0pZRTqP7f+vc9gBm8fOvHurthfm
	 kqamxla0EQsUYTTR+sI3AWlJ/35TaI6oFkDwvYAI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.6 28/39] cpuset: Fix missing adaptation for cpuset_is_populated
Date: Tue, 17 Feb 2026 21:30:50 +0100
Message-ID: <20260217200005.294682401@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200004.221651386@linuxfoundation.org>
References: <20260217200004.221651386@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ridong <chenridong@huawei.com>

Commit b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
was backported to the long‑term support (LTS) branches. However, because
commit d5cf4d34a333 ("cgroup/cpuset: Don't track # of local child
partitions") was not backported, a corresponding adaptation to the
backported code is still required.

To ensure correct behavior, replace cgroup_is_populated with
cpuset_is_populated in the partition_is_populated function.

Cc: stable@vger.kernel.org	# 6.1+
Fixes: b1bcaed1e39a ("cpuset: Treat cpusets in attaching as populated")
Cc: Waiman Long <longman@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/cgroup/cpuset.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -486,7 +486,7 @@ static inline bool partition_is_populate
 	    cs->attach_in_progress)
 		return true;
 	if (!excluded_child && !cs->nr_subparts_cpus)
-		return cgroup_is_populated(cs->css.cgroup);
+		return cpuset_is_populated(cs);
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {


