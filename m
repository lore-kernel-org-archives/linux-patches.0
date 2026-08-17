Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EA8A1D435F;
	Mon, 17 Aug 2026 13:42:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974156; cv=none; b=JIi+l+LmYAbCco890FaM0NaPhyiszfalfw/oaENDFyEPLfjgohi/jvWNEBmN+RAeLZvvrtuRBsBKMb9FGzSpwsFl+cOfhdK4QhXCu3gXx8oLHPVWqWxWJ4OF84Q0ZIwRYRIVNvGEvIuJ3PatnEmB4XTqQcD8xYP8+T8wfEBvIqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974156; c=relaxed/simple;
	bh=tEy2NFenHsb1P4RO+5Ru+oDikDiCZ4oJXq2MYx1+NrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H7ec8/PDqvp9IA1pV6tVV3lE5YpUXXBYHTWi6cj/nIPatXKMPGrrxnPqNys1oR9AZ/QK0LT7hhvOI6fU911dEm+hOqprt5+erIN1yiVT889vxXNyUUO6lm4KELwWyBIfiHMnmHZXCShlUUFiU5MikfG1Y9VDX1R+iu3n1Hac+k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nuFT01Sc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nuFT01Sc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E271F000E9;
	Mon, 17 Aug 2026 13:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974155;
	bh=3n3Rie4zrPeHrV0gDhVIhV9TNJyYsrugg+/tSbO+ew4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nuFT01ScINxaXnCi6Qd/y0MZ3C4731+7MlCB2otApEiaXhGY//atlsJGF1IkC/zGp
	 5CLNEjZfDmJxJKke+4HH+tcyrgiAmjYveJtdodtqeckdQSomUs7NYhmKpguYRFd6Jq
	 lgscjHrHPaVlZPqPlf6eE7fs0scTbO0FBljW3TJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 108/271] ata: pata_sl82c105: fix bridge revision use-after-free
Date: Mon, 17 Aug 2026 15:30:33 +0200
Message-ID: <20260817132541.311693790@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2d24c6b3e9d9f..25bce3fe2a101 100644
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



