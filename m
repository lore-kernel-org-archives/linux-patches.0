Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8621912B94;
	Tue, 17 Mar 2026 16:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765849; cv=none; b=XTFGHXH80wfu54eoVAx+015m5pE5nZgJ0eUSlWUKM1pjRt/kBqH4zsmqgHa41kBoCkc38rIInUstL8Pf3dXl+/4H6WdxtGDfeFh/S+eGmwLJqddJwM3y0zcAxDqKmWZp8uZRjoqzrpT9CaT5RA5QVrN/bEjlH3NTS+mHltDP438=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765849; c=relaxed/simple;
	bh=SHmr2nCJw917qsEfnAsjlaAPlfsk4k0ijk4nSDpCWBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZlyrezCJYMeKYXk9HpmRW9j2MEcCBf0LQ64P/ZQ4v4Dfx9BAoTg30sREMAvvxdECB4YYlz2Ni/edBANViBYcHosZrnclULTcQqlnR1ftmjOKyecBTQqOmC7Q/cr/yLYUfCN9ltQgRVnnmyk+/3/YadXgctKgDTIy08Jyuo8UQ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RePstaIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RePstaIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4787C4CEF7;
	Tue, 17 Mar 2026 16:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765849;
	bh=SHmr2nCJw917qsEfnAsjlaAPlfsk4k0ijk4nSDpCWBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RePstaIQ+lTJnO9hk8hsq9XS5EtOkww9VhVQqpqB4xDANNAKqMMbpJFigZE3wir6s
	 HXDP2s3mST4DG4DxHuxf8MIbWBep0iujA8hsDNRBzWHwDscnzuJJk/mSgm8NOnUfM8
	 NrnLSWWIiTSVIEUzdeZ4ka7sKdHUMJGa2WITu4r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 109/378] octeontx2-af: devlink: fix NIX RAS reporter recovery condition
Date: Tue, 17 Mar 2026 17:31:06 +0100
Message-ID: <20260317163011.026546254@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

From: Alok Tiwari <alok.a.tiwari@oracle.com>

[ Upstream commit dc26ca99b835e21e76a58b1463b84adb0ca34f58 ]

The NIX RAS health reporter recovery routine checks nix_af_rvu_int to
decide whether to re-enable NIX_AF_RAS interrupts. This is the RVU
interrupt status field and is unrelated to RAS events, so the recovery
flow may incorrectly skip re-enabling NIX_AF_RAS interrupts.

Check nix_af_rvu_ras instead before writing NIX_AF_RAS_ENA_W1S.

Fixes: 5ed66306eab6 ("octeontx2-af: Add devlink health reporters for NIX")
Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
Link: https://patch.msgid.link/20260310184824.1183651-1-alok.a.tiwari@oracle.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
index 0f9953eaf1b09..fa6ca4f41b59a 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -475,7 +475,7 @@ static int rvu_hw_nix_ras_recover(struct devlink_health_reporter *reporter,
 	if (blkaddr < 0)
 		return blkaddr;
 
-	if (nix_event_ctx->nix_af_rvu_int)
+	if (nix_event_ctx->nix_af_rvu_ras)
 		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
 
 	return 0;
-- 
2.51.0



