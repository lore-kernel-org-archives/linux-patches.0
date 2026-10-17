Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCC35E93B;
	Sat, 17 Oct 2026 17:13:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257187; cv=none; b=gaKCLM8awCtJsgGThiqS4Rz/5lFYSzRPCqqDAZwe+6hjOPS9nHHZ3DsYOr496fSTg2OUNvzjPLguzdGeQn1s3qIJPpoWoRm1HhAKmfLDVTGeiCWupvK1ve5xxrZmVajedXl3SaJI+nvpjGhe4PzL+BWPz+QhYF+FZ8h/KJaMdHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257187; c=relaxed/simple;
	bh=+RQt7Hnd3oOpiK/2GsYHevZvi7L0f54KXeZp2/D+raU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iw1H6bXjV3u8vFr1soSlnMF26CSNRGjmZpmWcfBPZ5sfAb21C8AxFolwDQmTiRWmkyHKsqie49UKdCmhZqlzoktq7SvJqfuIdnEsZwB9GqFM10SA88azM2tj2VuFPUOipaPfsP8j44KQtg5RqvNzjcPDBPwr+cS6xxqGeitUxW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=10RpLSIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="10RpLSIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 091791F000C4;
	Sat, 17 Oct 2026 17:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257186;
	bh=rDJ2bk84QrirwdvLcVCu0vASOjrsenGFEJcDvjLdhXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=10RpLSIwJPNFgw/gP+48YV4ZeXh+knWRFroTz/sLKNd7IfVywDCQAmjIP/ph2qcH+
	 KKr0dpcZrsSRFRa/kp3Oa4DzwAQc7wOBv9xbEgLInK8IWnATFJcw/6dQghALFA4ejW
	 ns8aOtJV7zYKfnw2JfU0OUgR8L1h55AbOn+OLyCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0437/1674] net: mana: Skip WQ object destruction for uninitialized RXQ
Date: Sat, 17 Oct 2026 17:45:09 +0200
Message-ID: <20261017160442.338707659@linuxfoundation.org>
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

From: Dipayaan Roy <dipayanroy@linux.microsoft.com>

[ Upstream commit 2a1c691182823a5c149d502ac153e249ee697b4a ]

In mana_destroy_rxq(), mana_destroy_wq_obj() is called unconditionally
even when the WQ object was never created (rxobj is still
INVALID_MANA_HANDLE). When mana_create_rxq() fails before
mana_create_wq_obj() succeeds, the error path calls mana_destroy_rxq()
which sends a bogus destroy command to the hardware:

    mana 7870:00:00.0: HWC: Failed hw_channel req: 0x1d
    mana 7870:00:00.0: Failed to send mana message: -71, 0x1d
    mana 7870:00:00.0 eth7: Failed to destroy WQ object: -71

Guard mana_destroy_wq_obj() with an INVALID_MANA_HANDLE check so that
mana_destroy_rxq() is safe to call at any stage of RXQ initialization.

Fixes: ca9c54d2d6a5 ("net: mana: Add a driver for Microsoft Azure Network Adapter (MANA)")
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Link: https://patch.msgid.link/20260430035935.1859220-3-dipayanroy@linux.microsoft.com
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Hamza Mahfooz <hamzamahfooz@linux.microsoft.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 1477f05b897d5..2c49bb7ddaba3 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2054,7 +2054,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
-	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
+	if (rxq->rxobj != INVALID_MANA_HANDLE)
+		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-- 
2.53.0



