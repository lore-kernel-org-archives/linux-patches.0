Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048040;
	b=Mm9/b4WJ4dNc+l1qH8SACh23EHT7AdCA8aI88+av+slR4oi95rEIk2L7H3gPEHG2o4AL
	 DLgw2LJN1WLP6GETX/jdzvtgyou88IGLktQoj7s4eMfogqrg9nNzOxDXQGE/5bqZ1aGcx
	 uL5EFXbiDPgqQSE+Hkk0tMnqpRdmj4EuU0YUiXcaP87jO/FvnwxjbmFGBRuxngsjbmuSn
	 Sn71w1tjSV/cmKpq3JuK0CY8FLENZxopcE8ISqzUNJZS/xmfCQ+s1e36Y/xs2+0qPOwI4
	 O1Qz87q+HXY+0pBqXtLQK+BYSXZGs10rrr4PkS4s0Qs/b8RXA1/eOtkS3o8ka7EQXbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048040;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LfDGyxCG5C829O+73P3wtw8AQjkh1xGaxQa2K0jSr7c=;
	b=uQyGYv+jzH91Zg7Zo4MY35sqwdNTrRYprzldPXDUO0is6n5AkAgPmzNFU24mbYvmjinX
	 eurnaNt1hUZ6fxtNH+uXo7QLm1UiaVc+/ayteSn54pgoRUvz6lmYlNdywl/maaoVUjR3e
	 mImgBbLXl4QakNjHdKSzMrBZdjWhphw5cTWJ2rZQlxtQPcRV8jnRk5/9nq5Yb+mWDLP5/
	 R62mDaQJPvpPOSzFpe9U6eNuqTcGb9WHUcdmujXxTKj5WhQsPiQ0LXDknHBhUwMAH4lnN
	 KyLmWAfkevsAM/4Pzd5lWstFbTgWBtzKjDnaJc0sXHosIOu3mEyHEBzNfvjxqk6Z02w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIqMKTIr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFCB1606A320;
	Thu, 19 Nov 2026 00:27:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nIqMKTIr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395731F000C4;
	Thu, 19 Nov 2026 00:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048039;
	bh=LfDGyxCG5C829O+73P3wtw8AQjkh1xGaxQa2K0jSr7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nIqMKTIrEy9pqpNjAzP9HtMYjalCAhEGpVrokcsPOeqUkSXj0lGuXDh1DV1SnoDHC
	 tzMEAxxcqdGVhxVZ2vik9AlugmKXNmgX7j0k1o429jBjUYkFsW5fsDOd9DuEn22tmZ
	 W2eNARz7XIiKwJdykd2aLW2h7BPKbY475LAWhjMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1852/2857] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:48:06 +0100
Message-ID: <20261118150307.925745913@linuxfoundation.org>
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

[ Upstream commit 7fea128f6b829ad834f21834d2605d28a45b903d ]

The sense buffer address reported on completion is turned into a virtual
address with no range check, so an address outside the pool resolves to
memory that does not belong to it.

Check that it lies within the pool and is correctly aligned.

Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-8-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_fw.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
index 11ac22947ca07..b173001d3344a 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
@@ -137,9 +137,19 @@ void *mpi3mr_get_reply_virt_addr(struct mpi3mr_ioc *mrioc,
 void *mpi3mr_get_sensebuf_virt_addr(struct mpi3mr_ioc *mrioc,
 	dma_addr_t phys_addr)
 {
+	u64 offset;
+
 	if (!phys_addr)
 		return NULL;
 
+	offset = phys_addr - mrioc->sense_buf_dma;
+
+	if (phys_addr < mrioc->sense_buf_dma ||
+	    (phys_addr > mrioc->sense_buf_dma +
+	     (mrioc->num_sense_bufs * MPI3MR_SENSE_BUF_SZ) - MPI3MR_SENSE_BUF_SZ) ||
+	    do_div(offset, MPI3MR_SENSE_BUF_SZ))
+		return NULL;
+
 	return mrioc->sense_buf + (phys_addr - mrioc->sense_buf_dma);
 }
 
-- 
2.53.0



