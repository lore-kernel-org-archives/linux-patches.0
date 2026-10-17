Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C392D3225;
	Sat, 17 Oct 2026 17:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257899; cv=none; b=XT+Ek6TnLeW0vBF5oFLMKF0HWHPXgfu9SuXkVDWm0N0P5scY+gpdph9b2Y/VYTjsRdIsfKezzKPFR+K7CbRGzSNoirM0aUT7GYct5UrolY1sxw0Ri56NKNrgkyCulI1x4+Z5sSMCSu+8JQwd16VXPCPJcRZUYP5Nfvu4LY2zEKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257899; c=relaxed/simple;
	bh=ktIQj4rnsgyXy1i1Ls4P5QvsO3pIEsukG+YpZ4TnA6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eBg2oRopeTaKeh+3F49z9/fV9xuYBaidMh04uqPb1v0JsuHqmAtNnrFxQZ9KTCX8/gBB4X7ptGSY3kf0CRNkGUa17eKlBMIkV+icTkan5rTpqVmdiN4Z97z+nIAJXnKbOiZnYxQ52cMfbOsqY7QYginzmozymO3Ob33IjukIokw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rl8Lg9oK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rl8Lg9oK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3F441F000C4;
	Sat, 17 Oct 2026 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257898;
	bh=ApBRVW+qhwIGD5XCcQOg+g3mpeFwAODdA2GhOCFRRgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rl8Lg9oKtjtNgYEz7k1wTXX5fnP1Bz14n1jiFeMrGiGrLGaOem97Nt5Ot/HiyxW0+
	 LHeQp/n8Bl44++08qH1gxz6RjDB2qYg83NJbWAhHA3Vxr9ho10djI8jLWn04uU1FFI
	 lNqvc1sXzoYMvLQLqUU4IHeEUWGYkT7xuIO3l9lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0664/1674] vfio/mlx5: Fix an unwind issue in mlx5vf_add_migration_pages()
Date: Sat, 17 Oct 2026 17:48:56 +0200
Message-ID: <20261017160448.153314147@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
 drivers/vfio/pci/mlx5/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/vfio/pci/mlx5/main.c b/drivers/vfio/pci/mlx5/main.c
index 42ec574a86221..b6c6643ab0f47 100644
--- a/drivers/vfio/pci/mlx5/main.c
+++ b/drivers/vfio/pci/mlx5/main.c
@@ -71,6 +71,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	unsigned long filled;
 	unsigned int to_fill;
 	int ret;
+	int i;
 
 	to_fill = min_t(unsigned int, npages, PAGE_SIZE / sizeof(*page_list));
 	page_list = kvzalloc(to_fill * sizeof(*page_list), GFP_KERNEL_ACCOUNT);
@@ -91,7 +92,7 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 			GFP_KERNEL_ACCOUNT);
 
 		if (ret)
-			goto err;
+			goto err_append;
 		buf->allocated_length += filled * PAGE_SIZE;
 		/* clean input for another bulk allocation */
 		memset(page_list, 0, filled * sizeof(*page_list));
@@ -102,6 +103,9 @@ int mlx5vf_add_migration_pages(struct mlx5_vhca_data_buffer *buf,
 	kvfree(page_list);
 	return 0;
 
+err_append:
+	for (i = filled - 1; i >= 0; i--)
+		__free_page(page_list[i]);
 err:
 	kvfree(page_list);
 	return ret;
-- 
2.53.0



