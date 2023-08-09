Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF42A1773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E38BC433C7;
	Wed,  9 Aug 2023 11:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579862;
	bh=kSEM3ZMvlKpvMvDZu3GG48NEx59CYGDgRgLw4CQa7sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ezHXwd6fW2eQLODKuy3SiJt98NMZAtH7OWOKWnSZzl31jvrS/bMU0uwH6CWMReEZe
	 x9LynSygR2xZQESTU2DzX/Jl3a2LU/jbbfwjxtcCcFDYLwO5DVr5ZQJmtyH3y9YF1E
	 oWBpwuNTz/f5vkvOv+ebXooaXrImksnz4smKvjmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yuan Can <yuancan@huawei.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 143/323] NTB: amd: Fix error handling in amd_ntb_pci_driver_init()
Date: Wed,  9 Aug 2023 12:39:41 +0200
Message-ID: <20230809103704.691403084@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit 98af0a33c1101c29b3ce4f0cf4715fd927c717f9 ]

A problem about ntb_hw_amd create debugfs failed is triggered with the
following log given:

 [  618.431232] AMD(R) PCI-E Non-Transparent Bridge Driver 1.0
 [  618.433284] debugfs: Directory 'ntb_hw_amd' with parent '/' already present!

The reason is that amd_ntb_pci_driver_init() returns pci_register_driver()
directly without checking its return value, if pci_register_driver()
failed, it returns without destroy the newly created debugfs, resulting
the debugfs of ntb_hw_amd can never be created later.

 amd_ntb_pci_driver_init()
   debugfs_create_dir() # create debugfs directory
   pci_register_driver()
     driver_register()
       bus_add_driver()
         priv = kzalloc(...) # OOM happened
   # return without destroy debugfs directory

Fix by removing debugfs when pci_register_driver() returns error.

Fixes: a1b3695820aa ("NTB: Add support for AMD PCI-Express Non-Transparent Bridge")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index 0b1fbb5dba9b6..7de7616803935 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1139,12 +1139,17 @@ static struct pci_driver amd_ntb_pci_driver = {
 
 static int __init amd_ntb_pci_driver_init(void)
 {
+	int ret;
 	pr_info("%s %s\n", NTB_DESC, NTB_VER);
 
 	if (debugfs_initialized())
 		debugfs_dir = debugfs_create_dir(KBUILD_MODNAME, NULL);
 
-	return pci_register_driver(&amd_ntb_pci_driver);
+	ret = pci_register_driver(&amd_ntb_pci_driver);
+	if (ret)
+		debugfs_remove_recursive(debugfs_dir);
+
+	return ret;
 }
 module_init(amd_ntb_pci_driver_init);
 
-- 
2.39.2



