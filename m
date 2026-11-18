Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023330;
	b=tYPX64NqiTVTz2CwNTAxRTFVcdj1q8Q3LmD/g/zLOHj85YUDnLh7RpbYFS5AaLU2ofi/
	 A5OYtKtUIPUpe9quRSjr7TuciZ09WxpOQ/PDkXOtiqHJ8yqpTfFh+Y2qNGiCcznXGQmKo
	 MD+TM2GbN0RFiveyzvPoob1hCfGDsKWXs32Q5UYBncXJDYP+8ScLTaK6qgTSfWr+8tKPq
	 67/LKVNNiLtuaTK8mE/i1WYW37zpkdiiR3O+/6iecAXGyhOyzo4v9aYrG1H91GkMhpxnX
	 kyheSD/JGjQXLTDyngg8f+M4bp9zwcnl28yjC+Po6gNvn67RKhxoiBuNlYvoAxvsxhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V/Lj79joCa4mh0ryHQMtm4cStkXTU3vqQBHU+TSjbTE=;
	b=yrYQ/tkqpo736f7BisKPESqUOQO9HY3d7CNDkCFX2Jxbw8q1SzL0+776y/llQqHi5+Nu
	 gIZYh7N3Yqj7N78/Auvlx7vJRoB6G2vWHzvpdC2IJtl3ZoSMJA/9dgMHOAGYUlA9BwsL/
	 x0TkaJm5HPHzGJToTM8Gm2/K2Y/nmyv9JGTDcJGbgbq3fKjx2O6AabYubylORdJJmbWfu
	 pU0sszg4d3YxIg0B746P6Q/ZPFH5jpFPnDU0xOTEa2v52m+ga4WF2N49R00UfrQ5tQtTT
	 cGwxA16fkcJ0DMjfGBkwVLWXP1bhj1wvmMXrRvtOZec6okLmd5Gx11JCuXBPxNH9f6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tm9Pf+o1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CA7606A325;
	Wed, 18 Nov 2026 17:35:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tm9Pf+o1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B40C1F000C6;
	Wed, 18 Nov 2026 17:35:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023330;
	bh=V/Lj79joCa4mh0ryHQMtm4cStkXTU3vqQBHU+TSjbTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tm9Pf+o1H9kU2WB+H1ieNWRs/GgyQB0gKckD598C3ArYwjHZW+xStsbVc0kuWhQMv
	 gzp7K7OwRp5DmRYeGvH67nhpaEd5NlVSl5S2TqvNJ454IWeq8Kq2oJqq525tKdBn0M
	 +plIMyRdIUTxj+Shc8o4nAr+o1WThxvC7AK4vXuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0330/2151] scsi: mpi3mr: Fix buffer overflow when caching log data
Date: Wed, 18 Nov 2026 15:34:25 +0100
Message-ID: <20261118150134.014759797@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 653844ab2aac4..552db18da1219 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2947,7 +2947,8 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
 	u16 event_data_size)
 {
-	u32 index = mrioc->logdata_buf_idx, sz;
+	u32 index = mrioc->logdata_buf_idx;
+	size_t entry_payload_len, sz;
 	struct mpi3mr_logdata_entry *entry;
 
 	if (!(mrioc->logdata_buf))
@@ -2956,7 +2957,12 @@ void mpi3mr_app_save_logdata(struct mpi3mr_ioc *mrioc, char *event_data,
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



