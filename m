Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E57396B75;
	Thu, 15 Jan 2026 16:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496052; cv=none; b=UTBnC3HSS3lI6a+xkA1m/X1VproebXcmSEfaukWtcvTuhjan0MJAgIsYP4dAlJ0EtI12/48JVdlj+Y444Antou6cM8qqg+hgJ0CxbpDKMq50W+Fy5IZBb6jlwVQQ9ol3gl6tR9l9vRdCrVKfBS3aWwLvEEGX8b73kS6KkVv9axg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496052; c=relaxed/simple;
	bh=kTAGkCIcNyvI8UNh/rGDGYJUchCNh9yCmA1zrw22E9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SeD4eyAKXJS/vTlNRuRb3vjYmPUi7qLXM0eWajB8zR4j86tExj7nKGK0RXBTFPHKA10AgYmiOL2aTTlLkFz/PjWKjSCCRqnmug0KvnBKQ2roqEjQ8bQxvgDsnuBAQvdlSI2vkWUZYAgOOfqLMAtHN0ylfHyFBoQT6uCIx+r+di8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a41xRWpH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a41xRWpH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A539BC116D0;
	Thu, 15 Jan 2026 16:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496052;
	bh=kTAGkCIcNyvI8UNh/rGDGYJUchCNh9yCmA1zrw22E9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a41xRWpHOV4JS9HZBDDwqv6SPgi5QlURXOPYRfWuAulQYO4IUAOryEQbKGKvaOwmj
	 vvjCZNb1yzEvWOHV8LPmokHU2BnK/jf9I1iTc7/X/Cu2XLCIPO8zqEcNHRNcx2grMi
	 ttYJ7FXg3jOEg4J9AfzsIHkkmnh9fXqC5DLhI9Oo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suganath Prabu S <suganath-prabu.subramani@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 060/181] scsi: mpi3mr: Prevent duplicate SAS/SATA device entries in channel 1
Date: Thu, 15 Jan 2026 17:46:37 +0100
Message-ID: <20260115164204.493210295@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>

[ Upstream commit 4588e65cfd66fc8bbd9969ea730db39b60a36a30 ]

Avoid scanning SAS/SATA devices in channel 1 when SAS transport is
enabled, as the SAS/SATA devices are exposed through channel 0.

Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/stable/20251120071955.463475-1-suganath-prabu.subramani%40broadcom.com
Link: https://patch.msgid.link/20251120071955.463475-1-suganath-prabu.subramani@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr.h    | 4 ++--
 drivers/scsi/mpi3mr/mpi3mr_os.c | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
index 6742684e2990a..31d68c151b207 100644
--- a/drivers/scsi/mpi3mr/mpi3mr.h
+++ b/drivers/scsi/mpi3mr/mpi3mr.h
@@ -56,8 +56,8 @@ extern struct list_head mrioc_list;
 extern int prot_mask;
 extern atomic64_t event_counter;
 
-#define MPI3MR_DRIVER_VERSION	"8.15.0.5.50"
-#define MPI3MR_DRIVER_RELDATE	"12-August-2025"
+#define MPI3MR_DRIVER_VERSION	"8.15.0.5.51"
+#define MPI3MR_DRIVER_RELDATE	"18-November-2025"
 
 #define MPI3MR_DRIVER_NAME	"mpi3mr"
 #define MPI3MR_DRIVER_LICENSE	"GPL"
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index b88633e1efe27..d4ca878d08869 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -1184,6 +1184,8 @@ static void mpi3mr_update_tgtdev(struct mpi3mr_ioc *mrioc,
 	if (is_added == true)
 		tgtdev->io_throttle_enabled =
 		    (flags & MPI3_DEVICE0_FLAGS_IO_THROTTLING_REQUIRED) ? 1 : 0;
+	if (!mrioc->sas_transport_enabled)
+		tgtdev->non_stl = 1;
 
 	switch (flags & MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_MASK) {
 	case MPI3_DEVICE0_FLAGS_MAX_WRITE_SAME_256_LB:
@@ -4844,7 +4846,7 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	if (starget->channel == mrioc->scsi_device_channel) {
 		tgt_dev = __mpi3mr_get_tgtdev_by_perst_id(mrioc, starget->id);
-		if (tgt_dev && !tgt_dev->is_hidden) {
+		if (tgt_dev && !tgt_dev->is_hidden && tgt_dev->non_stl) {
 			scsi_tgt_priv_data->starget = starget;
 			scsi_tgt_priv_data->dev_handle = tgt_dev->dev_handle;
 			scsi_tgt_priv_data->perst_id = tgt_dev->perst_id;
-- 
2.51.0



