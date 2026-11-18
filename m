Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015881;
	b=xK0++4dIffNkkjwcC+ybjC26j+wP6cois954/9Q3xvfNbBc7CC8sbkXOEkqlX4HjtwbH
	 N9CQ3YLChbi3ZCIn/cparB9EjYXrOVZ13CDBpiHCql3n22xoPjqKYSve8Wr4nli5M5MBG
	 lxHBSUXKEBallDHt7031Xld9P9jxK6W5RJ9gBHW14UJJcqEWVR5GxPg3ewl/mAaVlbJFJ
	 hjFTyLNYZm8225zEQqUtkkobsNmxgp5TM/xsIyRI+uzblUHtYBiFlaHbqt6YFGs09VM7c
	 AsYGVhG4mOkZG7+ZOPJ+6uHHLnRyLcglO5jjD9NLJDGhkZ8KKX8IVUHDNsxAskS2oVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ngmOpgdMKWxiCykxapx4TOKn2GDi2FNpiuqlqTGEsNg=;
	b=AzL4NQ7pur78Rvn6wX8GC+dETgZReEHUtIhzHb99A/Qsr1wtKUo/USv9cntIxQQNFIsm
	 GVrJudAE9/7NMleNL99jJ/ZY21bkAk33TOTgbVEOSbufg2f+dkDf0xO+d6vpmnNHl6gBN
	 Dtal+CryF4A3GEfw/uPHk8QCyEa4JW+QN5ALPv37qgG5Yxbtbr/RI7rICBQKns5tHMVQR
	 HLabtZuk/GsvOPn3VXV/IDFj7qXWdyWtP0Unu+WoXfDeKj0w1DGpYNvhLtupG3X/IOaAZ
	 ruK2jVv8slFrcEwiZwsWuP3l7UoRwEz+FGl8L9c9BtAVxTY6tFOIcNv4Y860PdKUKtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="MK/rSmYM";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18BAE606A32A;
	Wed, 18 Nov 2026 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MK/rSmYM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F9791F000C4;
	Wed, 18 Nov 2026 15:31:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015881;
	bh=ngmOpgdMKWxiCykxapx4TOKn2GDi2FNpiuqlqTGEsNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MK/rSmYM21pdvsF+vBovUXk7MZ+gJrIC46cdcb7c7994Tuh0uTclXCrtbaq6WWRxa
	 mQJu4Y96N7+1h6b4KwLxRVaRFQ8qU2BRb3KEQ9emDzNFVymo7dftck2Q3p1nuRupe2
	 bXTw6kDPARLronGQFW/lQPFcJWxQNQBeaIye7ES0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0330/2651] scsi: mpi3mr: Fix buffer overflow in BSG passthrough request copy
Date: Wed, 18 Nov 2026 15:26:10 +0100
Message-ID: <20261118150259.738922406@linuxfoundation.org>
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
index 094490713d697..42f32d1a4bdbb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -2384,7 +2384,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
 	long rval = -EINVAL;
 	struct mpi3mr_ioc *mrioc = NULL;
 	u8 *mpi_req = NULL, *sense_buff_k = NULL;
-	u8 mpi_msg_size = 0;
+	u32 mpi_msg_size = 0;
 	struct mpi3mr_bsg_packet *bsg_req = NULL;
 	struct mpi3mr_bsg_mptcmd *karg;
 	struct mpi3mr_buf_entry *buf_entries = NULL;
@@ -2538,7 +2538,7 @@ static long mpi3mr_bsg_process_mpt_cmds(struct bsg_job *job)
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



