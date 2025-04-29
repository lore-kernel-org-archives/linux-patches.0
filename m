Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A7A40C03;
	Tue, 29 Apr 2025 18:07:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950056; cv=none; b=ZKgFL8am4pktC3z8VULpghrY0ES7UlizCxpCx3givCQ/UKjadCpfGX5srS3Y5NYnyBe68RPSsqDeIKcD5pdHq9tnyU0nmJA8oXZmfQEDhcIiHygVLrta99btqp38bku3Ks77nyCcCayjt198MW1LI87ZooADV1TnUBo4OrYoe3k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950056; c=relaxed/simple;
	bh=twAfeZUaP2agdJqFkCSe7i4Kqe7Fzfp1j1ACQF2xrjs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eWn80HPwS/TV+U7VDtk076un/BHlYGjgCukIiZG/ZFkPilj999/awCui/jsnsPkvPN/e2BlH6zCjpjJUIKHwLmdK3nh4GoQTJhr81PK4+8wC/LjXo8/ZzprUIxFtVGPxxBnPghFIkaedjt2qz/BBM4DT3xvvjKKrgc/asnrOxwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c1dUOM1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c1dUOM1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84781C4CEE3;
	Tue, 29 Apr 2025 18:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950056;
	bh=twAfeZUaP2agdJqFkCSe7i4Kqe7Fzfp1j1ACQF2xrjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c1dUOM1o9UpqPu9xzuUe8oQtZSy1hcYWfD29jMifSqezY9IFrBwi05qAFQQrBM5AA
	 njfNb67cAnVx4M9GGR8K6duH0FJEoIfWOMWdnzuEGYRp6WcdfpS257kPAk5RFwCKoG
	 yd6Mo3+qoPduR9ugGtKDCJVhd+zsGgbuqyv45FgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/167] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Tue, 29 Apr 2025 18:44:10 +0200
Message-ID: <20250429161057.474863330@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
User-Agent: quilt/0.68
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

[ Upstream commit f7b705c238d1483f0a766e2b20010f176e5c0fb7 ]

When a fatal error occurs, a phy down event may not be received to set
phy->phy_attached to zero.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Salomon Dushimirimana <salomondush@google.com>
Link: https://lore.kernel.org/r/20250319230305.3172920-1-salomondush@google.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 8e3f2f9ddaacd..a87c3d7e3e5ca 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -720,6 +720,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5



