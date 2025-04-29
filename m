Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12608127E18;
	Tue, 29 Apr 2025 17:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946461; cv=none; b=d1sjekUQtoe23ngpBPnhSUhC6NS6heFf2aSHZAmsRx82TTt5Y6IJhlIbRm7WaUqoMt0Mk5al6ww8zVpRx7UY0or5lmRyPEilkRE/YB9c1JXreehCGPDZYbClUGaQhnSOP9Wj0lTgQDlF3+0E3NYi5f1zOoPxGMGD15rL0XuqlsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946461; c=relaxed/simple;
	bh=gUfbvzS7zJN8W8Xka1qcj4VIkgzctKN4m+punp1aIok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KRyMXi5QX5QZVK+kM70Z0kr6EMwJiJzYBTWruF9WWZp9BBnSFMrFErZnMKnHyCV/eSsBl4gB8dJPNoVAVaN+5JsI9G1X+e30niPquSpjEkC8S+KMyKp6MhFt9FuWGwKxxBqmORRBU6IGUPNNHtnJyxjK6rPemBhSKjNfBgQkdmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2R6hr6v1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2R6hr6v1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F59C4CEE3;
	Tue, 29 Apr 2025 17:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946460;
	bh=gUfbvzS7zJN8W8Xka1qcj4VIkgzctKN4m+punp1aIok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2R6hr6v1JAuhvJi3+vuxr0WWrTqwsgxiu7N0BnW6IEvVJsq0DKjCV40x2Y3OCeGnT
	 +ZAvaQgHBwJ+zreOc+gKR2ZogyCEKz92bWl1v+QkB5UQ3uzdR7c1i9klJmMhX8oS1W
	 xkz30/aX1zOHVKDiKcmw3RzDNLrcHVJkjmXr+sb8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 274/311] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Tue, 29 Apr 2025 18:41:51 +0200
Message-ID: <20250429161132.244255361@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 183ce00aa671e..f7067878b34f3 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -766,6 +766,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5



