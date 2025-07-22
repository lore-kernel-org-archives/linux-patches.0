Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66FE52D59E8;
	Tue, 22 Jul 2025 14:09:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753193359; cv=none; b=T6rBTrjn7l3qjm711MuEviUtrZrFlSoTCKk343Zx5cai7hycEiujytaSloh7gm6B08Me5alREnLqQEkVOHNjS1L+PbZWaeIhZd8+gTmxUw5lCo3dhAute0sP0CWLfLDciVNBHOHjfgS5RAzQWGUudCphngIOyPhQQavDTrJfseg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753193359; c=relaxed/simple;
	bh=xhZp0wj4bHPbcmqSHodW6b+Llp0KKh/zckF4RqNYsuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eUzxkBqZssfdIk6W4wCy4Qq2uPrVqlZedU1aCQ8XiqeT/JAIjnrgtjXLj/YoiMAAOlYqDrDdntHgqVC4zEWC7CNyec8akyyfWoa+XSGgSYsZ1PqHCsFIGZq9+z/bXOPULiVIzzqMZBJ6UJT0VQfKy3RGDRGGTJMC+6FS7N0BB8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zfv+Q8Qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zfv+Q8Qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E087DC4CEEB;
	Tue, 22 Jul 2025 14:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753193359;
	bh=xhZp0wj4bHPbcmqSHodW6b+Llp0KKh/zckF4RqNYsuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zfv+Q8QpX/P3oUv4T6MIWbXQzc7XZnZcqWlBIwJH/znJeZ2nIp3RHAuq787Y8C8aW
	 6sadGjUU+j5dGLFbDIad3YxiXckE663ud/qccOGGbq24624pjZOcQM3cLxvgy2AZSw
	 TbDwQeJvQ58zsAETD2s87VS/NqebaKXFVKqhYmZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Edson Juliano Drosdeck <edson.drosdeck@gmail.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.15 066/187] mmc: sdhci-pci: Quirk for broken command queuing on Intel GLK-based Positivo models
Date: Tue, 22 Jul 2025 15:43:56 +0200
Message-ID: <20250722134348.204608316@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
References: <20250722134345.761035548@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -913,7 +913,8 @@ static bool glk_broken_cqhci(struct sdhc
 {
 	return slot->chip->pdev->device == PCI_DEVICE_ID_INTEL_GLK_EMMC &&
 	       (dmi_match(DMI_BIOS_VENDOR, "LENOVO") ||
-		dmi_match(DMI_SYS_VENDOR, "IRBIS"));
+		dmi_match(DMI_SYS_VENDOR, "IRBIS") ||
+		dmi_match(DMI_SYS_VENDOR, "Positivo Tecnologia SA"));
 }
 
 static bool jsl_broken_hs400es(struct sdhci_pci_slot *slot)


