Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C829D274B55;
	Mon, 13 Oct 2025 14:51:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367109; cv=none; b=i4mkkmzBjwesI8nkkYlearfHu3hMyCWuLXwM2qW7B5WEH16piPvPsVnDIPg0Irm2KMQITtdhtn/pwwlmTjfDweCiGt32bp6lEeWXPUyoysVx1gfuWDHDUxN9j2vwqIdYRJE4lIFR/WICMprmAoaJ0uQaUUVJ7a14nsafz1Ug2Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367109; c=relaxed/simple;
	bh=TAcIwK3HqBnJePzWQ22Fj4H61FdJJb5mbr+1774A0DY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hhoRe/XbLvUaGTDETEn15f3+BTiummXxSRnErADF4MY9/vm7AcmIiieknlaT6K+ehEMD9lRdwCVM4MRO4BQpE9sLkko6v5yX5cpelGihyj4FW1NIe+G2HOhUnOjyhXU70KtuKCnNK5+9Xw2rhrrvRYJEJy1TVuKytGo63dgRLUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=luONCjvM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="luONCjvM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 582C3C4CEE7;
	Mon, 13 Oct 2025 14:51:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367109;
	bh=TAcIwK3HqBnJePzWQ22Fj4H61FdJJb5mbr+1774A0DY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luONCjvM0rNXASHxs5/bCdlnyUXRaB9pROSUcpLiFkU/8pRCJIeP+1o0HwQcgDXKg
	 VNT3ZQQXlyLyFuNsTPxM3+PoyoTBWa11prOdhtUUg+BgFTz46Zni0UzWlEDEsxNj6A
	 bGaPP59rhtgjeMxETiU2RWuMfk5B40hfkN3GP6mw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 096/196] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
Date: Mon, 13 Oct 2025 16:44:29 +0200
Message-ID: <20251013144318.172937546@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit 251be2f6037fb7ab399f68cd7428ff274133d693 ]

Since commit f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when
device is gone") UBSAN reports:

  UBSAN: array-index-out-of-bounds in drivers/scsi/pm8001/pm8001_sas.c:786:17
  index 28 is out of range for type 'pm8001_phy [16]'

on rmmod when using an expander.

For a direct attached device, attached_phy contains the local phy id.
For a device behind an expander, attached_phy contains the remote phy
id, not the local phy id.

I.e. while pm8001_ha will have pm8001_ha->chip->n_phy local phys, for a
device behind an expander, attached_phy can be much larger than
pm8001_ha->chip->n_phy (depending on the amount of phys of the
expander).

E.g. on my system pm8001_ha has 8 phys with phy ids 0-7.  One of the
ports has an expander connected.  The expander has 31 phys with phy ids
0-30.

The pm8001_ha->phy array only contains the phys of the HBA.  It does not
contain the phys of the expander.  Thus, it is wrong to use attached_phy
to index the pm8001_ha->phy array for a device behind an expander.

Thus, we can only clear phy_attached for devices that are directly
attached.

Fixes: f7b705c238d1 ("scsi: pm80xx: Set phy_attached to zero when device is gone")
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20250814173215.1765055-14-cassel@kernel.org
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index a87c3d7e3e5ca..00d70b458b48c 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -704,6 +704,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	unsigned long flags = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+	struct domain_device *parent_dev = dev->parent;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -720,7 +721,13 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
-		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
+
+		/*
+		 * The phy array only contains local phys. Thus, we cannot clear
+		 * phy_attached for a device behind an expander.
+		 */
+		if (!(parent_dev && dev_is_expander(parent_dev->dev_type)))
+			pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.51.0



