Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653D248F844;
	Sat, 12 Sep 2026 18:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238159; cv=none; b=b9jgiXIBw/D9UqQDmL4Uz/I91mrqTWl5zzNF2syTyVodHeiNUQ2BR+y7ROxuUNnmWepE/L9d2ytvOv091+2hl3XTLSlUCq6SRgVTZjcUk3gFVtxyOv7qLhqiblvGrHuOQ3DmKB3Mvezkn8WfmHJJuQwE7POPObwhhKjuzfP8gSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238159; c=relaxed/simple;
	bh=Q1KAzG1H38GLYurkHt+pNcfdiMpZi+tsUoYyhiZM2dI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K1CgaPul+Zm1xVJnVcC6R9Yr7kR2CtqkaxSj5kM/pYxd59RePg9qz+sMU6qowCGuchmMxuUC4FY4Hkly7PJmaz5vrt4K9c0bza13uSc+bI5P8cyLaWsPZQ20yZB+kUDePhkR2gf9gShYC0dkFP4rzCPxQEJ8aZ7j/zgOnj7yNVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CO9VFzLx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CO9VFzLx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 319F01F00893;
	Sat, 12 Sep 2026 18:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238153;
	bh=dqDlrJJi6UTZ25TaRGcbpXdnW7yCRsRSNc9G1efn/q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CO9VFzLxiNa7dlYrYGoaX624YxgWfMY5Xct8Syfq6O2DRp4x6AOl9t5mN2ShHESYG
	 9Bi37+vjP+uUQXA64snEo9pO/RSUlYXPThu1JweQwRfZLsYwqCvOr2WV7gXrMyC69k
	 2nakATp3LD6Q463rxkIxRBbnGxjNGd+frzmz2dJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.15 351/935] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Sat, 12 Sep 2026 08:56:21 +0200
Message-ID: <20260912065534.858736231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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
@@ -3631,10 +3631,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha
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


