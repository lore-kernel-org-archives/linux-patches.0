Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E8854FC8CC;
	Tue, 13 Oct 2026 12:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892812; cv=none; b=LHh925aLGhcaR1ag6VDgsy0l9o605hkURIsxk02n0QP9HwCcPUQ+ekiXY8X5B3RmS8r/uPgPP80SukH9hcsYXQwIipe+RN0CktJtmg9iyBI+ONZCWdwy9cADsI3MkLKduvNXCtHT7M2Ut9ThhFHxcAtg1CQr2RNpM++CNnSqutA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892812; c=relaxed/simple;
	bh=k09T7J3OQ7qxGcyCozVPTwBanneL5aulcIa7UEMFECc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pe5TC6fv9ntgZYDE+bZ0uUi5StMua2+Iyl9WnV4nF/BjVobXoWkZCLtcE+Wv2XYi+AY8oJMb7UiMvSmtbOLYToQ/SBLPehoG4OMcLqO6GcTI2tOfiQ4BR65zbKY4C/piahK+EruxwYPSrkmzpP9lFlQ66g1Y5gLPZyuUaiSjmSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ot7m4dhJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ot7m4dhJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E089E1F000FF;
	Tue, 13 Oct 2026 12:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892811;
	bh=KfR20w5rk78j7n6faFPsZIbimWMqCAS7XSMpc8qCFcQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ot7m4dhJQMECC0IzQmpNrfI6OADiw99kI4Q483FfsohzhTlxw0qdZ9bT0F9dQnFL9
	 Cee+IHSEU4MO0rV3rl/UpF0648ib0PlejyPj/vbLB8KHO2+Et2xDBpDcl+Ty9PnExw
	 cO3VNwmOPi6Es4ZhmbjSlWJHJK/3bENAV5SyoSB0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Dipayaan Roy <dipayanroy@linux.microsoft.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/621] net: mana: Skip WQ object destruction for uninitialized RXQ
Date: Tue, 13 Oct 2026 13:30:01 +0200
Message-ID: <20261013112921.014652209@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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
index cd77feb4109ea..5cbe24a1596c8 100644
--- a/drivers/net/ethernet/microsoft/mana/mana_en.c
+++ b/drivers/net/ethernet/microsoft/mana/mana_en.c
@@ -2539,7 +2539,8 @@ static void mana_destroy_rxq(struct mana_port_context *apc,
 	if (xdp_rxq_info_is_reg(&rxq->xdp_rxq))
 		xdp_rxq_info_unreg(&rxq->xdp_rxq);
 
-	mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
+	if (rxq->rxobj != INVALID_MANA_HANDLE)
+		mana_destroy_wq_obj(apc, GDMA_RQ, rxq->rxobj);
 
 	mana_deinit_cq(apc, &rxq->rx_cq);
 
-- 
2.53.0



