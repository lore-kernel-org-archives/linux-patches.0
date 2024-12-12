Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5120B215798;
	Thu, 12 Dec 2024 15:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017407; cv=none; b=Fdd7IONdtwwcfYWtf9LaVOJP5LCKuDBQ0hra1OdkMShP8b3aTP6TsjqDghyUwx7z+tcMEPFeIwjLQs+DK6os6LPmLFhqQRe3D5aZ313AHqroHVkRkLnUguz5yiz2zXCn/PGRGbEBxZRkb9Inz/RMWgiOGczRlIfHOGXz1ibFVGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017407; c=relaxed/simple;
	bh=NwR7/7lQDzNwZhBYIVn54iYOOg9AQ5FlDSK1L8D1CTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rut0Ee8wRiEQPA/CGGu7c7Y3O0Ruk7gU9MnQ4TCstv6KrIpGJiIEr1gVzIKQGsvVXX03i3pLPMA6HjNRVRhxs7MjwHvF+I2XrljhHAX2Mqsdp3ZjunUNr1YHWGBfc9t2nTgfQg2ckqMO5V8vVr/Kq6bEeEmXdzPlWbbhY4Jaah4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HehYiYow; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HehYiYow"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E9F6C4CECE;
	Thu, 12 Dec 2024 15:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017406;
	bh=NwR7/7lQDzNwZhBYIVn54iYOOg9AQ5FlDSK1L8D1CTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HehYiYowSD2+3zzl1t8y6qI61pinKZk3DoVvhzlGqSwDKckVUM7lFKWrg0NSMcSMj
	 z9PUKGbN9R/xXYJwwRIM3ChVYDIxj4NFtzy7IgfSNBh63eb2YjdaqEKEPlaph6zj5x
	 JlvCmJzH/2TMO3rx6kmfNYprhEJ00NM8j6SU1aHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Ott <sebott@redhat.com>,
	Breno Leitao <leitao@debian.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Matt Fleming <mfleming@cloudflare.com>
Subject: [PATCH 6.12 459/466] net/mlx5: unique names for per device caches
Date: Thu, 12 Dec 2024 16:00:28 +0100
Message-ID: <20241212144325.000168582@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Sebastian Ott <sebott@redhat.com>

commit 25872a079bbbe952eb660249cc9f40fa75623e68 upstream.

Add the device name to the per device kmem_cache names to
ensure their uniqueness. This fixes warnings like this:
"kmem_cache of name 'mlx5_fs_fgs' already exists".

Signed-off-by: Sebastian Ott <sebott@redhat.com>
Reviewed-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20241023134146.28448-1-sebott@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -3698,6 +3698,7 @@ void mlx5_fs_core_free(struct mlx5_core_
 int mlx5_fs_core_alloc(struct mlx5_core_dev *dev)
 {
 	struct mlx5_flow_steering *steering;
+	char name[80];
 	int err = 0;
 
 	err = mlx5_init_fc_stats(dev);
@@ -3722,10 +3723,12 @@ int mlx5_fs_core_alloc(struct mlx5_core_
 	else
 		steering->mode = MLX5_FLOW_STEERING_MODE_DMFS;
 
-	steering->fgs_cache = kmem_cache_create("mlx5_fs_fgs",
+	snprintf(name, sizeof(name), "%s-mlx5_fs_fgs", dev_name(dev->device));
+	steering->fgs_cache = kmem_cache_create(name,
 						sizeof(struct mlx5_flow_group), 0,
 						0, NULL);
-	steering->ftes_cache = kmem_cache_create("mlx5_fs_ftes", sizeof(struct fs_fte), 0,
+	snprintf(name, sizeof(name), "%s-mlx5_fs_ftes", dev_name(dev->device));
+	steering->ftes_cache = kmem_cache_create(name, sizeof(struct fs_fte), 0,
 						 0, NULL);
 	if (!steering->ftes_cache || !steering->fgs_cache) {
 		err = -ENOMEM;


