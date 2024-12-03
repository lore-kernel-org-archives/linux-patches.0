Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87C531DA3D;
	Tue,  3 Dec 2024 15:21:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239262; cv=none; b=QsHlYEMBzmo182elSZXVxlDkGhUd/aUmGgocBN1Drhl3Uqbkwh3Nt0uDYc1YqRJEC1w6aMZKX46KVnZ2OM6LPQtlZFTfBVw+Q29XBAzIU+sUSJSIDuoPN6RCqtwWJgdn97a93RvD6cxbS+WwoJeQcg8uBynwyiMbRzBuYfudJ7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239262; c=relaxed/simple;
	bh=qzUp4t624UIyhyJiaOk8DXujH41N+bG4945HaCYASvk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Oqnm8E6D4KxZA93tFRp+uDWxNR1hNA99ulbG3m/7gXErNrnsN+jWfbE9B35l7KWlzlXUcuoUgPW8JC8iQZRWOPUAFgy9XDlsIQ4VaN6XlVyQKq4btX9FN9hg10ro0ASJrekJ42DPxTUFAZmmszVyt9raWZ56vsWCfpugxws4bLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xdUC3BF+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xdUC3BF+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4C3C4CECF;
	Tue,  3 Dec 2024 15:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239262;
	bh=qzUp4t624UIyhyJiaOk8DXujH41N+bG4945HaCYASvk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xdUC3BF+2bRYzp3AKhDdJhKZhZhieO52t/MSjCo+uoC2Ou15WtySQVy+99nXx7YkT
	 vKXGM08B7Y3OnitSsvdu9XstVKXzZG56bs1/kOXu58k/McZKrrjLC0cmtTb4m2GLko
	 mMF17b4OrOPK0Ne7ojikaTQhZLvladYqXXuDs5tw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 554/817] vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
Date: Tue,  3 Dec 2024 15:42:06 +0100
Message-ID: <20241203144017.537061603@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 22e87bf3f77c18f5982c19ffe2732ef0c7a25f16 ]

Fix an unwind issue in mlx5vf_add_migration_pages().

If a set of pages is allocated but fails to be added to the SG table,
they need to be freed to prevent a memory leak.

Any pages successfully added to the SG table will be freed as part of
mlx5vf_free_data_buffer().

Fixes: 6fadb021266d ("vfio/mlx5: Implement vfio_pci driver for mlx5 devices")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Link: https://lore.kernel.org/r/20241114095318.16556-2-yishaih@nvidia.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/mlx5/cmd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/cmd.c b/drivers/vfio/pci/mlx5/cmd.c
index 41a4b0cf42975..7527e277c8989 100644
--- a/drivers/vfio/pci/mlx5/cmd.c
+++ b/drivers/vfio/pci/mlx5/cmd.c
@@ -423,6 +423,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	unsigned long filled;
 	unsigned int to_fill;
 	int ret;
+	int i;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
 	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
@@ -443,7 +444,7 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			GFP_KERNEL_ACCOUNT);
 
 		if (ret)
-			goto err;
+			goto err_append;
 		buf->allocated_length += filled * PAGE_SIZE;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
@@ -454,6 +455,9 @@ static int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	kvfree(page_list);
 	return 0;
 
+err_append:
+	for (i = filled - 1; i >= 0; i--)
+		__free_page(page_list[i]);
 err:
 	kvfree(page_list);
 	return ret;
-- 
2.43.0



