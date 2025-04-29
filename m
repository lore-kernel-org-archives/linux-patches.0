Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8993421ABDB;
	Tue, 29 Apr 2025 17:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947778; cv=none; b=NSfWj7elF8JU+AtuS4nWxsKBi4EkOk60yef1orINV+xXGoQtE7+rzDGwXQgjmDacp9MsQWZtgzkm+rwmIE6KM3LnNZssbp/T+jr3NOT7Y4u4jct/3/N7BFg+VdyR4mYLu37EA/s9CnD21jJu0P0gwdTA2Bss82mxQfGytPlORVY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947778; c=relaxed/simple;
	bh=EtztFZOfDygbVXJDExWb1XxB8Xz1fWAXV3bps7lOxlg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fjjmwHxhIZML4ZDOMK9YK8fvVsokdIRb/MYBIMAN3DHb+ZtWB42LyOfVrr3g7ONf19yt2Ftym+WAJ2Adbx+L6s4Yaedbb7EORq8m/IlEMG8Au0yK3tUuZVR1QXzVyemoydLveL27P0Ug+S4ILBvAkL59uWs3Eh+cg1WHuUu+Y/0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MmZsOID5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MmZsOID5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0374C4CEE9;
	Tue, 29 Apr 2025 17:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947778;
	bh=EtztFZOfDygbVXJDExWb1XxB8Xz1fWAXV3bps7lOxlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MmZsOID5ppByCMzG5raZjFchq7rhfNI6v2azF5DDDU/0KE57WxDUYg56WzFSBh9UE
	 VMvr/jQzSUdCVWHofRQC6VefVzdqnoOH5Cqx/FKhFPTHVzZcWrxj3T7irsChlFA67U
	 BaWJ8Rmva1yBjGohYWUqBq0eViZsZ2Z8EyCJWkeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sathya Prakash <sathya.prakash@broadcom.com>,
	Ranjan Kumar <ranjan.kumar@broadcom.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.12 100/280] scsi: mpi3mr: Fix pending I/O counter
Date: Tue, 29 Apr 2025 18:40:41 +0200
Message-ID: <20250429161119.204611271@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ranjan Kumar <ranjan.kumar@broadcom.com>

commit cdd445258db9919e9dde497a6d5c3477ea7faf4d upstream.

Commit 199510e33dea ("scsi: mpi3mr: Update consumer index of reply
queues after every 100 replies") introduced a regression with the
per-reply queue pending I/O counter which was erroneously decremented,
leading to the counter going negative.

Drop the incorrect atomic decrement for the pending I/O counter.

Fixes: 199510e33dea ("scsi: mpi3mr: Update consumer index of reply queues after every 100 replies")
Cc: stable@vger.kernel.org
Co-developed-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Sathya Prakash <sathya.prakash@broadcom.com>
Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>
Link: https://lore.kernel.org/r/20250411111419.135485-2-ranjan.kumar@broadcom.com
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -563,7 +563,7 @@ int mpi3mr_process_op_reply_q(struct mpi
 		WRITE_ONCE(op_req_q->ci, le16_to_cpu(reply_desc->request_queue_ci));
 		mpi3mr_process_op_reply_desc(mrioc, reply_desc, &reply_dma,
 		    reply_qidx);
-		atomic_dec(&op_reply_q->pend_ios);
+
 		if (reply_dma)
 			mpi3mr_repost_reply_buf(mrioc, reply_dma);
 		num_op_reply++;


