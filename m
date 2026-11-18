Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015897;
	b=DdggH3kcor48qhJFN1LT6wRBUIPqzEx/Fh9CMmSzi8umhpUiZkDors3HdJCKD4TsbIXK
	 2uANu+69nNAFMthQtOWN3xC6N8cFNG19QsiW9Wut+AAYq1tWqInEMDeBdLzRdiRWrQDCf
	 o4qogJG6tS9pVyp8u0hVXIC+JQygLlfzbaQ7d3XO1d2Tq83+hW0HPawpQW6UC+ZRt5Kcg
	 t5EHX3/xMWU0d+RBniE9C3ci5apS27pfBxpo0mjeNZcL5D9eg8hb2ZWZfaa9r/4GvULFi
	 pWnOq7tImvRuCE7Vi1Ygm1A+xafHwROnGb2Aop4cCM8HdBRxxpT4T2QzSEr77SsXz3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015897;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NlQZ5ZxrUWKCfVsOWrmyTnMSG64akYV11gyz6fUg99o=;
	b=Revy2kugm99jFCBdFWJ2lyFIxdzMN6I7jgGFo/hxZ1lNt5Iok62PBGbGEtqYLeqZ5hFW
	 iW3I/n3NPXcIBhIVENfJc4UOtMqVoQyCZpsJjvG94ehjLP/VDllwSORY6HDQu8oWiq0QP
	 c2Hl0GFN8cR8O992ippLSflio9ROdvAuCeBbRXThSpW83D3IVIK5TgJVbi7FaxJQOXuBY
	 mc82JUGoFV8nr+0dpLitw/9GNTRXByalswPo5eui28qXPdLdZrOlDC+xjotq56080R+Mi
	 HNiznt6ewt/1KPocyCJIbVJlWddrBjHwgqPXqfDzE+2+C4H0cT9COv5A5BiP190Maeg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFy025R+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2090606A325;
	Wed, 18 Nov 2026 15:31:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PFy025R+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583211F000C7;
	Wed, 18 Nov 2026 15:31:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015896;
	bh=NlQZ5ZxrUWKCfVsOWrmyTnMSG64akYV11gyz6fUg99o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PFy025R+M5qug3AiRmMat+w0BkZwbwi/I8GzjP7KbmrU1DrZIhGzs/OU0mLY5tvH9
	 MaPDeOmY8iH//cSZrvPK8RrX12UW/rt82Vtr6qVZrqY/M9dNwbLVjTHgIZW8OxW6eq
	 8HivSHILmw+tPmmlDcE6uMFrlHevn9/DFF6wixxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0334/2651] scsi: mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 18 Nov 2026 15:26:14 +0100
Message-ID: <20261118150259.882593656@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index c3c0469593d6b..4f99678858023 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2947,7 +2947,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -2956,7 +2957,12 @@ void mpi3mr_app_save_logdata_th(struct mpi3mr_ioc *mrioc, char *event_data,
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



