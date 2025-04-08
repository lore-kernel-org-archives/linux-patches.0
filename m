Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6D126656B;
	Tue,  8 Apr 2025 12:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116262; cv=none; b=lkjnU60nlpGVKyZLBGeRKM5L0Eq5z3Xi8+l1/0jIxY0iVyruTigfvb+56rEpNyNoH5C5JM/YQa+Ny7Wfk+zKPWaHqicuRob9DS3FemhEXfMTgYc3A8dN6dw+689JUhNpcvaosCSrKoKsReFCqpH2HGeMLYxcGcRv2fyApZVMUuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116262; c=relaxed/simple;
	bh=aFRWLCLj6OUs0W48nutSVSfbaqNP6WjX+deLg3mnbJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kNYCPhActyalgA8cDqEktBK4ZqFLWfAdYssl4LPDAgjpsQaRTZZzUshM7bUYkev2D5FCw/7ViYt9JvazuCe8G6T3TN+qiCDelF8o+z0er6geQtZcNQuigryo7YyGB2l296Y+sJtVhZPOWM3ZEL/rf51i7lLN3WqyDiSY2d0y9Mo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=y3oJJ1mU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="y3oJJ1mU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F37C4CEE5;
	Tue,  8 Apr 2025 12:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116262;
	bh=aFRWLCLj6OUs0W48nutSVSfbaqNP6WjX+deLg3mnbJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y3oJJ1mUGvanUqLf2mGggLsjYMOVMBG6RYJD0g8zigZhkHzQC6USYI0Z0PKuhBRJo
	 9dmAYU1t1ulB1qSkw2Yt8c185BcTa3j6zuNcSuRzmMdLNPl3Q/KWM4VGUfIuF/qVxw
	 d3a4PIo2LpF9FTumJqFkwgC4HeIQCo4cI+kKRyZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 075/423] PCI: brcmstb: Fix potential premature regulator disabling
Date: Tue,  8 Apr 2025 12:46:41 +0200
Message-ID: <20250408104847.492394981@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jim Quinlan <james.quinlan@broadcom.com>

[ Upstream commit b7de1b60ecab2f7b6f05d8116e93228a0bbb8563 ]

The platform supports enabling and disabling regulators only on
ports below the Root Complex.

Thus, we need to verify this both when adding and removing the bus,
otherwise regulators may be disabled prematurely when a bus further
down the topology is removed.

Fixes: 9e6be018b263 ("PCI: brcmstb: Enable child bus device regulators from DT")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20250214173944.47506-6-james.quinlan@broadcom.com
[kwilczynski: commit log]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 31778b5a949d7..582fa11070878 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1392,7 +1392,7 @@ static void brcm_pcie_remove_bus(struct pci_bus *bus)
 	struct subdev_regulators *sr = pcie->sr;
 	struct device *dev = &bus->dev;
 
-	if (!sr)
+	if (!sr || !bus->parent || !pci_is_root_bus(bus->parent))
 		return;
 
 	if (regulator_bulk_disable(sr->num_supplies, sr->supplies))
-- 
2.39.5



