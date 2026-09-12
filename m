Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50484195DA;
	Sat, 12 Sep 2026 12:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215952; cv=none; b=NyC+5V/HIlHyB20HQPfvCfDTnVwAuB4uhY/rHbZblJHp5sBJYilVQOvB4lnRDDvODNf0H7sswhdgZ5wO936DLWRd+tJquCOsQU2idXCxviX9gHh008AnCzj0ybZ4gxCxfQxCDU4cltEeQZbv3IXaj0zSXGJUrvyo7Y2zWGORjD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215952; c=relaxed/simple;
	bh=cM8cGeowifmot+KiorVvHhok91r9kpXHDIN96/ZqmVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cxp9Ye733QCq7+MnB/tLZ1UdssoZ8aEhQg2bVQFG4w1vDT5gUgekBtb3LknVMEm5WHGUb2doFzV9UDbafHZFPYso4eaVWLGtFQoDB84k8D1wVa2G4eDAJpzaJiYaDG3UMefE/EF9SA8G21pVD6f+Xdbru7Nezbz1c83hrSP5Epw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N78qcl1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N78qcl1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E3B1F000FF;
	Sat, 12 Sep 2026 12:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215950;
	bh=YMgfK3Cz+S/EKeT3SqaWiQfVodcgOrpitgtnXIBnq0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N78qcl1tOYRU7EXnNS0dKEYiDolCz5eIozU0nsU7GYVsSBmzLFwNWqDU2BG1wS5aD
	 AlR2H5Pu3SyplMrzmAJer3kY92K3+I7vW3U01KATy4Uh3xyIdRTJUFTgSMue+JaTTB
	 qZgxaYk4IegskQONikb1UeGb3N5O2/wEIVwuxRvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0636/1376] RDMA/core: Fix potential use after free in ib_free_cq()
Date: Sat, 12 Sep 2026 08:51:02 +0200
Message-ID: <20260912065621.716757409@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 29dc2f8e1c97372c2871a70088707933515fbd5b ]

When accessing a CQ via the netlink path the only synchronization
mechanism for the said CQ is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
ib_free_cq(), which is too late, since by that point
vendor-specific resources associated with the CQ might already be
freed. This can leave a short window where the CQ remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_del() call to be before the freeing
of the vendor-specific resources ensuring that the CQ is removed from
restrack before its internal resources are released.
This guarantees that no new users hold references to a CQ that is in
the process of destruction.

Fixes: 43d781b9fa56 ("RDMA: Allow fail of destroy CQ")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-6-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cq.c b/drivers/infiniband/core/cq.c
index 584537c71545c..4ea0dfcff95ea 100644
--- a/drivers/infiniband/core/cq.c
+++ b/drivers/infiniband/core/cq.c
@@ -324,6 +324,7 @@ void ib_free_cq(struct ib_cq *cq)
 	if (WARN_ON_ONCE(cq->cqe_used))
 		return;
 
+	rdma_restrack_del(&cq->res);
 	if (cq->device->ops.pre_destroy_cq) {
 		ret = cq->device->ops.pre_destroy_cq(cq);
 		WARN_ONCE(ret, "Disable of kernel CQ shouldn't fail");
@@ -350,7 +351,6 @@ void ib_free_cq(struct ib_cq *cq)
 	else
 		ret = cq->device->ops.destroy_cq(cq, NULL);
 	WARN_ONCE(ret, "Destroy of kernel CQ shouldn't fail");
-	rdma_restrack_del(&cq->res);
 	kfree(cq->wc);
 	kfree(cq);
 }
-- 
2.53.0



