Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B6CB37F33F;
	Sat, 12 Sep 2026 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199425; cv=none; b=RURpoK391gqvUvM3Xhsjc46eaDuG6Xg4CubAx2FmEbYGFYe0a2VxE6ffyyOcuFEfDRqyKuvics0BIwAQk1cfcz4r1mfUdNjs+Zu2r+ZxxF42lbjc4WZmq6R7K+LZzGnYKez/aRIq+/4UG9u/xAshux75hiPVmgsJiv0K0zwSfRY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199425; c=relaxed/simple;
	bh=1kBTNPDFCG7RCQ98FnTFjoL3/8/O3zNE/yWbhOonfP4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PpYcpwSSACeI9qZmcd+RJcyAfDw/EBkrtp9xW8HxpIjq/Vud8ZznT0VycVcG4Dvh/1XIHR0m/J9I37+ZRDaxWUsQofza9X7qtO6uufHAG9SNcbxhDvz/UK8DIZIITmZ7UiZaFYbNipWk7UoFH2EyxyXgqjtZWZoarrMH1F9fgIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j+DHzqdB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j+DHzqdB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26C131F000FF;
	Sat, 12 Sep 2026 07:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199424;
	bh=SS3xcnAlB6vmL24A/JKYSFrnJKldQvGggDQ6EAxc1aI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j+DHzqdBQf9WJXLHvWCL3y7BEZt7yTjcsFsXTaYggjSiozRaNvMCgpSRKrl+iEbzj
	 7ETMJko7ac54t0gdOSQul4T4QMueoCupTiW/6Elod0D6oA6tN4u0pXxxry+2IVawBb
	 AiQq+U5NlMsaJ/Exrwb3uOkVJ5yHLSVoW+lQ74nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0581/1815] RDMA/core: Fix potential use after free in ib_destroy_cq_user()
Date: Sat, 12 Sep 2026 08:38:51 +0200
Message-ID: <20260912065702.519786949@linuxfoundation.org>
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

[ Upstream commit 3481bec4dfc4aee24ffea5a547ee95b70b67d9d5 ]

When accessing a CQ via the netlink path the only synchronization
mechanism for the said CQ is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
ib_destroy_cq_user(), which is too late, since by that point
vendor-specific resources associated with the CQ might already be
freed. This can leave a short window where the CQ remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_begin_del() call to the start of
ib_destroy_cq_user(), ensuring that the CQ is removed from restrack
before its internal resources are released. This guarantees that no new
users hold references to a CQ that is in the process of destruction.

In addition, this change preserves the intended inverted order
between create and destroy routines: resources are added to
restrack at the end of successful creation, and hence shall be removed
from the restrack first thing during the destruction flow, which keeps
the lifecycle management consistent and predictable.

Fixes: 08f294a1524b ("RDMA/core: Add resource tracking for create and destroy CQs")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-3-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 5063bdc3f3cd5..6033e6f9fdc50 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2247,11 +2247,15 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
 	if (atomic_read(&cq->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_begin_del(&cq->res);
+
 	ret = cq->device->ops.destroy_cq(cq, udata);
-	if (ret)
+	if (ret) {
+		rdma_restrack_abort_del(&cq->res);
 		return ret;
+	}
 
-	rdma_restrack_del(&cq->res);
+	rdma_restrack_commit_del(&cq->res);
 	kfree(cq);
 	return ret;
 }
-- 
2.53.0



