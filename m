Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20AED3644BE;
	Sat, 12 Sep 2026 07:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199450; cv=none; b=peqLKz+npENn4bXqqOZ6iMm0TIkyPI8ErCEYOpc10h6NKPgnuThnPDcn4fHZhwIsof61VWLru0dPDuqgfSsw6ay7kOIg4bcIGIDE/k67d22JG8cILY/1Wkh4aMzrqrujOGOq5Rd9lJ6zjA5T4QM336Df307CGfDEaduvrKVffY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199450; c=relaxed/simple;
	bh=FnMqXd81cM5oZmUjwrqMKlORX4NZsJ4aCP6Q3PkrTA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gctw/HF3Gu1TCzacWu4l96bsMoKvf2/BS/Fx6eQs40euzLIxzXCgBJ7s3//4DVcThhk5kp4n2nxg8y53f7t++90SpyD/o7UFO9T2ZjdAE3Thc79ONNTF6/+Hl6ncWMMc1Zvl+H99OUs5O5FE2+pxClLDo36K99IZR7TLHpmIm+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mwSpDnaZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mwSpDnaZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD821F000FF;
	Sat, 12 Sep 2026 07:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199448;
	bh=h0FzBKzZSviV5uW6AnEts26xsoUubTD6B0e5l0dbwHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mwSpDnaZK6Z6i3mtX+aSzYEWgdtd3tZS733KdOR41+EiLJqn09JdEzhwTMzkq7p1E
	 PlQJn+1zvGXx9UVEusKlTWLMoZWy9ocJJeQ+qspjmghMropc0EEee6acSa5ypkLrLl
	 fGQ0JQgWwiImJ84m9x08EQH/a3Mluj1vu/sswBjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Edward Srouji <edwards@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0585/1815] RDMA/core: Fix potential use after free in uverbs_free_dmah()
Date: Sat, 12 Sep 2026 08:38:55 +0200
Message-ID: <20260912065702.615729215@linuxfoundation.org>
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

[ Upstream commit 2696626a0be5877f445fb647c25ef43930c777e6 ]

When accessing a dmah via the netlink path the only synchronization
mechanism for the said dmah is rdma_restrack_get().
Currently, rdma_restrack_del() is invoked at the end of
uverbs_free_dmah(), which is too late, since by that point
vendor-specific resources associated with the dmah might already be
freed. This can leave a short window where the dmah remains accessible
through restrack, leading to a potential use-after-free.

Fix this by moving the rdma_restrack_begin_del() call to the start of
uverbs_free_dmah(), ensuring that the dmah is removed from restrack
before its internal resources are released. This guarantees that no new
users hold references to a dmah that is in the process of destruction.

In addition, this change preserves the intended inverted order
between create and destroy routines: resources are added to
restrack at the end of successful creation, and hence shall be removed
from the restrack first thing during the destruction flow, which keeps
the lifecycle management consistent and predictable.

Fixes: d83edab562a4 ("RDMA/core: Introduce a DMAH object and its alloc/free APIs")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Signed-off-by: Edward Srouji <edwards@nvidia.com>
Link: https://patch.msgid.link/20260713-restrack-uaf-fix-resub-v2-7-bbe8bb270d51@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/uverbs_std_types_dmah.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types_dmah.c b/drivers/infiniband/core/uverbs_std_types_dmah.c
index 97101e0938263..9873ab49a6013 100644
--- a/drivers/infiniband/core/uverbs_std_types_dmah.c
+++ b/drivers/infiniband/core/uverbs_std_types_dmah.c
@@ -18,11 +18,14 @@ static int uverbs_free_dmah(struct ib_uobject *uobject,
 	if (atomic_read(&dmah->usecnt))
 		return -EBUSY;
 
+	rdma_restrack_begin_del(&dmah->res);
 	ret = dmah->device->ops.dealloc_dmah(dmah, attrs);
-	if (ret)
+	if (ret) {
+		rdma_restrack_abort_del(&dmah->res);
 		return ret;
+	}
 
-	rdma_restrack_del(&dmah->res);
+	rdma_restrack_commit_del(&dmah->res);
 	kfree(dmah);
 	return 0;
 }
-- 
2.53.0



