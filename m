Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F76E356903;
	Tue, 26 Aug 2025 14:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218585; cv=none; b=SYOE5jdx3mxRWq5JBr0/4j96bAAOLxCb75QWE0SKtQAqo1KBmmpfNc/5PdFe0COvU4zhuf7YQ4e0Oh3wYzGKgYnjDGfoIscl88AnkoJ8ggikIFc6b8B3jS9r/ux1IqTL2Vp2zHMDXzGpH4Id0aOV+zOHFQpGUdxGGkYOvwUsVUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218585; c=relaxed/simple;
	bh=wPo7f0QesYrlhyBXK6O6qPhzir4nDNWoahpm2vmZwCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nfZhVUf/4c3YmHSAltvFoD1TJEpWeF+KDP0N+DjrbH/bUPJyKq2XGkvhLrhk0DXIiYS85SWGqUg/2fId0M9mdbB2EcJ7wyzBTl47St7VuupiX4Mmxv03djCMEJOokGLROWhc3btvj8NHLdpUgZ7DDWyqHzDEyBnCE934q2DpfXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IC4r4Z9/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IC4r4Z9/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B6CC4CEF1;
	Tue, 26 Aug 2025 14:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218585;
	bh=wPo7f0QesYrlhyBXK6O6qPhzir4nDNWoahpm2vmZwCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IC4r4Z9/htTAAmScJm6EZXZSp+gKnAb4C3TqeXXVaBMlJ4VWyMrPkhRM4+kSiUB2t
	 homN9tHj22GyKek4z8vYKEeBu2oy94mo6NGEQNZFxl2qJErEwrZNqFoZpi2E4dtheo
	 cCrEyHyXHPFBNS0vmkHKwl3YKAefkagwB1VKKU0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 057/403] RDMA/core: Rate limit GID cache warning messages
Date: Tue, 26 Aug 2025 13:06:23 +0200
Message-ID: <20250826110907.443169335@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 333e4d79316c9ed5877d7aac8b8ed22efc74e96d ]

The GID cache warning messages can flood the kernel log when there are
multiple failed attempts to add GIDs. This can happen when creating many
virtual interfaces without having enough space for their GIDs in the GID
table.

Change pr_warn to pr_warn_ratelimited to prevent log flooding while still
maintaining visibility of the issue.

Link: https://patch.msgid.link/r/fd45ed4a1078e743f498b234c3ae816610ba1b18.1750062357.git.leon@kernel.org
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 7affe6b4ae210..641e537a0069a 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -578,8 +578,8 @@ static int __ib_cache_gid_add(struct ib_device *ib_dev, u8 port,
 out_unlock:
 	mutex_unlock(&table->lock);
 	if (ret)
-		pr_warn("%s: unable to add gid %pI6 error=%d\n",
-			__func__, gid->raw, ret);
+		pr_warn_ratelimited("%s: unable to add gid %pI6 error=%d\n",
+				    __func__, gid->raw, ret);
 	return ret;
 }
 
-- 
2.39.5



