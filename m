Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FC61465A8;
	Tue, 25 Jun 2024 09:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308713; cv=none; b=p0LN8jFAXsACOMxzWyjQ/gQKcr5Y2bNhBlgL2dLG4bvMzhdugke3VhGiPnvZtFfRVWnHNVXd63IXxRLm6FkxVJ2BSaN8bGHBDayivEtHDQ8wpyhdh4PDxUpcdNSuncqdIZW9cImKXr9DqT5n2FGria/4WvvWxQHv1jkAOFPy7I4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308713; c=relaxed/simple;
	bh=A/3mvs1Eh9u9z+E7vxEuvxkLFr8rizyje2DDHOQLHY8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jrcuBQFkiWC3COylaQhgy6ct5wm+H9+//QJ4UtxEBsyKHXQXqAdo8KJDU5Sp6CFlWmhfSM5ZCiMWUyoIAViSF2c9PrMJ0aboHXYQdPA45JF84Db3qRhczKfsBKIj8F8gtcbKtbbhCkuMTZv8xjK//bu/ehWRe89VusA5ZR2PfcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P3+tMQiE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P3+tMQiE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E284C32781;
	Tue, 25 Jun 2024 09:45:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308712;
	bh=A/3mvs1Eh9u9z+E7vxEuvxkLFr8rizyje2DDHOQLHY8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=P3+tMQiEvzYaBQVdzdtHKgZGHT2z+QsUV8E1PIXsZJSaxnEPV+01ccYH57y/YAZdl
	 5UI/lKlhoh2L3101lzKq2HM56u+TupayA6ZHAxWTGL1RVYdiXXUiX4DTGhUJ8oqKJh
	 kb3MkSFJ3kUfKDnK/awyIE6FNBatAy8FWnSX0crw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 6.9 197/250] RDMA/mlx5: Ensure created mkeys always have a populated rb_key
Date: Tue, 25 Jun 2024 11:32:35 +0200
Message-ID: <20240625085555.612734075@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

commit 2e4c02fdecf2f6f55cefe48cb82d93fa4f8e2204 upstream.

cachable and mmkey.rb_key together are used by mlx5_revoke_mr() to put the
MR/mkey back into the cache. In all cases they should be set correctly.

alloc_cacheable_mr() was setting cachable but not filling rb_key,
resulting in cache_ent_find_and_store() bucketing them all into a 0 length
entry.

implicit_get_child_mr()/mlx5_ib_alloc_implicit_mr() failed to set cachable
or rb_key at all, so the cache was not working at all for implicit ODP.

Cc: stable@vger.kernel.org
Fixes: 8c1185fef68c ("RDMA/mlx5: Change check for cacheable mkeys")
Fixes: dd1b913fb0d0 ("RDMA/mlx5: Cache all user cacheable mkeys on dereg MR flow")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/7778c02dfa0999a30d6746c79a23dd7140a9c729.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/infiniband/hw/mlx5/mr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -718,6 +718,8 @@ static struct mlx5_ib_mr *_mlx5_mr_cache
 	}
 	mr->mmkey.cache_ent = ent;
 	mr->mmkey.type = MLX5_MKEY_MR;
+	mr->mmkey.rb_key = ent->rb_key;
+	mr->mmkey.cacheable = true;
 	init_waitqueue_head(&mr->mmkey.wait);
 	return mr;
 }
@@ -1168,7 +1170,6 @@ static struct mlx5_ib_mr *alloc_cacheabl
 	mr->ibmr.pd = pd;
 	mr->umem = umem;
 	mr->page_shift = order_base_2(page_size);
-	mr->mmkey.cacheable = true;
 	set_mr_fields(dev, mr, umem->length, access_flags, iova);
 
 	return mr;


