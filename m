Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52439381AF8;
	Tue, 10 Mar 2026 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141159; cv=none; b=eQv5S4mRlJVcHMYZhDAsFCAV1rEBV5xp4mIRohj8bYObpMs83xxMzsjUT/Y1MGK8ZsDAeabRNDi+PiSSjAhKku9d8I5Hbw+XTAPNJOF0uaZVXtaevV3NPBi1OogtzoHRnbRTbDP1j2wOPTmmK+mTbg4JZItAQw+gw4+sAL216XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141159; c=relaxed/simple;
	bh=nk8TAKk5/BoHlxv/PUrEhk8hUKEgzQjKNs7gtU5shjQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k80yIWUgpaa+6iS3zWz8Eqk2qUwi9hLuKKDM1nHKZjDcfF/Fd1OnY/d0qhh5sVqzL9a9r653PsFdZmiLV37utzXlRTOZ55cBbVdxUVEAxliRCUCkFgRSOWY8sb2Yq+iy4ottpSwBQckXzSgt34hCum243DLYrxePBr15GrxodnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikftFKTF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikftFKTF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87A1EC2BC86;
	Tue, 10 Mar 2026 11:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141159;
	bh=nk8TAKk5/BoHlxv/PUrEhk8hUKEgzQjKNs7gtU5shjQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikftFKTFpUf9kopJryqXBruGI1obMHLimfa6dzXcX7eqIOaUAaI2dizV8VJS1xS1d
	 NuIr5UbGs8tEsTNHWIiOuJGf9R2k4lMpx+qsZa3uSPMoUWuYwS+i80uIUdp9FO/9nw
	 KXa/T5+l9Ih/uetubHNXIeCrVwyC8hqLkDtd69hJqVe2xMYPnsZjqrO66rBtyEkS89
	 GtbWrm1PvzXwiS0M2ryMy/R2Bl0MjXHZ3Sk4Ab2BYpi9fAnYYqqV/tfwFnnRXFo70R
	 /v6siSZRn4IRvC1qpspO+3ewHnNckInEKupzcTFcfVQI90BX/Vya5RgtNy3HJoL0mr
	 Eu02YSIWIHbBA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexey Charkov <alchark@flipper.net>,
	Bean Huo <beanhuo@micron.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 6.19 161/311] scsi: ufs: core: Fix RPMB region size detection for UFS 2.2
Date: Tue, 10 Mar 2026 07:03:28 -0400
Message-ID: <9edf1af8edfad6aa706eb34a505535f1a3c1fe23.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alexey Charkov <alchark@flipper.net>

commit 2e6b5cd6a4b37a95b78cf8c39a979b58c915c8ed upstream.

Older UFS spec devices (2.2 and earlier) do not expose per-region RPMB
sizes, as only one RPMB region is supported. In such cases, the size of the
single RPMB region can be deduced from the Logical Block Count and Logical
Block Size fields in the RPMB Unit Descriptor.

Add a fallback mechanism to calculate the RPMB region size from these
fields if the device implements an older spec, so that the RPMB driver can
work with such devices - otherwise it silently skips the whole RPMB.

        Section 14.1.4.6 (RPMB Unit Descriptor)

Link: https://www.jedec.org/system/files/docs/JESD220C-2_2.pdf
Cc: stable@vger.kernel.org
Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Reviewed-by: Bean Huo <beanhuo@micron.com>
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260209-ufs-rpmb-v3-1-b1804e71bd38@flipper.net
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufshcd.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index d6e4e99a571f1..80fafad339c75 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -23,6 +23,7 @@
 #include <linux/pm_opp.h>
 #include <linux/regulator/consumer.h>
 #include <linux/sched/clock.h>
+#include <linux/sizes.h>
 #include <linux/iopoll.h>
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_dbg.h>
@@ -5237,6 +5238,25 @@ static void ufshcd_lu_init(struct ufs_hba *hba, struct scsi_device *sdev)
 		hba->dev_info.rpmb_region_size[1] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION1_SIZE];
 		hba->dev_info.rpmb_region_size[2] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION2_SIZE];
 		hba->dev_info.rpmb_region_size[3] = desc_buf[RPMB_UNIT_DESC_PARAM_REGION3_SIZE];
+
+		if (hba->dev_info.wspecversion <= 0x0220) {
+			/*
+			 * These older spec chips have only one RPMB region,
+			 * sized between 128 kB minimum and 16 MB maximum.
+			 * No per region size fields are provided (respective
+			 * REGIONX_SIZE fields always contain zeros), so get
+			 * it from the logical block count and size fields for
+			 * compatibility
+			 *
+			 * (See JESD220C-2_2 Section 14.1.4.6
+			 * RPMB Unit Descriptor,* offset 13h, 4 bytes)
+			 */
+			hba->dev_info.rpmb_region_size[0] =
+				(get_unaligned_be64(desc_buf
+					+ RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_COUNT)
+				<< desc_buf[RPMB_UNIT_DESC_PARAM_LOGICAL_BLK_SIZE])
+				/ SZ_128K;
+		}
 	}
 
 
-- 
2.51.0

