Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0983F17731
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:06:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE06C433C8;
	Wed,  9 Aug 2023 11:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579162;
	bh=ZW+I683meoPZIsCvFI8i9djiCwjQtP2utXCxwadsZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOqlZvUvu1kpWDv1limQOeZo0vdZC9tIUtptaioF3tZj2y9JhyrShNVa6nROYiBvg
	 1WNsXnBkVSRrRnF+txlEa5TUhoScT11R/k+tbnLCgbCZ2SOUM1xrfeDPKArMCRTXX3
	 m1cw6Y2w2QjOec965PICHxejdHSpBFJcqB/CieCg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 097/204] ntb: intel: Fix error handling in intel_ntb_pci_driver_init()
Date: Wed,  9 Aug 2023 12:40:35 +0200
Message-ID: <20230809103645.883130218@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103642.552405807@linuxfoundation.org>
References: <20230809103642.552405807@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 4c3c796aca02883ad35bb117468938cc4022ca41 ]

A problem about ntb_hw_intel create debugfs failed is triggered with the
following log given:

 [  273.112733] Intel(R) PCI-E Non-Transparent Bridge Driver 2.0
 [  273.115342] debugfs: Directory 'ntb_hw_intel' with parent '/' already present!

The reason is that intel_ntb_pci_driver_init() returns
pci_register_driver() directly without checking its return value, if
pci_register_driver() failed, it returns without destroy the newly created
debugfs, resulting the debugfs of ntb_hw_intel can never be created later.

 intel_ntb_pci_driver_init()
   debugfs_create_dir() # create debugfs directory
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when pci_register_driver() returns error.

Fixes: e26a5843f7f5 ("NTB: Split ntb_hw_intel and ntb_transport drivers")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Acked-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/intel/ntb_hw_intel.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/intel/ntb_hw_intel.c b/drivers/ntb/hw/intel/ntb_hw_intel.c
index 58068f1447bb2..6b1484b4351d8 100644
--- a/drivers/ntb/hw/intel/ntb_hw_intel.c
+++ b/drivers/ntb/hw/intel/ntb_hw_intel.c
@@ -3041,12 +3041,17 @@ static struct pci_driver intel_ntb_pci_driver = {
 
 static int __init intel_ntb_pci_driver_init(void)
 {
+	int ret;
 	pr_info("%s %s\n", NTB_DESC, NTB_VER);
 
 	if (debugfs_initialized())
 		debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
-	return pci_register_driver(&intel_ntb_pci_driver);
+	ret = pci_register_driver(&intel_ntb_pci_driver);
+	if (ret)
+		debugfs_remove_recursive(debugfs_dir);
+
+	return ret;
 }
 module_init(intel_ntb_pci_driver_init);
 
-- 
2.39.2



