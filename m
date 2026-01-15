Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226662C0F83;
	Thu, 15 Jan 2026 17:43:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499013; cv=none; b=lHIviWiHGepB7GYG4GQkLSyiVgbq40zUAoCfbwvIZ+fR5VjuQv95PaVSUgl4IHRPb9URy3Uhq4aIn1hGtRYR33hEnVVK5798G/cYw4P5/FfDsSrtQ9XUao6uqPcK6usYmdbOReCmDoSF1gbkdKIWXqlc9fqZuhmjWBhhYu2uO7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499013; c=relaxed/simple;
	bh=5chU0IIhOjVS7zeGlAFJfJAN5u8X6tUlLMvQca7VuyY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2FjV7I84IqINSJyNOqFTl4mJW0XY0Ay8/UGj2xaWT0k8go2l9H3/1NZMTgMWfsmb6UY2NPAeM/PoZTgpLj9UXSrBDckI0aV6TgJcobTAnxQISYkIongpS0H+V105NveWwqmvOjHWGg/03WMprVV8tI8A7D0Gm9/X93bHFpUFcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcyXGEZ6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcyXGEZ6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23E7C116D0;
	Thu, 15 Jan 2026 17:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499013;
	bh=5chU0IIhOjVS7zeGlAFJfJAN5u8X6tUlLMvQca7VuyY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcyXGEZ64xOuDhZDP2W7gXJmQ6Y/Ckxo0ehhO4y89Gea64znTRHkWymx1qZVX/VtZ
	 nDlSexuFr43489GqeX3onYhizD21zdnJ9oLUhS7T4oEn4p1znsBIhL+SsPbxfsbxvl
	 brLMSJev+VEStV/1xp+XRIKgdXBwfHho+XS4wsjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 077/451] PCI: keystone: Exit ks_pcie_probe() for invalid mode
Date: Thu, 15 Jan 2026 17:44:38 +0100
Message-ID: <20260115164233.699696014@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 95d9c3f0e4546eaec0977f3b387549a8463cd49f ]

Commit under Fixes introduced support for PCIe EP mode on AM654x platforms.
When the mode happens to be either "DW_PCIE_RC_TYPE" or "DW_PCIE_EP_TYPE",
the PCIe Controller is configured accordingly. However, when the mode is
neither of them, an error message is displayed, but the driver probe
succeeds. Since this "invalid" mode is not associated with a functional
PCIe Controller, the probe should fail.

Fix the behavior by exiting "ks_pcie_probe()" with the return value of
"-EINVAL" in addition to displaying the existing error message when the
mode is invalid.

Fixes: 23284ad677a9 ("PCI: keystone: Add support for PCIe EP in AM654x Platforms")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20251029080547.1253757-4-s-vadapalli@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/dwc/pci-keystone.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/pci/controller/dwc/pci-keystone.c b/drivers/pci/controller/dwc/pci-keystone.c
index 6245c179ce49f..6844c4652e702 100644
--- a/drivers/pci/controller/dwc/pci-keystone.c
+++ b/drivers/pci/controller/dwc/pci-keystone.c
@@ -1382,6 +1382,8 @@ static int ks_pcie_probe(struct platform_device *pdev)
 		break;
 	default:
 		dev_err(dev, "INVALID device type %d\n", mode);
+		ret = -EINVAL;
+		goto err_get_sync;
 	}
 
 	ks_pcie_enable_error_irq(ks_pcie);
-- 
2.51.0



