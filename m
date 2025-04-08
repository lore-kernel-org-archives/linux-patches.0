Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F925269817;
	Tue,  8 Apr 2025 11:52:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113137; cv=none; b=AG0cY0tgROBVIBU0TrgUUiSQIoBh4MVLIpJSBkB3+ezTnib2wvSwdlgUZCf9HfTUiv8ixPaB1ivIN22GBDznJTzy+jDahjqx/uUlz8Cd3w1+QPOKt6hHM3iadIraBdGDEY5DMyl1qrS9fit9WRbJ3W/Xe0vZ8Icm2EJO5URE3EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113137; c=relaxed/simple;
	bh=1z0rZhnSs3bx2v4vF+f3sePbCay9IYdYY7Fl08Dip4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PECM4Jrm3CyO5Dvq9V52Xx6x4phTDQKLjLgKGvDF6qe4ypmCtsPsIVX7Z0hRPBeUbXuRZ8AOKmtfWzAw2bBLoYIpyn8kKE4S6vzvbPK3uvSwkgFzs12bNb9WvryCpwlcgJF1Jv5wh0TvPdKI/7Zk0ZwXvpGXy5a8pAl+ak/qaBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JJKHM3c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JJKHM3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A479EC4CEE5;
	Tue,  8 Apr 2025 11:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113137;
	bh=1z0rZhnSs3bx2v4vF+f3sePbCay9IYdYY7Fl08Dip4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JJKHM3cYzmDXFDtXq71cTa+4JymzJFkxx/Bw5I7A12tRlqTOVtx5fZ7h1vViGJYb
	 q1qrVg/raoZYz0Lv5qQDVx2NQp6C5VcNmQgvL/lZWTAmBXZmDQ83q7dB2gV8ZmMmEI
	 SFPc/EweyH0cYTZ1JRwTxe5kWQ1CO24k7+jNLI2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 047/268] PCI: brcmstb: Fix error path after a call to regulator_bulk_get()
Date: Tue,  8 Apr 2025 12:47:38 +0200
Message-ID: <20250408104829.771191033@linuxfoundation.org>
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
index 54c440f09a7ab..e39c61e17d86c 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1132,7 +1132,8 @@ static int brcm_pcie_add_bus(struct pci_bus *bus)
 
 		ret = regulator_bulk_get(dev, sr->num_supplies, sr->supplies);
 		if (ret) {
-			dev_info(dev, "No regulators for downstream device\n");
+			dev_info(dev, "Did not get regulators, err=%d\n", ret);
+			pcie->sr = NULL;
 			goto no_regulators;
 		}
 
-- 
2.39.5



