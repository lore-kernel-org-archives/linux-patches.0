Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85855381DE;
	Fri, 24 Nov 2023 18:29:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CPEn1F1C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1ABC433C8;
	Fri, 24 Nov 2023 18:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850569;
	bh=198FYOlQ6MI5ZYqZXbuRlj15N5GX2pUFbI/py+FkCak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPEn1F1C7U0feomVxsUmavvuxwB1RfZJ0N3UN4zboI0Sx6+cdX/3P0FNzKnnUcedZ
	 ObuWAEuRiCnvyNPA8DkTrgUUygZkrCNoNPmqrN2bcdBLBQTLgpOO9X3DH918eNGgXP
	 8co1qXzalLNyntCh5+H63rPJJ1lzUBWx7w6oIP5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Bartosz Pawlowski <bartosz.pawlowski@intel.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 101/491] PCI: Extract ATS disabling to a helper function
Date: Fri, 24 Nov 2023 17:45:37 +0000
Message-ID: <20231124172027.598776168@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bartosz Pawlowski <bartosz.pawlowski@intel.com>

[ Upstream commit f18b1137d38c091cc8c16365219f0a1d4a30b3d1 ]

Introduce quirk_no_ats() helper function to provide a standard way to
disable ATS capability in PCI quirks.

Suggested-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20230908143606.685930-2-bartosz.pawlowski@intel.com
Signed-off-by: Bartosz Pawlowski <bartosz.pawlowski@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index e8a051e2d8140..b82f94af2fae4 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5507,6 +5507,12 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0420, quirk_no_ext_tags);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0422, quirk_no_ext_tags);
 
 #ifdef CONFIG_PCI_ATS
+static void quirk_no_ats(struct pci_dev *pdev)
+{
+	pci_info(pdev, "disabling ATS\n");
+	pdev->ats_cap = 0;
+}
+
 /*
  * Some devices require additional driver setup to enable ATS.  Don't use
  * ATS for those devices as ATS will be enabled before the driver has had a
@@ -5520,14 +5526,10 @@ static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 		    (pdev->subsystem_device == 0xce19 ||
 		     pdev->subsystem_device == 0xcc10 ||
 		     pdev->subsystem_device == 0xcc08))
-			goto no_ats;
-		else
-			return;
+			quirk_no_ats(pdev);
+	} else {
+		quirk_no_ats(pdev);
 	}
-
-no_ats:
-	pci_info(pdev, "disabling ATS\n");
-	pdev->ats_cap = 0;
 }
 
 /* AMD Stoney platform GPU */
-- 
2.42.0



