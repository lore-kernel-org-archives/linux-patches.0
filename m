Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA3C2192EC;
	Mon, 23 Jun 2025 22:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717465; cv=none; b=C6S4Pa16FPm+wMLuKYct/JbxGH92NRzgWwi8plq8Xirw4r0JdL5HH5SzZQeDFFio8HWJcDbD7pv8Hgj86Ctc+DEIk+HNRE2+xGDzsHFSlnN+cYspPQQiRHQh0GMTw6EoZU9KZIziXejOqYa4qmhyBW/FPFZEYOOmz7l9b/YhCTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717465; c=relaxed/simple;
	bh=2RZr4mdnD2x7eRsQjz9Vb0OjynUPiyyVYnIxk/oEkJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gALgC0LWPh/7X9INySNcM+Z27IQN+fQIrWBlBWwGF7Nb+poYPiH8C6Nf1i3rDSM/qaUb7Z8BtpKfZNAyxF5YI4vkGcWOOLaXUXQHpqY0W5fhpCfUBxN38byCmKL8Y28fQDuZNRcDjH5M4dW9N71OWYEx5kLfSJDDlenYmKvqDRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yaZCSndL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yaZCSndL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBBB5C4CEEA;
	Mon, 23 Jun 2025 22:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717465;
	bh=2RZr4mdnD2x7eRsQjz9Vb0OjynUPiyyVYnIxk/oEkJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yaZCSndLei1lJDwqxuMCAK8flGqorrfcthKwafet29y+ZePNqS+3lojdXoM8vvl0z
	 rckoz4SSh6IGTIqEEQFIOcePAYIFZDxKazKJOI0XpuPhOSGSc7oISa9bomSjsqJ8cB
	 qXEPaSj0Nit9MGUNe+I8rOXyhWZxcImUPCXI+pdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 392/414] mlxbf_gige: return EPROBE_DEFER if PHY IRQ is not available
Date: Mon, 23 Jun 2025 15:08:49 +0200
Message-ID: <20250623130651.742126096@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit e7ea5f5b1858ddb96b152584d5fe06e6fc623e89 ]

The message "Error getting PHY irq. Use polling instead"
is emitted when the mlxbf_gige driver is loaded by the
kernel before the associated gpio-mlxbf driver, and thus
the call to get the PHY IRQ fails since it is not yet
available. The driver probe() must return -EPROBE_DEFER
if acpi_dev_gpio_irq_get_by() returns the same.

Fixes: 6c2a6ddca763 ("net: mellanox: mlxbf_gige: Replace non-standard interrupt handling")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250618135902.346-1-davthompson@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 385a56ac73481..c82254a8ae661 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -447,8 +447,10 @@ static int mlxbf_gige_probe(struct platform_device *pdev)
 	priv->llu_plu_irq = platform_get_irq(pdev, MLXBF_GIGE_LLU_PLU_INTR_IDX);
 
 	phy_irq = acpi_dev_gpio_irq_get_by(ACPI_COMPANION(&pdev->dev), "phy", 0);
-	if (phy_irq < 0) {
-		dev_err(&pdev->dev, "Error getting PHY irq. Use polling instead");
+	if (phy_irq == -EPROBE_DEFER) {
+		err = -EPROBE_DEFER;
+		goto out;
+	} else if (phy_irq < 0) {
 		phy_irq = PHY_POLL;
 	}
 
-- 
2.39.5



