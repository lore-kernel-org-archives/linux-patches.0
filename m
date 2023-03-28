Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4566A8BE0
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 15:01:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B867BC433D2;
	Tue, 28 Mar 2023 15:01:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680015687;
	bh=5VMwDl1Jsw26GjyXU8bTq4Dwad0lh0CCc32p19PzZOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uu5cL3ZNEc9O8EWRIt2XOnqyAXdpH1U2FhW+fpv4XtLdgl0Q/GL6KDUMtGbo4GyF8
	 yesi5nSnvWl8Q21p08aRkmeKDizFUpR7cng28MnRB/fT7CIPm88S2/PtmwzOjQf50v
	 WY4VgqW4EQ4/dQgtBhT29gBMeMd4jx+h8r050sZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 138/224] scsi: mpi3mr: NVMe command size greater than 8K fails
Date: Tue, 28 Mar 2023 16:42:14 +0200
Message-Id: <20230328142623.131678791@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
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

[ Upstream commit 4f297e856a7b5da2f2c66a12e739666e23943560 ]

A wrong variable is checked while populating PRP entries in the PRP page
and this results in failure. No PRP entries in the PRP page were
successfully created and any NVMe Encapsulated commands with PRP of size
greater than 8K failed.

Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Signed-off-by: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Link: https://lore.kernel.org/r/20230228140835.4075-6-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index bff6377023979..d10c6afb7f9cd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -886,7 +886,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			 * each time through the loop.
 			 */
 			*prp_entry = cpu_to_le64(dma_addr);
-			if (*prp1_entry & sgemod_mask) {
+			if (*prp_entry & sgemod_mask) {
 				dprint_bsg_err(mrioc,
 				    "%s: PRP address collides with SGE modifier\n",
 				    __func__);
@@ -895,7 +895,7 @@ static int mpi3mr_build_nvme_prp(struct mpi3mr_ioc *mrioc,
 			*prp_entry &= ~sgemod_mask;
 			*prp_entry |= sgemod_val;
 			prp_entry++;
-			prp_entry_dma++;
+			prp_entry_dma += prp_size;
 		}
 
 		/*
-- 
2.39.2



