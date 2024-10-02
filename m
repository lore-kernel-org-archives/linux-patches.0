Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074EF1D0F69;
	Wed,  2 Oct 2024 14:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727878320; cv=none; b=B/N6aeZjF7fzV0a7e1ArSMVIDjv/6F7YF5qubdrnHvalibAzokfW6GL6YL7RBhsZqvkDMIlOe6wR/GhFijz1H7BszOtvMI0JoiG5cvdwem76Xe8B8F+25cUZ1rvESelXuYrm3uFz7CW2AmGL5B2RjGq2I0dfpodLNryuCAPFttM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727878320; c=relaxed/simple;
	bh=mOoBD6NWXVNY6zPjQU6q0ZnTjb7RLqNPGtT+SFoW7Gk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DhiZfXP4BIm219Y8V0Ik0aVc5ZdV8jozltJTfRcAltASJ+8gQH22e44UETR/BIlvFHtPw/HFs22yVT1bcQX2rrTV0B8WMJrZVr8PjtyoRHiGEFs9h8wenPjTCqBrIuQ4qNdkQBUDiZGTN81crqn/OGhLk1HDw1YbxoAFawKoJHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuzIE+ld; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuzIE+ld"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85DDAC4CEC2;
	Wed,  2 Oct 2024 14:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727878319;
	bh=mOoBD6NWXVNY6zPjQU6q0ZnTjb7RLqNPGtT+SFoW7Gk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuzIE+ld5xfzn6Ekc5ROWa6jqOfE8GZZTjBBpe72OLlS9II7MgrGd+bU8BErbqe5d
	 5byW8mouR1+1eBYETckvIOdOTxg9mUca8Fe73LwBYYffhKuumLQNPnZxjVyxdCoERX
	 GNc/sfI0odxq+oEIFTWlT2BYV7lX+vPy1mCN/yQI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 342/634] x86/PCI: Check pcie_find_root_port() return for NULL
Date: Wed,  2 Oct 2024 14:57:22 +0200
Message-ID: <20241002125824.600624462@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>

[ Upstream commit dbc3171194403d0d40e4bdeae666f6e76e428b53 ]

If pcie_find_root_port() is unable to locate a Root Port, it will return
NULL. Check the pointer for NULL before dereferencing it.

This particular case is in a quirk for devices that are always below a Root
Port, so this won't avoid a problem and doesn't need to be backported, but
check as a matter of style and to prevent copy/paste mistakes.

Link: https://lore.kernel.org/r/20240812202659.1649121-1-samasth.norway.ananda@oracle.com
Signed-off-by: Samasth Norway Ananda <samasth.norway.ananda@oracle.com>
[bhelgaas: drop Fixes: and explain why there's no problem in this case]
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/pci/fixup.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/pci/fixup.c b/arch/x86/pci/fixup.c
index b33afb240601b..98a9bb92d75c8 100644
--- a/arch/x86/pci/fixup.c
+++ b/arch/x86/pci/fixup.c
@@ -980,7 +980,7 @@ static void amd_rp_pme_suspend(struct pci_dev *dev)
 		return;
 
 	rp = pcie_find_root_port(dev);
-	if (!rp->pm_cap)
+	if (!rp || !rp->pm_cap)
 		return;
 
 	rp->pme_support &= ~((PCI_PM_CAP_PME_D3hot|PCI_PM_CAP_PME_D3cold) >>
@@ -994,7 +994,7 @@ static void amd_rp_pme_resume(struct pci_dev *dev)
 	u16 pmc;
 
 	rp = pcie_find_root_port(dev);
-	if (!rp->pm_cap)
+	if (!rp || !rp->pm_cap)
 		return;
 
 	pci_read_config_word(rp, rp->pm_cap + PCI_PM_PMC, &pmc);
-- 
2.43.0



