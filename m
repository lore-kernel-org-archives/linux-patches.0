Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFAAE2E542E;
	Tue,  8 Jul 2025 16:43:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751993034; cv=none; b=dTATt/IPNr1IAZfMiPMgmll10ZgbfKW7zDrWhPhDxlGt/2n/ulJIwEmXNsZoDIk7eY1w/9VHgrPZQjEYAwzrVgzxdOTWfSqBFgv2q+uImUKxd2VBeIgZKPHVTA9PyHNIc6KVWdlSOh1I3SJsZryXZegKH5Jl3LEQZFvnU4QoxV8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751993034; c=relaxed/simple;
	bh=t1edlcN3cNrhfvn8rgNBL48ov+/ChVIbUofr+vTxCxo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XIKA0YxB2L9DjK3Bv18UZSnmIgKOncMmo58UcX69i5bBz5tI/BXZ4pkeThkp9K4q8hgO/Q30/L7jFQ0BiGKoZNI5dCAKT4rnRK5osSHVXgkwbbGwY7upTUq26YS4WKCTVV4Bao/Bz1XGTtaGdUdSDiWBUfnSHzWu9BHGQKG78hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UFtzM97f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UFtzM97f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6650EC4CEED;
	Tue,  8 Jul 2025 16:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751993033;
	bh=t1edlcN3cNrhfvn8rgNBL48ov+/ChVIbUofr+vTxCxo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UFtzM97f3rlszLd430/7yJpAdZ4F6JabcjrTlD0xhad22FzkGwUq1fU7Xa/IhxWTl
	 j/TmPSwNWEcrfqumxPoClm1k1oxQ1I0daP9UTe/9mhwN5qLDXMhaRIdy0NbkgaoKMy
	 qZCzDn6hhl1z9A/h9bZUxpLMnyMRyICiBcl/wuLM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 134/232] hisi_acc_vfio_pci: bugfix cache write-back issue
Date: Tue,  8 Jul 2025 18:22:10 +0200
Message-ID: <20250708162244.950986133@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Longfang Liu <liulongfang@huawei.com>

[ Upstream commit e63c466398731bb7867f42f44b76fa984de59db2 ]

At present, cache write-back is placed in the device data
copy stage after stopping the device operation.
Writing back to the cache at this stage will cause the data
obtained by the cache to be written back to be empty.

In order to ensure that the cache data is written back
successfully, the data needs to be written back into the
stop device stage.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20250510081155.55840-4-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index 68300fcd3c41b..e37699fc03707 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -554,12 +554,6 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	vf_data->vf_qm_state = QM_READY;
 	hisi_acc_vdev->vf_qm_state = vf_data->vf_qm_state;
 
-	ret = vf_qm_cache_wb(vf_qm);
-	if (ret) {
-		dev_err(dev, "failed to writeback QM Cache!\n");
-		return ret;
-	}
-
 	ret = qm_get_regs(vf_qm, vf_data);
 	if (ret)
 		return -EINVAL;
@@ -985,6 +979,13 @@ static int hisi_acc_vf_stop_device(struct hisi_acc_vf_core_device *hisi_acc_vdev
 		dev_err(dev, "failed to check QM INT state!\n");
 		return ret;
 	}
+
+	ret = vf_qm_cache_wb(vf_qm);
+	if (ret) {
+		dev_err(dev, "failed to writeback QM cache!\n");
+		return ret;
+	}
+
 	return 0;
 }
 
-- 
2.39.5



