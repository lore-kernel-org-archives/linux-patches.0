Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E54F15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4382C433D6;
	Mon,  5 Dec 2022 19:25:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268323;
	bh=LXKzYJ7Jr8pppxHfgLFiEJ5vM0Y1HSKQ+cdDykRvyLY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCMAjIzAxxb+Zy8MdEIRPV0u1PZH65EQm/2dMNDp57+AxxHCOAgj7XbOpFpXeMQFe
	 5uKqr0owgrvXNF7vqA3g1LGZ1I6u2n0bMnSEsTtiKcXvdKjIKmgnrTClM462dh+nMf
	 8xDhBsL6FpZALdJgMeniJB1kP0Po+3QfPDPpIHps=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Konrad Jankowski <konrad0.jankowski@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 032/124] iavf: Fix error handling in iavf_init_module()
Date: Mon,  5 Dec 2022 20:08:58 +0100
Message-Id: <20221205190809.356967552@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
References: <20221205190808.422385173@linuxfoundation.org>
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

[ Upstream commit 227d8d2f7f2278b8468c5531b0cd0f2a905b4486 ]

The iavf_init_module() won't destroy workqueue when pci_register_driver()
failed. Call destroy_workqueue() when pci_register_driver() failed to
prevent the resource leak.

Similar to the handling of u132_hcd_init in commit f276e002793c
("usb: u132-hcd: fix resource leak")

Fixes: 2803b16c10ea ("i40e/i40evf: Use private workqueue")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index cff03723f4f9..4e03712726f2 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -5196,6 +5196,8 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
+	int ret;
+
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -5206,7 +5208,12 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	return pci_register_driver(&iavf_driver);
+
+	ret = pci_register_driver(&iavf_driver);
+	if (ret)
+		destroy_workqueue(iavf_wq);
+
+	return ret;
 }
 
 module_init(iavf_init_module);
-- 
2.35.1



