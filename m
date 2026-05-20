Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31E1403EBF;
	Wed, 20 May 2026 18:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302982; cv=none; b=pB0xSY2rmJtBdFOezLHlN8un37mH8Vkw6MD4WZEFVOn5grhlJqUCeXDsbW0twv1AdCFezwr99tYG2NBHpZ3OlcTYR3yXdgH6BglzKmyyqPUSeo2sz5J1adYTQ89M9fcngA7JAI0yiZOLhATzHHfMu3yuHHh9TGe6rP/Q3B+bsEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302982; c=relaxed/simple;
	bh=vu19sV0rwKrvCD+l82Dji2Ddo2vDHqsp1x196vovl9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvCjQHxEB6TsS/PgmMVYEInVt1+EscGTxPYMdDwlTTtlG6FGIb86g1n3J1bVc+JnCvA4ltm1XbVuXEII96bLFhuEk52KQtAUstdSkd9ZDqHd4nv9yVqDc20kwIHzZ1iT5d10aMt4K4ddXPloguT+UZzkkXNT/5SqKeFO77QXy6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=odPb3G/7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="odPb3G/7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F48F1F00894;
	Wed, 20 May 2026 18:49:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302980;
	bh=+OVyUgWoIKhCp3tTSAu8K5EF+aoD8MtDAQHQlTBCVNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=odPb3G/7PPYN2VE1RsmxrTA6Cje+uj23hkgucv2QG8ss9qPPX7KMOjxNXiF4yVWUg
	 Q09r2EgfqX3XeMtcV6YWh2TpMyTMckh4MgS8G8/SG/LnhjYtTvqZ4cFcvYrhVJ89ob
	 3ugDI77OdIj1338U0QX9wOIB9XlAaOXIXQFfyg3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Edward Cree <ecree.xilinx@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 436/508] sfc: fix error code in efx_devlink_info_running_versions()
Date: Wed, 20 May 2026 18:24:19 +0200
Message-ID: <20260520162108.046914837@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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
index 3cd750820fdde..d5a4b3cf94544 100644
--- a/drivers/net/ethernet/sfc/efx_devlink.c
+++ b/drivers/net/ethernet/sfc/efx_devlink.c
@@ -530,7 +530,7 @@ static int efx_devlink_info_running_versions(struct efx_nic *efx,
 	if (rc || outlength < MC_CMD_GET_VERSION_OUT_LEN) {
 		netif_err(efx, drv, efx->net_dev,
 			  "mcdi MC_CMD_GET_VERSION failed\n");
-		return rc;
+		return rc ?: -EIO;
 	}
 
 	/* Handle previous output */
-- 
2.53.0



