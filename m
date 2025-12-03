Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7DB3148CD;
	Wed,  3 Dec 2025 16:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764780500; cv=none; b=HQoWdmNUODCzFERpYDDIGNzVDXynKz1tlKvqBy6YgMJKNvVFR/sqibnsFjQPM+zAhpIhjb3CtThOeSBVJ/5vmg7Dda0M9UjBQtC/2F5up7egHNigVfinVUpGUtwnGiSPRbIVOS3WCcSMphoECZRay7iG+wNNiSUjth4j0y/FMTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764780500; c=relaxed/simple;
	bh=jCZ1nwn+SEayR32dmpb8s+RvFitztN7wEJtyxAiD+WI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sCY1/KnEG/DTJBumUU7x7ythVqXcSn9N1l0RwqUVvP3v24JWF0JigVldmoF/JgMBwWEeuQ5WTfdkxNTWgxO6f6dDU2v9nVkUpuLQLF0gr4IYYsi+OsOuHF1HvgsoW3VXRlCBVG8C/dTDhxDImhC+Zs9rHBW3ypArSXpaj2v1SoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CG5owtj1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CG5owtj1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12804C4CEF5;
	Wed,  3 Dec 2025 16:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764780500;
	bh=jCZ1nwn+SEayR32dmpb8s+RvFitztN7wEJtyxAiD+WI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CG5owtj1HxT6k4LXZC3hYtKq/4TlzvT7dXisUfgI0mPwRo1Qx6KnNFJrd87o/VeAK
	 hdYQuxG0RG700Ap/AoS2yBIVly0yd483A7El83RlKUUfmZfnVKM8LMTbLccZN5zMWs
	 Kvz8AEMHmEo+Y0Fwi1eB+KipoMAGWeKqkv+ptLz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Terrence Adams <tadamsjr@google.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Nazar Kalashnikov <sivartiwe@gmail.com>
Subject: [PATCH 6.1 566/568] scsi: pm80xx: Set phy->enable_completion only when we
Date: Wed,  3 Dec 2025 16:29:28 +0100
Message-ID: <20251203152501.479482878@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

From: Igor Pylypiv <ipylypiv@google.com>

[ Upstream commit e4f949ef1516c0d74745ee54a0f4882c1f6c7aea ]

pm8001_phy_control() populates the enable_completion pointer with a stack
address, sends a PHY_LINK_RESET / PHY_HARD_RESET, waits 300 ms, and
returns. The problem arises when a phy control response comes late.  After
300 ms the pm8001_phy_control() function returns and the passed
enable_completion stack address is no longer valid. Late phy control
response invokes complete() on a dangling enable_completion pointer which
leads to a kernel crash.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Link: https://lore.kernel.org/r/20240627155924.2361370-2-tadamsjr@google.com
Acked-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Nazar Kalashnikov <sivartiwe@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
Backport fix for CVE-2024-47666
 drivers/scsi/pm8001/pm8001_sas.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -168,7 +168,6 @@ int pm8001_phy_control(struct asd_sas_ph
 	unsigned long flags;
 	pm8001_ha = sas_phy->ha->lldd_ha;
 	phy = &pm8001_ha->phy[phy_id];
-	pm8001_ha->phy[phy_id].enable_completion = &completion;
 	switch (func) {
 	case PHY_FUNC_SET_LINK_RATE:
 		rates = funcdata;
@@ -181,6 +180,7 @@ int pm8001_phy_control(struct asd_sas_ph
 				rates->maximum_linkrate;
 		}
 		if (pm8001_ha->phy[phy_id].phy_state ==  PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -189,6 +189,7 @@ int pm8001_phy_control(struct asd_sas_ph
 		break;
 	case PHY_FUNC_HARD_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}
@@ -197,6 +198,7 @@ int pm8001_phy_control(struct asd_sas_ph
 		break;
 	case PHY_FUNC_LINK_RESET:
 		if (pm8001_ha->phy[phy_id].phy_state == PHY_LINK_DISABLE) {
+			pm8001_ha->phy[phy_id].enable_completion = &completion;
 			PM8001_CHIP_DISP->phy_start_req(pm8001_ha, phy_id);
 			wait_for_completion(&completion);
 		}


