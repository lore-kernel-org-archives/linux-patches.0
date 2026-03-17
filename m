Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B91E03F54B8;
	Tue, 17 Mar 2026 16:49:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766158; cv=none; b=lZhKNy7ciCsea3MwjSIw2UiFvqw/nQ7Y8/FHzWCelu6FV5K45N3qoOaNmeCaMC1zVTCpo9G/SHKrGEREUg9orBFV0u09R+vA4l+ERJhjvbb4wVKoAFGPj5Tg7lhoYITSLq6ozUXilSuPoWf99xcBoNQ6ISovmhuw/UpJIopiang=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766158; c=relaxed/simple;
	bh=gH//UTdT/Z3znrzG1GRKMou9voVaAQFsgSjicI3Idrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8RO6G8HYdS9s1783z10Km5SDRhfH8uQsotjMz6EZZ2xQp5POHBdUXyd6B3nPO48KL7NQTVsKntE0egU+oC7If4yCyEOJ3yyqDgXX780+OLxwvC8XYqRqY3jPYSRFNDsmWqoTrqqaTc5z/dWTsWeX+7dTZ1Xq3A+hmGUeWHW+go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DRiksygz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DRiksygz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF147C4CEF7;
	Tue, 17 Mar 2026 16:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766158;
	bh=gH//UTdT/Z3znrzG1GRKMou9voVaAQFsgSjicI3Idrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DRiksygzJp+fj6qf9kXlvaFeCnins8K9pKnPMHBXFvQt74+S9h+w+ew0AwGwHgx9f
	 MSQuW/A1U3XrGHDq+OSHZVpBK9nCb/7iZg1jBTDSSPLyOsG9/JRUdFG/7/nqTXAhUn
	 ciwuHKuoimdA0nYR7gl8OAIMPba+H75xoSaJ6I70=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jessica Liu <liu.xuemei1@zte.com.cn>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 182/378] irqchip/riscv-aplic: Do not clear ACPI dependencies on probe failure
Date: Tue, 17 Mar 2026 17:32:19 +0100
Message-ID: <20260317163013.703577492@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jessica Liu <liu.xuemei1@zte.com.cn>

[ Upstream commit 620b6ded72a7f0f77be6ec44d0462bb85729ab7a ]

aplic_probe() calls acpi_dev_clear_dependencies() unconditionally at the
end, even when the preceding setup (MSI or direct mode) has failed. This is
incorrect because if the device failed to probe, it should not be
considered as active and should not clear dependencies for other devices
waiting on it.

Fix this by returning immediately when the setup fails, skipping the ACPI
dependency cleanup. Also, explicitly return 0 on success instead of relying
on the value of 'rc' to make the success path clear.

Fixes: 5122e380c23b ("irqchip/riscv-aplic: Add ACPI support")
Signed-off-by: Jessica Liu <liu.xuemei1@zte.com.cn>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://patch.msgid.link/20260310141600411Fu8H8-GXOOgKISU48Tjgx@zte.com.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-aplic-main.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-aplic-main.c b/drivers/irqchip/irq-riscv-aplic-main.c
index 4495ca26abf57..8775f188ea4fc 100644
--- a/drivers/irqchip/irq-riscv-aplic-main.c
+++ b/drivers/irqchip/irq-riscv-aplic-main.c
@@ -372,18 +372,21 @@ static int aplic_probe(struct platform_device *pdev)
 		rc = aplic_msi_setup(dev, regs);
 	else
 		rc = aplic_direct_setup(dev, regs);
-	if (rc)
+
+	if (rc) {
 		dev_err_probe(dev, rc, "failed to setup APLIC in %s mode\n",
 			      msi_mode ? "MSI" : "direct");
-	else
-		register_syscore(&aplic_syscore);
+		return rc;
+	}
+
+	register_syscore(&aplic_syscore);
 
 #ifdef CONFIG_ACPI
 	if (!acpi_disabled)
 		acpi_dev_clear_dependencies(ACPI_COMPANION(dev));
 #endif
 
-	return rc;
+	return 0;
 }
 
 static const struct of_device_id aplic_match[] = {
-- 
2.51.0



