Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F2F32D0C75;
	Sat, 12 Sep 2026 12:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789215928; cv=none; b=uPXcIg28sG5FZg+tgjCVXLL6AXa11sBhbQ6vxs7+Km+YLS1s8ENem4W2uNq7bf7hIEO5kfyCkN3lHHTrKUP3ez7tMwbyDAGU4qSRhLkJZSnJhl7ML+hqk0xNbbX5iznT0wp49SBoQXB790RJYINQpBDSUa4Tfq1hYZ+gnQYYFL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789215928; c=relaxed/simple;
	bh=AcohDLN/jx3sCDmegz/nn9B1xMxRVMVx4bMQai0aEyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiGm1h1Aifeik4NuOkJ1kpP6Wzau1ku4vYnQkc4TAoRuP5ZoUsiitO3M7JWj/3X8diZ/F/Y/lF7fw921CZ010gnTHWLP5DDqc5eLg1V7lhT8Qmouu7kYUKYgA2od4QxBdmnRPRnbP7Uz+OP4MMpNM57gyyWIu1NXCPlK60DYNSo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQJhBAfP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQJhBAfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F911F000FF;
	Sat, 12 Sep 2026 12:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789215926;
	bh=p6GwzDw6jRZwjDv6IZkH7ljJDsAhiogu4xyO6CHNg58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQJhBAfPKdzP00Dvo220adGkyMxTiZjXjSZMF6ItT25sJGjyUX8hexQs3tjKA9M2F
	 aBHiBMFOjppMD6Xojk27rQ9rU4NFjDZJAgipuhQ5xYxpe2/zH9mkIPAt6AzxFG0zCc
	 e74b7rale9hPYp4qdEnEIT6fvtTDVVRMbKPTLL+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0632/1376] RDMA/core: Fix potential use after free in ib_destroy_cq_user()
Date: Sat, 12 Sep 2026 08:50:58 +0200
Message-ID: <20260912065621.629123730@linuxfoundation.org>
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
index 52d412267d842..67c04b14b1509 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2190,11 +2190,15 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
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



