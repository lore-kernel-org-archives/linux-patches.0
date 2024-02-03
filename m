Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 019C813ADB;
	Sat,  3 Feb 2024 04:16:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933786; cv=none; b=BAQOEpKbva0wyO9jokc6JM3VxOxliNIZ/EJySnxD3Y2K7mtSgmGb9xEmEa3aC6aGltKolUDcm3VnBrO/Aj6adOMSfQQ0olTEjF1XU/e+0wpd62aBSkZRMhnEanr+CVEUHQfnuiupbalWmuF/8JxOkQUNWsZBahubq7ITESm3WC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933786; c=relaxed/simple;
	bh=Ba4iCRgV5Ib56xqk6mlCHei2GbhwJxguBfo/qHhuemY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B7+cciYqszcd4My6JuwLPc6QAwgk4bvSy6Kla84KvQ6SijwPr+KN6fzk28bMUSyskAF8iQn+AyZPlmpKw1iEP6XGy024iNUDKYG7jHjFgReSQP0+eB18G1PFobljQ9t0Q5YaKoK9g35U7P75slrP2WbGWPZk9GRGQP9pW0ervEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ldMriuDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ldMriuDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE597C433C7;
	Sat,  3 Feb 2024 04:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933785;
	bh=Ba4iCRgV5Ib56xqk6mlCHei2GbhwJxguBfo/qHhuemY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ldMriuDn4IhfwvhT7FahyFn2OMZH2rfCGXhmQVSloeHnm6oQZN5UAlpyCi5GcJtDa
	 b0xAhIcU9h52BQ93b1i4GdAk1zMQgPfWmJzDWwPgS4RAE6JM/IACsjCVB7OUpC8eVZ
	 /NYNqLxcdW9RnBJ2yBmNv0Yf+Pscj9Qjsq9zp13M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumit Saxena <sumit.saxena@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 085/353] scsi: mpi3mr: Add PCI checks where SAS5116 diverges from SAS4116
Date: Fri,  2 Feb 2024 20:03:23 -0800
Message-ID: <20240203035406.498327234@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumit Saxena <sumit.saxena@broadcom.com>

[ Upstream commit c9260ff28ee561fca5f96425c9328a9698e8427b ]

Add PCI IDs checks for the cases where SAS5116 diverges from SAS4116 in
behavior.

Signed-off-by: Sumit Saxena <sumit.saxena@broadcom.com>
Link: https://lore.kernel.org/r/20231123160132.4155-3-sumit.saxena@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 3 ++-
 drivers/scsi/mpi3mr/mpi3mr_os.c | 5 ++++-
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index f039f1d98647..0d148c39ebcc 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -1892,7 +1892,8 @@ static int mpi3mr_create_op_reply_q(struct mpi3mr_ioc *mrioc, u16 qidx)
 
 	reply_qid = qidx + 1;
 	op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD;
-	if (!mrioc->pdev->revision)
+	if ((mrioc->pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!mrioc->pdev->revision)
 		op_reply_q->num_replies = MPI3MR_OP_REP_Q_QD4K;
 	op_reply_q->ci = 0;
 	op_reply_q->ephase = 1;
diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index 94adb0b1afc9..872d4b809d08 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -5112,7 +5112,10 @@ mpi3mr_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		mpi3mr_init_drv_cmd(&mrioc->evtack_cmds[i],
 				    MPI3MR_HOSTTAG_EVTACKCMD_MIN + i);
 
-	if (pdev->revision)
+	if ((pdev->device == MPI3_MFGPAGE_DEVID_SAS4116) &&
+		!pdev->revision)
+		mrioc->enable_segqueue = false;
+	else
 		mrioc->enable_segqueue = true;
 
 	init_waitqueue_head(&mrioc->reset_waitq);
-- 
2.43.0



