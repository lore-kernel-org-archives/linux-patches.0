Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE08715C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:24:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403D3C433D7;
	Mon,  5 Dec 2022 19:24:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268262;
	bh=ej+v5aqHDtEuMwUrK7dcJ8XNPjBxut/nU5tAETQ4ghk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QUG2XRBRZ0nCdscq2yWUp9CYCdeZyJM7+AIqyZpRKyK4wbDjjADKVrNggA+9II0Ju
	 de/xFfoMHV0FqJDBoNb9agv/yGYUWI8ROpHhelGpvpTCrtFz2mGhD1eI3O8iSjopJA
	 Vi4BYxeNaNriLVSBVfgYWbvgATZHC8w8KJzU1CS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shang XiaoJing <shangxiaojing@huawei.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Gurucharan G <gurucharanx.g@intel.com>
Subject: [PATCH 6.0 030/124] i40e: Fix error handling in i40e_init_module()
Date: Mon,  5 Dec 2022 20:08:56 +0100
Message-Id: <20221205190809.302950985@linuxfoundation.org>
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

From: Shang XiaoJing <shangxiaojing@huawei.com>

[ Upstream commit 479dd06149425b9e00477f52200872587af76a48 ]

i40e_init_module() won't free the debugfs directory created by
i40e_dbg_init() when pci_register_driver() failed. Add fail path to
call i40e_dbg_exit() to remove the debugfs entries to prevent the bug.

i40e: Intel(R) Ethernet Connection XL710 Network Driver
i40e: Copyright (c) 2013 - 2019 Intel Corporation.
debugfs: Directory 'i40e' with parent '/' already present!

Fixes: 41c445ff0f48 ("i40e: main driver core")
Signed-off-by: Shang XiaoJing <shangxiaojing@huawei.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Tested-by: Gurucharan G <gurucharanx.g@intel.com> (A Contingent worker at Intel)
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/i40e/i40e_main.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_main.c b/drivers/net/ethernet/intel/i40e/i40e_main.c
index b3336d31f8a9..023685cca2c1 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_main.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_main.c
@@ -16652,6 +16652,8 @@ static struct pci_driver i40e_driver = {
  **/
 static int __init i40e_init_module(void)
 {
+	int err;
+
 	pr_info("%s: %s\n", i40e_driver_name, i40e_driver_string);
 	pr_info("%s: %s\n", i40e_driver_name, i40e_copyright);
 
@@ -16669,7 +16671,14 @@ static int __init i40e_init_module(void)
 	}
 
 	i40e_dbg_init();
-	return pci_register_driver(&i40e_driver);
+	err = pci_register_driver(&i40e_driver);
+	if (err) {
+		destroy_workqueue(i40e_wq);
+		i40e_dbg_exit();
+		return err;
+	}
+
+	return 0;
 }
 module_init(i40e_init_module);
 
-- 
2.35.1



