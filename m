Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A061D2472B0;
	Fri, 17 Oct 2025 14:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713128; cv=none; b=p9iAOjoXpdpEZmDSFfeRIyaUuwJik0kkkiLd9Aqv4zN+5lkTBP2PgQuGhcZKT+LvS4drqJVVgtkq3Rb7InJnc4gSz7w+Zg1PtBB7klb+Yj0EcRuj7JOlGKMVuU1KlTqaui5EZE/mM9DTsCHVZx/f4jhzYrzZuUvfnIPrpTU0oY8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713128; c=relaxed/simple;
	bh=SRVpUUgjzn9IlBoJStPFpzdRLFbZ+yLfBUptgGtMwJk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CTUR12In5SqQL8HLnkLQbiil9ppBsDU9mE/O9K+1bAkl0cQrwpvqLC6lCS8vCL8soMcQpMQyEPNiRO2D+bbEmp1A/t2LIbYvp0rnhWMgZroN7eEiN/FYPvJ8yse/05gae9N+uUQ12Om5wpJxcoxeM5ky2lASMiPJyOuRoNAysMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vVNOzkzs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vVNOzkzs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E863C4CEE7;
	Fri, 17 Oct 2025 14:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713128;
	bh=SRVpUUgjzn9IlBoJStPFpzdRLFbZ+yLfBUptgGtMwJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vVNOzkzsPZD6O4K/nZP4Z7dhMHVz4uzbVZ19bPIyGQEGGQw4DFh1dOOokhs1Nm0M8
	 ywBdeocMnHpUjKS7tUcVkjAU1tOkEYH9avcvHYSejXQHfzyPVe/xui/Ztg+R9QWspH
	 2fjp/6GW7sZwqFYjrF6jc+x3WVaPxxHbxA3WFm14=
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
Subject: [PATCH 6.1 024/168] scsi: libsas: Add sas_task_find_rq()
Date: Fri, 17 Oct 2025 16:51:43 +0200
Message-ID: <20251017145129.910301580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2dbead74a2afe..9e9dff75a02bc 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -648,6 +648,24 @@ static inline bool sas_is_internal_abort(struct sas_task *task)
 	return task->task_proto == SAS_PROTOCOL_INTERNAL_ABORT;
 }
 
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



