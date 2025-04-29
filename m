Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCA9215060;
	Tue, 29 Apr 2025 16:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945622; cv=none; b=Yc7Yp5xpBZxrONlXZsBd3Ywl8SVfDtxmgTLlEtFRWYrNlvaq2UzBdDRugAWszNQ9aygTt/JuCtoeVAAwDZa7vSzNQkUKhAn9e378coLpxMSKlVM4UyOomaDwMYLgq3ek4P16kefab/PWd7O6OY7DDx+5psBEK5OPLRi6ePvRYxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945622; c=relaxed/simple;
	bh=xCe8ujLChza/mR+vNxEDMa/LEYEnPJrEuAj1EJKjRUs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fVZqxUEfmjr/MEt0SyDOGqWFY2wsqFEER8ZgpGYHaRm7t7pQfBQ6Ew5S2mZg0JRtPl+/Qn6LEG1q0JJZTufJ9kQn9wbwtN0XyXI+CSpkiRjTU2nACT4D9WPzRqeWenAFJakfD3dpdrlus/6FrDupgsM5pw1mAeVTks1h8vU7YUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SIPuU56x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SIPuU56x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10C7AC4CEE3;
	Tue, 29 Apr 2025 16:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945622;
	bh=xCe8ujLChza/mR+vNxEDMa/LEYEnPJrEuAj1EJKjRUs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SIPuU56xn9T5rspsTJU1A3kq4xprOKsteAXCTI9OkfjIDRZF5wmetk+Ql1xd/UVDD
	 DVC/tEezlg9YITHB1yJ0983Erq7rfB6i672uwprkDhIKj9jmGZ3BcIflKPybiOPDL4
	 AVV3waBEgLbcUXV9IwLMWknOI+N8VEiu2+eAVH1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/179] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Tue, 29 Apr 2025 18:41:55 +0200
Message-ID: <20250429161056.434127842@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 36f5bab09f73e..1215fc36862da 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -893,6 +893,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		PM8001_DISC_DBG(pm8001_ha,
-- 
2.39.5



