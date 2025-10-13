Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C92B731280A;
	Mon, 13 Oct 2025 15:11:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368271; cv=none; b=Iav8DKarC837dhZqNiup5Rex18Q9IMv5G0k6PgOFDpa52a3vSW2kBzTGea1tVwgdiwXZYzEyXpmKFKF/dFefzfOWgN0jjrECRcUvNaeurz3X+YTYHwJkfqSN8gJoyh407mHgBiH+sIJ0TCmvNsbgE76SQ6ykHJzEiSxhoXxxPxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368271; c=relaxed/simple;
	bh=t7c4M5iq+5KcTOWEQu0uoqiqbcEi3zaDjeomPBSIz2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pJov2vOg5jVafFqPuGE9le9PrQHL5MsY1LKYY+iV/TsKoVCm/jaPzp1+aO3fA2rHoAJ1M5D4N+okA3gJ3qoi+K/BMF32s3abY7dD8GX5o6JfVmBwV+8slDHqt/4D1M2Rvw3X60POY7RydVW66xWWy5jcpnL0/tnLNDnWKPDLDHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aplzYzRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aplzYzRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 537A6C4CEE7;
	Mon, 13 Oct 2025 15:11:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368271;
	bh=t7c4M5iq+5KcTOWEQu0uoqiqbcEi3zaDjeomPBSIz2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aplzYzRwBEAYlyg0Heg4jflVblVessxmJaXZFQ7aTRMc0qGcCn3zACw91VAZOPtRK
	 R0fr+pD+VKS2b1Wc/PObQf7Ikl53pe2IYvkcZpytBERMBel6KY6vEs498PZJFHtYjB
	 T2A7tvCQN5FNaKD9FewDeE4QuFoLK/WxsQ9LCHwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/262] scsi: pm80xx: Fix array-index-out-of-of-bounds on rmmod
Date: Mon, 13 Oct 2025 16:44:04 +0200
Message-ID: <20251013144329.803093744@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index a9d6dac413346..4daab8b6d6752 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -703,6 +703,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 	unsigned long flags = 0;
 	struct pm8001_hba_info *pm8001_ha;
 	struct pm8001_device *pm8001_dev = dev->lldd_dev;
+	struct domain_device *parent_dev = dev->parent;
 
 	pm8001_ha = pm8001_find_ha_by_dev(dev);
 	spin_lock_irqsave(&pm8001_ha->lock, flags);
@@ -719,7 +720,13 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
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



