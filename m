Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 241453E5A14;
	Sat, 12 Sep 2026 10:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207953; cv=none; b=kctaiSAh17n2aGgROktm+54Sp26Yz6Pz9moDbQsJtsPuadkCZ0V4dE/JzwPxi6rNkQgGKQxv7bDCtfBT33l1jeznzI9lVXK5dwHuS0XmVosd+fX+nqPIoi69Dw4sVJG6COLLt0Zxak3qjiNmu5XkQ1+xemahgdOFNUTjdONwygU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207953; c=relaxed/simple;
	bh=0P7q7WuWJ6u2yNVniZf6qs4jV8gg6fvCwpnMVwXBW9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nnreEkR1bc1J5TirW84lS6/Yu+k1ULxZ8bXaDx3wj3V8oJe9tHibyEVtJ+lU9fvJjlD/WVMz7QlgUu+JqO0C0fprIDgVEzWOobQh7yRXwUMBptp1IV2WKSr4jac/uw+G/8DmhTO2nGrKjBihyI/Q6+jB8Kd5qJNqr0+URf1vqQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bkRtTePr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bkRtTePr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272251F000FF;
	Sat, 12 Sep 2026 10:12:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207951;
	bh=jqdX1m+QKkUftspu3dg7tRr9bcJ+JDBraVzTqUEZ6sU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bkRtTePr6IWF+JkQ5pvkbHbdnIkbzqVlIB288g/bcPxZPHqi3ybVgu1TsyyoyFDwX
	 zJzRj5Zlr1cXuC8kvPsv71Dfsxsx/zWc/oLmUapboAQa3vSyu41PAdx6DgOpA4rmJD
	 GHqBvBkHg5m84wWWQZkxB8MVkBya4bJzrZMhbHf8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0519/1518] RDMA/core: Fix potential use after free in ib_free_cq()
Date: Sat, 12 Sep 2026 08:44:48 +0200
Message-ID: <20260912065635.185902226@linuxfoundation.org>
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



