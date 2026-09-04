Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78A903E866B;
	Fri,  4 Sep 2026 05:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501380; cv=none; b=ljTYhyC0hjdM+2cQZ12aqDel3rz8VTb/joYOnMfp+UBqJId3aE8+9pbhku8bpElXqnT2V7ykDlc9PmnLivLEkY2TvVsd5VP1VH3cfU2z64qJt1j/9Vk2OlQsMuEp2FJLavoQVZGefg90qhAvabjOzgO86jjBC9ToCKaTbJldcII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501380; c=relaxed/simple;
	bh=5h4WZZFort5AA9liGcMQAIKLYqoMPWCZLXh60CzPOlk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YBPwW8f1vrgQOVG4a5VGRvnWJjrbtzFrkU8B7IYJNf7ZMINXjlvR0VVR89/MXbVWUWn/6P/94oWx2nmbs9ADPrmSefnegPPQD39sZT4W6oTfD74+930POJYYzxo7/tFymT9Wu13xrpxLvEsceHaeIrF1aqn2rKaEH13XZI52s24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1EnVxi3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1EnVxi3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 677A81F00A3D;
	Fri,  4 Sep 2026 05:56:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501378;
	bh=xAVQMmJXF1AfdvYt+wsSp0HGDGR6er7cQDqU08kmhoQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z1EnVxi3uo+NCdBSChVQl0ZDRY29Sg3NSvKNWSIYFQLpVHabFddm5GLUpEmHnkJVi
	 87iwN/ZGRkOoDYC5tCitLmIUurBTqy1ND4cZg7sMlQN3Xpn2rix0K8Zx8wa/yT0BCN
	 q0W+HiGk2wL6xagDtizMIuM7h6siJGvmOX47VB7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 6.18 387/552] PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk
Date: Fri,  4 Sep 2026 06:59:04 +0200
Message-ID: <20260904045758.982509561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5331,7 +5331,7 @@ static void pci_quirk_enable_intel_rp_mp
 	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
 		pci_info(dev, "Enabling MPC IRBNCE\n");
 		mpc |= INTEL_MPC_REG_IRBNCE;
-		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+		pci_write_config_dword(dev, INTEL_MPC_REG, mpc);
 	}
 }
 


