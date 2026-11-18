Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048023;
	b=wOMJ0Z/+9fXFtUfjahpSYBevclpklnnAmVCJmB0PbZ3KyJztjO1X6W75KxhWABkR+5s8
	 7oOLd8US19STA8CfDjo+cuQXuXwDaWdrfOuss7PdUQb5KWbK3CG6rnLG9PgTebydHQ40Y
	 QxQtS+H9cD879ua7f0Sc4o5E7uYk1GpO4EKz6G3Rn0MZdiFW7YF7bumqXs6f27A8+ugYf
	 BCv72yJq4hhA/ClQULg63zt3ueAFlQZMbvvMp94QiQBuigmR9IQchcFwH6vLRJ7edErDq
	 PZaRTWmIG15PzKD0zpRY5Og7NX+K0ccJhgZrg2TxMxuPErs5svMFQBu03bR7uS2mwpQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048023;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=piFqZXJPZJLLZ60Op8kjT7/BWURl81GP9a8hz6SuDSE=;
	b=3Ah50QPw5FlfTuHQJvzKFBRzF0fO3YS8lDigtp+ceSR92W2R53vUVjqtw+B1fOCNNuXY
	 cu0qARAPDO3qC2SfPVPhH/JuVCZ1xMrjRgT8b2JSQUCebf0K4J6ux7JNqzC65xbh+RbR9
	 LWrb9Y1cqNcLtkkdvt4bc9NOF7twH4Xa9KVgcXWkPRrdDOznrP4d5WcZfTx2EakxeLWPU
	 jlHKE/oqHW0WSFc4QdSEqjYt78KesYpbya5i3Hf8TlwgnnYqbdFecbk1IPUUyf3bJMnHP
	 sZ+2y0ahC9F81x1QY3eOJD/NcLPd6xOR/GijJKeNGmNJ/bw8Ka6C3cRiZFc8AxsL97Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VCc3UHr+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47381606A31C;
	Thu, 19 Nov 2026 00:27:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VCc3UHr+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98E351F000C4;
	Thu, 19 Nov 2026 00:27:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048023;
	bh=piFqZXJPZJLLZ60Op8kjT7/BWURl81GP9a8hz6SuDSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCc3UHr+MoaFuRpmWW9AWO0d1zcQb+d9iypwGXzxi6jNQzY7eDGP2EaIDMlksk44n
	 szj7PajjLcfePHgN++drzfFcJye+qFdLjnPtWRB9gcotPG8x9LWGKfA1JbVUk6K1wg
	 dcaZmO2Jgq7CAjkeQlKfCCFpegLN3Hs+/ROlksR8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1846/2857] scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 18 Nov 2026 15:48:00 +0100
Message-ID: <20261118150307.712241193@linuxfoundation.org>
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

[ Upstream commit 896abdd4d81f40575b05d593f7fe004935a6cf97 ]

The size of an incoming BSG request is checked using a variable that is
narrower than the field it is read from, so large values wrap and pass the
check. The copy that follows then uses the full value and writes past the
request buffer.

Widen the variable and copy only the amount that was checked.

Fixes: 506bc1a0d6ba ("scsi: mpi3mr: Add support for MPT commands")
Signed-off-by: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Link: https://patch.msgid.link/20260825210411.301535-2-chandrakanth.patil@broadcom.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 28f19209c58db..c5ac6d3fe72dd 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -959,7 +959,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -1098,7 +1098,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job, unsigned int *reply
 				rval = -EINVAL;
 				goto out;
 			}
-			memcpy(mpi_req, sgl_iter, buf_entries->buf_len);
+			memcpy(mpi_req, sgl_iter, mpi_msg_size);
 			break;
 		default:
 			invalid_be = 1;
-- 
2.53.0



