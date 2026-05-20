Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53FA939B483;
	Wed, 20 May 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779299654; cv=none; b=geqGa0n5zxZRobFY02GylIMJIwsJ/E6MQt0Uevyi0DAOBFaJXUjN1k3dN/AW4N6rtwoyxyArcp1zAk7mYcFNQ/KZzxbJUBjoB/V7sFhz0b+gN90u5XrIUBcqUD0G3MOyaNiSuBcUfPibf4OiXzwuyWEzfzH4IsCNy7Lk94s5JOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779299654; c=relaxed/simple;
	bh=rBw/51LZjmg+NvJZYF4gyCd0AZI5pcJKV0ounwiACuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzDdXrQKTwEmocOtxs7hv8pOEUjMI6dzK0mCTaFWOJUsN8nq+kl0yowK3epe07nGzzHgITg/Tkei45oXr2rk3k7OC7M1wh0ceHT+QTiMN35xQeRvIKXO5iGamJWFW87UoFiU+/6wxu7gyuO7HKa1d8K1yqMFD9XWn4JoW3iBHgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=inCnmih1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="inCnmih1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0541F000E9;
	Wed, 20 May 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779299653;
	bh=rilJWf9z9LOCWwqCgqd2KCEzlVfOXmAzGOvJbGCJuPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=inCnmih1qKiGMS6uCqtLo6f/T9t+ggWHVtkejhyHtesm4MQF/ydcUW4CpvFUY6JFe
	 mOpFMLKEcEIG7CY/WAo7xP9Bw5cGi7RV1SNAVyNnV4a6riof8wOFE2Vg6X1S9rYhgV
	 5i2P5svp/FM/PyXVrM8NlppidKDcXxWp7Pc3O0Vo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 855/957] sfc: fix error code in efx_devlink_info_running_versions()
Date: Wed, 20 May 2026 18:22:18 +0200
Message-ID: <20260520162153.107897763@linuxfoundation.org>
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

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 051ffb001b8a232cfa6e72f38bb5f51c4270a60b ]

Return -EIO if efx_mcdi_rpc() doesn't return enough space.

Fixes: 14743ddd2495 ("sfc: add devlink info support for ef100")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>
Link: https://patch.msgid.link/afGpsbLRHL4_H0KS@stanley.mountain
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/efx_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/efx_devlink.c b/drivers/net/ethernet/sfc/efx_devlink.c
index d842c60dfc100..e5c6f81af48be 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -531,7 +531,7 @@ static int efx_devlink_info_running_versions(struct efx_nic *efx,
 	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN) {
 		netif_err(efx, drv, efx->net_dev,
 			  "mcdi MC_CMD_GET_VERSION failed\n");
-		return rc;
+		return rc ?: -EIO;
 	}
 
 	/* Handle previous output */
-- 
2.53.0



