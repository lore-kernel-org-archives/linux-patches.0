Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD15142EEDD;
	Mon, 17 Aug 2026 14:46:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977977; cv=none; b=uXoYs4J3zAYrqoES4EnoKdsoVudfPjC2wNWGwHL7DgYDFrZkkSrLXFycGEbhACJ1X10q9kkNHvvMrVB7uMBu8b+FnDzxWCabTqw61Q6Fz27BP2m78dGJG2o3F43RNAFKeNxnaBeUowFbJKhNzTCCR40qaWB0zACZDDDoYkSvMLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977977; c=relaxed/simple;
	bh=JBeGyYAtPPMNZKw/gcibb2tKtW36Ixd4Yjfr+9RekIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ot4h5QS7CbCPvg6zl/ZaVkJhR3pu5BJOZEbaq6wFbR+X8QkM4QCJK+BPQLq7HNl5c364aC6sesLyvzf/i3hzD4viCrBtM73SNiCk6kpdQtHw+0eIpXtClQfXsxnb0Fm0Om24Foi+aKCd7wEC5HJD6FA8fvQggPgIlaLT5Pr2QKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hweNFqQl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hweNFqQl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 426C31F000E9;
	Mon, 17 Aug 2026 14:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977975;
	bh=Pi0LBZzt1U0vjJsoME+6H6vYbUAYwIcLzj7qeiJKceE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hweNFqQl++LkHKpFNcghQOzRN0E3/5EyVRSHAF3ol2AY7C7Lp664+preyZkApgmHC
	 +kiMkXAWacJSwNhkRePE5GDE4VAac1BHGy8ZgcMCo7kcFOW2Q6ewbUx5RMAZh3F+8A
	 oUGRq93jkg/H6sQqc57ul/VHH0Uwww1UbrcH24HY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 058/181] ata: pata_sl82c105: fix bridge revision use-after-free
Date: Mon, 17 Aug 2026 15:32:32 +0200
Message-ID: <20260817132537.698890419@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

From: Hongyan Xu <getshell@seu.edu.cn>

[ Upstream commit 7700a31039cdc6715cb6cce7e7a664ee4e945f67 ]

pci_get_slot() returns a referenced PCI device. Commit 44c10138fd4b
("PCI: Change all drivers to use pci_device->revision") replaced a
configuration-space read with direct access to the cached revision field,
but left that access after pci_dev_put(). The bridge may therefore be freed
before its revision is read.

Read the revision before dropping the reference.

Fixes: 44c10138fd4b ("PCI: Change all drivers to use pci_device->revision")
Signed-off-by: Hongyan Xu <getshell@seu.edu.cn>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_sl82c105.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/pata_sl82c105.c b/drivers/ata/pata_sl82c105.c
index 93882e976ede4..2a5ce46af5a0a 100644
--- a/drivers/ata/pata_sl82c105.c
+++ b/drivers/ata/pata_sl82c105.c
@@ -264,6 +264,7 @@ static struct ata_port_operations sl82c105_port_ops = {
 static int sl82c105_bridge_revision(struct pci_dev *pdev)
 {
 	struct pci_dev *bridge;
+	u8 revision;
 
 	/*
 	 * The bridge should be part of the same device, but function 0.
@@ -285,8 +286,9 @@ static int sl82c105_bridge_revision(struct pci_dev *pdev)
 	/*
 	 * We need to find function 0's revision, not function 1
 	 */
+	revision = bridge->revision;
 	pci_dev_put(bridge);
-	return bridge->revision;
+	return revision;
 }
 
 static void sl82c105_fixup(struct pci_dev *pdev)
-- 
2.53.0



