Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6360B2DFF0B;
	Tue, 17 Jun 2025 15:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175969; cv=none; b=bQ2+WOnbDL5MqBc5obeC7nwIvbClZBB/sdsOfp0CyikZmp60RAhkSDNHLW3x7eClPzhSfzj5SPWzEyHjjoePCxoGdvU5BNLCQiWVKwnhzFBupahrQAt5IFOFXLhYD9qaeF2JjohaVWJGZxP6nIF4qkdj26eFZ6dfr+CQohxq6jI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175969; c=relaxed/simple;
	bh=i0StvP6HcX48wFE0JyvgLRRAzuw3cQBOm1553WQhZtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K7QjvJRHFXDWqeM8S1HiQOGjav4RU35Xc7l3j6IW8MYtO3JKzMCbq4xu2EQZ7P+P8Uj64Ietczsz92uxPKemA8nhbeaUYHgax39grOHgb+0omMKWZsLefUP6yjgY2w83BajggF0c0nro1cKbN4OfwuHsZneOsj2wwGSm5qXIJ8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIPrMOzx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIPrMOzx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C728DC4CEE3;
	Tue, 17 Jun 2025 15:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175969;
	bh=i0StvP6HcX48wFE0JyvgLRRAzuw3cQBOm1553WQhZtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIPrMOzxLyhZU3oMvEKkdp07K03hXS1xZRre5GTFh/dXR3XuVRGeICDQhtZq6nJUI
	 2fN5AOjUjdt4Bz+7T5JrMjtVe+FF5bxOlH/emtWjv9mCk2EP6QuLMEd9AkSUO99AyZ
	 65meagmCq4nEi+bMDgwWoJRU8NiQDvhKUD/F6TJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 177/512] hisi_acc_vfio_pci: add eq and aeq interruption restore
Date: Tue, 17 Jun 2025 17:22:23 +0200
Message-ID: <20250617152426.814678000@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

[ Upstream commit 3495cec0787721ba7a9d5c19d0bbb66d182de584 ]

In order to ensure that the task packets of the accelerator
device are not lost during the migration process, it is necessary
to send an EQ and AEQ command to the device after the live migration
is completed and to update the completion position of the task queue.

Let the device recheck the completed tasks data and if there are
uncollected packets, device resend a task completion interrupt
to the software.

Fixes: b0eed085903e ("hisi_acc_vfio_pci: Add support for VFIO live migration")
Signed-off-by: Longfang Liu <liulongfang@huawei.com>
Reviewed-by: Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Link: https://lore.kernel.org/r/20250510081155.55840-3-liulongfang@huawei.com
Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
index ec38977336778..81e9a4d362fbc 100644
--- a/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
+++ b/drivers/vfio/pci/hisilicon/hisi_acc_vfio_pci.c
@@ -470,6 +470,19 @@ static int vf_qm_get_match_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	return 0;
 }
 
+static void vf_qm_xeqc_save(struct hisi_qm *qm,
+			    struct hisi_acc_vf_migration_file *migf)
+{
+	struct acc_vf_data *vf_data = &migf->vf_data;
+	u16 eq_head, aeq_head;
+
+	eq_head = vf_data->qm_eqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_EQ, eq_head, 0);
+
+	aeq_head = vf_data->qm_aeqc_dw[0] & 0xFFFF;
+	qm_db(qm, 0, QM_DOORBELL_CMD_AEQ, aeq_head, 0);
+}
+
 static int vf_qm_load_data(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 			   struct hisi_acc_vf_migration_file *migf)
 {
@@ -566,6 +579,9 @@ static int vf_qm_state_save(struct hisi_acc_vf_core_device *hisi_acc_vdev,
 	}
 
 	migf->total_length = sizeof(struct acc_vf_data);
+	/* Save eqc and aeqc interrupt information */
+	vf_qm_xeqc_save(vf_qm, migf);
+
 	return 0;
 }
 
-- 
2.39.5



