Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9EB527280A;
	Mon, 13 Apr 2026 16:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776097499; cv=none; b=bauq7e9OU/JGHBGbWTmJUuspiEfL+Doae91h/s1crXQRunU3lUJsy8/PNsHxX8JUTG7hZC5r6Bb41E5Z1d4dETaz+R0N11/lzCIAXeI0D/cgMumIs7dfQmGbvIG4i7ZgK21894vF3KtvzCNUdOLVivtBZbfxU4DfuPMaNivuROE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776097499; c=relaxed/simple;
	bh=sfv0x3KIbZcjjIOkatBRrADXwSqWl8iCQhO0xiILxv0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ujcwezjNE8Hkdb/f2ZUB7cd/KsP5jCJo651sFWM+fBrt+wxDLp2MRFbSBK+2KwNbqREyB5CqBwa2JlAJc3TMmrqmAWvduRtKb7xKxSiCYsiCy9cxRSF2DEQuuM79zCwuuIF1k/dcwfO5b0Xvin3pXZoKjtzQN8GDMEjLFdvHzkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZeP3m/Ry; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZeP3m/Ry"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB8C2BCAF;
	Mon, 13 Apr 2026 16:24:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776097499;
	bh=sfv0x3KIbZcjjIOkatBRrADXwSqWl8iCQhO0xiILxv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZeP3m/RyJwcvqe3JIHUUSYpqrvGDSImiVH88eMu0OLVU6X2dx3Xzni4tCgcvzq0oZ
	 cjxahbtTe5XRfxCJFlubRrC/jx9nWrXqYgLysWjL/VWo1NfziB/OG6bpoN4UQUl+dk
	 l2svr4aD2GshEawPRtfME0WMb4kmQmjYgFo+u6BA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alok Tiwari <alok.a.tiwari@oracle.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 127/570] octeontx2-af: devlink: fix NIX RAS reporter recovery condition
Date: Mon, 13 Apr 2026 17:54:18 +0200
Message-ID: <20260413155835.200063535@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155830.386096114@linuxfoundation.org>
References: <20260413155830.386096114@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index c5e3ef6b41a87..c3da400e87eba 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_devlink.c
@@ -578,7 +578,7 @@ static int rvu_hw_nix_ras_recover(struct devlink_health_reporter *reporter,
 	if (blkaddr < 0)
 		return blkaddr;
 
-	if (nix_event_ctx->nix_af_rvu_int)
+	if (nix_event_ctx->nix_af_rvu_ras)
 		rvu_write64(rvu, blkaddr, NIX_AF_RAS_ENA_W1S, ~0ULL);
 
 	return 0;
-- 
2.51.0



