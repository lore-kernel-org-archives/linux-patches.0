Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6617D3AFD15;
	Sat, 12 Sep 2026 10:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207942; cv=none; b=D3ZqR86rvqdDCf5crXWegQJSZnkSkSzyvmi6CVGzm/5CM+48awbH1pcfdMok0yH1YGJJ24TULxCFeG/VSBh3e0ET4EhOKov/7Q7k7QB8JvrQxPy3CjpB6i6Nvarj6OSwOnhlhIO1BAw6sTGaXA0XTGMz0+q4nkwBa2TlROym8wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207942; c=relaxed/simple;
	bh=u/4qffYOJwZjPoNspWqOr2ewI11D5mjZ/Zb0vOwVF9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9DUKgAUAq1KOi+qPod8T02X9bSv61yBdW+XKC5MyPJj+cNmhaMTwTpSqkr9FlzN8zzpANJipgSZnWqLD68/I5QwE/HxrtD23Jmqt2jAE+sr1SOqhzaf1SwCHBIoqnGCsmlKm5JVa04/73EsVBAlGyuba7Xx4b1l01FpbXivtIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=soW7/h+E; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="soW7/h+E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 055901F000FF;
	Sat, 12 Sep 2026 10:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207941;
	bh=fVKCWTYxMkd1/fbZbiqhwwd/Uu2VlSvxriSkV35iYbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=soW7/h+EvqtGOFFc0HlnFgkFhnv1yhoIsItp3/h1Cow0sXXMQI+0GFaSfsR6UjgTY
	 mjWRy0+ItlxB0Ta0nmCnjI8rKct83zKbd5cYeKYVCNEGwGJ0CeuYlNU/UusrKBxSA5
	 FsRd6LfYZSvrH9llb2G35jcOTCmnvFeKnH7uFiAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0517/1518] RDMA/core: Fix potential use after free in ib_destroy_srq_user()
Date: Sat, 12 Sep 2026 08:44:46 +0200
Message-ID: <20260912065635.140319117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 0404fc9bd1da4..480a2b1898619 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1083,16 +1083,20 @@ int ib_destroy_srq_user(struct ib_srq *srq, struct ib_udata *udata)
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



