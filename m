Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EFFA1C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:08:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EF5AC433D2;
	Mon, 20 Mar 2023 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679324917;
	bh=L4BPA/j0NaFTaEujZOmx4EUTbVrT7bo2QbPBZ6j0+QY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+XOBNq9keKFXuP8XnqOUK6RaDyBpz9fRSRdNWLohH+tAaIp8oc59jmGApW+evN3J
	 Aqfc7W+WY1nZCgAxQlOVxC6pQU0r+8xrjl5c0ziZZoFGpaGUbPcTklH1IX+3aneG6n
	 yNSfZ60IYH0TrPNbLqkWnCjYnHxYkNkOH4v1h2vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/198] scsi: mpi3mr: Return proper values for failures in firmware init path
Date: Mon, 20 Mar 2023 15:52:38 +0100
Message-Id: <20230320145508.345697464@linuxfoundation.org>
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

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

[ Upstream commit ba8a9ba41fbde250fd8b0ed1e5dad0dc9318df46 ]

Return proper non-zero return values for all the cases when the controller
initialization and re-initialization fails.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-5-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: c798304470ca ("scsi: mpi3mr: Fix memory leaks in mpi3mr_init_ioc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f6b726359a1cc..37aaf8dc65d4d 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -3817,8 +3817,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 	dprint_init(mrioc, "allocating config page buffers\n");
 	mrioc->cfg_page = dma_alloc_coherent(&mrioc->pdev->dev,
 	    MPI3MR_DEFAULT_CFG_PAGE_SZ, &mrioc->cfg_page_dma, GFP_KERNEL);
-	if (!mrioc->cfg_page)
+	if (!mrioc->cfg_page) {
+		retval = -1;
 		goto out_failed_noretry;
+	}
 
 	mrioc->cfg_page_sz = MPI3MR_DEFAULT_CFG_PAGE_SZ;
 
@@ -3880,8 +3882,10 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		dprint_init(mrioc, "allocating memory for throttle groups\n");
 		sz = sizeof(struct mpi3mr_throttle_group_info);
 		mrioc->throttle_groups = kcalloc(mrioc->num_io_throttle_group, sz, GFP_KERNEL);
-		if (!mrioc->throttle_groups)
+		if (!mrioc->throttle_groups) {
+			retval = -1;
 			goto out_failed_noretry;
+		}
 	}
 
 	retval = mpi3mr_enable_events(mrioc);
@@ -3901,6 +3905,7 @@ int mpi3mr_init_ioc(struct mpi3mr_ioc *mrioc)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller initialization failed\n");
 	mpi3mr_issue_reset(mrioc, MPI3_SYSIF_HOST_DIAG_RESET_ACTION_DIAG_FAULT,
@@ -4013,6 +4018,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		ioc_err(mrioc,
 		    "cannot create minimum number of operational queues expected:%d created:%d\n",
 		    mrioc->shost->nr_hw_queues, mrioc->num_op_reply_q);
+		retval = -1;
 		goto out_failed_noretry;
 	}
 
@@ -4079,6 +4085,7 @@ int mpi3mr_reinit_ioc(struct mpi3mr_ioc *mrioc, u8 is_resume)
 		mpi3mr_memset_buffers(mrioc);
 		goto retry_init;
 	}
+	retval = -1;
 out_failed_noretry:
 	ioc_err(mrioc, "controller %s is failed\n",
 	    (is_resume)?"resume":"re-initialization");
-- 
2.39.2



