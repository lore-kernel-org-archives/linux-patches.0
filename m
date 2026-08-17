Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A678F443E52;
	Mon, 17 Aug 2026 15:15:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979760; cv=none; b=D1JbhQ7cofMGgTOk2Qjh7lHlLj5ujbrFo7Gr7Omwubon5Z8uIjB2DdTdURu8gmGV1EL6EiViucxVB+4e5LF/c92HGMsAL9S/6Dm/WUWH55i6eOE8VMwBrRRn9cbtqtBUoort3OsRuHBoYc1L39FMaDSZ+SqeFl218wB47d8VJ88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979760; c=relaxed/simple;
	bh=AGFYRsoQ+X0XUxhisxQW3WE5rUMfKT1Bvcw1BVYEZZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CsEFF5VozXyZOUf6X13eA+OpIFNqRyTEYBnDrblZtuPTbj8ZoRfyw1gcoGG0H3HnVNgDbMKQZsOUoXZvm8EQevfHpJk/ttQbwrzsJPQk1nrJQ3kX8DtGlIOIYEer26NDVmg2yGIpoHT0DUjVZOt9yPacvkUGgxsmpooby36EYoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pgc4MYUG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pgc4MYUG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 829F81F000E9;
	Mon, 17 Aug 2026 15:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979757;
	bh=li0cs6TJoj4nfCTYOsYkrPtRivkvgA3C2J+g1YR/6YM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pgc4MYUGoRvRWVjmB9+zJZ0pcQX4T9YIOQ3ydOJ+05mBzNW5J4tmE+DDiaNndbcsp
	 vVZSTVcRCg4wtUXzEry1qe5Qu0ZmTJfTJgI6MVP/uU8echwVve/vPi7Ju4+X6WXoXH
	 Z8ZzVPzhDnBEiFic5v5kTF/3/RMMkq8U+u3YyawY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	John Garry <john.g.garry@oracle.com>,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Hannes Reinecke <hare@suse.com>,
	Jason Yan <yanaijie@huawei.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 337/609] scsi: libsas: Abort all in-flight requests when device is gone
Date: Mon, 17 Aug 2026 15:30:33 +0200
Message-ID: <20260817132555.508947090@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Jason Yan <yanaijie@huawei.com>

[ Upstream commit 0e4b1791d9b192ac263a03707d876132eb0f8dab ]

When a disk is removed with in-flight I/O, the application needs to wait
for 30 seconds (depending on the timeout configuration) to hear back from
the kernel. Xingui tried to fix this issue by aborting the ATA link for
SATA devices[1], however this approach left the SAS devices unresolved.

Try to fix this issue by aborting all in-flight requests when the device is
gone. This is implemented by iterating over the tagset.

[1] https://lore.kernel.org/lkml/234e04db-7539-07e4-a6b8-c6b05f78193d@opensource.wdc.com/T/

Cc: Xingui Yang <yangxingui@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Signed-off-by: Jason Yan <yanaijie@huawei.com>
Link: https://lore.kernel.org/r/20230330110930.175539-1-yanaijie@huawei.com
Reviewed-by: John Garry <john.g.garry@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Stable-dep-of: 3dbbbf656b85 ("scsi: libsas: Fix HA resume deadlock and hisi_sas disk-wake race")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_discover.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index d5bc1314c3415..49dea3c597778 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -360,6 +360,33 @@ static void sas_destruct_ports(struct asd_sas_port *port)
 	}
 }
 
+static bool sas_abort_cmd(struct request *req, void *data)
+{
+	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
+	struct domain_device *dev = data;
+
+	if (dev == cmd_to_domain_dev(cmd))
+		blk_abort_request(req);
+	return true;
+}
+
+static void sas_abort_device_scsi_cmds(struct domain_device *dev)
+{
+	struct sas_ha_struct *sas_ha = dev->port->ha;
+	struct Scsi_Host *shost = sas_ha->core.shost;
+
+	if (dev_is_expander(dev->dev_type))
+		return;
+
+	/*
+	 * For removed device with active IOs, the user space applications have
+	 * to spend very long time waiting for the timeout. This is not
+	 * necessary because a removed device will not return the IOs.
+	 * Abort the inflight IOs here so that EH can be quickly kicked in.
+	 */
+	blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
+}
+
 void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 {
 	if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
@@ -372,6 +399,8 @@ void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *dev)
 	}
 
 	if (!test_and_set_bit(SAS_DEV_DESTROY, &dev->state)) {
+		if (test_bit(SAS_DEV_GONE, &dev->state))
+			sas_abort_device_scsi_cmds(dev);
 		sas_rphy_unlink(dev->rphy);
 		list_move_tail(&dev->disco_list_node, &port->destroy_list);
 	}
-- 
2.53.0



