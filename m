Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5631E1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC5BC433D2;
	Mon, 20 Mar 2023 15:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325257;
	bh=ZEXuUZ6tnyP9XDvjgUq4SWG4Mp0T7Uy/II4sX+pGXlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sjxXYckTdjylsnUCA9Ev1otRRjaItkAHbNJrIhehoQHBjkCp/roZCVI1Q3w/EyD4q
	 aZt4r2hzghDIA8uTQKP9jvEggWGjDCmf8bv7nhpXrpzt0mk1iF/g7yeZUbX0z3OnzN
	 lZkAID+hMiQ0euArzLMahDVV9eRBbvs/1dlzpbME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomas Henzl <thenzl@redhat.com>,
	Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 022/211] scsi: mpi3mr: Fix memory leaks in mpi3mr_init_ioc()
Date: Mon, 20 Mar 2023 15:52:37 +0100
Message-Id: <20230320145514.228897123@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
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
index e702911e8e934..4147920afbaee 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3813,29 +3813,34 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 
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



