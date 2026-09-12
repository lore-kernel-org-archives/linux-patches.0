Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2713B37F313;
	Sat, 12 Sep 2026 07:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199430; cv=none; b=A7D3BsISyqFLUGJvxKe9JlWVJyPfL2Ar3gbsSpLJkkMFYifUSKnFRXRfIuiFvGWzRmMWGepZqIMoX4w/NLVLDFfx+ap7++LrqFKy1P7DrU540pCbhP9B81rOEYenx6xF4G13q3O3EoghuFam/X43ChGJNviO4nVd+qvOW1mZepQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199430; c=relaxed/simple;
	bh=Z16zsBz+onGmRB1ZHacilpYBroNCu+ELMMGOUTfA1mQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fDXPnzx/rYAT+uYkly3eO76XOkxDGYJYskd8bqleEoYxRc3oqL8SCaUFiT2Jgt38HlkG6+PNdr8pmCAgTIyu7RS8shpiqR0XZYIDfIBeQ5Oa8SpTTf1iTghld5GFrXznLZrDE2fOdyYhV6Aw5HpIEc/3YgQuN0WocUVitAvxEkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FOIjZvw5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FOIjZvw5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D43BB1F000FF;
	Sat, 12 Sep 2026 07:50:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199429;
	bh=kcuu9NsHlOhyzP9JX9CiwroX+qeZJAiAuw6Di8+pBxs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FOIjZvw5M3d995RkLgbdR5lqHpEH4e0IbnciPGWHF3Z8tQ4/s4fCzonJd4scTOMd8
	 /kTGZs6iJH/qVxur8lOt5OcWo7n+0nSysrqJkfNpUbXV3Mye7Ers7+ppwo+BoVli9V
	 i6b9oHpvaX82jp+ef5TZfJqoZ0If7tMyV65W4tKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0582/1815] RDMA/core: Fix potential use after free in ib_destroy_srq_user()
Date: Sat, 12 Sep 2026 08:38:52 +0200
Message-ID: <20260912065702.544647414@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit 88244ecc71cc0b3ed200f5ef7ddea6686adfd730 ]

When accessing a SRQ via the netlink path the only synchronization
mechanism for the said SRQ is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
ib_destroy_srq_user(), which is too late, since by that point
vendor-specific resources associated with the SRQ might already be
freed. This can leave a short window where the SRQ remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_begin_del() call to the start of
ib_destroy_srq_user(), ensuring that the SRQ is removed from restrack
before its internal resources are released. This guarantees that no new
users hold references to a SRQ that is in the process of destruction.

In addition, this change preserves the intended inverted order
between create and destroy routines: resources are added to
restrack at the end of successful creation, and hence shall be removed
from the restrack first thing during the destruction flow, which keeps
the lifecycle management consistent and predictable.

Fixes: 48f8a70e899f ("RDMA/restrack: Add support to get resource tracking for SRQ")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-4-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 6033e6f9fdc50..d8e0b7afb6b97 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1140,16 +1140,20 @@ int ib_destroy_srq_user(struct ib_srq *srq, struct ib_udata *udata)
 	if (atomic_read(&srq->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_begin_del(&srq->res);
+
 	ret = srq->device->ops.destroy_srq(srq, udata);
-	if (ret)
+	if (ret) {
+		rdma_restrack_abort_del(&srq->res);
 		return ret;
+	}
 
 	atomic_dec(&srq->pd->usecnt);
 	if (srq->srq_type == IB_SRQT_XRC && srq->ext.xrc.xrcd)
 		atomic_dec(&srq->ext.xrc.xrcd->usecnt);
 	if (ib_srq_has_cq(srq->srq_type))
 		atomic_dec(&srq->ext.cq->usecnt);
-	rdma_restrack_del(&srq->res);
+	rdma_restrack_commit_del(&srq->res);
 	kfree(srq);
 
 	return ret;
-- 
2.53.0



