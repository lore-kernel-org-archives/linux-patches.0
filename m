Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6029D18E76B;
	Tue, 10 Sep 2024 09:51:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961864; cv=none; b=dO6EIbLn6ol1N5IFjXN3PYHqhOts8uv5X8JllgCygYrAhWjsYSuNPDcvkn7rAbDRxXpc20WHD+valxK92Fr4CXMkOoBKINm0yPH0I4M86K4bMXRHgHuEh8ASyfbrvGfchdk9zNiak+tuYOISIg3d+Vb2165LHJSWyoqxeplsc/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961864; c=relaxed/simple;
	bh=8myMmm9nA8uOFweoQewOTi040oNYdZPBys9lDjdUTCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OPSm/BwtuHqgYSjpFhMa+k3GwspPIFF/+xBF1VamoFDLMwYE8V5dBLHyYff7KKBsaEINly9fRIUuxHbJbvzgpgbWW350r2ezK188oY8FdRFcypFZliZPwbCHqTFjW5n0aV22DQ8dNyRDUVLqaSUr5HlcA41cQcctY2m9owYmSbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwQgNebw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwQgNebw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D899EC4CECE;
	Tue, 10 Sep 2024 09:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961864;
	bh=8myMmm9nA8uOFweoQewOTi040oNYdZPBys9lDjdUTCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwQgNebwbfiwyfmTBWTcKFvNvntlfMb+MAmPj62prPMMAjmYs8LHuDzXwi1cXHyUe
	 qOUtLN3VlB3JKygKAorzh3jly65NiEZv6iNDPXcYMwWOk+kLmWZOCCFdytif622A+p
	 hdiOPoFWERUewnpQSKvgc3aCNef/cgrqCikcicNg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyoungrul Kim <k831.kim@samsung.com>,
	Minwoo Im <minwoo.im@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 214/375] scsi: ufs: core: Remove SCSI host only if added
Date: Tue, 10 Sep 2024 11:30:11 +0200
Message-ID: <20240910092629.713576565@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 91bfdc17eedb..b9c436a002a1 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -10196,7 +10196,8 @@ void ufshcd_remove(struct ufs_hba *hba)
 	blk_mq_destroy_queue(hba->tmf_queue);
 	blk_put_queue(hba->tmf_queue);
 	blk_mq_free_tag_set(&hba->tmf_tag_set);
-	scsi_remove_host(hba->host);
+	if (hba->scsi_host_added)
+		scsi_remove_host(hba->host);
 	/* disable interrupts */
 	ufshcd_disable_intr(hba, hba->intr_mask);
 	ufshcd_hba_stop(hba);
@@ -10478,6 +10479,7 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
 			dev_err(hba->dev, "scsi_add_host failed\n");
 			goto out_disable;
 		}
+		hba->scsi_host_added = true;
 	}
 
 	hba->tmf_tag_set = (struct blk_mq_tag_set) {
@@ -10560,7 +10562,8 @@ int ufshcd_init(struct ufs_hba *hba, void __iomem *mmio_base, unsigned int irq)
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



