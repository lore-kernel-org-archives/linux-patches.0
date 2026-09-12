Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAB43176EE;
	Sat, 12 Sep 2026 19:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242159; cv=none; b=Q2jiVeB7UEpS5dHNsg9qUz/aJjcpJrHf4LZK2E+aRH6CLJEB1ap5qXKvIXyOH/TDEp9+k5fptD7pUMGh7VsRhaSsF4eAGkl/xat1MhvhJruQPVmubcCkJOwNCUJYBTs3RzHF76+PFgPxiaXaBOd6P4QScOvZp/zDkyXfK8c+8zA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242159; c=relaxed/simple;
	bh=ajrNJff9YFNvZUPkA67VtrLmHgQ4IzETAtvpjMICkf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ofjznNvH4H7sOtyALjE5Ah/fVQtt+5lPvDZwFRb0S1oiRfb7ibNOH92NDYit088t8Dzkfhc4siVq2rKYqPBF1X2g3ou3CqJ78jzmNJ3nSwX2i9mgPQ1fgmwUBBhOCdWB4OaecfqQ3vXA0rU0Y41o0krXtlfMtNyHok0U+Ga1kK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TUmCMvfy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TUmCMvfy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97FB21F000FF;
	Sat, 12 Sep 2026 19:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242158;
	bh=jHqrjiwS1KGXM94OHwAgnXK8AVjWjadEiIMOu57Bt+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TUmCMvfyJsyv4M+e2xCHkzyXb+wZUCUG3hTo1d43upxC9Qkh53lbsEt8Mn6L0mmvF
	 0x/mAhpx/BP6WbScUjcJJOG36Pqa70bYXzZkSu95/O0aKH8cj3uM8enffQ2E81eEe+
	 gYdRSJB2fnefju1Z0bkKyXXApq9zZ53pOiKfOjEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-dev@google.com>,
	Nilesh Javali <njavali@marvell.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>
Subject: [PATCH 5.10 306/798] scsi: qla2xxx: Avoid req_q_map double-read in qla2x00_error_entry()
Date: Sat, 12 Sep 2026 08:58:54 +0200
Message-ID: <20260912065524.173360865@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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
@@ -3325,10 +3325,12 @@ qla2x00_error_entry(scsi_qla_host_t *vha
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


