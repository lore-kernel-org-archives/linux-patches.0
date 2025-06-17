Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D446E2EE5E3;
	Tue, 17 Jun 2025 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175140; cv=none; b=ZNg5ZSdTAGihhh0QxFiyhdyDMZMv32vpXDoL/OeuTUB3WF2kldRjk7SuS6GvUeexY8J1awWatRVrj9xViTVHQSnScGLe5twW+dtK4D+Nae0MCtXBRpMWfcrP4wKavn29ooTJ1x37tL9cit/cZMkQ2N/bvJsH4AP8PS/hpHBgVzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175140; c=relaxed/simple;
	bh=P6kMKSZyofVnwfcVZN1cP6ObYgdfLMd5apA/uXxSsec=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LRE1w3l9uPdaZVX4i4dduFSFXYRh4ZsfnODjwtfKjby0vBbT5qJQgnaU6xiCKBi/uejcHC+UW+rt8J/gRCo9lc+TlGo0sC2s3uIXFNDtw9qnVxTWtPj9w5EBOdAOlP6h/Jv4rA1/VlYQM8WP8vNC8OZb4IprK1QGDRkUfUgRt8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ny7mfZPn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ny7mfZPn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6910C4CEE3;
	Tue, 17 Jun 2025 15:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175140;
	bh=P6kMKSZyofVnwfcVZN1cP6ObYgdfLMd5apA/uXxSsec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny7mfZPnN540ynlY0iymOc5laeky9Z/qHotcJa58beDcvsbAFo9X14uxVWWtDuEMO
	 blEyfeo4Ry1ee3FoTICi+ddKlNVJrpSPWf5cIVfblJrO9Dy/SqKr9VRtFF+XLLZFaJ
	 CnpCiratZJUh5XRYIv4ZTq5jFxgrgXUAk6rwuTjg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Longfang Liu <liulongfang@huawei.com>,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>,
	Alex Williamson <alex.williamson@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 129/356] hisi_acc_vfio_pci: add eq and aeq interruption restore
Date: Tue, 17 Jun 2025 17:24:04 +0200
Message-ID: <20250617152343.431289526@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
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
index d09e7d295625d..521f969e1c608 100644
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



