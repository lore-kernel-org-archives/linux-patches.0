Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9C7619D06D;
	Thu, 25 Jul 2024 14:43:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721918588; cv=none; b=s6UdLvipZZijOQEUQRv6xhvM6kxaHtNuze4+S5/CnKudUJl50qdkkWYod6yPSHBn4s6yDFgCacgTAdB92NW5OzF0UIXznwUpjNGNDmx2riY89HHjxgcUGnbU1nwYesoVQaLebQj/N50V/BpASeYH8WnAVo6UyVeF0g7b3Ov+o1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721918588; c=relaxed/simple;
	bh=d/Pt6sQbMZmStVd3nhG5llCmrqOvKLh5xf8NiiDHTUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mpc869fFUZ7jTelxQ+ajy6aEND0HP+56LeNZd1dJYvI+kgujWIPCx/KRB3bp3BYQJ4lJpsQDxuCdn6awMsRT+ZuR26sLnbyu1Th+nZnxrPBf/pKK8rThhxFazOAjiqHf87tw0aIt3nfAoIWY/ccH/3DaTe4aobNwjR/hXrSy090=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VREquHW/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VREquHW/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33306C116B1;
	Thu, 25 Jul 2024 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721918588;
	bh=d/Pt6sQbMZmStVd3nhG5llCmrqOvKLh5xf8NiiDHTUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VREquHW/yZeDrWhDXwN5CCmS8L98yzUVftO91W0fNio1Iferfiu7GZkAewZEnhw8t
	 AUp6WpFPgmODBD9xo4N15pjsrf1OG81yTAjywIbMOk7Lhwv54wWt+cCO66PoHZJIRD
	 ZHowYpMAGb/ZiLPCC2JtdB5MLcCGV/NltQ4mB8Q4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 30/43] scsi: libsas: Fix exp-attached device scan after probe failure scanned in again after probe failed
Date: Thu, 25 Jul 2024 16:36:53 +0200
Message-ID: <20240725142731.610554915@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
References: <20240725142730.471190017@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit ab2068a6fb84751836a84c26ca72b3beb349619d ]

The expander phy will be treated as broadcast flutter in the next
revalidation after the exp-attached end device probe failed, as follows:

[78779.654026] sas: broadcast received: 0
[78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
[78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
[78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 500e004aaaaaaa05 (stp)
[78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
[78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
[78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
...
[78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries: 1
[78835.171344] sas: sas_probe_sata: for exp-attached device 500e004aaaaaaa05 returned -19
[78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
[78835.187487] sas: broadcast received: 0
[78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
[78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
[78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated BROADCAST(CHANGE)
[78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
[78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 500e004aaaaaaa05 (stp)
[78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
[78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0

The cause of the problem is that the related ex_phy's attached_sas_addr was
not cleared after the end device probe failed, so reset it.

Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://lore.kernel.org/r/20240619091742.25465-1-yangxingui@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_internal.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/scsi/libsas/sas_internal.h b/drivers/scsi/libsas/sas_internal.h
index 01f1738ce6dff..3fb8a64f571d5 100644
--- a/drivers/scsi/libsas/sas_internal.h
+++ b/drivers/scsi/libsas/sas_internal.h
@@ -111,6 +111,20 @@ static inline void sas_fail_probe(struct domain_device *dev, const char *func, i
 		func, dev->parent ? "exp-attached" :
 		"direct-attached",
 		SAS_ADDR(dev->sas_addr), err);
+
+	/*
+	 * If the device probe failed, the expander phy attached address
+	 * needs to be reset so that the phy will not be treated as flutter
+	 * in the next revalidation
+	 */
+	if (dev->parent && !dev_is_expander(dev->dev_type)) {
+		struct sas_phy *phy = dev->phy;
+		struct domain_device *parent = dev->parent;
+		struct ex_phy *ex_phy = &parent->ex_dev.ex_phy[phy->number];
+
+		memset(ex_phy->attached_sas_addr, 0, SAS_ADDR_SIZE);
+	}
+
 	sas_unregister_dev(dev->port, dev);
 }
 
-- 
2.43.0



