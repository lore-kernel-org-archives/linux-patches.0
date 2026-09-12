Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8650937CD3E;
	Sat, 12 Sep 2026 19:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241482; cv=none; b=k9tN5kJ/vPQpMVtwrP7YowP8pc1SjN20ARdM3G4ZUFSBA6ZL9br1RrLMsCt/+LBrmkH8kuNHWCLriiAu5HdiT1DK6xzuiMyvdzWoQoqhYzkegSbeynBEKbMkbn1eNyYoJ/XvAqFRqrBwDDq0vTaPQhemgA76tKPJRHlIPxM6iTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241482; c=relaxed/simple;
	bh=KzQVptm0F7VEXztl27NLmecyrfSP/udWDPCcg2cuwpc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GT1SGW3ja0C4A07zruDMbEadb+40XmsdVDmlvd97xQo6jjPaSFnlItd9Z8Um/QD3MXfIq55Q1ZnQJigbyV19+olfzuaQNW/UbpKJYA5HNstbvsrO3+jgiooEaMBnfVaGO9TYVsuPq3LRFCKdzrNLpRI2+EAXoAXn/wV336OBp+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=guiAwZ8F; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="guiAwZ8F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5625A1F000FF;
	Sat, 12 Sep 2026 19:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241478;
	bh=dYV7VYa6LQaZ5RGkQv1u2Mq+G8VXSNvETMEzt56BmUY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=guiAwZ8F6vwILYJQz1GwsuedqQEYg9k4l8gqZTIlYOt0bpkFP9574vZG1bAuomJ7J
	 iKx5fQNoQdmW53OHqgoz+EaK5M2MM/tePYrVckg6+R1aejz+OwCzMMcViFRMgfDSFc
	 DBQ/wN8Wvzy4g8IKpZ2FJLvkbV3xnkl+Ll6OEnfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohamad Raizudeen <raizudeen.kerneldev@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Subject: [PATCH 5.10 142/798] PCI: Fix 32-bit config write in Intel PCH Root Port MPC ACS quirk
Date: Sat, 12 Sep 2026 08:56:10 +0200
Message-ID: <20260912065520.236271825@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
@@ -5169,7 +5169,7 @@ static void pci_quirk_enable_intel_rp_mp
 	if (!(mpc & INTEL_MPC_REG_IRBNCE)) {
 		pci_info(dev, "Enabling MPC IRBNCE\n");
 		mpc |= INTEL_MPC_REG_IRBNCE;
-		pci_write_config_word(dev, INTEL_MPC_REG, mpc);
+		pci_write_config_dword(dev, INTEL_MPC_REG, mpc);
 	}
 }
 


