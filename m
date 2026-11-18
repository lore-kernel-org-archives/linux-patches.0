Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029305;
	b=JQ1Iy6ULegBpOnrtcoNMb8s/4pAAf9dmAaz9f506Mgf9xPJhhYIPzAVRd5lPts9R8V03
	 XTkKhiGW1TdroPrT9kRfQJMTJlm01PxEcltwBsYfavjKU97clE74VJtOkqfq4TSLmQcgv
	 fWwuo6qnG/My3BM3nSYqVe/bcZqWjBY4su/wEUCZiaszzxTC5pEr2QOiwBcCyDwH/peFe
	 Ba5Vbvhx4SvbW646X1Prxtq6u7jXye6IbLL0OxHCNbOrd8lOYQ3Froz2MGAxVvLd5V5+Q
	 xlsZozUYBAGr6yC3gijyPab9vczwXg3E3wGkOTQ7BeTBAeq3xaacVXPNCNw2h//dJqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zbrbSo4UVgBNyDWhZmKt0VcG9SsDvW79DjsUMbNYvnY=;
	b=rsLVIPjA87qL6TSHAGIz7KP5xPkY0PfI0qXKsd51YeirZKbCwld9c5UcaOol2UKfsebg
	 7Amafz79A1iW3QoXVF60qcTCrMRR6ug0ekYEWh4L91sqpu0WY8lHz+EQhTAmcAAj0JGMo
	 xO2qEh3bKJ/TW+jxBrFzAXfKnfivcsSJaHk8Tss/Ujf8/TyqX+G1C52+I3F1pDeHv7ANd
	 XwmjYDdyF2Rb4Lr1/KDy82kbPWZW/vXlY5/oLfWCv/Rjkm/lwXqcWuJKs3bWMO3yO0zp8
	 CcM+prUETWi0tw1vQMWB09CBDGRPkAE2pwYgtNRXvm2p4YYU8pmp9qAM4hxvY8E1u3g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwgH7duQ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962E4606A32F;
	Wed, 18 Nov 2026 19:15:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YwgH7duQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECEFB1F000C4;
	Wed, 18 Nov 2026 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029305;
	bh=zbrbSo4UVgBNyDWhZmKt0VcG9SsDvW79DjsUMbNYvnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YwgH7duQGOWKcQnkY3q88axJ4I6bNrkxcwAfos/8xnXLhyt2YEfpL0Fi/e2QGPHON
	 U/dUJMA7wZLXRvadDaQmILO5kb/Az409Z3N7BwEJ132zumxuFjhZVVPJudgiKG6oQo
	 MtiDAQIqPSJLL62HaZPv0ELhRN1C7IUIpZe/hbEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0302/1756] scsi: mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 18 Nov 2026 15:40:29 +0100
Message-ID: <20261118150020.374849246@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b51dbb4404565..3c409b3fdd925 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2862,7 +2862,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -2871,7 +2872,12 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
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



