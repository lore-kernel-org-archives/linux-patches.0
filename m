Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A933E8C74;
	Mon, 17 Aug 2026 13:55:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974918; cv=none; b=FFcM2lU3fEF16CrwFC5xdPHmXP6De/BFvxlW1refk65Y63hYP7lB3tFvuqrFcYCUrzrejPCde1b+rT6d82XDcdQdJMSIvj1eh0Cvreb2gZJ2rb9J+UI5foEd9jXDFFI/1btMJyym2fB119z2SULHOH53kEIDloFgHEcUqVPs75I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974918; c=relaxed/simple;
	bh=iRwEXsuFH4KLoOTtH02Xq5CpzaFhjjxogLJmD/J2VDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jiZli9/BSQCHs5dgDIU4ufhtp1iJb4P9OgrTV5xqtrXFR1p7x3nCfXN7lMZ8OVAUpI86FkX9s/mkLEWUMsx0UXssxsrudVeh5qZvonqmA1XfV/D5LQYhtCQwmt9VtFU5G8FayBhBsy/ZXCZ/LhtOaeztd5bVC9aTb8+Z7eONvLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kLxyd5QC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kLxyd5QC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC95A1F00A3A;
	Mon, 17 Aug 2026 13:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974915;
	bh=fNtlEWzvpHoQYfdJdybF6iwwhOLcUs1eF8zsLui096k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kLxyd5QC5lL1OR87ZSAiYwewg1KKKminS6TQegnF6MKI+/i7Cz3j7k6ETzytz6vL+
	 ReIp9x/LF35mqK0N5d/IOqjxfUAxDWlF8HO6aaTQHOJBwZvV95EsxXBANMkJwh1YiD
	 ppC426kw6hnQvJQxFcTlFvOEtmGbJwRyvWh6Nw8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyan Xu <getshell@seu.edu.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/250] ata: pata_sl82c105: fix bridge revision use-after-free
Date: Mon, 17 Aug 2026 15:30:59 +0200
Message-ID: <20260817132540.525921724@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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



