Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6FE16FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:43:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BB2C433C8;
	Sun, 17 Sep 2023 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979801;
	bh=WIrm5m+D1vipkBtvSOmEfueCQ2lfyinHO6Lyj2qfFbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ny9NNNCBAEMXoyZdkUnG/OLDNXjVRUZFiYz/lKmaIHOn+zrF2NCuMv74geiTldvyb
	 nbs6zqRHWgZiIc4hbeK2BYYStojL94OwuPWMhG8HDqJ+IBh7ZM55m7oX2bKcCdAyx2
	 E+OWrWV8vcTQ0Z93V2kMAcxPhovPWCn51tLtr9e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"jonghwi.rha" <jonghwi.rha@samsung.com>,
	Bean Huo <beanhuo@micron.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.5 003/285] scsi: ufs: core: Add advanced RPMB support where UFSHCI 4.0 does not support EHS length in UTRD
Date: Sun, 17 Sep 2023 21:10:03 +0200
Message-ID: <20230917191051.753979110@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bean Huo <beanhuo@micron.com>

commit c91e585cfb3dd7d076e9ba0967908fc504d32def upstream.

According to UFSHCI 4.0 specification:

5.2 Host Controller Capabilities Registers
5.2.1 Offset 00h: CAP – Controller Capabilities:

 "EHS Length in UTRD Supported (EHSLUTRDS): Indicates whether the host
  controller supports EHS Length field in UTRD.

  0 – Host controller takes EHS length from CMD UPIU, and SW driver use EHS
  Length field in CMD UPIU.

  1 – HW controller takes EHS length from UTRD, and SW driver use EHS
  Length field in UTRD.

  NOTE Recommend Host controllers move to taking EHS length from UTRD, and
  in UFS-5, it will be mandatory."

So, when UFSHCI 4.0 doesn't support EHS Length field in UTRD, we could use
EHS Length field in CMD UPIU. Remove the limitation that advanced RPMB only
works when EHS length is supported in UTRD.

Fixes: 6ff265fc5ef6 ("scsi: ufs: core: bsg: Add advanced RPMB support in ufs_bsg")
Co-developed-by: "jonghwi.rha" <jonghwi.rha@samsung.com>
Signed-off-by: "jonghwi.rha" <jonghwi.rha@samsung.com>
Signed-off-by: Bean Huo <beanhuo@micron.com>
Link: https://lore.kernel.org/r/20230809181847.102123-2-beanhuo@iokpp.de
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ufs/core/ufs_bsg.c |    3 +--
 drivers/ufs/core/ufshcd.c  |   10 +++++++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

--- a/drivers/ufs/core/ufs_bsg.c
+++ b/drivers/ufs/core/ufs_bsg.c
@@ -76,8 +76,7 @@ static int ufs_bsg_exec_advanced_rpmb_re
 	int ret;
 	int data_len;
 
-	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en ||
-	    !(hba->capabilities & MASK_EHSLUTRD_SUPPORTED))
+	if (hba->ufs_version < ufshci_version(4, 0) || !hba->dev_info.b_advanced_rpmb_en)
 		return -EINVAL;
 
 	if (rpmb_request->ehs_req.length != 2 || rpmb_request->ehs_req.ehs_type != 1)
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -7296,7 +7296,15 @@ int ufshcd_advanced_rpmb_req_handler(str
 	/* Advanced RPMB starts from UFS 4.0, so its command type is UTP_CMD_TYPE_UFS_STORAGE */
 	lrbp->command_type = UTP_CMD_TYPE_UFS_STORAGE;
 
-	ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, dir, 2);
+	/*
+	 * According to UFSHCI 4.0 specification page 24, if EHSLUTRDS is 0, host controller takes
+	 * EHS length from CMD UPIU, and SW driver use EHS Length field in CMD UPIU. if it is 1,
+	 * HW controller takes EHS length from UTRD.
+	 */
+	if (hba->capabilities & MASK_EHSLUTRD_SUPPORTED)
+		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, dir, 2);
+	else
+		ufshcd_prepare_req_desc_hdr(lrbp, &upiu_flags, dir, 0);
 
 	/* update the task tag and LUN in the request upiu */
 	req_upiu->header.dword_0 |= cpu_to_be32(upiu_flags << 16 | UFS_UPIU_RPMB_WLUN << 8 | tag);


