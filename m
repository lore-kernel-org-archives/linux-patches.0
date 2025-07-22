Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD307263D;
	Tue, 22 Jul 2025 13:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192785; cv=none; b=UgKTf18oR9TWdm9IC37xdbdF6uF3SUneShPUZ7+NdIvBU7i/a+ITMQRU3wkGOXvXFgqw2ft8dfGk7D0WEcwUWz3dcqzUC9A3bvcGsYmWravEzW+IwAldiL7eECYgalYS7LbYk+bDW1RKWEuYNLuWSKsBPigKbgXj8n7tX0Id6FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192785; c=relaxed/simple;
	bh=8j2+C6oeXRZcozhj9cQQWVqWV3BXw+BV9dFWLDvj+pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UImKGUr+vyyzdguFt80Uajl7jcEbC4fou0z43DZ3Fwwi5i2fPqKxTMFEXmiXpj4YHmRwLY4nSOyDcER0a8Hsvk3ToV6tUWVgq1sF5tUl5v5eq+h13KB54z7f6JBnaf5tWNB+8yEkL4wngHmEwjjdfeO6bBt1FDBssbtRGL91LXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pzi9qIhw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pzi9qIhw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3107C4CEEB;
	Tue, 22 Jul 2025 13:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192785;
	bh=8j2+C6oeXRZcozhj9cQQWVqWV3BXw+BV9dFWLDvj+pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pzi9qIhw6hTbTblOJUfDqoDZ3tmnZr8rWPLry8IZE2s03xG/3DGLwx21dzVJBC2qh
	 smsmMM4/klRdGGaj5q16vtckLxSKyKFiiHJWAmE3LtIlXg8nv5r0HVsklHXKR4aHc0
	 ujCxYNBeLQsVWYSTm6/vQCSz1X8P7kzO83AsxqvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.12 056/158] mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models
Date: Tue, 22 Jul 2025 15:44:00 +0200
Message-ID: <20250722134342.837611734@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
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

From: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>

commit 50c78f398e92fafa1cbba3469c95fe04b2e4206d upstream.

Disable command queuing on Intel GLK-based Positivo models.

Without this quirk, CQE (Command Queuing Engine) causes instability
or I/O errors during operation. Disabling it ensures stable
operation on affected devices.

Signed-off-by: Edson Juliano Drosdeck <edson.drosdeck@gmail.com>
Fixes: bedf9fc01ff1 ("mmc: sdhci: Workaround broken command queuing on Intel GLK")
Cc: stable@vger.kernel.org
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20250626112442.9791-1-edson.drosdeck@gmail.com
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/host/sdhci-pci-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mmc/host/sdhci-pci-core.c
+++ b/drivers/mmc/host/sdhci-pci-core.c
@@ -912,7 +912,8 @@ static bool glk_broken_cqhci(struct sdhc
 {
 	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_GLK_EMMC &&
 	       (dmi_match(DMI_BIOS_VENDOR, "LENOVO") ||
-		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
+		dmi_match(DMI_SYS_VENDOR, "IRBIS") ||
+		dmi_match(DMI_SYS_VENDOR, "Positivo Tecnologia SA"));
 }
 
 static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)


