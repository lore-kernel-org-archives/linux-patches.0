Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3093369D56;
	Sat, 12 Sep 2026 10:12:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207963; cv=none; b=htDuq0ROxJ8tX+Abd52fmjG6USKMVUuRy2GXTJQ6KXLiZtvKlU6xcv2Tr2PYT2CKvlphObpeYN5+IS8BedC/bJenPe9ZTJp33tNC9FkujTILA53SEOsgfJyroK9cykdwTP3hIuOkM9C+ZgZyb3d/HeoYHlvGgLUnHCEK6/JxUSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207963; c=relaxed/simple;
	bh=BByc3rzhQGJxjPURWAq9DVlnLluSJMni+XhEf0paZxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ND0zsyQfAVxbLugzOuIg4vzpwYr0TMJhRiomyr9sbxYqO++aGNT8UOWPGY3j3mZlUjl5bcKUNAPAWK8XrQ+LNyY/JlC8i40Z0vXxfhC54MP11/6rzphwJdwd/6oAMhUXUQWWkaqOmk/tPOrlFZoPREDpqVaGNqvMn/Vz9N+mwJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gQNT/2wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gQNT/2wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD3091F000FF;
	Sat, 12 Sep 2026 10:12:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207961;
	bh=bdIny75S9Qcl8WpTCqJc47gKg1kTEGTD3ZJa5Up/vqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQNT/2wnhwb+9BoYuxBvkb1wY07oEKOxDoHvw9fduuJDi/57e0aISgfvO/wznrMc+
	 Fpotletc9vo1rnpG0QR1PEqSpmj54cj5goXjSMaQDQeN9rz2rTl65gS4hmxWo8MgUO
	 peUeAvKC2oq+lHVhgEyCPxG/Gw+V5Akf05HUfJic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0521/1518] RDMA/core: Fix potential use after free in ib_dealloc_pd_user()
Date: Sat, 12 Sep 2026 08:44:50 +0200
Message-ID: <20260912065635.231592737@linuxfoundation.org>
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

[ Upstream commit 8b90e701342275f414e36e7421c502237df241ad ]

When accessing a PD via the netlink path the only synchronization
mechanism for the said PD is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
ib_dealloc_pd_user(), which is too late, since by that point
vendor-specific resources associated with the PD might already be
freed. This can leave a short window where the PD remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_begin_del() call to the start of
ib_dealloc_pd_user(), ensuring that the PD is removed from restrack
before its internal resources are released. This guarantees that no new
users hold references to a PD that is in the process of destruction.

In addition, this change preserves the intended inverted order
between create and destroy routines: resources are added to
restrack at the end of successful creation, and hence shall be removed
from the restrack first thing during the destruction flow, which keeps
the lifecycle management consistent and predictable.

Fixes: 91a7c58fce06 ("RDMA: Restore ability to fail on PD deallocate")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-8-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/verbs.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 480a2b1898619..2ef4358b01c52 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -335,6 +335,7 @@ int ib_dealloc_pd_user(struct ib_pd *pd, struct ib_udata *udata)
 {
 	int ret;
 
+	rdma_restrack_begin_del(&pd->res);
 	if (pd->__internal_mr) {
 		ret = pd->device->ops.dereg_mr(pd->__internal_mr, NULL);
 		WARN_ON(ret);
@@ -342,10 +343,12 @@ int ib_dealloc_pd_user(struct ib_pd *pd, struct ib_udata *udata)
 	}
 
 	ret = pd->device->ops.dealloc_pd(pd, udata);
-	if (ret)
+	if (ret) {
+		rdma_restrack_abort_del(&pd->res);
 		return ret;
+	}
 
-	rdma_restrack_del(&pd->res);
+	rdma_restrack_commit_del(&pd->res);
 	kfree(pd);
 	return ret;
 }
-- 
2.53.0



