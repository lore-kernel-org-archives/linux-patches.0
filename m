Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD7CF26656B;
	Tue,  8 Apr 2025 12:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116259; cv=none; b=TdMxhRYzoWyHUiQnfrPcyYdleEtMs+/WU5HpKeBPvmLDlvK9btXjWo0bHKqMyWdVoqyRdOmHTeVgyfpwwJ2SkBgXN69w87oTwwIF590aN0UUeu2CnFXal5BXcNhCi3CJ613L9Bxz9QPNNEX7ad+glYfRY9j5UrhFX1ag+KaqGlI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116259; c=relaxed/simple;
	bh=r78IIhURiMwWPnxMRMrvtonZ8pMHpizA21GyyEWWPWw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dhLoJ2CKYRM0XLuww4+eRPVu+txBPESTfSEIspfTdlGhCrmGtWyjAcaozsonimir4TPr+nenLkqSOVQN/XHnj8qdFFopnaTw076+oRYIFh9KUf9M9voLcuwV5nZPk/yhNObSlZzwXng5DPCZn9KeD4myXfj+NWLREhIKNlJfC2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTO1NxeR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTO1NxeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3DB6DC4CEE5;
	Tue,  8 Apr 2025 12:44:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116259;
	bh=r78IIhURiMwWPnxMRMrvtonZ8pMHpizA21GyyEWWPWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YTO1NxeRJelNxWnc358nLKznv2Iki3hz3hTuTMUqnSoSXy0+mJJGxXLCApt6lM7ko
	 OeYGIcbos9mpn+irCSAi0SgfMRe3w0IsIoBDqIjnI2c5alnZintwol/YmWdJ7pxFWW
	 5BQ3XWb+Kgjsrs/lx2Xn9XGOkUnF6lG1YcTswjtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 074/423] PCI: brcmstb: Fix error path after a call to regulator_bulk_get()
Date: Tue,  8 Apr 2025 12:46:40 +0200
Message-ID: <20250408104847.470243965@linuxfoundation.org>
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

[ Upstream commit 3651ad5249c51cf7eee078e12612557040a6bdb4 ]

If the regulator_bulk_get() returns an error and no regulators
are created, we need to set their number to zero.

If we don't do this and the PCIe link up fails, a call to the
regulator_bulk_free() will result in a kernel panic.

While at it, print the error value, as we cannot return an error
upwards as the kernel will WARN() on an error from add_bus().

Fixes: 9e6be018b263 ("PCI: brcmstb: Enable child bus device regulators from DT")
Signed-off-by: Jim Quinlan <james.quinlan@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://lore.kernel.org/r/20250214173944.47506-5-james.quinlan@broadcom.com
[kwilczynski: commit log, use comma in the message to match style with
other similar messages]
Signed-off-by: Krzysztof Wilczyński <kwilczynski@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pcie-brcmstb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/pci/controller/pcie-brcmstb.c b/drivers/pci/controller/pcie-brcmstb.c
index 3bb35f096b45b..31778b5a949d7 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1368,7 +1368,8 @@ static int brcm_pcie_add_bus(struct pci_bus *bus)
 
 		ret = regulator_bulk_get(dev, sr->num_supplies, sr->supplies);
 		if (ret) {
-			dev_info(dev, "No regulators for downstream device\n");
+			dev_info(dev, "Did not get regulators, err=%d\n", ret);
+			pcie->sr = NULL;
 			goto no_regulators;
 		}
 
-- 
2.39.5



