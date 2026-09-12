Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1683532D7F8;
	Sat, 12 Sep 2026 18:16:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789236967; cv=none; b=HuluXllilPDaLAJzEQtOYuH0aeB6ESxw6XtaaxIaA7dcYX0U0oe2TNJy6NHjYt5tEDqkipYwN0uIBEDXNijTSYffq+cMZjFL7iG+nSYWoeJP+NwsNYpEZv8hVKT1N1YiXSZa0dPrT9ttZdNQYnqCBV38hORTg7E+I1M0MSCjnaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789236967; c=relaxed/simple;
	bh=iYlV5wTAjMs3k1tGiE0VqPJcKu8biY4XIG5dRVUIj/4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FpW0fqedWbiVHN9bbkyA3I0G2zOfFMR9S33YNmjAapeqtFJsntCYRYzNVNTrCjGn1iQMFiPqqaxxxKOC1t5rT5RFzPd+YnUQJHTLlgpeRMa5AyLd84OmpeqYq4wNVoT4tGVVeDyH4MkiS5/qvjQaU1oF1tvNfNCITteOmK4vFE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Jnfubdm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Jnfubdm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC9F1F000FF;
	Sat, 12 Sep 2026 18:16:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789236965;
	bh=cwYbxW8EdvDA013BVlQSroIkhc2cmFF0ye7sMVJumkw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1JnfubdmD2Yeg0/qfK7tZuk/9JuANpyCokMG7I87KPIlPtqTOt10b9XP2vSJflHp9
	 1qvulGTk5huPKfLXwqEPkZt0+20DqFoT18ZlXdW3GH15QPXoh+dICaW/NA+4aUeMhT
	 rV6b7XNIwvJw0yNAMmyYfZumM3UOgwGlf4FuQWwM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 5.15 161/935] PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk
Date: Sat, 12 Sep 2026 08:53:11 +0200
Message-ID: <20260912065530.513897485@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>

commit 23d7eed5974989de56273c964d7e510e4aad91e8 upstream.

pci_quirk_enable_intel_rp_mpc_acs() reads a 32-bit DWORD from the MPC
register, sets bit 26 (INTEL_MPC_REG_IRBNCE), but it writes it back using
pci_write_config_word().

Because bit 26 resides in the upper 16 bits of the 32-bit register, a
16-bit write drops the newly set bit. The quirk logs that it is enabling
IRBNCE, but the hardware never actually receives the command.

Use pci_write_config_dword() to ensure the full 32-bit value is written
back to the hardware.

Fixes: d99321b63b1f ("PCI: Enable quirks for PCIe ACS on Intel PCH root ports")
Signed-off-by: Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260723171203.4892-1-raizudeen.kerneldev@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5195,7 +5195,7 @@ static void pci_quirk_enable_intel_rp_mp
 	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
 		pci_info(dev, "Enabling MPC IRBNCE\n");
 		mpc |= INTEL_MPC_REG_IRBNCE;
-		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+		pci_write_config_dword(dev, INTEL_MPC_REG, mpc);
 	}
 }
 


