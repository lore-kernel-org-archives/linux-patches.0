Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC7192C2365;
	Mon, 13 Oct 2025 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369500; cv=none; b=hKwZIT04HkZvSTEt8q/MycjO3Hl3oOa1bYmmtrP2ZI6Wo1RVB/s6qbRrlV/5XNkBFJI63dvzu4iqAnlHxGahVcPidar9GtNLysYmSSP5eawt1FiNNy7ZIpAxHiZo7hhsQ3jrNtNLzR0XY7jM5Otvjg5BpySGNoOkdDJHUH4anzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369500; c=relaxed/simple;
	bh=5bLcnJf6Vj+XTGSOocszFrTN3/Py8uYUYvJje7HHGVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rbs5xJqShykHa/exjTUDrrkb5cBoyME96f0SrBxF0GQ4fhJ6tuH4BoErlAHm2hYKPNtzFgO4cUwxAD6D/zzkvT8SM30T9Msh/KlVSdYpPp0/y+h/HGocmP27a1Sx6lhclp94yzHseuk4RUrJ1oJs8c4+HWwsBqEU+YuQ4dUnbi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw3fnYCv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw3fnYCv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 496D6C4CEE7;
	Mon, 13 Oct 2025 15:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369500;
	bh=5bLcnJf6Vj+XTGSOocszFrTN3/Py8uYUYvJje7HHGVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw3fnYCvX3rS7/ldDj2eickPEPE/ZvWLhAk3V+3OVpvzuRu/wclN0zryVGjQn11DP
	 0Sqs8Mr6HtB+VxfFeSq9Mol50icfvpJYr15/QGEDkIkrngU442cdmyoB7DgPw5Hvv3
	 FkbqLmjlvoyj9nT/ToleyI4lxICzf6z7We+wo9bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 236/563] PCI/pwrctrl: Fix double cleanup on devm_add_action_or_reset() failure
Date: Mon, 13 Oct 2025 16:41:37 +0200
Message-ID: <20251013144419.834806616@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ab81f2f79c683c94bac622aafafbe8232e547159 ]

When devm_add_action_or_reset() fails, it calls the passed cleanup
function.  Hence the caller must not repeat that cleanup.

Replace the "goto err_regulator_free" by the actual freeing, as there
will never be a need again for a second user of this label.

Fixes: 75996c92f4de309f ("PCI/pwrctrl: Add pwrctrl driver for PCI slots")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Tested-by: Marek Vasut <marek.vasut+renesas@mailbox.org> # V4H Sparrow Hawk
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Reviewed-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Acked-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Link: https://patch.msgid.link/7b1386e6162e70e6d631c87f6323d2ab971bc1c5.1755100324.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pwrctrl/slot.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/pci/pwrctrl/slot.c b/drivers/pci/pwrctrl/slot.c
index 6e138310b45b9..3320494b62d89 100644
--- a/drivers/pci/pwrctrl/slot.c
+++ b/drivers/pci/pwrctrl/slot.c
@@ -49,13 +49,14 @@ static int pci_pwrctrl_slot_probe(struct platform_device *pdev)
 	ret = regulator_bulk_enable(slot->num_supplies, slot->supplies);
 	if (ret < 0) {
 		dev_err_probe(dev, ret, "Failed to enable slot regulators\n");
-		goto err_regulator_free;
+		regulator_bulk_free(slot->num_supplies, slot->supplies);
+		return ret;
 	}
 
 	ret = devm_add_action_or_reset(dev, devm_pci_pwrctrl_slot_power_off,
 				       slot);
 	if (ret)
-		goto err_regulator_disable;
+		return ret;
 
 	clk = devm_clk_get_optional_enabled(dev, NULL);
 	if (IS_ERR(clk)) {
@@ -70,13 +71,6 @@ static int pci_pwrctrl_slot_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, ret, "Failed to register pwrctrl driver\n");
 
 	return 0;
-
-err_regulator_disable:
-	regulator_bulk_disable(slot->num_supplies, slot->supplies);
-err_regulator_free:
-	regulator_bulk_free(slot->num_supplies, slot->supplies);
-
-	return ret;
 }
 
 static const struct of_device_id pci_pwrctrl_slot_of_match[] = {
-- 
2.51.0



