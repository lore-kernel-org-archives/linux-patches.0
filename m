Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAB46188A3A;
	Thu,  3 Apr 2025 15:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743693982; cv=none; b=HKWSr77M0hwrU08W064YtPcDwebMh0C3kzpq8O91KvBh7lp0qfIANUfKxS90NnFe+D488yiPUqAUyBLrmht3FQlMiUrBy5Vt0nEapzu9ayEo5UuqSASIDFNz+rrtv+E7teKt/vTrw9pFsLfYm6eLRtlkGGrMyiZtSGdQFrRJvw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743693982; c=relaxed/simple;
	bh=45RN4MZ1onXE8IgHC06jd02JqSqqs4zc2LJK7YqzO6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SdWFIDWYk/hNjYBzQQN//mbdQQ4qABJBBNF6p6mgWedKtLrolj9i/Ko3Tjnlm3CTWcVTa/K+ZvLEi/Dd53PmkqA29EWSQVnsVm4/m1n2RK0XxYmuBXTaqSGiMHO5g4Gm1TbLqg9jCpTge2LU5MN+pFycWE8pRCe4wY3ZG+TebNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIvTwmsU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIvTwmsU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AAF3C4CEE3;
	Thu,  3 Apr 2025 15:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1743693982;
	bh=45RN4MZ1onXE8IgHC06jd02JqSqqs4zc2LJK7YqzO6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIvTwmsUVPKZeC1hZU8sr0oMp/8a1HUQExaEozk5HsgvqgaQ7Th/iY0u77QH30S+z
	 Lr83K0O1d+Ts97ut3+edH912ayi9yRdwJVJUp/gbjUce4/DXxC4oF1pYyHAtjn0di8
	 so+1SxklvT2ESwNcrvVE1W+CwHNAQcbXx9VyPgY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Jianqi Ren <jianqi.ren.cn@windriver.com>,
	He Zhe <zhe.he@windriver.com>
Subject: [PATCH 6.6 13/26] scsi: ufs: qcom: Only free platform MSIs when ESI is enabled
Date: Thu,  3 Apr 2025 16:20:34 +0100
Message-ID: <20250403151622.800792545@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250403151622.415201055@linuxfoundation.org>
References: <20250403151622.415201055@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>

commit 64506b3d23a337e98a74b18dcb10c8619365f2bd upstream.

Otherwise, it will result in a NULL pointer dereference as below:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000008
Call trace:
 mutex_lock+0xc/0x54
 platform_device_msi_free_irqs_all+0x14/0x20
 ufs_qcom_remove+0x34/0x48 [ufs_qcom]
 platform_remove+0x28/0x44
 device_remove+0x4c/0x80
 device_release_driver_internal+0xd8/0x178
 driver_detach+0x50/0x9c
 bus_remove_driver+0x6c/0xbc
 driver_unregister+0x30/0x60
 platform_driver_unregister+0x14/0x20
 ufs_qcom_pltform_exit+0x18/0xb94 [ufs_qcom]
 __arm64_sys_delete_module+0x180/0x260
 invoke_syscall+0x44/0x100
 el0_svc_common.constprop.0+0xc0/0xe0
 do_el0_svc+0x1c/0x28
 el0_svc+0x34/0xdc
 el0t_64_sync_handler+0xc0/0xc4
 el0t_64_sync+0x190/0x194

Cc: stable@vger.kernel.org # 6.3
Fixes: 519b6274a777 ("scsi: ufs: qcom: Add MCQ ESI config vendor specific ops")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Link: https://lore.kernel.org/r/20241111-ufs_bug_fix-v1-2-45ad8b62f02e@linaro.org
Reviewed-by: Bean Huo <beanhuo@micron.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
Signed-off-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/host/ufs-qcom.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -1918,10 +1918,12 @@ static int ufs_qcom_probe(struct platfor
 static int ufs_qcom_remove(struct platform_device *pdev)
 {
 	struct ufs_hba *hba =  platform_get_drvdata(pdev);
+	struct ufs_qcom_host *host = ufshcd_get_variant(hba);
 
 	pm_runtime_get_sync(&(pdev)->dev);
 	ufshcd_remove(hba);
-	platform_msi_domain_free_irqs(hba->dev);
+	if (host->esi_enabled)
+		platform_msi_domain_free_irqs(hba->dev);
 	return 0;
 }
 


