Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EBB52BD033;
	Mon, 27 Oct 2025 18:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590546; cv=none; b=C/rvqtcQbwhg6oMDlLtKhtNHezAqxA6rDS3Rcv6PCeLP3vuu+GgkhFRiSrPwT6pwVYwfi6Hxcd/C48J3iZfWkdfhG1rtPYsNDEctUk9uB21f6vL/jVwsVPpDuJjvHd2s2xX1inVUVqBvYOxySk18H4sZ5qaDlDxerZ1qApkm3ws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590546; c=relaxed/simple;
	bh=Sz77OevdIvfVc8mfOUOLYClOsRJOKrR345LG4ro1J6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UjO3rrLdLl8X95q258Q7O8IC4Zzf640X7g9f2Fs10sswG0NP6lokGebY1oexFrYz2CrMf3fJIB/TOoRzN11N5Z4llYNNvXhuvjA6aucRiDNuDBz4bd3t96gwIlthcLwz23ZEKAt2kKMwZR+hIcL53xe4G2HWf/5ATzENtVEYrUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cMxSAEMi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cMxSAEMi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56EA6C4CEF1;
	Mon, 27 Oct 2025 18:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590545;
	bh=Sz77OevdIvfVc8mfOUOLYClOsRJOKrR345LG4ro1J6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMxSAEMiD8Mi1zx0guloQOIUraK8KIdBpG75KmfFkpG/Y70MVh8vg91r9zl3NE/zI
	 zO5tseS4roYE8Wqq2WT9i1kkIYx0xnuRoFQqeXhx4piUs4vAIKukET6OurL7Rfe3+z
	 vZZ5tFeFo3/y9O9eQSlTxjP/iWGAy57szDNHWQF4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Garry <john.garry@huawei.com>,
	Jack Wang <jinpu.wang@ionos.com>,
	Jason Yan <yanaijie@huawei.com>,
	Hannes Reinecke <hare@suse.de>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 085/224] scsi: libsas: Add sas_task_find_rq()
Date: Mon, 27 Oct 2025 19:33:51 +0100
Message-ID: <20251027183511.268900123@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: John Garry <john.garry@huawei.com>

[ Upstream commit a9ee3f840646e2ec419c734e592ffe997195435e ]

blk-mq already provides a unique tag per request. Some libsas LLDDs - like
hisi_sas - already use this tag as the unique per-I/O HW tag.

Add a common function to provide the request associated with a sas_task for
all libsas LLDDs.

Signed-off-by: John Garry <john.garry@huawei.com>
Link: https://lore.kernel.org/r/1666091763-11023-2-git-send-email-john.garry@huawei.com
Reviewed-by: Jack Wang <jinpu.wang@ionos.com>
Reviewed-by: Jason Yan <yanaijie@huawei.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 60cd16a3b743 ("scsi: mvsas: Fix use-after-free bugs in mvs_work_queue")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/scsi/libsas.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
index 4e2d61e8fb1ed..8461fad88a119 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -620,6 +620,24 @@ extern struct sas_task *sas_alloc_task(gfp_t flags);
 extern struct sas_task *sas_alloc_slow_task(gfp_t flags);
 extern void sas_free_task(struct sas_task *task);
 
+static inline struct request *sas_task_find_rq(struct sas_task *task)
+{
+	struct scsi_cmnd *scmd;
+
+	if (task->task_proto & SAS_PROTOCOL_STP_ALL) {
+		struct ata_queued_cmd *qc = task->uldd_task;
+
+		scmd = qc ? qc->scsicmd : NULL;
+	} else {
+		scmd = task->uldd_task;
+	}
+
+	if (!scmd)
+		return NULL;
+
+	return scsi_cmd_to_rq(scmd);
+}
+
 struct sas_domain_function_template {
 	/* The class calls these to notify the LLDD of an event. */
 	void (*lldd_port_formed)(struct asd_sas_phy *);
-- 
2.51.0



