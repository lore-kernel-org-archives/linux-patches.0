Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062642;
	b=3sSwUzSdlFklO/rAq2eIh7IbqcJII+nw0DkBu+6eBW6dqi2BZSmaZbOfGNF7m8PcnQ/E
	 cmtmBuAv6ojPyZTPmgqmV5ss4RRIJt2qDRu+aMrRIo30/MyedXKTbpk1WuWULyBF46eI/
	 uaespEAC6h178pwZKpl4K26eIeeWju/sNOEVU214RY+ULGiNRMLgwixaiGvu/1iSQsC+Y
	 eGsXTdwXpzKv214H26e9Cx2rT+hXujfj4od4fVLF/fYosBIHxITBghElnCdl1lmyRq4Ov
	 pB+WD9ZGR9eEU0t306gD6nIAeW3CdtNkiHBHI+gUfhfZCO94sGbjMhnLO05Ec0Oocnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gDWWzBrO2YGeW7mZtx60YEDRCBpsSBwKSG7GtI/+yFI=;
	b=YnuGV41ER2Ax+qdqS68WAIH5fTgGae8Srth97KmWWSO2Dt+X/skpMTTIXQTWzQqQmSnA
	 zeSW7WRUZFcA5oLhYUdhtVb/1j/V3/VaayBER+xo2nhFcatsABBjiG9HsiQKulRD4ZAMm
	 37O7rB92tDeiUCsOvZTbXjJgND5jyxzbW5M9z2PNxMT3xtWh4bS8Bk/MeLqqHzOqF0ICg
	 qC5ZC57s+BxxGauHZhXSiWAQbcMsQ5zZ4HCuXPiD7L1e1ALiUzN0JTuCZjLriYJzj9FPR
	 1h9pTpSa4d7SolpsTu0w4yJOBs2QW7NnEncIDk2WDFsKVCrYFqDYylUGv/MQI9J+NMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5Cftokt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47C25606A32D;
	Sat,  7 Nov 2026 14:44:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c5Cftokt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7AA61F0089F;
	Sat,  7 Nov 2026 14:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062641;
	bh=gDWWzBrO2YGeW7mZtx60YEDRCBpsSBwKSG7GtI/+yFI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c5CftokteFLGuzWihbs/cRKGw9hMD9LLH9oyuQ6w7K1R2Q4g97wme2a2k9dfBZU9p
	 r1SvITQCAm3r+BgT0QYa0mmy+jj0XUtkxkITr6bNZ43KcjeDSVY92PSAiZ+JH+5ylk
	 vSmxitvw+su5lrb6q67kBrNwxP1l0bhkHYeQMTAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Andrea Parri <parri.andrea@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1509/1536] nvmet-fc: only send read data for successful commands
Date: Sat,  7 Nov 2026 08:58:45 -0500
Message-ID: <20261107135040.247257744@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

From: Andrea Parri <parri.andrea@gmail.com>

[ Upstream commit 94f93c61b1a5dd08d011be58172ce4392b849008 ]

When a read command completes with an error,
__nvmet_fc_fcp_nvme_cmd_done() still pushes the whole data buffer to
the host before the response. nvmet_fc_alloc_tgt_pgs() allocates that
buffer with sgl_alloc() and no __GFP_ZERO, and a command rejected by
nvmet_check_transfer_len() leaves it untouched, so the host receives
stale target memory.

The buffer is as large as the data length in the command IU, so the
amount of stale memory returned is up to the host.

The tcp and rdma targets send data only when cqe->status is zero (see
nvmet_tcp_need_data_out() and nvmet_rdma_need_data_out()), so no nvmet
command can rely on returning data with an error status. Do the same
for fc. The ERSP then reports a transferred length of fod->offset,
which is 0, matching what nvme_fc_fcpio_done() checks on the host.

Tested over nvme-fcloop: a failed read command no longer transfers
data and still completes with its error status, and successful reads
are unaffected.

Fixes: c53432030d86 ("nvme-fabrics: Add target support for FC transport")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrea Parri <parri.andrea@gmail.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/nvme/target/fc.c b/drivers/nvme/target/fc.c
index 4e54681ab4936..90948e09b5d2a 100644
--- a/drivers/nvme/target/fc.c
+++ b/drivers/nvme/target/fc.c
@@ -2468,11 +2468,11 @@ __nvmet_fc_fcp_nvme_cmd_done(struct nvmet_fc_tgtport *tgtport,
 	} else {
 
 		/*
-		 * try to push the data even if the SQE status is non-zero.
-		 * There may be a status where data still was intended to
-		 * be moved
+		 * A failed command may not have filled its read buffer, so
+		 * only push data for success, as the tcp and rdma targets do.
 		 */
-		if ((fod->io_dir == NVMET_FCP_READ) && (fod->data_sg_cnt)) {
+		if (fod->io_dir == NVMET_FCP_READ && fod->data_sg_cnt &&
+		    !cqe->status) {
 			/* push the data over before sending rsp */
 			nvmet_fc_transfer_fcp_data(tgtport, fod,
 						NVMET_FCOP_READDATA);
-- 
2.53.0



