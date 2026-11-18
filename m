Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039510;
	b=FCO4D61lu1PGgYT1kdwA4ciiQ/6cZWPtwyIxaVdIL/5UnuIKtYaNqEapG8JaJWTSc/aB
	 uOuNBtc5SFzM8BdZg4HK3wS+kj1cbQuehGbAv4G43nP9IAw1nYKX1mNf60WZKXXTy+lwN
	 olPay6I8Ogn5pXKx67RPRpFYb6hFPssumdfrSiSdG30thWcFuBpoUT2YI1wONMkLR8hGh
	 zdbtAjtbWewtkeyj9lYAkpobdtG16oJomIbXE+LN2GtSQXf1/0QIqkLmkScMh1vzsIzUn
	 OtulCC+nDLLxm1b4wtR0/CZMcWvx9mEfkxDBda1sE+q24+udDb+jhRbj79guUNjswFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039510;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BUjmhrdKTU4j59eg57a5/NV4qfiByOZACqaAm619sp4=;
	b=2udEvsYgAS+ho5fJd2Z7q/ZwSWyfHw0fbVZVJzPnEGDqPJjt0PyKKsMt2cxcs5LxINSK
	 FLwPKcVu0SiaObOySc5BmUCKapl3ZaEsi5O9K+i0kUS/zIfrYyHCuA2dIgtzHBUfs2cwk
	 nMp04jzfAM4dzIkE2FfODdvdx6QHrr+MjvEatfuRm37FJfpjoowv7DV6MFcSG+U8P/Pmq
	 q/Y4xr3PnWgA5Z8U5JmfPIEiQR0eNfS6XVSnoZJhqavg8C2bj+KbwIj/7JQ32JPyu6nm4
	 sWHk9wRNSgOHSPCqENVBt8t+LeUZSYThRemXIWSyrx9jY3k4FRJrVhjACcBCU35YGOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWhh5MV2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80198606A320;
	Wed, 18 Nov 2026 22:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWhh5MV2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D02DF1F000C4;
	Wed, 18 Nov 2026 22:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039510;
	bh=BUjmhrdKTU4j59eg57a5/NV4qfiByOZACqaAm619sp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWhh5MV2KFG5xsOP8qK3N1xg833Bb95+FducDeFxnCltCPE2rmucEM1njpUG73SFa
	 H2Qc1wgZvOZK/Yh6u4eWrsfBcGVY8//dlhSVLlEjEZvAJ2RN9dxxL0H1rueawrUjDm
	 QRw9+4BuNYE4stOowHq+0Ci0atcEvbz/CozGhbj0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2125/3318] scsi: mpi3mr: Fix out-of-bounds bitmap access during device removal
Date: Wed, 18 Nov 2026 15:45:47 +0100
Message-ID: <20261118150425.812194008@linuxfoundation.org>
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

[ Upstream commit 5dade59551d344d0308256edfef6bc3fb4202eb3 ]

Device handles reported by the controller are used to index the remove
pending bitmap and to build a task management request without being
compared against the maximum handle the controller reported.

Check the handle before using it.

Fixes: 13ef29ea4aa0 ("scsi: mpi3mr: Add support for device add/remove event handling")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-9-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_os.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
index f257721033841..c6d59c3d09595 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_os.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
@@ -2172,7 +2172,8 @@ static void mpi3mr_dev_rmhs_complete_iou(struct mpi3mr_ioc *mrioc,
 		ioc_info(mrioc,
 		    "%s :dev removal handshake completed successfully: handle(0x%04x)\n",
 		    __func__, drv_cmd->dev_handle);
-		clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
+		if (drv_cmd->dev_handle < mrioc->facts.max_devhandle)
+			clear_bit(drv_cmd->dev_handle, mrioc->removepend_bitmap);
 	}
 
 	if (!list_empty(&mrioc->delayed_rmhs_list)) {
@@ -2286,6 +2287,20 @@ static void mpi3mr_dev_rmhs_send_tm(struct mpi3mr_ioc *mrioc, u16 handle,
 	struct mpi3mr_tgt_dev *tgtdev = NULL;
 	unsigned long flags;
 
+	if (handle >= mrioc->facts.max_devhandle) {
+		ioc_err(mrioc, "dev_remove_hs: handle(0x%04x) >= max_devhandle(0x%04x)\n",
+			handle, mrioc->facts.max_devhandle);
+		if (drv_cmd) {
+			cmd_idx = drv_cmd->host_tag - MPI3MR_HOSTTAG_DEVRMCMD_MIN;
+			drv_cmd->state = MPI3MR_CMD_NOTUSED;
+			drv_cmd->callback = NULL;
+			drv_cmd->dev_handle = MPI3MR_INVALID_DEV_HANDLE;
+			drv_cmd->retry_count = 0;
+			clear_bit(cmd_idx, mrioc->devrem_bitmap);
+		}
+		return;
+	}
+
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	tgtdev = __mpi3mr_get_tgtdev_by_handle(mrioc, handle);
 	if (tgtdev && (iou_rc == MPI3_CTRL_OP_REMOVE_DEVICE))
-- 
2.53.0



