Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D3E330B1F;
	Fri, 17 Oct 2025 15:51:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760716296; cv=none; b=ok/aHzfKJEl0heQKu4CEqsZHSA1wJ9z3UWyaQBJ6r46RD39LMyT7YrfuqQqfqj2Y/PwA9qQHPfe1MbEtKgu0WoZFVboIfq0Dk5kVDCqDSbOgzJLTVpjgscgE89zgQ8vN3b0Wbk16YImwx7kwSnmb2XG2cfAC20BFW2fjlvz6UEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760716296; c=relaxed/simple;
	bh=wkQ1hH3uGWjCIojGmHGVNmmng3yTJf8TCy60i+Xck74=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nk1al+V+sh90D9+EBko/2Q6A9UIQAsWSym/Y9nCEjL/xynZQSIc6UiHa3pxuKSzX1iVTHcNcD1lPtgOVC2KfcWENDmAvk1s4a2YXqjiZLfom+0SMoScu4Df9w8gQHMp4htTz7Us7m09UPmpPb7Nsb4hZIp5mQ/Dqib4xPZYPj+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yKR65x/k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yKR65x/k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5215C4CEE7;
	Fri, 17 Oct 2025 15:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760716296;
	bh=wkQ1hH3uGWjCIojGmHGVNmmng3yTJf8TCy60i+Xck74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yKR65x/kfBqCasgtFv0nL+Pk0TaawQ0stIHQeIHDGjNmHVL7cuMHZZGJr7hvq5o3L
	 8mjxUT1c2XaZBfr0R7IUC9WxkA46bLffP0KnBBzfxzbPrw8b3qUCaLLEF7bxNwvy76
	 WntKSpGcv3R2+z7zR19buEYGHov8PYh/s+9COk+k=
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
Subject: [PATCH 5.15 140/276] scsi: libsas: Add sas_task_find_rq()
Date: Fri, 17 Oct 2025 16:53:53 +0200
Message-ID: <20251017145147.593341781@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
References: <20251017145142.382145055@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 306005b3b60f3..97e99385f70ce 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -631,6 +631,24 @@ extern struct sas_task *sas_alloc_task(gfp_t flags);
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



