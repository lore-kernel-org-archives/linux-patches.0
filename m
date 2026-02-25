Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571B818B0A;
	Wed, 25 Feb 2026 01:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983361; cv=none; b=VmkMlyNin1F5m/hpvLgnm9QBBOsZgswFZygIlrm1l61asn141kvn0lTWqdBs1H5v8Fdx1+bQw6uLI0R+PRsYKNItGL/wNHwHVS2aKJrwO/T7gWn8ieu5C90RrFB2CnU6gpGsZW3Ubj6QhaeDNYNmdBCKdneXm6gnRqSmZTdncpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983361; c=relaxed/simple;
	bh=sakwBSFzZRWbyBUIVi4PG5IErjGfCPyOOUXR3t9ZuUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KAMQZqy8C1AumD/e9DBQtQHluDdS86PMlNZadB4kIhfisSbZasDCHIioy+0iet2skyk5em2oWy9U8GDTKixpBHOmvsg+r65sLNrlekxOpDfQCA58gOB9aNo3fCcKEu0XveOMdv89xXEgg4kPdPxQBO4nMo7hcr75uBzSya0Hqy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WXIk0DW4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WXIk0DW4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B622C19423;
	Wed, 25 Feb 2026 01:36:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983361;
	bh=sakwBSFzZRWbyBUIVi4PG5IErjGfCPyOOUXR3t9ZuUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WXIk0DW4VD04Ei0mZ4CM0KKeb6oDWTzxRJ5V9vb/IS+L1mv/DyKAOro/vy1OnR+CA
	 zTLWtOeLvoZzEpMVszzWU3Sww1OCKs/VaFV/1cGDGE3ycPypa/XXYHPE3PeMWwGPbb
	 vAwfcNp3YB7Ko/5wRauVDSt+SWBAW+S/eKS0Jxig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maher Sanalla <msanalla@nvidia.com>,
	Yishai Hadas <yishaih@nvidia.com>,
	Kalesh AP <kalesh-anakkur.purayil@broadcom.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 445/781] RDMA/mlx5: Fix ucaps init error flow
Date: Tue, 24 Feb 2026 17:19:14 -0800
Message-ID: <20260225012410.622080646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maher Sanalla <msanalla@nvidia.com>

[ Upstream commit 6dc78c53de99e4ed9868d4f0fc6da6e46f52fe4d ]

In mlx5_ib_stage_caps_init(), if mlx5_ib_init_ucaps() fails after
mlx5_ib_init_var_table() succeeds, the VAR bitmap is leaked since
the function returns without cleanup.

Thus, cleanup the var table bitmap in case of error of initializing
ucaps before exiting, preventing the leak above.

Fixes: cf7174e8982f ("RDMA/mlx5: Create UCAP char devices for supported device capabilities")
Signed-off-by: Maher Sanalla <msanalla@nvidia.com>
Reviewed-by: Yishai Hadas <yishaih@nvidia.com>
Link: https://patch.msgid.link/20260104-ib-core-misc-v1-3-00367f77f3a8@nvidia.com
Reviewed-by: Kalesh AP <kalesh-anakkur.purayil@broadcom.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 40284bbb45d6d..8d515d266125e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4466,12 +4466,16 @@ static int mlx5_ib_stage_caps_init(struct mlx5_ib_dev *dev)
 	    MLX5_HCA_CAP_2_GENERAL_OBJECT_TYPES_RDMA_CTRL) {
 		err = mlx5_ib_init_ucaps(dev);
 		if (err)
-			return err;
+			goto err_ucaps;
 	}
 
 	dev->ib_dev.use_cq_dim = true;
 
 	return 0;
+
+err_ucaps:
+	bitmap_free(dev->var_table.bitmap);
+	return err;
 }
 
 static const struct ib_device_ops mlx5_ib_dev_port_ops = {
-- 
2.51.0



