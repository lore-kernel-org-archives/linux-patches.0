Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B84B381EB5;
	Sat, 12 Sep 2026 07:50:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199455; cv=none; b=lAnIIg/49kNb78d32kt8o1K+hN9yTsjVglascryCAaWzOd2jcWfnzZ0L1lvrxo0LbnyoZsoUtUJ3vzELcx7R7mEU3dm8Go5wrzDAfVVsb/jP4GX4VJ0ZHRnLLls+CqG3Ef79Q+nnPt3d2Q62tN2hOcLeJnEZP6e8iLIE27SJzEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199455; c=relaxed/simple;
	bh=gpWR41enzQD3S9wfW4ETnwjjA3JJlVyaC4oAlIu52uQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIaZdSyojHRMeYXZl0iDzhJEUxgvfFjauyg1+yVa6HMtgw4HBaF1NBQHWUfQC3Yds/i03OpjDpi5WMqUix8xoieBIQEcHjtlLUJ7i+jdbQehc7wNJn2CX0SZdGjFh+OwJLD6NN4dsYcp6/cwmll2GWf3FwlLxO9El3b0W/YSprA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH/DijGP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH/DijGP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 108D51F000FF;
	Sat, 12 Sep 2026 07:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199453;
	bh=EkIxih/mf7UNhtlOwvxKQB40wPZsboGgW5dvWttAYBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wH/DijGP2HGwcmfhuhG6DI+t7rKOaT3cEeCWZgZmEIsRz7AEhwtSJYE4/7jmX+vfe
	 bHuBvvyhWl8q91OesCsCUKrLczvX9AVCBE06UpiPVXoh4+uPDpczaLhRU7yseUOPei
	 KMr2mScUbDUVbQj7mqiAAKNMwd1q0+nkOV1vvdpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0586/1815] RDMA/core: Fix potential use after free in ib_dealloc_pd_user()
Date: Sat, 12 Sep 2026 08:38:56 +0200
Message-ID: <20260912065702.638720925@linuxfoundation.org>
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
index d8e0b7afb6b97..f8b219bd308bd 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -392,6 +392,7 @@ int ib_dealloc_pd_user(struct ib_pd *pd, struct ib_udata *udata)
 {
 	int ret;
 
+	rdma_restrack_begin_del(&pd->res);
 	if (pd->__internal_mr) {
 		ret = pd->device->ops.dereg_mr(pd->__internal_mr, NULL);
 		WARN_ON(ret);
@@ -399,10 +400,12 @@ int ib_dealloc_pd_user(struct ib_pd *pd, struct ib_udata *udata)
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



