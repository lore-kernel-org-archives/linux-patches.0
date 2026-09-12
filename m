Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99C684BEE38;
	Sat, 12 Sep 2026 16:18:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789229934; cv=none; b=TEd9rNSpEuz1BtXRkTXkLaFjuxBKPXtBdWEQNaRfrS8CKtOu2i4eb0FkNkAqVD+lFel5DqPwy43BLx873Cwu9ndS4Gph0HvsD2QXa74bUfjrwVXIJz2yUbTT7mogZ7/+5IY99ZuuTqjN3FiP+wPnIQkHySy4ck3MlddNlKsBdg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789229934; c=relaxed/simple;
	bh=UFlCPRo9EYYWUu7GnzmIwNYtpHN1ES2eGKG+C9P+8c8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rHJPqpiIPD58/3Zk1W42TTr6osaRTiyyfVhnATi+XfEVoIZ2YX9L8lswdxi0yT43e9Dp/g+735L7uCux8UIxA4F9/yGSUYlxXqer5wLLMbkKN5AtZlO841trxS2UoFwM65AubKbjPa+YZLd1uI3cRpBP/UEXnzZDwpUJ+kBWCsM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sHPV1FAL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sHPV1FAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9178F1F000FF;
	Sat, 12 Sep 2026 16:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789229933;
	bh=MGRkviOPCA70JJ7Nwyq2nOJuNVEWX1q2rtSMfZhgUMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sHPV1FAL1mWeTbYAYhiNYD1hHw4AaVfStsBprZ1gXL0Cb0c6hMU7R+2aMshWP13oD
	 NdAcvKUx8Un546sAckpDuo0DymUzvgyK6v9yaT+VSHRWPpMjkSAZDXoLToInz5y3Qc
	 DmbjCxIzutrAXoxCsv1RrwwRuchkTreEmm2LC+VM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0689/1191] RDMA/core: Fix potential use after free in ib_destroy_cq_user()
Date: Sat, 12 Sep 2026 08:56:57 +0200
Message-ID: <20260912065603.735860625@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
index 623f43ee5b5f5..0337dea370120 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -2108,11 +2108,15 @@ int ib_destroy_cq_user(struct ib_cq *cq, struct ib_udata *udata)
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



