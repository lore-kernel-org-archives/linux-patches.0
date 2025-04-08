Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF25622488E;
	Tue,  8 Apr 2025 12:35:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115717; cv=none; b=o6JQzjrGkSAzgrCFOnPP2LCqatA3vS1YBpp5QTs1qb9Ak4atPnM0PwKJH0LULvQZbMc2hlzdZFVJ+ULENCmlEeNNe/pgYEJ6wADS6P5x+aZlf1r4O/uRYQl+ZZDRf1KLu37vjO/xViiuX0W9Dx9zsR0JsXBWjnp2eWzGYViENtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115717; c=relaxed/simple;
	bh=Pl9FZrBq7pYelHuuyrC5Mm31QYD0vnWZUb5Q0MpUWQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LOnAFpS7MLB2IwSkFGeGJF6UikhyKYrsNOtXwTVXmi2WAmY4h8SLr+T4LFGKbi6MKkuEFqmg9kZOVY/JBqxh39J2EWoScP9jGGo0pg3G26TpA6fXPT2NRGFHirCFiWy+nU6XdqJEsU/BejvUGolfSJ8Z1wvfcfK5yKjK8jV8i/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wIbn1uFQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wIbn1uFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D6C2C4CEE5;
	Tue,  8 Apr 2025 12:35:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115717;
	bh=Pl9FZrBq7pYelHuuyrC5Mm31QYD0vnWZUb5Q0MpUWQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wIbn1uFQwf2royjRjJAzrYQ5bHFrhiGjfX14p9B3iq2+HlZHp8h//Hx1yCeUKZRBm
	 agkq3XogsNImBSSgqqQjgO3S6dUEu4WhObbP0kT+IWuEk2GSW8hVGQr/hRw1C+jgNi
	 bCGxntftE8HYR1ZPmBZTCkjEHQFTT7NhT7xH5w50=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Quinlan <james.quinlan@broadcom.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/204] PCI: brcmstb: Fix error path after a call to regulator_bulk_get()
Date: Tue,  8 Apr 2025 12:49:29 +0200
Message-ID: <20250408104821.491589564@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index feb825326d596..016ea0e79c3ad 100644
--- a/drivers/pci/controller/pcie-brcmstb.c
+++ b/drivers/pci/controller/pcie-brcmstb.c
@@ -1117,7 +1117,8 @@ static int brcm_pcie_add_bus(struct pci_bus *bus)
 
 		ret = regulator_bulk_get(dev, sr->num_supplies, sr->supplies);
 		if (ret) {
-			dev_info(dev, "No regulators for downstream device\n");
+			dev_info(dev, "Did not get regulators, err=%d\n", ret);
+			pcie->sr = NULL;
 			goto no_regulators;
 		}
 
-- 
2.39.5



