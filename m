Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2FC01D07A5;
	Wed,  2 Oct 2024 13:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876240; cv=none; b=W7dw90kyHNRTjk7iu+pNFGTcNAcPKgs/XiD5rHussJQGlZm5oTpdVotl2gpD/g8sY6bHrIPx0aUyuQqgVFxORw9dI2v7h8bWbGUa/fO7/6d4dJbSvvDCAbwTXIC7DPdgHFDlfOk8TZos/oqNP01T6Yd+jSCq0sdsKVr+UgumwBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876240; c=relaxed/simple;
	bh=QqiJw+ERwCGga92qFNyVsXHmmqnJFJbQlyUlqVXo+Ss=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=USTKZw3HO/qr+eF03wYmd/MNcTMcbwaAtyIxsq7SS4L8ybbbdfoXv6hvRgXMq0n5rc3ImSr/z+A8540SvtXTI6VYV5otNxkbbdpjKtHeDa7ojzV3QKtkryQsBWtdsRAeX2pw+snt6T7JL/+b5Gn20rGn8ehJGX5F9LUyLQL1eW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zXps97O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zXps97O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 552D6C4CEC5;
	Wed,  2 Oct 2024 13:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876240;
	bh=QqiJw+ERwCGga92qFNyVsXHmmqnJFJbQlyUlqVXo+Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zXps97O6qlFEc1lOEaaly4ChjG5d7kOJeIh3d9fu8lwfhf9jlkfuE0KUO0fAH5o3s
	 uDlgysSF5GU9F8miSHhe34ypQJmqORfYPeypEL3vHQUQGU8q09ar8nz/pOcicdkre3
	 f4876JfAyI/n1CmTxdfxIT+hk0KoBqMkNx5wdRBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Samasth Norway Ananda <samasth.norway.ananda@oracle.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Mario Limonciello <mario.limonciello@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 376/695] x86/PCI: Check pcie_find_root_port() return for NULL
Date: Wed,  2 Oct 2024 14:56:14 +0200
Message-ID: <20241002125837.470579385@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



