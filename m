Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048034;
	b=oeh91gWYeUAV1npiAC9N1if3tanw2djK+g84iwibiZ5fEQcCFXDuvzYt9b9s3ek8fEYA
	 B+wwtNYRqHW37vzLk0dKf/KBBSKdKEN4QplFDn2FkWSjWV4yz+MAmSmuXjJYUohvdiFMt
	 bcL65zEOoNV9xH3gW2b23sszfjgaSNr6/AiMara8kgld7bPIUWecGR85Vher0AuF83HE3
	 fB3DwrIsNtjTGK5F79ipQx1CUeomzRJkz5ZbRf1S5T84KlYxb2ppIIHYMEm0GqdnY5Ioz
	 khS0y0495uShjN2nW/e4DD6MVGCur677b5K6JwWi7wiktT0AyQCk/fxaTKsyVxe+uxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048034;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7W1iwtIPqQC0PRGvuv+GQDxTLGjPIo5cH8q7CPkPZgg=;
	b=OaS63UhtIkJDbp7V/yekTRQ1Or6a/dhxEhGP/EdOwKbz5sRomQet/Efb5+O6j9vnGclj
	 hcO8oqgNwBOJ5hNX0AFiB0We7VxJzKZ3rrj10ZbvhuUyogFmw38WaMd1kVzA34h2vHs9y
	 7M1lDW3CqODFWTZUmpnnw8521lcECX9JoxvZfEmjvje6NnVzxz9DOEatIXfojh+lq8UJS
	 Ps19G4aGeb1eq2pMfBvBWEmDEkpV3K4f+9c3PmM2HVoGYsq0j9ZhNhtnGKPYuOzcjzz8j
	 Nsdh7gtsmyyS3LQbefBcSyEqxbB3/HuQVJ5l92bVRuNBQloKwlGLq0c9OA1vgddOP1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7aKb7Ge;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C92606A325;
	Thu, 19 Nov 2026 00:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=k7aKb7Ge
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4B2B1F000C4;
	Thu, 19 Nov 2026 00:27:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048034;
	bh=7W1iwtIPqQC0PRGvuv+GQDxTLGjPIo5cH8q7CPkPZgg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=k7aKb7GeUTSoY5/uI3GAVJjPDpvkwRjRlx/lytkcjvYUuaC5Qr2aWCUgfIXqe6ymb
	 Tz8PFPFBVYy0ziW6X/USgw4xCF/7G4IBxWhRf4fIZWrd7ighFcj/a1wkTUXU+ea1OW
	 E8LCBDA41liMOkrp3pQZSeX3Lvxl0BHF6jh2RQSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1850/2857] scsi: mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 18 Nov 2026 15:48:04 +0100
Message-ID: <20261118150307.853693801@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 68d4d9b42f297..91cf32ba55256 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -1448,7 +1448,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -1457,7 +1458,12 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
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



