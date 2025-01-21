Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60571F5439;
	Tue, 21 Jan 2025 17:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482294; cv=none; b=DHBoOKJuAT/3exUi/cyrzofKq6MrYhFLqIvRC6p1OBxIsJ/55EHJLyhu6wAl3L6VlJrsBftbIAknUEDbkbFD91oNQDjo7LIKjukef6RkJn1Kruuz7PUbT9lNcyCiA3IrmbgAAP5oIkOYseiG+gDIWVhJWKXkll1PaQbWbCge8bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482294; c=relaxed/simple;
	bh=qT1LSqneCTeAcXi6Hw0N/elDq2F98JzZUKX+BtWHMAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A9YD+Y0fVo1Eul+tm+TFUq8axLf1FpOySMYSgzvqM+gmIQd2wZyjmROhAIfPp16zEL95LNY5B4+HjGzY2/Z19f59GIvYXezT/Azu5goEOfo3ZRNd2VzGSakBjaZNmNcgy9n2i/K3uYUezWFJ/atwCNaeRv6BAR5xM4o4Ds5wAQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JyoFRgSF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JyoFRgSF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EABBC4CEDF;
	Tue, 21 Jan 2025 17:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482294;
	bh=qT1LSqneCTeAcXi6Hw0N/elDq2F98JzZUKX+BtWHMAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JyoFRgSF6k624n9Z8sxpUtZqf4rnq4GKYVZzZHE/4kSNDoiHP4+5YuwPE6ylDWays
	 StmjFQHRGC99N13g0BXwJe0vz42h0Tjk+7KKWQbl6a+z6wvZVdmDqINQjsS4GETXOT
	 iSIoj25ErZU9lQjnR1zNJ33Gtr+kMMWSjeApmLwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 027/122] net/mlx5: SF, Fix add port error handling
Date: Tue, 21 Jan 2025 18:51:15 +0100
Message-ID: <20250121174534.042026232@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 2011a2a18ef00b5b8e4b753acbe6451a8c5f2260 ]

If failed to add SF, error handling doesn't delete the SF from the
SF table. But the hw resources are deleted. So when unload driver,
hw resources will be deleted again. Firmware will report syndrome
0x68def3 which means "SF is not allocated can not deallocate".

Fix it by delete SF from SF table if failed to add SF.

Fixes: 2597ee190b4e ("net/mlx5: Call mlx5_sf_id_erase() once in mlx5_sf_dealloc()")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index a96be98be032f..b96909fbeb12d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -257,6 +257,7 @@ static int mlx5_sf_add(struct mlx5_core_dev *dev, struct mlx5_sf_table *table,
 	return 0;
 
 esw_err:
+	mlx5_sf_function_id_erase(table, sf);
 	mlx5_sf_free(table, sf);
 	return err;
 }
-- 
2.39.5



