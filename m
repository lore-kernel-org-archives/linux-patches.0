Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AD7A33F5A9;
	Sat, 12 Sep 2026 14:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789223729; cv=none; b=V/by1uAOjul/n9Ar4qwei+rQNIhqf8zuZbJAEFE77lYAlY1GzMNNeCsw/AjnncZSD5IHqa83btR/wH8zX22Fvgzhj5BFVFMDaZsQOk6xui/1lTiB38cmvZfIHcqdyLkCS57xzgO9DC+Dl3ajAJIbu29a3ScS1I1TzJ546wEaACg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789223729; c=relaxed/simple;
	bh=APHFQspPXXzBGtUgmXcA8rAe97RGqLWxviIgFPzrdoo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LdSdKK1uJW585jZ5agMUp7tkX9ZMWtGjy14+c1qPKqSajZOir57YmylyTYSzWUxkBGFs2r/anIaRO7dbtfGZ42+h2NxfDV1of2b8f3IS0fUBX7YiRsxPBphC3StTWtwZxm+uyoYpqWeLqkIKtPHtpuxa65/0qEvzJ4Y5UHBhBJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qn7Vw9D5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qn7Vw9D5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A81F81F000FF;
	Sat, 12 Sep 2026 14:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789223726;
	bh=ZMf4HA2+o0F5O7MYEATevWh5ZrC/rNoakO5cRNrRgJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qn7Vw9D5whcclLS8jIvO/CnAtJkxkvEraUeQ3ZCb0ygl+2f3n0o3LFeMuGgNEhA2y
	 VV391c5GV2vdxNOxLU6VTExivffdt6pVdEEKdXdMzymfQ1BKmUUZdK9fLwcx0gedWR
	 jAw1dno3tRMOz68uVqaJNPMV7Aa9PDrwtmRiftNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0847/1424] RDMA/core: Fix potential use after free in ib_dealloc_pd_user()
Date: Sat, 12 Sep 2026 08:54:39 +0200
Message-ID: <20260912065626.278156844@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 68cff9faf225b..d08aa155a9cfa 100644
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



