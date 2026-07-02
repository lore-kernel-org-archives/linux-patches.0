Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8635E3446A7;
	Thu,  2 Jul 2026 16:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011024; cv=none; b=GfH8MLF+sn/uQmdlWxIf2fphWyMECpk0009Dol5ijb7OzyhxvOX70eCY30N7Uni45SULfsj6YG3pQjYcb64Legp9s/rDnfANMHM5GyaTX/wF0IInez146Lxki7upr7T1PWpYFjinLvkrdEqOfxPtnyCE1xu3rpha/bj283b0u9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011024; c=relaxed/simple;
	bh=qmbGLjFAJZXiToJaPZMMxEIsEGq6xDwyWms6H5GS9Ps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3nJh33RxDvB+QUqg3u5eTvsEKEFiHavcTyJA9n5hrSlVKgrwQsG+1kVLFFZzi9Jf/asj7GFP1dgdhRHENGSM19uaddFK4SvmVT3LAMkzQip+ouQvB3IFC7LQsE7SkvqvcBUgyEMeFgaqWz+Eb0VYrJE1hY/BoCX4Ui+X8khfIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ajWTtRtW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ajWTtRtW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8641F00A3A;
	Thu,  2 Jul 2026 16:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011023;
	bh=2mkwdx4IIIR1QVfSuRJcvQAm2rfUa09a0SOLJYVxRnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajWTtRtWrXi/sRMfLI9rFB4gA6pWC2Sr6e0L1JlkRhmwxYCT+xGxIK9B2Hqdb+r4F
	 WyLt6Zo1kYmz6IMnFuDTKIlUHEt62UDS7yHehlQZt+TilFr9+uW35SyszdgoWbaBW2
	 cku+FJmwxtAWyL+o6jqLYpf0cBqq/AbVcwdsoK4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Koichiro Den <den@valinux.co.jp>,
	Dave Jiang <dave.jiang@intel.com>,
	Jon Mason <jdmason@kudzu.us>
Subject: [PATCH 6.6 126/175] NTB: epf: Avoid pci_iounmap() with offset when PEER_SPAD and CONFIG share BAR
Date: Thu,  2 Jul 2026 18:20:27 +0200
Message-ID: <20260702155118.407563391@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155115.766838875@linuxfoundation.org>
References: <20260702155115.766838875@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Koichiro Den <den@valinux.co.jp>

commit d876153680e3d721d385e554def919bce3d18c74 upstream.

When BAR_PEER_SPAD and BAR_CONFIG share one PCI BAR, the module teardown
path ends up calling pci_iounmap() on the same iomem with some offset,
which is unnecessary and triggers a kernel warning like the following:

  Trying to vunmap() nonexistent vm area (0000000069a5ffe8)
  WARNING: mm/vmalloc.c:3470 at vunmap+0x58/0x68, CPU#5: modprobe/2937
  [...]
  Call trace:
   vunmap+0x58/0x68 (P)
   iounmap+0x34/0x48
   pci_iounmap+0x2c/0x40
   ntb_epf_pci_remove+0x44/0x80 [ntb_hw_epf]
   pci_device_remove+0x48/0xf8
   device_remove+0x50/0x88
   device_release_driver_internal+0x1c8/0x228
   driver_detach+0x50/0xb0
   bus_remove_driver+0x74/0x100
   driver_unregister+0x34/0x68
   pci_unregister_driver+0x34/0xa0
   ntb_epf_pci_driver_exit+0x14/0xfe0 [ntb_hw_epf]
  [...]

Fix it by unmapping only when PEER_SPAD and CONFIG use difference bars.

Cc: stable@vger.kernel.org
Fixes: e75d5ae8ab88 ("NTB: epf: Allow more flexibility in the memory BAR map method")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Koichiro Den <den@valinux.co.jp>
Reviewed-by: Dave Jiang <dave.jiang@intel.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ntb/hw/epf/ntb_hw_epf.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ntb/hw/epf/ntb_hw_epf.c
+++ b/drivers/ntb/hw/epf/ntb_hw_epf.c
@@ -646,7 +646,8 @@ static void ntb_epf_deinit_pci(struct nt
 	struct pci_dev *pdev = ndev->ntb.pdev;
 
 	pci_iounmap(pdev, ndev->ctrl_reg);
-	pci_iounmap(pdev, ndev->peer_spad_reg);
+	if (ndev->barno_map[BAR_PEER_SPAD] != ndev->barno_map[BAR_CONFIG])
+		pci_iounmap(pdev, ndev->peer_spad_reg);
 	pci_iounmap(pdev, ndev->db_reg);
 
 	pci_release_regions(pdev);


