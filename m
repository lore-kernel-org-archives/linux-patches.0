Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D02441C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 525E9C433EF;
	Mon, 20 Mar 2023 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324925;
	bh=o5u7k0nbL21Q8qrws88vl+I5xOSuwItooO2dh7Gyc8A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hhg7kUMUe0K3XECUHkCQQR4iwNmbXMbykAluoZYiqChgdiha8m9Z/5RpDjOxA8RV0
	 n7ytHgTktAJ5Y4o2+U9J3i2nY8uoaBsraaCL2wf7RgQ+6jaHFDjP74Yixw9JeXS20f
	 eHKyjCQP+7+GZmtegAtVtPUa6zf9JixDgsqzL/pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/198] scsi: mpi3mr: Fix memory leaks in mpi3mr_init_ioc()
Date: Mon, 20 Mar 2023 15:52:39 +0100
Message-Id: <20230320145508.375216911@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tomas Henzl <thenzl@redhat.com>

[ Upstream commit c798304470cab88723d895726d17fcb96472e0e9 ]

Don't allocate memory again when IOC is being reinitialized.

Fixes: fe6db6151565 ("scsi: mpi3mr: Handle offline FW activation in graceful manner")
Signed-off-by: Tomas Henzl <thenzl@redhat.com>
Link: https://lore.kernel.org/r/20230302234336.25456-6-thenzl@redhat.com
Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 41 ++++++++++++++++++---------------
 1 file changed, 23 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 37aaf8dc65d4d..1a404d71b88cf 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3814,29 +3814,34 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
 	mpi3mr_print_ioc_info(mrioc);
 
-	dprint_init(mrioc, "allocating config page buffers\n");
-	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
-	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
 	if (!mrioc->cfg_page) {
-		retval = -1;
-		goto out_failed_noretry;
+		dprint_init(mrioc, "allocating config page buffers\n");
+		mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
+		mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
+		    mrioc->cfg_page_sz, &mrioc->cfg_page_dma, GFP_KERNEL);
+		if (!mrioc->cfg_page) {
+			retval = -1;
+			goto out_failed_noretry;
+		}
 	}
 
-	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
-
-	retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc,
-		    "%s :Failed to allocated reply sense buffers %d\n",
-		    __func__, retval);
-		goto out_failed_noretry;
+	if (!mrioc->init_cmds.reply) {
+		retval = mpi3mr_alloc_reply_sense_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc,
+			    "%s :Failed to allocated reply sense buffers %d\n",
+			    __func__, retval);
+			goto out_failed_noretry;
+		}
 	}
 
-	retval = mpi3mr_alloc_chain_bufs(mrioc);
-	if (retval) {
-		ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
-		    retval);
-		goto out_failed_noretry;
+	if (!mrioc->chain_sgl_list) {
+		retval = mpi3mr_alloc_chain_bufs(mrioc);
+		if (retval) {
+			ioc_err(mrioc, "Failed to allocated chain buffers %d\n",
+			    retval);
+			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_issue_iocinit(mrioc);
-- 
2.39.2



