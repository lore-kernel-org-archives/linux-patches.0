Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0201422B5;
	Thu, 13 Jun 2024 11:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278698; cv=none; b=hTWFDwN1yPBDFcbzs1Vx4e7Gn9iRhCKj7EE/y6eao2jZ0bj3qtSWLKHCZPgvtpL7PoZ415YhqML/iR5cRa/9GJFd/9ontH1tVo5meDRr+6wo1ffaVXneKFIxfoW+vpDUds84HcCXtxgiPvZzqETZvwrlADTjsvxZt6owrsXn45g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278698; c=relaxed/simple;
	bh=icACGCTNJCIgyToP2bT4hGBPHxGXHLGey4sL8hjZivk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t3738m977Fe0X+UH5yZCFWfClG26Mi0YHEa8vLUloqZXNM0jyBIiZHWfRymTHNA6Fbl4Wv9BTzIuvh7GhjHimLk8CMcp43Z5py9rD8QXGMc+wynTvodzYk3h/9pFwl5ca8JJsT1KT7a/kLB96fjWJ9X+St8RQ6zfUYYnZAERdZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjHJ/wcH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjHJ/wcH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05297C2BBFC;
	Thu, 13 Jun 2024 11:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278698;
	bh=icACGCTNJCIgyToP2bT4hGBPHxGXHLGey4sL8hjZivk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjHJ/wcHH9LL+0+xtlFpfHmRy99/SmWrvdOVmR42QX5ZUNbTa1Hl89n/Eo9kHKmAa
	 8xDRfvg+6c9VuGNHAR2X4OCm1HkLJYWY0+6WfxDv3EM9tUAUhUgCk4hS5pyKel6Gb2
	 1PsWJDenOZTCyNvVUrT4f6qirwxskNoEXXHQ6vt4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/213] scsi: libsas: Fix the failure of adding phy with zero-address to port
Date: Thu, 13 Jun 2024 13:31:27 +0200
Message-ID: <20240613113229.509683577@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 06036a0a5db34642c5dbe22021a767141f010b7a ]

As of commit 7d1d86518118 ("[SCSI] libsas: fix false positive 'device
attached' conditions"), reset the phy->entacted_sas_addr address to a
zero-address when the link rate is less than 1.5G.

Currently we find that when a new device is attached, and the link rate is
less than 1.5G, but the device type is not NO_DEVICE, for example: the link
rate is SAS_PHY_RESET_IN_PROGRESS and the device type is stp. After setting
the phy->entacted_sas_addr address to the zero address, the port will
continue to be created for the phy with the zero-address, and other phys
with the zero-address will be tried to be added to the new port:

[562240.051197] sas: ex 500e004aaaaaaa1f phy19:U:0 attached: 0000000000000000 (no device)
// phy19 is deleted but still on the parent port's phy_list
[562240.062536] sas: ex 500e004aaaaaaa1f phy0 new device attached
[562240.062616] sas: ex 500e004aaaaaaa1f phy00:U:5 attached: 0000000000000000 (stp)
[562240.062680] port-7:7:0: trying to add phy phy-7:7:19 fails: it's already part of another port

Therefore, it should be the same as sas_get_phy_attached_dev(). Only when
device_type is SAS_PHY_UNUSED, sas_address is set to the 0 address.

Fixes: 7d1d86518118 ("[SCSI] libsas: fix false positive 'device attached' conditions")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240312141103.31358-5-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_expander.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
index 3e74fe9257617..601e06ad6a7b2 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -269,8 +269,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id, void *rsp)
 	/* help some expanders that fail to zero sas_address in the 'no
 	 * device' case
 	 */
-	if (phy->attached_dev_type == SAS_PHY_UNUSED ||
-	    phy->linkrate < SAS_LINK_RATE_1_5_GBPS)
+	if (phy->attached_dev_type == SAS_PHY_UNUSED)
 		memset(phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
 	else
 		memcpy(phy->attached_sas_addr, dr->attached_sas_addr, SAS_ADDR_SIZE);
-- 
2.43.0



