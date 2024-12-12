Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3254A213E6B;
	Thu, 12 Dec 2024 16:11:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019866; cv=none; b=gedMUg+Zqh4xkXMcc5c+om0bmKO6JamAi8AHLhJTWxMEdekAShJqxi8vgYsJu6MngF1zeO1CxB0K2LiCAkgeBNe7LaS4cqXhBh/lnwGD6JJBBlAa9F6vX2c9AIUopYztTRyjbOLwnSvpyHLI2d2UoQLrg7JFHy7vtAzmdaSPc3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019866; c=relaxed/simple;
	bh=+528Hdwv5W0mBSUHAnn6t6oCeP+o9nAU711u1/jsqvM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6aljTYcGNzfzQhB6YNB9pBlS2ptOEdmSkYCz5b0kclHeG5O3OUaWvprUCSO5KSVzJMl1/EIgyPu4LCNIvDoaEzx2Ul/oNF+G1gnvmC2O+WL9LvvifTmJLI1iRh/10cYyJoKgD7aOELrYe04lQDVODCselTjShQYKhYIR8zrqds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dt2lgEho; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dt2lgEho"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D579C4CED4;
	Thu, 12 Dec 2024 16:11:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019866;
	bh=+528Hdwv5W0mBSUHAnn6t6oCeP+o9nAU711u1/jsqvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dt2lgEhodtdP/Ilw647w17qrHvJMFj/lPGGrrFdTthWeWdalRdyFOBd+yJNF0MJe+
	 glxfu+my8qU5WCzf/EADg1AGQllNFXcy0HFQXHJ5pU8DjgeQz8kONoKz2exGQQOjNS
	 UyUNHcs/nJRad3acwjgbNc76P5ek+wTejuTh6TUM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Somnath Kotur <somnath.kotur@broadcom.com>,
	Pavan Chebbi <pavan.chebbi@broadcom.com>,
	Kashyap Desai <kashyap.desai@broadcom.com>,
	Saravanan Vajravel <saravanan.vajravel@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 317/772] bnxt_en: Reserve rings after PCIe AER recovery if NIC interface is down
Date: Thu, 12 Dec 2024 15:54:22 +0100
Message-ID: <20241212144402.988131815@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Saravanan Vajravel <saravanan.vajravel@broadcom.com>

[ Upstream commit 5311598f7f3293683cdc761df71ae3469327332c ]

After successful PCIe AER recovery, FW will reset all resource
reservations.  If it is IF_UP, the driver will call bnxt_open() and
all resources will be reserved again.  It it is IF_DOWN, we should
call bnxt_reserve_rings() so that we can reserve resources including
RoCE resources to allow RoCE to resume after AER.  Without this
patch, RoCE fails to resume in this IF_DOWN scenario.

Later, if it becomes IF_UP, bnxt_open() will see that resources have
been reserved and will not reserve again.

Fixes: fb1e6e562b37 ("bnxt_en: Fix AER recovery.")
Reviewed-by: Somnath Kotur <somnath.kotur@broadcom.com>
Reviewed-by: Pavan Chebbi <pavan.chebbi@broadcom.com>
Reviewed-by: Kashyap Desai <kashyap.desai@broadcom.com>
Signed-off-by: Saravanan Vajravel <saravanan.vajravel@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 20e2fae64e67f..7d9677d0f7304 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -14113,8 +14113,12 @@ static void bnxt_io_resume(struct pci_dev *pdev)
 	rtnl_lock();
 
 	err = bnxt_hwrm_func_qcaps(bp);
-	if (!err && netif_running(netdev))
-		err = bnxt_open(netdev);
+	if (!err) {
+		if (netif_running(netdev))
+			err = bnxt_open(netdev);
+		else
+			err = bnxt_reserve_rings(bp, true);
+	}
 
 	bnxt_ulp_start(bp, err);
 	if (!err) {
-- 
2.43.0



