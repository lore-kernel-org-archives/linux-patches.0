Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 700EC224F6;
	Tue,  8 Apr 2025 11:18:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744111097; cv=none; b=eCGxWUt2bLHGiUmfhnXfSQf6o5LAO8IszJ0ttYUCDx5zCiCxkSxRJWZhTLnVnIQ8yufk02Q/VL4/RBfoYHCzCoflNlY2lFymbKZDvOq/RDijza9e8sQLEt44yXWMaDsdwdzRdQDDmDFCg79CzH9b20EUUgX+cJrc3a6Fcs0RsKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744111097; c=relaxed/simple;
	bh=5lwqtocACR1gOzM5Ab1io7mZUIdjYKPLY4eossYfSMc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9/LqfmM/TR0nBWVcNNLAVtO4qk/6pZwMRW/LGsShZVpFBTVXGxG6R0AzzcN6b+kOMA+ebituY/d6EAt7SxfYClSfzzHYYHsVQiptJQ2nA96e3Eb8cz55mzpAT+BYRxGxAbqwttbcnMyrX4kjqzARflRV1CVn0OhbBHFOiQ5IW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bbm5dcue; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bbm5dcue"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40D6C4CEE5;
	Tue,  8 Apr 2025 11:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744111097;
	bh=5lwqtocACR1gOzM5Ab1io7mZUIdjYKPLY4eossYfSMc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bbm5dcuezTlsQh4LZ8mppwdisucnRjvzNjQd1J7Z2kzJ9+rZ8tNOOUxFV0FdFTWmM
	 ZAfYI4X+XaWZSvKW5KF5lrxA/230SGlyB+il2qAOGGQJzP502Mm+1udCYa5fKJhRgh
	 L0Vg99uUTltqmb+GUvMfAmOoxVzWlwUVfIshQGj4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 308/731] PCI: brcmstb: Fix error path after a call to regulator_bulk_get()
Date: Tue,  8 Apr 2025 12:43:25 +0200
Message-ID: <20250408104921.441448245@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 8b728c0f7f421..1495d770b4c2c 100644
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



