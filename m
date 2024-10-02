Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB21D0E3A;
	Wed,  2 Oct 2024 14:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878299; cv=none; b=TzDm8NqBo245fJmJN4z7Oivm1r3bY5+YjE22BzlCZFCmbXSgpwCfsrwEja4JWt7k6dx5XKZWA6NLTp/zk1ILYMkuXb7T3g8MqUQAXY9uynEdc/B5nJ0zjThhtelAejsQNIoSx2fThRNy3OkbAuPjc446I6cfbq3ePgXahkW3HcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878299; c=relaxed/simple;
	bh=B/GsG17Vc6WaDgShk5V4fdJiWk+IP/7mGzb70tqKVfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rC6Rbicp2Wwr+J9i7B5L7uLcXitJcYItEputzmBzfwkuBh+YVOIQ7Ro7rqZcC0kXOBdIo9j0rNwTReNSdit2+YHRpxtgb0llamyYjeqcBSjRoJC9jkJKFOBZtsPhX5MfVv9wiqnaDrRB5p4d9/hxhTaqA2Uv4u6NjzGD7qPjmqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sK/KVewf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sK/KVewf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53A74C4CEC5;
	Wed,  2 Oct 2024 14:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878299;
	bh=B/GsG17Vc6WaDgShk5V4fdJiWk+IP/7mGzb70tqKVfE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sK/KVewfjNnC2T558EMnI3qVqfCpMK9ALw+j41GTCPigjgRG4RDzDvQ4dAMaK40bP
	 z/mmqOzN+MFdxLphvVhqnzQ4Agv/+Jb59r/dOlewZ7BHJlihAur9oVKdgVMl7PaQHr
	 g2Pgi3ZIguEOVyqyl8MJTZicmVucF5uGW+uzvznc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolin Chen <nicolinc@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 365/634] iommufd: Check the domain owner of the parent before creating a nesting domain
Date: Wed,  2 Oct 2024 14:57:45 +0200
Message-ID: <20241002125825.502839485@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit 73183ad6ea51029d04b098286dcee98d715015f1 ]

This check was missed, before we can pass a struct iommu_domain to a
driver callback we need to validate that the domain was created by that
driver.

Fixes: bd529dbb661d ("iommufd: Add a nested HW pagetable object")
Link: https://patch.msgid.link/r/0-v1-c8770519edde+1a-iommufd_nesting_ops_jgg@nvidia.com
Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/iommufd/hw_pagetable.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/iommufd/hw_pagetable.c b/drivers/iommu/iommufd/hw_pagetable.c
index a9f1fe44c4c0b..21f0d8cbd7aad 100644
--- a/drivers/iommu/iommufd/hw_pagetable.c
+++ b/drivers/iommu/iommufd/hw_pagetable.c
@@ -215,7 +215,8 @@ iommufd_hwpt_nested_alloc(struct iommufd_ctx *ictx,
 
 	if (flags || !user_data->len || !ops->domain_alloc_user)
 		return ERR_PTR(-EOPNOTSUPP);
-	if (parent->auto_domain || !parent->nest_parent)
+	if (parent->auto_domain || !parent->nest_parent ||
+	    parent->common.domain->owner != ops)
 		return ERR_PTR(-EINVAL);
 
 	hwpt_nested = __iommufd_object_alloc(
-- 
2.43.0



