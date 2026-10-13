Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C241348C4B;
	Tue, 13 Oct 2026 12:47:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895659; cv=none; b=eAT5jVZszq6oFbwHeNhu47SlcCJsl95o86EHNRGNMGOcfY7fEsI8cKFgpqSzDEilrQVsZhh4z87qDn3zLwNMfWYVqHAw366wgiAz4kCwKF7BcfsnmOMyCFe7HN/8ggJae/E2H23RULbT4jxdAN2uN1HVvwVoyec+C1NxagDM4dw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895659; c=relaxed/simple;
	bh=S6lN8x+kgK2a4Xbxcu5a0+K3xjZpWuh0AIxlocr2FdI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ely5PA0moFVLcsQej2o7vlPwJ8Ezt7BjhYnPy9Mxl1Dh2s7xM9mavC6XWjyxNZvFFgqutnqz4yqDVe9FQ0JvarsIzmf8Z/uNokLj4jtJstcn329TgE/At7lgjhNTpavLSpGymT/i0yaiDFHNbsqJOemPdTN53sBBsvK9N07LjQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ejnm92RF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ejnm92RF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E910F1F000FF;
	Tue, 13 Oct 2026 12:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895658;
	bh=jCorcF9aSmCa1azo4jJams7Ab9BT3ZSE38yNXMs1qI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ejnm92RFYR3BMrRpLTDlb3mD6pEXeGugrqH8qio5Oer4EnzLsyc0Dl+hQJQ0A42IB
	 KC7N2IQrQHI3joEOXPRowcbbNyWongB0l35ojTLQV59FARDMI/uhZ56I0XDS8qVTC1
	 jWiVK0e3F7YwTBeOOLGCQvbxxu/+i1G/eleBwIQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 322/497] net: mana: Skip WQ object destruction for uninitialized RXQ
Date: Tue, 13 Oct 2026 13:38:09 +0200
Message-ID: <20261013112915.546077036@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microsoft/mana/mana_en.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/microsoft/mana/mana_en.c b/drivers/net/ethernet/microsoft/mana/mana_en.c
index 0da960bc11de7..46726f743d322 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2047,7 +2047,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
-	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
+	if (rxq->rxobj != INVALID_MANA_HANDLE)
+		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-- 
2.53.0



