Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90F1A29A1;
	Tue, 17 Feb 2026 20:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361296; cv=none; b=h+5D868Va3VuJMKYRdlz9qxaEHUh70bBx+1HcH30MyhefXh+81K1MeVlFKHygnh1FzjSel69N6dwdQW5T8qgl6EqgH1ffKL6byfwnzCOenMf8zL3RYTMppBhJAh9bDkqIS5Qt0n/ThebCrxMBT8avj6Gr+Mb93WGPDdRSSA4pvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361296; c=relaxed/simple;
	bh=YUZsNAoHy3C7dVTedfrAtBm1t6ptuD89/jTOoZHEfzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f3HI/elAoYw52Qjo6PhwTUIDpI5vc6Z4WR7mRPsLlA9C2zCBzOaKgaEhserZKAAl3FYi0mM78ASnQlLCURPgHnQkD5z61j+AoB1Al2izgJGCty1YRfvb+vQ11QFUzVVglOa1EoqUqWtbJ+3UODxVWfaNlpnQvXAW1r8Ms/ay0so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jbMe8Oqc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jbMe8Oqc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDBEFC4CEF7;
	Tue, 17 Feb 2026 20:48:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361296;
	bh=YUZsNAoHy3C7dVTedfrAtBm1t6ptuD89/jTOoZHEfzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jbMe8OqckWbA98feSPFLMHYF6hoQL6nORsZKKOom+3xMGdfNeMeIenTtnlfyTY97/
	 YHWju35yx/+VpqexIVMdtGHBtXGS0p0+xgIl+Iz0qhKcXoH9hKDyIPELWq5nJvuG5L
	 tYi/TtQkQOS4WjXsvXJYoc0V7O6639bUE7r7xIlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waiman Long <longman@redhat.com>,
	Tejun Heo <tj@kernel.org>,
	Chen Ridong <chenridong@huawei.com>
Subject: [PATCH 6.1 57/64] cpuset: Fix missing adaptation for cpuset_is_populated
Date: Tue, 17 Feb 2026 21:31:53 +0100
Message-ID: <20260217200009.643447935@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -509,7 +509,7 @@ static inline bool partition_is_populate
 	    cs->attach_in_progress)
 		return true;
 	if (!excluded_child && !cs->nr_subparts_cpus)
-		return cgroup_is_populated(cs->css.cgroup);
+		return cpuset_is_populated(cs);
 
 	rcu_read_lock();
 	cpuset_for_each_descendant_pre(cp, pos_css, cs) {


