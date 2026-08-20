Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1746D3803D7;
	Thu, 20 Aug 2026 17:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247830; cv=none; b=dbfVR/WOFKKqKaZSrU6+iBVxLQxrO9q8D4X4+Jp40g27DOSn7lXVTRFy6SEog6bOKtx5Zka0WxFcMbigrFDJys37X8YGJjAaESX4EsIurJxsIHzj1ojpcRvZrHpF77LQwjzPkLErEaANPL+0SEeI3KBeBvnO3id0/d2pB0MXgO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247830; c=relaxed/simple;
	bh=L+buUzWzGd0R93kxw3KvqtxhTLcYna9aQOloXOvg2/8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kw+EzUwt28MWx2B43lBkVCsi1VGWOTFY1l4pH1L/NdHUq9Ol1IVDbJCba/SszG1xeuQneH+JMbsgftc1yhnFQjv/jwvak9WG8/zCxnXZe+Hara6OgXnKWvZUdLQ4z48+uqYOLOaPP00JqcO2sZgo8h3w+mbt4iMmDWwtsgwc3VI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tlx1HCyw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tlx1HCyw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BBDD1F000E9;
	Thu, 20 Aug 2026 17:43:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247829;
	bh=DUhwtlNEKy9dhasvMKwP7+ACTo3l1qTzbAThJCVHfGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Tlx1HCywdTcRD8gEe2nLTi4kigs2m71yrOyJgdmuWXOHdDDysYc1c0WMRzEm/Wt/c
	 Ca7qY2iMjJpgJ+CycyMLnF4cJaWOYmAVQETeREanwKcKAkgci+xcOxxtzfIZTkbxNc
	 /N2CFkH43E3WfJ4ziqdCBJOMQk8YJEgFY46eFvE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Tian <kevin.tian@intel.com>,
	Eric Auger <eric.auger@redhat.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Lixiao Yang <lixiao.yang@intel.com>,
	Matthew Rosato <mjrosato@linux.ibm.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Farhan Ali <alifm@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/303] kernel/user: Allow user_struct::locked_vm to be usable for iommufd
Date: Thu, 20 Aug 2026 16:52:18 +0200
Message-ID: <20260820145253.272230469@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145253.200766705@linuxfoundation.org>
References: <20260820145253.200766705@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit ce5a23c835aa0f0a931b5bcde1e7811f951b0146 ]

Following the pattern of io_uring, perf, skb, and bpf, iommfd will use
user->locked_vm for accounting pinned pages. Ensure the value is included
in the struct and export free_uid() as iommufd is modular.

user->locked_vm is the good accounting to use for ulimit because it is
per-user, and the security sandboxing of locked pages is not supposed to
be per-process. Other places (vfio, vdpa and infiniband) have used
mm->pinned_vm and/or mm->locked_vm for accounting pinned pages, but this
is only per-process and inconsistent with the new FOLL_LONGTERM users in
the kernel.

Concurrent work is underway to try to put this in a cgroup, so everything
can be consistent and the kernel can provide a FOLL_LONGTERM limit that
actually provides security.

Link: https://lore.kernel.org/r/7-v6-a196d26f289e+11787-iommufd_jgg@nvidia.com
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Reviewed-by: Eric Auger <eric.auger@redhat.com>
Tested-by: Nicolin Chen <nicolinc@nvidia.com>
Tested-by: Yi Liu <yi.l.liu@intel.com>
Tested-by: Lixiao Yang <lixiao.yang@intel.com>
Tested-by: Matthew Rosato <mjrosato@linux.ibm.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Farhan Ali <alifm@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/sched/user.h | 2 +-
 kernel/user.c              | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/user.h b/include/linux/sched/user.h
index f054d0360a75..4cc52698e214 100644
--- a/include/linux/sched/user.h
+++ b/include/linux/sched/user.h
@@ -25,7 +25,7 @@ struct user_struct {
 
 #if defined(CONFIG_PERF_EVENTS) || defined(CONFIG_BPF_SYSCALL) || \
 	defined(CONFIG_NET) || defined(CONFIG_IO_URING) || \
-	defined(CONFIG_VFIO_PCI_ZDEV_KVM)
+	defined(CONFIG_VFIO_PCI_ZDEV_KVM) || IS_ENABLED(CONFIG_IOMMUFD)
 	atomic_long_t locked_vm;
 #endif
 #ifdef CONFIG_WATCH_QUEUE
diff --git a/kernel/user.c b/kernel/user.c
index e2cf8c22b539..d667debeafd6 100644
--- a/kernel/user.c
+++ b/kernel/user.c
@@ -185,6 +185,7 @@ void free_uid(struct user_struct *up)
 	if (refcount_dec_and_lock_irqsave(&up->__count, &uidhash_lock, &flags))
 		free_user(up, flags);
 }
+EXPORT_SYMBOL_GPL(free_uid);
 
 struct user_struct *alloc_uid(kuid_t uid)
 {
-- 
2.53.0



