Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CFDF15C83
	for <patches@lists.linux.dev>; Mon,  5 Dec 2022 19:33:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C252FC433D7;
	Mon,  5 Dec 2022 19:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670268838;
	bh=SwWNltb6kmGF7VfiN+QYinvTyyxJexJad0yCYOiAJrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ODRE520IWfq2k0jwI9bfrhdZCPoYYV8V0/Bx9TyKrwuQbouh3iTzkm9aTW99M5j5X
	 LtlIYqrSYnjuBSQkBG73AfGf/pPNG0ywn241K4Wn2xMQ4CF8KmuhBYI5GctfamR1cC
	 3BFYBOEWXXskg7qYGvq0R/keqX0vIcaZOt6FqJYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 030/120] fm10k: Fix error handling in fm10k_init_module()
Date: Mon,  5 Dec 2022 20:09:30 +0100
Message-Id: <20221205190807.464652332@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

[ Upstream commit 771a794c0a3c3e7f0d86cc34be4f9537e8c0a20c ]

A problem about modprobe fm10k failed is triggered with the following log
given:

 Intel(R) Ethernet Switch Host Interface Driver
 Copyright(c) 2013 - 2019 Intel Corporation.
 debugfs: Directory 'fm10k' with parent '/' already present!

The reason is that fm10k_init_module() returns fm10k_register_pci_driver()
directly without checking its return value, if fm10k_register_pci_driver()
failed, it returns without removing debugfs and destroy workqueue,
resulting the debugfs of fm10k can never be created later and leaks the
workqueue.

 fm10k_init_module()
   alloc_workqueue()
   fm10k_dbg_init() # create debugfs
   fm10k_register_pci_driver()
     pci_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without remove debugfs and destroy workqueue

Fix by remove debugfs and destroy workqueue when
fm10k_register_pci_driver() returns error.

Fixes: 7461fd913afe ("fm10k: Add support for debugfs")
Fixes: b382bb1b3e2d ("fm10k: use separate workqueue for fm10k driver")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/fm10k/fm10k_main.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/fm10k/fm10k_main.c b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
index 3362f26d7f99..1b273446621c 100644
--- a/drivers/net/ethernet/intel/fm10k/fm10k_main.c
+++ b/drivers/net/ethernet/intel/fm10k/fm10k_main.c
@@ -32,6 +32,8 @@ struct workqueue_struct *fm10k_workqueue;
  **/
 static int __init fm10k_init_module(void)
 {
+	int ret;
+
 	pr_info("%s\n", fm10k_driver_string);
 	pr_info("%s\n", fm10k_copyright);
 
@@ -43,7 +45,13 @@ static int __init fm10k_init_module(void)
 
 	fm10k_dbg_init();
 
-	return fm10k_register_pci_driver();
+	ret = fm10k_register_pci_driver();
+	if (ret) {
+		fm10k_dbg_exit();
+		destroy_workqueue(fm10k_workqueue);
+	}
+
+	return ret;
 }
 module_init(fm10k_init_module);
 
-- 
2.35.1



