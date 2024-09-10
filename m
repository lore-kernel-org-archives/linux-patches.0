Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A36A172BA8;
	Tue, 10 Sep 2024 10:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964417; cv=none; b=O/vhQKVCXtUjm9K0c9Uj5K0k9T55Fg//VsM9MaWmnLbF+MxQql/Y0Us0Ik9ZMpJUjwyJjjkgn9uSqCpA2UH1O29/2yBpuS4D8FGI+gQJLOAtAXfIQqU14UuQhE44bRXmCw6PMgoasWQYEj4l52UqJuBpg4MpsfsayvKWo9Zd/vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964417; c=relaxed/simple;
	bh=8sR/ZKlXwE/+JaKqBjwsF7PhUHRl3jFA7WfXIBIBZz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jm7V4/+7ACslzo4Id4BX1ZgO0vLpEyB+IiQRaslibI4ZF0znvEZL1rJHOG6tlOgY2xOTBARebkc34aaIHsmGSVV0pxLaU5pC5b+QMPNZ0e5FOQof5E6zRpnFhX3/5NUUyAeLhifelqYchmNnsGWOcgLdkFBfpFDnPsIgnqsyZ9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BIeSnWjS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BIeSnWjS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6983C4CEC3;
	Tue, 10 Sep 2024 10:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964417;
	bh=8sR/ZKlXwE/+JaKqBjwsF7PhUHRl3jFA7WfXIBIBZz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BIeSnWjSTPMSgR7C+NWzh+UiLhvt3IP5ehk6QJ7B1Wn/NOCm7KVMTSuXnDBthNubA
	 qhW9o+dAMjxGKFSkffuBfIbfIOy/6V9GTrD+PlUECJesDN6MLEdGLzGbN3ITHJXtL5
	 6hWudkqO5v7AppCmvPXfgFFhCBZUk5mPph/6/rLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyoungrul Kim <k831.kim@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 149/269] scsi: ufs: core: Remove SCSI host only if added
Date: Tue, 10 Sep 2024 11:32:16 +0200
Message-ID: <20240910092613.535498551@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyoungrul Kim <k831.kim@samsung.com>

[ Upstream commit 7cbff570dbe8907e23bba06f6414899a0fbb2fcc ]

If host tries to remove ufshcd driver from a UFS device it would cause a
kernel panic if ufshcd_async_scan fails during ufshcd_probe_hba before
adding a SCSI host with scsi_add_host and MCQ is enabled since SCSI host
has been defered after MCQ configuration introduced by commit 0cab4023ec7b
("scsi: ufs: core: Defer adding host to SCSI if MCQ is supported").

To guarantee that SCSI host is removed only if it has been added, set the
scsi_host_added flag to true after adding a SCSI host and check whether it
is set or not before removing it.

Signed-off-by: Kyoungrul Kim <k831.kim@samsung.com>
Signed-off-by: Minwoo Im <minwoo.im@samsung.com>
Link: https://lore.kernel.org/r/20240627085104epcms2p5897a3870ea5c6416aa44f94df6c543d7@epcms2p5
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/core/ufshcd.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index ad0ef5b6b8cf..ed59d2367a4e 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10130,7 +10130,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -10408,6 +10409,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			dev_err(hba->dev, "scsi_add_host failed\n");
 			goto out_disable;
 		}
+		hba->scsi_host_added = true;
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
@@ -10489,7 +10491,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 free_tmf_tag_set:
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
 out_remove_scsi_host:
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 out_disable:
 	hba->is_irq_enabled = false;
 	ufshcd_hba_exit(hba);
-- 
2.43.0



