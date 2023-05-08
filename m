Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2E57168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:02:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68A31C433D2;
	Mon,  8 May 2023 10:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540126;
	bh=Wv30nxnmmr9JBuugpbhj65hrnNe2unOmsDnthNncaic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WqKNMArcDdeOzShnFYXSg1GkH+BOQC+mKVTny/bHmTOqF1p1O+iitxVhn6DA6lBag
	 hpIprvB/qfpWCHbmisFeha00qfPJHHA7eRbBsRdxXqUAtKbcvTKdNdj4nswLV48Oux
	 fhAHQiMWPTPqMRy5nMA4RpP0BA1PaJO/AgirSmfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sanket Goswami <Sanket.Goswami@amd.com>,
	Shyam Sundar S K <Shyam-sundar.S-k@amd.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 241/611] platform/x86/amd: pmc: Move out of BIOS SMN pair for STB init
Date: Mon,  8 May 2023 11:41:23 +0200
Message-Id: <20230508094430.246665582@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>

[ Upstream commit 8d99129eef8f42377b41c1bacee9f8ce806e9f44 ]

The current SMN index used for the driver probe seems to be meant
for the BIOS pair and there are potential concurrency problems that can
occur with an inopportune SMI.

It is been advised to use SMN_INDEX_0 instead of SMN_INDEX_6, which is
what amd_nb.c provides and this function has protections to ensure that
only one caller can use it at a time.

Fixes: 426c0ff27b83 ("platform/x86: amd-pmc: Add support for AMD Smart Trace Buffer")
Co-developed-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Sanket Goswami <Sanket.Goswami@amd.com>
Signed-off-by: Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
Link: https://lore.kernel.org/r/20230409185348.556161-7-Shyam-sundar.S-k@amd.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmc.c | 26 ++++----------------------
 1 file changed, 4 insertions(+), 22 deletions(-)

diff --git a/drivers/platform/x86/amd/pmc.c b/drivers/platform/x86/amd/pmc.c
index 2ecee810c960a..eb9fc6cb13e33 100644
--- a/drivers/platform/x86/amd/pmc.c
+++ b/drivers/platform/x86/amd/pmc.c
@@ -38,8 +38,6 @@
 #define AMD_PMC_SCRATCH_REG_YC		0xD14
 
 /* STB Registers */
-#define AMD_PMC_STB_INDEX_ADDRESS	0xF8
-#define AMD_PMC_STB_INDEX_DATA		0xFC
 #define AMD_PMC_STB_PMI_0		0x03E30600
 #define AMD_PMC_STB_S2IDLE_PREPARE	0xC6000001
 #define AMD_PMC_STB_S2IDLE_RESTORE	0xC6000002
@@ -897,17 +895,9 @@ static int amd_pmc_write_stb(struct amd_pmc_dev *dev, u32 data)
 {
 	int err;
 
-	err = pci_write_config_dword(dev->rdev, AMD_PMC_STB_INDEX_ADDRESS, AMD_PMC_STB_PMI_0);
+	err = amd_smn_write(0, AMD_PMC_STB_PMI_0, data);
 	if (err) {
-		dev_err(dev->dev, "failed to write addr in stb: 0x%X\n",
-			AMD_PMC_STB_INDEX_ADDRESS);
-		return pcibios_err_to_errno(err);
-	}
-
-	err = pci_write_config_dword(dev->rdev, AMD_PMC_STB_INDEX_DATA, data);
-	if (err) {
-		dev_err(dev->dev, "failed to write data in stb: 0x%X\n",
-			AMD_PMC_STB_INDEX_DATA);
+		dev_err(dev->dev, "failed to write data in stb: 0x%X\n", AMD_PMC_STB_PMI_0);
 		return pcibios_err_to_errno(err);
 	}
 
@@ -919,18 +909,10 @@ static int amd_pmc_read_stb(struct amd_pmc_dev *dev, u32 *buf)
 {
 	int i, err;
 
-	err = pci_write_config_dword(dev->rdev, AMD_PMC_STB_INDEX_ADDRESS, AMD_PMC_STB_PMI_0);
-	if (err) {
-		dev_err(dev->dev, "error writing addr to stb: 0x%X\n",
-			AMD_PMC_STB_INDEX_ADDRESS);
-		return pcibios_err_to_errno(err);
-	}
-
 	for (i = 0; i < FIFO_SIZE; i++) {
-		err = pci_read_config_dword(dev->rdev, AMD_PMC_STB_INDEX_DATA, buf++);
+		err = amd_smn_read(0, AMD_PMC_STB_PMI_0, buf++);
 		if (err) {
-			dev_err(dev->dev, "error reading data from stb: 0x%X\n",
-				AMD_PMC_STB_INDEX_DATA);
+			dev_err(dev->dev, "error reading data from stb: 0x%X\n", AMD_PMC_STB_PMI_0);
 			return pcibios_err_to_errno(err);
 		}
 	}
-- 
2.39.2



