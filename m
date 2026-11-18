Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019929;
	b=mKopCPou/bqV/1GgzLwo8GGCCP+lbUHHchmaDFCsExkfrfy/Np8hMlWSfiC9368j5FTr
	 4TLSItQx9q1PJzU/AqCZLmlBgRgG8EUjjnVE7/yvmNzoMA6JhMiHb0BJEcnslYFItt0lK
	 XFMiVB/tHTOlGG2SIDS/+cYdmDSngKfE7CAbYlDpdu5vqNRtfZkMqJnwq+7ASJhUo+5lp
	 Xi5Qlf5qtwXMxsidcpPorm77ysrE4Zhmt/+rUC0DZcIx3ruupwDI+pn5L/zhNNarGGoVG
	 ShDj+WzNTbOw33dROliuoCl9Mn4QDqxWNUcgoiVS1GPU92PcsffncjKEtJ/QaOYJdgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cnVpyHoGlrUc/IFPIbjMqDFu58ecPueTd07Nc0UPpwI=;
	b=Y521TzjvjfhkQQqIrjzEtfUxpq644LKgL7gCucwTQe9TvxAcbDa6fmQ7Gu8PqwbQZ0zu
	 NhHS6jG6k/kHag9cpNOdbPLlIQoHV9Cnmwcp78LugZWPw8epc7S4VrQwyTkR7bKl4bytK
	 /i9gADBn2hCwknl6KbqKaFezRQKveZE8CFQpl0L929AB7I/lLwOX8ZFs+nV+I+DIvuitg
	 f1mKj8QuRs+v+2LNly67/IAnbixbf/28XX3iDMpRer6ccrguL5427U+qDBn+tt7nPev/w
	 3f6jA+oQxj5yVUooiMnW1iYzfttgGlnaDnooThMYFPxbXYoV/f4Q5O/o0eP51Uz9Q8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYNdyvcH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E050606A31C;
	Wed, 18 Nov 2026 16:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eYNdyvcH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18BF51F000C4;
	Wed, 18 Nov 2026 16:38:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019928;
	bh=cnVpyHoGlrUc/IFPIbjMqDFu58ecPueTd07Nc0UPpwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eYNdyvcHqlV8kxzYxtZdb6/CQftR4J0t2PxQcxIHIMWTcmsDi8h/YzYEElr95Bbia
	 qiXJn2YOtKXWgdiEfnLVZX1Zgi0lYAAgbvV+3jgllaUM3pBZL8+ZsIg6BAi0pegUEt
	 nhq+0AXP37eqZ9zSuyKZWQzkxZhhu15f6gD7rqrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Alex Williamson <alex@shazbot.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1770/2651] hisi_acc_vfio_pci: fix NULL dereference in reset_prepare on PF passthrough
Date: Wed, 18 Nov 2026 15:50:10 +0100
Message-ID: <20261118150351.140441206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit e1d2d60b1f50296828d3f7ff26c45d1a90f142ef ]

When a PF is bound to the driver via driver_override and passed
through to a VM, its pf_qm stays NULL. The PCI error handler
reset_prepare() runs during open_device through
pci_try_reset_function(), before the mig_ops gate, and dereferences
the NULL pf_qm for the timeout log, crashing the kernel.

Move the mig_ops check to the entry of reset_prepare() and
aer_reset_done() so non-migration devices skip the QM_RESETTING
coordination. The dev local resolved &qm->pdev->dev before the
gate, so open code it at the dev_err() call where qm is known
valid. Also clear set_reset_flag together with QM_RESETTING in
aer_reset_done(); the flag was never cleared before, so a later
timed-out reset could release a foreign lock.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Fixes: a22099ed7936f ("hisi_acc_vfio_pci: fix VF reset timeout issue")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Link: https://lore.kernel.org/r/20261013071929.3988687-2-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex@shazbot.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 86362ec424a50..e6fdf4d2e5818 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -1154,14 +1154,16 @@ static void hisi_acc_vf_pci_reset_prepare(struct pci_dev *pdev)
 {
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
-	struct device *dev = &qm->pdev->dev;
 	u32 delay = 0;
 
+	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
+		return;
+
 	/* All reset requests need to be queued for processing */
 	while (test_and_set_bit(QM_RESETTING, &qm->misc_ctl)) {
 		msleep(1);
 		if (++delay > QM_RESET_WAIT_TIMEOUT) {
-			dev_err(dev, "reset prepare failed\n");
+			dev_err(&qm->pdev->dev, "reset prepare failed\n");
 			return;
 		}
 	}
@@ -1174,12 +1176,14 @@ static void hisi_acc_vf_pci_aer_reset_done(struct pci_dev *pdev)
 	struct hisi_acc_vf_core_device *hisi_acc_vdev = hisi_acc_drvdata(pdev);
 	struct hisi_qm *qm = hisi_acc_vdev->pf_qm;
 
-	if (hisi_acc_vdev->set_reset_flag)
-		clear_bit(QM_RESETTING, &qm->misc_ctl);
-
 	if (!hisi_acc_vdev->core_device.vdev.mig_ops)
 		return;
 
+	if (hisi_acc_vdev->set_reset_flag) {
+		clear_bit(QM_RESETTING, &qm->misc_ctl);
+		hisi_acc_vdev->set_reset_flag = false;
+	}
+
 	mutex_lock(&hisi_acc_vdev->state_mutex);
 	hisi_acc_vf_reset(hisi_acc_vdev);
 	mutex_unlock(&hisi_acc_vdev->state_mutex);
-- 
2.53.0



