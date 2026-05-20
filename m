Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BC1B36A352;
	Wed, 20 May 2026 17:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297055; cv=none; b=ZdboQxGKNfTOZGk8fJq9qAYKGASeXj4iPVExb/F4wUY0h5qiJwdiFvCexpdRRkZ0y9+W8Q1sGEbZmOPo+jaGDp2763q6psA50MmSLRUmobDXEcEQnhUauVL4prkBVdzqVIC2PCjBuJFEvmSyHLhhGEkfJlez8Y8egj1fxGsCtsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297055; c=relaxed/simple;
	bh=Y2HVjyWQpqPse5EpMG+JNFVlRf3i0xRSaSIEsRMQruw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ILrM/AyLQIjdZaVn/uz8+aV0w40V/QmBhknUvji4Dp+CNIWQApO3AFbaaE709E/jFsTN7rdOGu6/dkT95fEr469rtWTg5UPiPgDnArK/tC6m/eu4MNw6Ia55b7u+dFDButgJnhvoZ6BlL190Gj+gl7T3v7O5lneSuYtwF7cAsmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyt6lNVw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyt6lNVw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2A391F000E9;
	Wed, 20 May 2026 17:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297054;
	bh=LYLQuIkIjmoIvOOnlsX4nls9+0VZWHowGZ+GDYPjB/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dyt6lNVwsMkjwBKTzXikzy2liVMIWN2zBa56uigsqcxlX/Xegg0SqcfnFe0liLxyS
	 iGMQsHNJuHdbx0dRemH1MJF+8mN1iXCLl5dqjUIVE6s2Oj3qOaD2QvUrffKpkujc0P
	 z0xze0U/tC7KUB867MrNF9gKJCH4jVq05L2sMses=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 1032/1146] sfc: fix error code in efx_devlink_info_running_versions()
Date: Wed, 20 May 2026 18:21:22 +0200
Message-ID: <20260520162211.583488546@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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



