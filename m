Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C1F91662E9;
	Thu, 13 Feb 2025 15:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459120; cv=none; b=okQp3KO6E7FCvW8Dmc43JtKNXjDCQO/u+mW+RYTiKPiH8wHYUKv7makaABmQQeJjQBWELXbursXq8QMMlwpOlo+6sr9JDa48tVVtdxqRnxxzIlh0jUFFUx7QeXqs4V/HRGjk2dvtBXSr1MmTeH5gM5RT23rPZiSaEobfb5ZLYmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459120; c=relaxed/simple;
	bh=ZYncKfp073bCki3UucooyEccaPqTAMS3w8n5msTzm1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6eEtFxsBNdrUHJa0vb/4ODyA4LyksMNgfHfOolo75iDXH7Mp5AocoFu4w8dm9iTodBNYHc8B5EAfJ0IpAbgN7JcYwuYIVm+A9ZO54tlGRWcdHUBc2DQFxqa38T2vFiS3NbboUB+8gxDrZNQGc0E48lPPxxT/6aPg8oMLmIHP3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIlaY5r7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIlaY5r7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45B39C4CEE4;
	Thu, 13 Feb 2025 15:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459119;
	bh=ZYncKfp073bCki3UucooyEccaPqTAMS3w8n5msTzm1k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RIlaY5r7vNTS7f7rT/5Z26xrThlGpu+ls8aJ7XrCcTPI7tEy2KbDGV0P96jAxPdE8
	 p+2Qhv0hx8ITbgS9XD+Q0XhNxfyYcbnhKttHlwemsgJCjCIFuaxFZsi/BMZ4/u1oMk
	 U66BA0UWOR5Pw1C4OadKtqSUj2Y55r/1W1uDLCEc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Murphy <robin.murphy@arm.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Wei Huang <wei.huang2@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 141/443] PCI/TPH: Restore TPH Requester Enable correctly
Date: Thu, 13 Feb 2025 15:25:06 +0100
Message-ID: <20250213142446.040855597@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit 6f64b83d9fe9729000a0616830cb1606945465d8 ]

When we reenable TPH after changing a Steering Tag value, we need the
actual TPH Requester Enable value, not the ST Mode (which only happens to
work out by chance for non-extended TPH in interrupt vector mode).

Link: https://lore.kernel.org/r/13118098116d7bce07aa20b8c52e28c7d1847246.1738759933.git.robin.murphy@arm.com
Fixes: d2e8a34876ce ("PCI/TPH: Add Steering Tag support")
Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Wei Huang <wei.huang2@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/tph.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/tph.c b/drivers/pci/tph.c
index 1e604fbbda657..07de59ca2ebfa 100644
--- a/drivers/pci/tph.c
+++ b/drivers/pci/tph.c
@@ -360,7 +360,7 @@ int pcie_tph_set_st_entry(struct pci_dev *pdev, unsigned int index, u16 tag)
 		return err;
 	}
 
-	set_ctrl_reg_req_en(pdev, pdev->tph_mode);
+	set_ctrl_reg_req_en(pdev, pdev->tph_req_type);
 
 	pci_dbg(pdev, "set steering tag: %s table, index=%d, tag=%#04x\n",
 		(loc == PCI_TPH_LOC_MSIX) ? "MSI-X" : "ST", index, tag);
-- 
2.39.5



