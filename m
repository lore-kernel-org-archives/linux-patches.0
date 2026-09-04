Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42263B42F7;
	Fri,  4 Sep 2026 06:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502668; cv=none; b=p+7kvcP5UpTcCcHhYpuGN1e2yxan9Ka+d436oGvfwlXaywFXPMy9boyj8jFo/CPHJ16bGvfSA8Iltvd9MQMF2GiFb8kY4XkqGaJuTo6IsOTmepyeuK9RJbuWIZtZR0dpBTI0k0d4RNpHZuD6Y5w2YcD/GBFzA68SKPb49kZPsvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502668; c=relaxed/simple;
	bh=1ooHKTz6ZH6moN34VGNQd/T+qEH+XCV30r22EJGu27U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E8e7YPe311CE1tUNAe+IBHyaHl0YVK3Rx+8xvmir80+Gi1J7EMg+8bZodXNFw7FrkJIaY84zNqVmMSxGs4blCSQ0ZrQgtjoBLD1wTrGivIefghdEHhjWKHA2wHaGIg1opiZx5WabT9Tic2OF4jdMCTXb0soRI1iO3XB49ETsJMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bOojotYw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bOojotYw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1923A1F00A3D;
	Fri,  4 Sep 2026 06:17:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502667;
	bh=GGw4uCO8CSn9l8rtuUHiDcq65D+tXGq1rl8tec9z9GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bOojotYwkr54MF60StI0Hwquw+pUpt4l9BlL21X3RJmH82UlGvI4hcJ7PgOq4yKP6
	 LtiQbMB9OGdp2+KenlnJipqJpJbTRPIO9trsgwxC7RcsCGBQY1Z2eFQX3YmgxEBRFk
	 nMssxATnb5ve5SJuTnpFg1C3WMnIcbX2sT1Tzk8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.12 289/403] PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk
Date: Fri,  4 Sep 2026 07:01:32 +0200
Message-ID: <20260904045741.422863683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5325,7 +5325,7 @@ static void pci_quirk_enable_intel_rp_mp
 	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
 		pci_info(dev, "Enabling MPC IRBNCE\n");
 		mpc |= INTEL_MPC_REG_IRBNCE;
-		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+		pci_write_config_dword(dev, INTEL_MPC_REG, mpc);
 	}
 }
 


