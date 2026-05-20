Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 133722F0C62;
	Wed, 20 May 2026 17:44:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299092; cv=none; b=RVWwIaym+QWMSxv+w2pgRNLdVkCOwbOjyDbcdNuHDQGa0gumGH0v39/zMYBFDlDwWanv3un/UHYSMMl89tBcj6P/jPf0mbAeX6FOFHft/GQoVeUaKtrVofQ9B7Ii4SyIJo6de//3CRnvlQw7GTa5Ow6WwKRLOnpW2gUcNhXNof4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299092; c=relaxed/simple;
	bh=y66fZv33uUSNqplkrZwl+umEEKMj2jat4eH+4cLCBPg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XzS3376wPvUQlx6HLC5iUEADo1XS6WmXMeshWA8EhGUViG6NeXDyJSgiuegP6xm0qfx1MgukX5qi8cJUdkwcZElGHKXNIC46cB0A1lMCT7Akpwf8OdXDoRTYHIJlHUE0DEzp/G563iAXX64YfJlRt7Z61LpmP/5aVmaJ1ukISV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rzEXinQX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rzEXinQX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F8F1F000E9;
	Wed, 20 May 2026 17:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299090;
	bh=z6KFDTbjVkcom1I8qkvEV85ucsDIC1iJPT+juekRH6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rzEXinQX+ZazVVsvVrJs1zOOAEqmrdFiBCMKZvhi8H8pMsQOmzkjcRMfsxet6/2/J
	 9ngCE+QSLoroUgqx6J9GGTNhcTXKgTLqnhga1UT7DAZ3tLSvJuvpOzu5O9eKlPW/A2
	 QACseF7LUifxWq7vq5VRU3AOO3LjcW1nq0HEW1Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Prathamesh Deshpande <prathameshdeshpande7@gmail.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 657/957] net/mlx5: Fix HCA caps leak on notifier init failure
Date: Wed, 20 May 2026 18:19:00 +0200
Message-ID: <20260520162148.780425222@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>

[ Upstream commit d03fc81a57956248383efec99967d0ae627390a8 ]

mlx5_mdev_init() allocates HCA caps via mlx5_hca_caps_alloc() before
calling mlx5_notifiers_init(). If notifier initialization fails, the
error path jumps to err_hca_caps and skips mlx5_hca_caps_free(), leaking
allocated caps.

Add a dedicated unwind label for notifier-init failure that frees HCA
caps before continuing the existing cleanup sequence.

Fixes: b6b03097f982 ("net/mlx5: Initialize events outside devlink lock")
Signed-off-by: Prathamesh Deshpande <prathameshdeshpande7@gmail.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260415005022.34764-1-prathameshdeshpande7@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index 5903a4af9173b..6e10a6de8ebcc 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1878,7 +1878,7 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 
 	err = mlx5_notifiers_init(dev);
 	if (err)
-		goto err_hca_caps;
+		goto err_notifiers_init;
 
 	/* The conjunction of sw_vhca_id with sw_owner_id will be a global
 	 * unique id per function which uses mlx5_core.
@@ -1894,6 +1894,8 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 
 	return 0;
 
+err_notifiers_init:
+	mlx5_hca_caps_free(dev);
 err_hca_caps:
 	mlx5_adev_cleanup(dev);
 err_adev_init:
-- 
2.53.0



