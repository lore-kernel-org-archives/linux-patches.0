Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039499;
	b=2l822n7kSMrNZghhulq+Sf+Z2urNALpRTKx8U3+OMpOU6myuZSN9yDC3XtuiB7ErATDz
	 nfztYgENRD2Z2tWyWi1BWsR+ILK5OPW4f4PzbVAxf9RqkprPGrOIARQjMP/SNuEVpj8cQ
	 h35MI0aPU+kNsM4t84X6Rd4j9gPM5ol1Qiq8zL4IWX9OPnra/9lhpXTcXkKYf5XY2lBJJ
	 XTlD9ggANSleXAGLy2DwbsVgcm4QwCRmNLfHKi17xEO7KykQxoje15Z+QcNXXLHx2pFtF
	 B1osA2mQvBBdPPmc2Dy8qpe3erqoUO4OU+okZABBbSVEDErfI3brN1afIW1NGCpMMEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039499;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+xMfon10DtEaPa/qjRn4ZB8WZtRz+vZ6/bsfQFdFS7s=;
	b=2B0MFf6l7fXPHEfhGlfCHsKVrpO4VTYdwOkwqii56yNYVekxEKIyx60qHRtakxacex/z
	 P2ocKq0it4+GIczCwhI+XBs4G5s606946Kqy3JkhkpMw9uVyM/c7ekioOlU6ursZfhDBD
	 m4zbJr4+vwHBALSfAwa+UtNn9QdrVL1NMiVlrU9kK9dowjlwO9cftR1TKjirogjssutGj
	 TReN3IuQg+/ddO7a1IleCrLUecQ/7gD4eaZCSfSOwubIXbuOOPxHmREn7g9O5FZQy08eu
	 X3Ny51pjF6Y084+uITizEpB7A3R6nzojPfuggRSuJgevHj2+XmyE0asljAOR0L0IkPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLzl21sK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADCC606A325;
	Wed, 18 Nov 2026 22:04:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NLzl21sK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C4311F000C4;
	Wed, 18 Nov 2026 22:04:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039499;
	bh=+xMfon10DtEaPa/qjRn4ZB8WZtRz+vZ6/bsfQFdFS7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NLzl21sKd98bhtcRwEbUpcSN+JqkI4/z1M7mvTZetRv+Bpyo7bfO7WPylFCQaLzG4
	 j7KJpQhttRhB0nXKV/I7j5wirQyr6f8bLQU8LZFf6X05ytYCBheDUr6VsMZFhYfOd7
	 K01iRO7OXMb3xh/A6NjxAQMXhiaaBX0ikDmoxejY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2122/3318] scsi: mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 18 Nov 2026 15:45:44 +0100
Message-ID: <20261118150425.719503836@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chandrakanth Patil <chandrakanth.patil@broadcom.com>

[ Upstream commit 9ff1af19c488efad66f2b803eefa0abd5fdac8f4 ]

Each log data slot holds a header followed by the payload, but the copy was
sized against the whole slot and so wrote one header length past the end of
it. Subtracting the header on its own is not enough either, because the
entry size is derived from the controller reply size and can be smaller
than the header.

Work out the payload room first and clamp the copy to it.

Fixes: 43ca11005098 ("scsi: mpi3mr: Add support for PEL commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-6-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index cbe3c6f04b353..6ef3a8b1f805b 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1449,7 +1449,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -1458,7 +1459,12 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	entry = (struct mpi3mr_logdata_entry *)
 		(mrioc->logdata_buf + (index * mrioc->logdata_entry_sz));
 	entry->valid_entry = 1;
-	sz = min(mrioc->logdata_entry_sz, event_data_size);
+	if (mrioc->logdata_entry_sz > MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ)
+		entry_payload_len = (size_t)mrioc->logdata_entry_sz -
+		    MPI3MR_BSG_LOGDATA_ENTRY_HEADER_SZ;
+	else
+		entry_payload_len = 0;
+	sz = min_t(size_t, entry_payload_len, event_data_size);
 	memcpy(entry->data, event_data, sz);
 	mrioc->logdata_buf_idx =
 		((++index) % MPI3MR_BSG_LOGDATA_MAX_ENTRIES);
-- 
2.53.0



