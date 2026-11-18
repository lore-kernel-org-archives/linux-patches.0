Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023339;
	b=GXndlea6QeuVgXQOnF3i9hXtiaJO7VtQBeHzXW7aXAc8yZHKqXi25zfF3MdgxRGZLUaO
	 buLT6BQrVYAzepCNHpLA6Z7186u8SGweqTPgYSdX64SjqtzJ4ID4epSrb6NnmjTEb2E+4
	 7Yyng58+xDhe4F5x37Mr/n+Yjsdycx4VyvOKjNKqXnawQyeGfgZp75B1Edx0mvu/Ezu/o
	 yaqdKDHa4RqLqBRPjsibjaFu7rVLtfS5JyYmUQDPYmgga91Y9cS8g5VhpSRbRXwOtUdoC
	 d37Ccsj2ErosDgNWPaPpZuaBccgE4PY2GkBXEfcA9wRFIL5ZNxThKCKbUYDIYC/24JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023339;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=puK6ZhOFxzDTIRQiw8SOe0xN73eZIT5fFLkHbWH28S8=;
	b=PYPbuja162J4ugKhWy0B78ZoM/jbz+IY8pua3+c+kh0znlhtM2yOjpxF6Ug12vZAWCNs
	 x1Epz9BXnRtrBv9oczlQE49Iyu/lA63UtIIROzvWcueKEXnFC4L3pustTPqtOrPEbxYVI
	 ZUwaNIzL+UNJjK4l546ghRxn+J6f/c7SNg2Q00J7EwzdkgB1q07VvyYY1qzWhxIlrPk3m
	 WP2tuMVr31vfMIIEH23Qu9ECCl/Q8ysFozPw8tUUv4k2MuHE04N4zyT2zcnLewfauLmXh
	 0yhNBxdp/JB7cde58VBufmY2N2cUmWksGXeVZij2hCcuZ1Qg2zzdm8MiS2XxRzUEckQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwjEGWal;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28E9A606A325;
	Wed, 18 Nov 2026 17:35:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KwjEGWal
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FCCE1F000C4;
	Wed, 18 Nov 2026 17:35:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023339;
	bh=puK6ZhOFxzDTIRQiw8SOe0xN73eZIT5fFLkHbWH28S8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KwjEGWalQxyu7cE70bo6VpLFAUGPHNSTxZ6WurTUNestMWZ67mQDLRD1M/hW2V5ue
	 fVLAnL/Pm3Isa+I54aFxsZK0QX5L6EEQcydgBjprgpe5vftfouO3QPYIH1rKSVoDZR
	 VdjsL/54ZVabfBWmoRzPZ83is8quD0zSr6lLNh4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0332/2151] scsi: mpi3mr: Fix out-of-bounds sense buffer access
Date: Wed, 18 Nov 2026 15:34:27 +0100
Message-ID: <20261118150134.088574175@linuxfoundation.org>
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
index b83bb6027d578..d4db5a747198b 100644
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



