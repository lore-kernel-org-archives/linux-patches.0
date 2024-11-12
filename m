Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A632B2309AE;
	Tue, 12 Nov 2024 10:41:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408075; cv=none; b=PTgOMhcp2JNq8MnhWm2oUy+Ao+DYPioFpJ+Sc+3fi3bvDWEKFckSZXDwPb1s6a89SX4iYG2DKHMMrJ8plffTJGRBd0QjyU79GRbNg7ZErHmzCHGc+79d5dSzUjOvERwvvGp0WCEy+Ljzf5KJTVZ+YPmu5lp9GvF2JyO3rmLh9VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408075; c=relaxed/simple;
	bh=BiPhBs9cPEnjtislKxR0waiRQURAepHPjqSeOT7RqBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OHiNuk6YYr5Yjb1aGChDPgtgFPh1tb3msyVaaJvOG0fPHBvNLtSTxAhV3cw15jAoA/eIRJCatBPrD+CfO6Uv2duDLi0c4TYyHnW+AbF04ZtD0LWLCuY15SP9Jb6rtXdy0sJoP3TLkDJq4f1e52N02GxFDv2iMAHtCHpJQqueSQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NWZtrDHv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NWZtrDHv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B83FBC4CECD;
	Tue, 12 Nov 2024 10:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408075;
	bh=BiPhBs9cPEnjtislKxR0waiRQURAepHPjqSeOT7RqBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NWZtrDHvEu8NMA4B+YjLBfG06UfGNM4ab+y8PLFTkZQOpDC+tN9tYxmA+uj/+ofXF
	 RdTGIndVJx6hqri3lNq26fvg3jPwDOkQBxUHEFjXy1c1k0UGhaRz/QEXGFD1TbsJsZ
	 PlAyUTrDEZPjjomVwGyuDuHIZ0lqAnRnPSMGw30Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peiyang Wang <wangpeiyang1@huawei.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 051/184] net: hns3: fix kernel crash when uninstalling driver
Date: Tue, 12 Nov 2024 11:20:09 +0100
Message-ID: <20241112101902.819400241@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peiyang Wang <wangpeiyang1@huawei.com>

[ Upstream commit df3dff8ab6d79edc942464999d06fbaedf8cdd18 ]

When the driver is uninstalled and the VF is disabled concurrently, a
kernel crash occurs. The reason is that the two actions call function
pci_disable_sriov(). The num_VFs is checked to determine whether to
release the corresponding resources. During the second calling, num_VFs
is not 0 and the resource release function is called. However, the
corresponding resource has been released during the first invoking.
Therefore, the problem occurs:

[15277.839633][T50670] Unable to handle kernel NULL pointer dereference at virtual address 0000000000000020
...
[15278.131557][T50670] Call trace:
[15278.134686][T50670]  klist_put+0x28/0x12c
[15278.138682][T50670]  klist_del+0x14/0x20
[15278.142592][T50670]  device_del+0xbc/0x3c0
[15278.146676][T50670]  pci_remove_bus_device+0x84/0x120
[15278.151714][T50670]  pci_stop_and_remove_bus_device+0x6c/0x80
[15278.157447][T50670]  pci_iov_remove_virtfn+0xb4/0x12c
[15278.162485][T50670]  sriov_disable+0x50/0x11c
[15278.166829][T50670]  pci_disable_sriov+0x24/0x30
[15278.171433][T50670]  hnae3_unregister_ae_algo_prepare+0x60/0x90 [hnae3]
[15278.178039][T50670]  hclge_exit+0x28/0xd0 [hclge]
[15278.182730][T50670]  __se_sys_delete_module.isra.0+0x164/0x230
[15278.188550][T50670]  __arm64_sys_delete_module+0x1c/0x30
[15278.193848][T50670]  invoke_syscall+0x50/0x11c
[15278.198278][T50670]  el0_svc_common.constprop.0+0x158/0x164
[15278.203837][T50670]  do_el0_svc+0x34/0xcc
[15278.207834][T50670]  el0_svc+0x20/0x30

For details, see the following figure.

     rmmod hclge              disable VFs
----------------------------------------------------
hclge_exit()            sriov_numvfs_store()
  ...                     device_lock()
  pci_disable_sriov()     hns3_pci_sriov_configure()
                            pci_disable_sriov()
                              sriov_disable()
    sriov_disable()             if !num_VFs :
      if !num_VFs :               return;
        return;                 sriov_del_vfs()
      sriov_del_vfs()             ...
        ...                       klist_put()
        klist_put()               ...
        ...                     num_VFs = 0;
      num_VFs = 0;        device_unlock();

In this patch, when driver is removing, we get the device_lock()
to protect num_VFs, just like sriov_numvfs_store().

Fixes: 0dd8a25f355b ("net: hns3: disable sriov before unload hclge layer")
Signed-off-by: Peiyang Wang <wangpeiyang1@huawei.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20241101091507.3644584-1-shaojijie@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.c b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
index 67b0bf310daaa..9a63fbc694083 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.c
@@ -25,8 +25,11 @@ void hnae3_unregister_ae_algo_prepare(struct hnae3_ae_algo *ae_algo)
 		pci_id = pci_match_id(ae_algo->pdev_id_table, ae_dev->pdev);
 		if (!pci_id)
 			continue;
-		if (IS_ENABLED(CONFIG_PCI_IOV))
+		if (IS_ENABLED(CONFIG_PCI_IOV)) {
+			device_lock(&ae_dev->pdev->dev);
 			pci_disable_sriov(ae_dev->pdev);
+			device_unlock(&ae_dev->pdev->dev);
+		}
 	}
 }
 EXPORT_SYMBOL(hnae3_unregister_ae_algo_prepare);
-- 
2.43.0



