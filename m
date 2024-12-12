Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BD13223E66;
	Thu, 12 Dec 2024 16:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019572; cv=none; b=SHQrl3Ywvti4Bo17Sg8MWNC1FmEjGeFQFnWMGn1yZoPekUZ2xvstDv92ZX+wmNfnIwqCnILqRFq7aGBoW9EFUQBBqxJc6XPNXBhD6zCYmwYK9NvmV0NUQn91AuXs3QdUiwAVJIi0yixYKGb9d12l8Aq/Wyhf0TtsDoUyJBrqObw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019572; c=relaxed/simple;
	bh=7xSYQHAnrDGzrV6zA2j2f623LF6p+Nm0O0FJtxQdATk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HAPhG8fY3yAEfhoTa++6D3BAQPI7SRO7lokSBeY73UEKqXKgFajB1iOz2oJkuy3AGBzRykDHcAKjQSdqydsoDiKeTnziMeRSUMKRVxLVXw1U2CuOD/nvjnjVYsOcBFh/T7MBvW/wq1aWvHbVN7EC/g9sSRntbDvbhXxaOsHl90I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QrwdAvVN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QrwdAvVN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7CDC4CECE;
	Thu, 12 Dec 2024 16:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019571;
	bh=7xSYQHAnrDGzrV6zA2j2f623LF6p+Nm0O0FJtxQdATk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QrwdAvVNbRtR222FTXW6dIHbHSsHWrufKhAEF/lCoNdHqD3YA265UNF0+Pr+HJbBR
	 NZ+Ij87uKCQPiXSvOPJqeNyMT0La6vAp7efRpwukPIYOAGLzJdoAkoyXqvP94D25F8
	 iWgtPhHdOenBCI4SimgnTlJi9qu7VOk4EIn8VC8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhen Lei <thunder.leizhen@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 242/772] scsi: qedi: Fix a possible memory leak in qedi_alloc_and_init_sb()
Date: Thu, 12 Dec 2024 15:53:07 +0100
Message-ID: <20241212144359.908636678@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhen Lei <thunder.leizhen@huawei.com>

[ Upstream commit 95bbdca4999bc59a72ebab01663d421d6ce5775d ]

Hook "qedi_ops->common->sb_init = qed_sb_init" does not release the DMA
memory sb_virt when it fails. Add dma_free_coherent() to free it. This
is the same way as qedr_alloc_mem_sb() and qede_alloc_mem_sb().

Fixes: ace7f46ba5fd ("scsi: qedi: Add QLogic FastLinQ offload iSCSI driver framework.")
Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>
Link: https://lore.kernel.org/r/20241026125711.484-3-thunder.leizhen@huawei.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/qedi/qedi_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 2ee109fb65616..825606c845e1a 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -369,6 +369,7 @@ static int qedi_alloc_and_init_sb(struct qedi_ctx *qedi,
 	ret = qedi_ops->common->sb_init(qedi->cdev, sb_info, sb_virt, sb_phys,
 				       sb_id, QED_SB_TYPE_STORAGE);
 	if (ret) {
+		dma_free_coherent(&qedi->pdev->dev, sizeof(*sb_virt), sb_virt, sb_phys);
 		QEDI_ERR(&qedi->dbg_ctx,
 			 "Status block initialization failed for id = %d.\n",
 			  sb_id);
-- 
2.43.0



