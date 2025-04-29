Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6827E24A07D;
	Tue, 29 Apr 2025 17:37:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948279; cv=none; b=toMMdnkTHs0G0X0ClOdaJTpWZVsMkjBuy9oSTbXN0hKkFDBEGbPO+dlTdtBTRKx1Km1m7pkhWPAPWLP3hXsJy/F96+e2evxoFvjlqQwzwPllgVppcQn3p7DBarF9yHJUtEWVMF1rqE1z5moxesHxbuARH9AprAPY8f+9iAEncfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948279; c=relaxed/simple;
	bh=5QUmHhEItUyA3sa+rwI83vHw1DezEn2cdqSgA1tuF6A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WgExOFyG/UaIleuR3UckJVtNqEstrWnZGZQXN2ukRprfARPUq/lQbpP9z791ciiPk1e4DuzN7QCA2jvXWQdZNcnlss7iZ4eVAfBBlY1ryZYwbsouTX0gWBBPeQY2P1b0LrTCZ7Wxy1qkSO6IVEBPJxPskLf+2kNPjCletJYO/zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TCw7fePK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TCw7fePK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B222C4CEEA;
	Tue, 29 Apr 2025 17:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948278;
	bh=5QUmHhEItUyA3sa+rwI83vHw1DezEn2cdqSgA1tuF6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TCw7fePKtTIrW8F+UK0SIAgHLXD5F4BNuuI7YUPUA4c809CHZ8dI/3EVTwmvtT1xM
	 gDetE0uXbTVLvQ2GVTE2Ibu+xknoEIMMw3Adm0I0S28dzPtrgiIaMpZvIzE2fWSney
	 +LS4blBA9lGiFCJUY8LW3sD3zl0MWh1HFZCVS/Kw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Igor Pylypiv <ipylypiv@google.com>,
	Salomon Dushimirimana <salomondush@google.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 233/280] scsi: pm80xx: Set phy_attached to zero when device is gone
Date: Tue, 29 Apr 2025 18:42:54 +0200
Message-ID: <20250429161124.651767590@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ee2da8e49d4cf..a9d6dac413346 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -719,6 +719,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.39.5



