Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1499224AE6;
	Tue, 29 Apr 2025 17:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947419; cv=none; b=hnsGcyM33qqeGXeCyOyN1AbYEzPO+kgq7Cz2n8vh4B8zwnjuVUTpqdm9YDFDyXLFhuf44PWzJue1yPoymF37cYgsiqBBq1TCXsTbacFdPZvMVV+k1+20W60MsjSxo+jNs2Xh9Hvq2uXNb8xz6nBX/KR+eQ2K+cEo9VbJLbFdjdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947419; c=relaxed/simple;
	bh=Sd2jqNNkeZyAAqDx8XGJL9veqSSFp9PBieXNnvZsDQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1HtkjIRgb5HVZw+osRA1RLMEB7IRf+mTfRwBpCJ1vcm1tpiKX5LuSRr2X7Yzz2qh30791gEKO4NmbDCFhl1KrZ19VR2olpNz3ZszwgssXhLsvl5Ex/ERAvFqdAeHVd9DKbhvu4HyQNyMeu2qHpVXdZxu8y+4s4ZXWYGSidUpfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQiC9ez0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQiC9ez0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 022A4C4CEF5;
	Tue, 29 Apr 2025 17:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947419;
	bh=Sd2jqNNkeZyAAqDx8XGJL9veqSSFp9PBieXNnvZsDQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQiC9ez0RvupBEgLIyEuuuKYxy898D6NlM98vhAiOvqdRDDSl4YhjPbcqHB2hFyzp
	 laGlosS23XIE6jNC49axgkkykYiUQtdiDnBgUJG+7gck//tzezVXcoSNkBcbZfk97r
	 saIuJliZXiCEuUeKN7xa4GCnSrIqZS7luA52JtGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 275/286] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Tue, 29 Apr 2025 18:42:59 +0200
Message-ID: <20250429161119.230264853@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a16ed0695f1ae..3244f30dffec2 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -892,6 +892,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5



