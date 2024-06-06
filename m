Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B68F1993A0;
	Thu,  6 Jun 2024 14:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683252; cv=none; b=j8MEs5Dx7DQnmSSLYGSyvrSMMXqK9ejuaLJMlZy2c7eTNC/llNfAS/eef5JmoFCpV0XmPiWL1VN2tCflUNa9iy4Vd2I1rzAlQ2aCz5ZiewopuZtDTDc7k3Iv4ChYUfgdWGTCRooyUc6KYLfhJgSdKFVE777W+LzZ7wQpBT4eYEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683252; c=relaxed/simple;
	bh=P3y1+pbhnhjMOU8o3j7bTIT4YG9noOnJbV1Yu/ngFIM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhBJ63m2eaWpNP7U5/grrhNT6Lvm/1iWHC5WYJSPOPv9OejktHuf8u4F011uYg6jonKeUhHXyVH9Cf+uppJ9cN63P8tKhfE2ssuRwZYGIE3mOPGGqIatOE00hN38aqXFezciGORNyS5+p5b3//O5zwctK38VODREeMELKNty65A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rjavu8bZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rjavu8bZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F028AC2BD10;
	Thu,  6 Jun 2024 14:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683252;
	bh=P3y1+pbhnhjMOU8o3j7bTIT4YG9noOnJbV1Yu/ngFIM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rjavu8bZ/1Ej4PlUGzG3X4K1LsBfTsEpss5oDROX8ReR7X/NB0d8YLnR91oLZkhZo
	 TRKGgmIHAywn0dSd97U9Ij49iluAYzmhrv6HvV3IYgdhPnoLDLV2LaZIEQ8yKuCt00
	 Ux+EVwVEH5heMkpXYQw8nhG6BuP9LekWYk1a5mVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/473] scsi: libsas: Fix the failure of adding phy with zero-address to port
Date: Thu,  6 Jun 2024 16:00:57 +0200
Message-ID: <20240606131704.173329761@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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
index 4b5ceba68e46e..ffec7f0e51fcd 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -239,8 +239,7 @@ static void sas_set_ex_phy(struct domain_device *dev, int phy_id,
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



