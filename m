Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B322FF672;
	Sat, 12 Sep 2026 14:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221979; cv=none; b=aZK/GlBMPk/cflwERHxlrCfjHnJffi7LkrikccUczGhEc1UveQ+9wyu6Twti1VY2UJ2BHi41E3k7WpBKfrvmoGyKtglUWFoLhPMtTI930KFt+/vVTX6X/q9IzqovuBWKaQvnSCQTid8uvyt5tyzatAwQ1zuqdjukN9RjRMnu3VM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221979; c=relaxed/simple;
	bh=x1fskLv0e5e8pCEOvTtKMfVPTFKs/GRmIs1Lb1vZ31A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nYAKUjAVHojKSXCyD6V+y2UkvkpgRfZZk4sK3YaXoRSCeEUyEYSEaR2w2+9yVR+Iq2RmMruPSnvYI3yin8pHJRcgCKRPyK7JHu3CxVV2eS5T8yxgfCOvC0gZ1k6w7w9ko3mEivfLoKGOau9GNIG7vpGehkwgTHwTVGOkV1FHnr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NzXsmGCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NzXsmGCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C12DE1F000FF;
	Sat, 12 Sep 2026 14:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221978;
	bh=rq+YEr1U/4ugDn33CzWqTyL+lr7Zb1A5a2s/g7PGqWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NzXsmGCs4lAeDNkKQ0sLA80cZHP/Vi0wZgPjwjtrjhh6+4DDIeOXI2HyOVb5yxyl+
	 se7IHFv40hvo/3LY5OpHyYa1zLAcwL40w2dnFwKEfPnf+raJs1VkD8mbR7F3FwYsJf
	 OcKho5GXBT0pKy4CnCE06lK6Qfl7zs7iDHcRpRKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.6 0494/1424] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Sat, 12 Sep 2026 08:48:46 +0200
Message-ID: <20260912065618.353841031@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nilesh Javali <njavali@marvell.com>

commit deb8abde83a799d2501f3977f6d6051000253f5e upstream.

qla2x00_error_entry() reads ha->req_q_map[que] twice: once for the NULL
check and again when assigning it to req. The map slot is cleared by
qla25xx_free_req_que() (ha->req_q_map[que_id] = NULL under mq_lock)
during queue teardown, while the response-queue interrupt that drives
qla2x00_error_entry() is still registered (the IRQ is released later in
qla25xx_free_rsp_que()). If the slot is set to NULL between the two
reads, req becomes NULL and is dereferenced.

Read the slot once into req and NULL-check the local before use. mq_lock
is a mutex and cannot be taken from interrupt context, so the single
read plus local check is the appropriate fix for the reported NULL
dereference.

Fixes: a6fe35c052c4 ("[SCSI] qla2xxx: Avoid invalid request queue dereference for bad response packets.")
Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-dev@google.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://patch.msgid.link/20260730155838.2119230-17-njavali@marvell.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_isr.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -3815,10 +3815,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha
 	    "iocb type %xh with error status %xh, handle %xh, rspq id %d\n",
 	    pkt->entry_type, pkt->entry_status, pkt->handle, rsp->id);
 
-	if (que >= ha->max_req_queues || !ha->req_q_map[que])
+	if (que >= ha->max_req_queues)
 		goto fatal;
 
 	req = ha->req_q_map[que];
+	if (!req)
+		goto fatal;
 
 	if (pkt->entry_status & RF_BUSY)
 		res = DID_BUS_BUSY << 16;


