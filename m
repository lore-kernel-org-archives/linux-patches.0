Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A63EE1362;
	Tue,  3 Dec 2024 15:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733241189; cv=none; b=mR2/6Iym3rvyEqRxWj4dJ7tBMib8PCjAMcQhCdf91t9ImcAExAMSmCN4RwSLRGgGurLepnknl2K4oHnAIJTAZAxX/lgpXAVgh3V9zPad9v8nIyx0+4OKwuoVc5EadQf0aDbBrPkKbjllzCmmdtapofyEB/i1zvYcj2KJEiCsHDI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733241189; c=relaxed/simple;
	bh=/TDAJXDGcNpxNx8AW0eG/wO8nPoiyBIsTnnXelSCqrs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TVpKABl4gABhbisHvrCwQQao/utd6aaGaV8iuoSxfJAk30uQJKjIic9z3taZK4vvr313D8Y9k//tEdcbkD3MF8DkOil2hJNLrNzyGcsMtlIoPMVtpbK256+8J/o9APTgTsjar9StjEP28TF7oXvmiasvDWnl0ZC+TiyyaK1Z7Zw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrcVmbis; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrcVmbis"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09B84C4CECF;
	Tue,  3 Dec 2024 15:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733241189;
	bh=/TDAJXDGcNpxNx8AW0eG/wO8nPoiyBIsTnnXelSCqrs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LrcVmbisxuBr0Zg1AFXa+oobE19cFclpD+PjJDZ/q/mG69/P7bGJPy5M8Lemop0KV
	 EzKiD9tcF//TcOdQlUvRMl0ge0vXlF1nH7SHsnM6I4l4PFFx3lif6oAHjSuxYwHvAB
	 zsHVvbYkr/+PKjKJwJmHvrywFN0bIr/Wcr8E0qIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/826] eth: fbnic: dont disable the PCI device twice
Date: Tue,  3 Dec 2024 15:41:18 +0100
Message-ID: <20241203144757.454544612@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 62e9c00ea868ceb71156c517747dc69316c25bf1 ]

We use pcim_enable_device(), there is no need to call pci_disable_device().

Fixes: 546dd90be979 ("eth: fbnic: Add scaffolding for Meta's NIC driver")
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241115014809.754860-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index a4809fe0fc249..268489b15616f 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -319,7 +319,6 @@ static int fbnic_probe(struct pci_dev *pdev, const struct pci_device_id *ent)
 free_irqs:
 	fbnic_free_irqs(fbd);
 free_fbd:
-	pci_disable_device(pdev);
 	fbnic_devlink_free(fbd);
 
 	return err;
@@ -349,7 +348,6 @@ static void fbnic_remove(struct pci_dev *pdev)
 	fbnic_fw_disable_mbx(fbd);
 	fbnic_free_irqs(fbd);
 
-	pci_disable_device(pdev);
 	fbnic_devlink_free(fbd);
 }
 
-- 
2.43.0



