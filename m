Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D52BC34389F;
	Sat, 30 May 2026 17:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162882; cv=none; b=a+2TX6FXCSJS7DJ1aquD5qgAO5esiD0yzZWZj/WrsKdVjM04COGZiWIMKjbJfT7xdA1r0KDSGS6Yis+Dlxb+/bNOEMqubdvE6fESZILVGBMZtCNotLzBhsNOMcoXortC7Gspnqx0GjQgnNf+CBCvZzW+HG22jCCYXufo31qXyEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162882; c=relaxed/simple;
	bh=0+aY/znyy0cURpqsvnTBCKvk/AiPUfQf2Rge6mlRATY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI9qZeYq3K8WlsHIJv2KmUoMB1R0ltYld/F8qLqwleys4vvJhVSbyun/Lu1xnwqlEThk7d94zAgrSK4Y8ZnEsYrmfANq9RIVHQ89hFJWQ8v4evkPmnRwr3hO5Ycby1LnQn71wlFHssVt5Gx+OggwR0wpR5QU2kGEg28PB7UU768=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y6Lj6B23; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y6Lj6B23"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D421F00893;
	Sat, 30 May 2026 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162881;
	bh=nhoB8y4zTYseBXs+umPB21s2z5qB5YMLIU1WWFkVy3s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y6Lj6B23XA3NjtY//PcDUZoInjSsofvZfxK63U1qn/RB5d4RWg6SzX1+oWBw8dOLH
	 mpWrbb3JM39PPOqN0ik97tFhy9Zrv8RBy8zY2Uo2re3Yox8i1SziFREjDuiOoO68bv
	 p83VjpbNvEDA3eEegR1oUT1vv5dqegb8YR4GYyzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Koichiro Den <den@valinux.co.jp>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 091/776] PCI: endpoint: pci-epf-vntb: Remove duplicate resource teardown
Date: Sat, 30 May 2026 17:56:45 +0200
Message-ID: <20260530160242.688929816@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

[ Upstream commit 0da63230d3ec1ec5fcc443a2314233e95bfece54 ]

epf_ntb_epc_destroy() duplicates the teardown that the caller is
supposed to perform later. This leads to an oops when .allow_link fails
or when .drop_link is performed. The following is an example oops of the
former case:

  Unable to handle kernel paging request at virtual address dead000000000108
  [...]
  [dead000000000108] address between user and kernel address ranges
  Internal error: Oops: 0000000096000044 [#1]  SMP
  [...]
  Call trace:
   pci_epc_remove_epf+0x78/0xe0 (P)
   pci_primary_epc_epf_link+0x88/0xa8
   configfs_symlink+0x1f4/0x5a0
   vfs_symlink+0x134/0x1d8
   do_symlinkat+0x88/0x138
   __arm64_sys_symlinkat+0x74/0xe0
  [...]

Remove the helper, and drop pci_epc_put(). EPC device refcounting is
tied to the configfs EPC group lifetime, and pci_epc_put() in the
.drop_link path is sufficient.

Fixes: e35f56bb0330 ("PCI: endpoint: Support NTB transfer between RC and EP")
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Signed-off-by: Manivannan Sadhasivam <mani@kernel.org>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260226084142.2226875-2-den@valinux.co.jp
[ context mismatch in deletion hunk ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/endpoint/functions/pci-epf-vntb.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/drivers/pci/endpoint/functions/pci-epf-vntb.c b/drivers/pci/endpoint/functions/pci-epf-vntb.c
index 45530bca50fb8..e9402b5dc8359 100644
--- a/drivers/pci/endpoint/functions/pci-epf-vntb.c
+++ b/drivers/pci/endpoint/functions/pci-epf-vntb.c
@@ -650,18 +650,6 @@ static void epf_ntb_mw_bar_clear(struct epf_ntb *ntb)
 	}
 }
 
-/**
- * epf_ntb_epc_destroy() - Cleanup NTB EPC interface
- * @ntb: NTB device that facilitates communication between HOST and vHOST
- *
- * Wrapper for epf_ntb_epc_destroy_interface() to cleanup all the NTB interfaces
- */
-static void epf_ntb_epc_destroy(struct epf_ntb *ntb)
-{
-	pci_epc_remove_epf(ntb->epf->epc, ntb->epf, 0);
-	pci_epc_put(ntb->epf->epc);
-}
-
 /**
  * epf_ntb_init_epc_bar() - Identify BARs to be used for each of the NTB
  * constructs (scratchpad region, doorbell, memorywindow)
@@ -1289,7 +1277,7 @@ static int epf_ntb_bind(struct pci_epf *epf)
 	ret = epf_ntb_init_epc_bar(ntb);
 	if (ret) {
 		dev_err(dev, "Failed to create NTB EPC\n");
-		goto err_bar_init;
+		return ret;
 	}
 
 	ret = epf_ntb_config_spad_bar_alloc(ntb);
@@ -1326,9 +1314,6 @@ static int epf_ntb_bind(struct pci_epf *epf)
 err_bar_alloc:
 	epf_ntb_config_spad_bar_free(ntb);
 
-err_bar_init:
-	epf_ntb_epc_destroy(ntb);
-
 	return ret;
 }
 
@@ -1344,7 +1329,6 @@ static void epf_ntb_unbind(struct pci_epf *epf)
 
 	epf_ntb_epc_cleanup(ntb);
 	epf_ntb_config_spad_bar_free(ntb);
-	epf_ntb_epc_destroy(ntb);
 
 	pci_unregister_driver(&vntb_pci_driver);
 }
-- 
2.53.0



