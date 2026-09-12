Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDCDB29DB64;
	Sat, 12 Sep 2026 15:55:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228548; cv=none; b=bONvMCKHv/hP8KjR4SKG/17zn/dUk6yWqJgiU4wnDfeAOhZCsAVEJHe0lDf519qtGlPx4tzr5EpwBN5zPru4B7qwX8k8CGpBxE2Sl68I9Fbob6gTBG9UyyM98CESYcVWVIUH3sO+SlPBIb8Gwggukrx+GhDFg4ENm3jKsw3PuLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228548; c=relaxed/simple;
	bh=58j4spw2euLaQuWVibD3UUwRA2V3r5zXkN7lYS1kH/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N67dhtmDajMdoxcQRyLRP5rT4HbG6/rIpHF8wSoe4KqYf3ArytopqWZZfCFu0kL84DeyZyi+BwyeKoowKsiGPSRglw68nRCBxUW/4ma98Dz1rOEZEOB8fF/oT56N/nhrxGSvOaO0CnAFaE39PBa6vPwbMLfm1uHCr9q0qOjKEVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RIVicajl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RIVicajl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6ED41F000FF;
	Sat, 12 Sep 2026 15:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228546;
	bh=5QqUMXtulbXtb53aJ980WUHndfMvIZELeO2z7QDzYdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RIVicajlzJiDmq7A4vG0orUPWaA/zRKJkvmd7k3WsOJHwkq5NcpllrK0vIAzSuC0+
	 nmLJ0/6GpxiDMnHWH+3zSpGDZXk3kKeo+w/rC+8+08kcp86h15QuZ7AKgLjwxmonc+
	 EBcX611N6ZXqe9bm0hJ5EQRWl5zOXlsCaRmDyz18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 6.1 0406/1191] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Sat, 12 Sep 2026 08:52:14 +0200
Message-ID: <20260912065557.359088641@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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
@@ -3661,10 +3661,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha
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


