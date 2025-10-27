Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D119932D0FB;
	Mon, 27 Oct 2025 18:53:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591205; cv=none; b=CiSRBHY1Zaaty0pBayRe5eaHGq1LgfCIami8/ZU6/vyfh6mVjnXLvDjTlTLUSLp5XVZgpFXdr70y38bb52FJClJSIsI4fwFqEveEuPlTyXRf3RzqnUgfy2pGFR7dnmP0K0rbT4b1GMokALmdXgQuXFFktBw2YX25d2/Xv6hOeGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591205; c=relaxed/simple;
	bh=WvXu8gmrSqZiTHd0X3XY5zflkVrYVg8/ygbslerfznM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unDurK81iyogyckkEIgNo6ZdwcF3fr+I3fPsReHSTfTa/gScOGNkjgXB6oGVTuQbJQlTYyKBli3a3ALVKLiBIzqq7/wInuFxXUUfYn04AVWBC/KpbvTv5CeuqttkpvHC+hIpSnEArWzHRIYGEO+LQCGxCchx4QLcdrvCNymuzZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hMkzNngq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hMkzNngq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55527C4CEF1;
	Mon, 27 Oct 2025 18:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591205;
	bh=WvXu8gmrSqZiTHd0X3XY5zflkVrYVg8/ygbslerfznM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hMkzNngq/coFiva42gD/MeNblqZ9kFr6fR2hp9KRW1x/GuCvV4CR6N1+9Q/OGrjJw
	 dWxoemCWwr3xMoulN5OXCee7B1J5hLxJ72jb/Yr9Vu72gITfKi5GCDJxp659Jmxc6H
	 hhl4Jy8EzbUf8qPyY+XjVuoTTwoCgYJwbBum5LsI=
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
Subject: [PATCH 5.10 106/332] scsi: libsas: Add sas_task_find_rq()
Date: Mon, 27 Oct 2025 19:32:39 +0100
Message-ID: <20251027183527.414356644@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183524.611456697@linuxfoundation.org>
References: <20251027183524.611456697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index daf9b07956abf..a4d34c118f8f7 100644
--- a/include/scsi/libsas.h
+++ b/include/scsi/libsas.h
@@ -622,6 +622,24 @@ extern struct sas_task *sas_alloc_task(gfp_t flags);
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



