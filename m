Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB27F23CE;
	Tue,  3 Dec 2024 16:04:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241874; cv=none; b=uALzGwCKh0aTrlIZvfdp31YMtAGLYkQ9Nhxczkok3K4UdfMM7UO9zG7AusaMHklftiyFNX9no+G1eiAiJEzSfPS843jA3f3IE+QycPYDmr0ljog6STsxgLjlJnvJXVg7RmLJy2f4aKsN3tK5+jukNXPaKf+VVS4KUiLBA+h87xQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241874; c=relaxed/simple;
	bh=ogvCTtrrSN6ECBQamQ/csB2nojqI6n9cz3vYYpNuulI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nvM4dlDhw7rpNUvEK/8GU3br6ml5z7+3HAc+xJFhJACBdJkK9euCfTx0NtOMyOYqEJUUGvXWV5rfWUsNCIQ3JHzRUxt0TtvEU6b6rAqr0lFx7mUvgbVMIqaod3AmQmlyD2S4EeJaeV3aGc/AhpHLznJKZXMtab30SKWVx/Qvwko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IZthUx7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IZthUx7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA25C4CED6;
	Tue,  3 Dec 2024 16:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241874;
	bh=ogvCTtrrSN6ECBQamQ/csB2nojqI6n9cz3vYYpNuulI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IZthUx7sC3SEyjvx5/4ghmpxvEnl+jGsuFASV1+upEK5OboR/2I2K/TzerZdUtCG2
	 k9Z8/1we9ggoApSJe9nDEHtMtzpGPM2DlTXJAJWgBvfZKnl7SNsnGV3x1o/RBQego5
	 Sd0Wv+EEj8pZxAZa0gB/KHEYo+JG2lMglN0K86gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 540/826] vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
Date: Tue,  3 Dec 2024 15:44:27 +0100
Message-ID: <20241203144804.818356336@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



