Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD08269801;
	Tue,  8 Apr 2025 11:52:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113140; cv=none; b=TKkP2/bJd+hRfZFKFBYklTYt79+Y2tN0YIBBDoy/43Q7k4ivQwgfoLQZpAeEEghEROlxCfgdp86CgT0O62F0wypkH8qb2UO8IdRkmrPY3I0xKyEW+kafmGTca6LhTLbhUaQXnGMBWLCLkYOpXPGdCOJQqGscI0hPY7wdP1yAjU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113140; c=relaxed/simple;
	bh=SEeJDhlL/GusuHpSzcS5YSvyAsmDeEdN+JEu+AOXaAY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4Rb6w/GFJCvf9Fezn9sbrrmYO4ojGDvVWksO29BC4zZuDlh7KImA4qkvI6rTChKSOV/briHOjIWp+ROv/d7yLdp5fQadPEaa6PyYLZaVowbRfisaIgC663Ym/4XCv0EZUOj/NiSC2Iil2ykJxP/zyZTSOMHKdlJcyya12QugQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RC5ZhBfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RC5ZhBfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C55C4CEE5;
	Tue,  8 Apr 2025 11:52:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113139;
	bh=SEeJDhlL/GusuHpSzcS5YSvyAsmDeEdN+JEu+AOXaAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RC5ZhBfpGSftVnpmmDjvYWAdoAw4DzFT+6qNwKzAhz3WNFARLNimY5dFefiwRsXaX
	 HMnsCnvnC+us1Q+EutJwcsOZAd+yGfwi5bBo1UF4vPwYN8ydd6Pe2f8GAjBMAe13iE
	 g5uIHxUWikScplo+gbyZ/8lB9cnC6uUxXpSVmQmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/268] PCI: brcmstb: Fix potential premature regulator disabling
Date: Tue,  8 Apr 2025 12:47:39 +0200
Message-ID: <20250408104829.797565775@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e39c61e17d86c..44d385f5c27cd 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1156,7 +1156,7 @@ static void brcm_pcie_remove_bus(struct pci_bus *bus)
 	struct subdev_regulators *sr = pcie->sr;
 	struct device *dev = &bus->dev;
 
-	if (!sr)
+	if (!sr || !bus->parent || !pci_is_root_bus(bus->parent))
 		return;
 
 	if (regulator_bulk_disable(sr->num_supplies, sr->supplies))
-- 
2.39.5



