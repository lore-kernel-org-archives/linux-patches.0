Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A3421DA112;
	Wed, 19 Mar 2025 14:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395094; cv=none; b=n9wYidoHp+Pfqy+ClZbm6nKvk3+ogndr4bz7yfNXVrxBiZa1/I1fDBqXewcTYMyEDBPWRrd9nH0UROLb1VAXWOxmW0el6D5F1wP9JXtTMMAETD2SaMO9fBLNcoVNwUs4Lq4v2nI/nL3AJpqw4YgBwCj10mRvdjJ5PpzAFlH47P4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395094; c=relaxed/simple;
	bh=6Iju+ntpwo8ymvKWQTLw8OpAlum0c3ab0Ix7s32UunE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sABHrETxrx0wzbNV4t6SyDHLzzgPuDvE3JiSK62cYbf2qqnRCgGf9L4lHJan90kBpJS3+GwVhZopSB05QZ5MgjWaVraJ6y98bN3AaK0S9+Gyg7x5YZuxDKvFM4AWl0TE5cAVYucySL5EkA8KcoMyNeRV5UAq6MrepMQTE+W2fGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qC6M3f02; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qC6M3f02"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FE42C4CEE4;
	Wed, 19 Mar 2025 14:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395094;
	bh=6Iju+ntpwo8ymvKWQTLw8OpAlum0c3ab0Ix7s32UunE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qC6M3f02baRStnMeetG0ymWOVDDAvauG+y4IYQt6+ao1hyR5CpppxMsK3OP0O06lE
	 Sjuz6swDN9//B5WXpiKw+LRe286ouYqRIxQbBzWvHE6MhpWciy2CzoxlleNZuQ64Gz
	 C1NkU0hxsmNiX4IUsjaqBxzoRZGiV8FueSPyujWc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keith Busch <kbusch@kernel.org>,
	Mike Christie <michael.christie@oracle.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 143/231] vhost: return task creation error instead of NULL
Date: Wed, 19 Mar 2025 07:30:36 -0700
Message-ID: <20250319143030.369144031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit cb380909ae3b1ebf14d6a455a4f92d7916d790cb ]

Lets callers distinguish why the vhost task creation failed. No one
currently cares why it failed, so no real runtime change from this
patch, but that will not be the case for long.

Signed-off-by: Keith Busch <kbusch@kernel.org>
Message-ID: <20250227230631.303431-2-kbusch@meta.com>
Reviewed-by: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/mmu/mmu.c | 2 +-
 drivers/vhost/vhost.c  | 2 +-
 kernel/vhost_task.c    | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kvm/mmu/mmu.c b/arch/x86/kvm/mmu/mmu.c
index 19c96278ba755..9242c0649adf1 100644
--- a/arch/x86/kvm/mmu/mmu.c
+++ b/arch/x86/kvm/mmu/mmu.c
@@ -7589,7 +7589,7 @@ static void kvm_mmu_start_lpage_recovery(struct once *once)
 				      kvm_nx_huge_page_recovery_worker_kill,
 				      kvm, "kvm-nx-lpage-recovery");
 
-	if (!nx_thread)
+	if (IS_ERR(nx_thread))
 		return;
 
 	vhost_task_start(nx_thread);
diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 9ac25d08f473e..63612faeab727 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -666,7 +666,7 @@ static struct vhost_worker *vhost_worker_create(struct vhost_dev *dev)
 
 	vtsk = vhost_task_create(vhost_run_work_list, vhost_worker_killed,
 				 worker, name);
-	if (!vtsk)
+	if (IS_ERR(vtsk))
 		goto free_worker;
 
 	mutex_init(&worker->mutex);
diff --git a/kernel/vhost_task.c b/kernel/vhost_task.c
index 8800f5acc0071..2ef2e1b800916 100644
--- a/kernel/vhost_task.c
+++ b/kernel/vhost_task.c
@@ -133,7 +133,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 
 	vtsk = kzalloc(sizeof(*vtsk), GFP_KERNEL);
 	if (!vtsk)
-		return NULL;
+		return ERR_PTR(-ENOMEM);
 	init_completion(&vtsk->exited);
 	mutex_init(&vtsk->exit_mutex);
 	vtsk->data = arg;
@@ -145,7 +145,7 @@ struct vhost_task *vhost_task_create(bool (*fn)(void *),
 	tsk = copy_process(NULL, 0, NUMA_NO_NODE, &args);
 	if (IS_ERR(tsk)) {
 		kfree(vtsk);
-		return NULL;
+		return ERR_PTR(PTR_ERR(tsk));
 	}
 
 	vtsk->task = tsk;
-- 
2.39.5



