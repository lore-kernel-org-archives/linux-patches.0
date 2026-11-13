Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591538;
	b=IAkna5ofhjrW8uIXeTEkr5CrUpjciKLA6l6Ww0+6aNxsWtMv0mJyrf+jlUQm25UnpCvO
	 N8bYuaAUD82TV3wjGbIbOp2ScS0zS371ipMnqFwNsTB/GcH06vvsPnh/2fMdAaRkhTzic
	 Z/lqaiA3IrXf82yWxK0Mpqfxh6GuseLXXzpO00QC+5bQq13tufuHh08C24scLvBhMyDTP
	 2I9Px3gwQtVOGIn2/JgGVFOuTg8rvCYGVQPYtr2TpGfoHQATTJaMsZ0b/uhjuo7dRHnnR
	 loUvd4P8HVr/n7zTjQHTMzbxnE7c5LVLucqyK6aQD3x/7VLoc3SN6JgOFh/dHYVUVHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ghCJETSqRFFpBNy6JVR1fXpX937sZsdYeA9TjODeYME=;
	b=1RmKdXZ+UuJVKqaZXnv8G3wngcYrb6hB7/3hmmhlzG4Y4sHqq78O/uWtUTipJY561nFS
	 lLkiqlFGQdEdsvPDAl1NpezpVy+Q7eKwYY40h8ExwkR7A3Txey8pAZIhznadhzOsemHu+
	 YXOJ6GgKmmqP9tdTKr7RZiuladEhySH1+roesTjiXXRY1TSBHoX1NcR62OLV3qBQuvSBI
	 XlQk4XAxdi5KbkoPqjhpZxgk6ctiA5ebBbTnRLvuqnSqWSYXAN2jzd2IoJr/nuqJ0XYXv
	 OU+boTKsHh1VrFCvvp16M+VrBM/CocMOHDRnjylvZj460Tj98RX2LYkPocoGIJdR3LQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH+xnFCV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E20FD606D869;
	Fri, 13 Nov 2026 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QH+xnFCV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DFA11F000C4;
	Fri, 13 Nov 2026 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591537;
	bh=ghCJETSqRFFpBNy6JVR1fXpX937sZsdYeA9TjODeYME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QH+xnFCV+EpSXx5tT5rsThfLiBXMoJAEM9abikDAVXAV7GPnnfqbLQZBHiiC+9H76
	 cYBtKXWaabUTTmKqSNZHrUca3fv8ffBdXfvnnby3NcN0XIYztsfjXwC1u0N79APo4B
	 5ff+i8RAMP5Bix3EFbdbqLxwRiBjc9CQmrm/KWww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 592/670] ublk: mark the io command cancelable before publishing it
Date: Fri, 13 Nov 2026 10:52:36 -0500
Message-ID: <20261113153831.897676542@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <tom.leiming@gmail.com>

[ Upstream commit a261f0cacacc022e4fab5b8e38c59f74ce4942e8 ]

FETCH, COMMIT_AND_FETCH and NEED_GET_DATA publish the command in io->cmd
before marking it cancelable. A cancel from the control path (STOP_DEV,
QUIESCE_DEV) can complete it in between:

  issue path                       control-path cancel
  io->cmd = C
                                   take C, io_uring_cmd_done(C):
                                     C not marked, nothing to unlink
  ublk_prep_cancel(C)
    the completed C is linked on the cancelable list
  ring exit: the cancel walk hits it → GPF (KASAN, with a delay added)

Mark the command before ublk_fill_io_cmd() publishes it. The handlers
run with uring_lock held, as io_uring's cancel walk does, so marking
takes no lock and the walk can't see a marked command before it is
published. smp_wmb() orders the mark before the io->cmd store; the
cancel loads cmd with READ_ONCE(io->cmd) before reading cmd->flags.

A marked command has to be completed by io_uring_cmd_done(), so a failed
FETCH and the inline UBLK_IO_RES_OK of NEED_GET_DATA now do that. The CQE
is the same.

Fixes: 216c8f5ef0f2 ("ublk: replace monitor with cancelable uring_cmd")
Cc: stable@vger.kernel.org
Tested-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-3-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ sashal: Omitted out_done because FETCH validation precedes cancellation marking and NEED_GET_DATA already completes asynchronously. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 3e7c3b1f0b8a1..f89b36017d979 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1589,8 +1589,10 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, unsigned tag,
 		io->flags |= UBLK_IO_FLAG_CANCELED;
 	spin_unlock(&ubq->cancel_lock);
 
+	/* dependency ordered against smp_wmb() in ublk_prep_cancel() */
 	if (!done)
-		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
+		io_uring_cmd_done(READ_ONCE(io->cmd), UBLK_IO_RES_ABORT, 0,
+				  issue_flags);
 }
 
 /*
@@ -1807,6 +1809,12 @@ static inline void ublk_fill_io_cmd(struct ublk_io *io,
 	io->addr = buf_addr;
 }
 
+/*
+ * Call before ublk_fill_io_cmd() publishes @cmd in io->cmd: a control-path
+ * cancel may complete any command found there, and io_uring_cmd_done() only
+ * takes it off the cancelable list if it is marked already. The handlers
+ * hold uring_lock, so marking takes no lock.
+ */
 static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 				    unsigned int issue_flags,
 				    struct ublk_queue *ubq, unsigned int tag)
@@ -1820,6 +1828,8 @@ static inline void ublk_prep_cancel(struct io_uring_cmd *cmd,
 	pdu->ubq = ubq;
 	pdu->tag = tag;
 	io_uring_cmd_mark_cancelable(cmd, issue_flags);
+	/* pairs with the cancel loading cmd from io->cmd, then cmd->flags */
+	smp_wmb();
 }
 
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
@@ -1899,6 +1909,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			goto out;
 		}
 
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
 		ublk_mark_io_ready(ub, ubq);
 		break;
@@ -1925,19 +1936,20 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			goto out;
 		}
 
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
 		ublk_commit_completion(ub, ub_cmd);
 		break;
 	case UBLK_IO_NEED_GET_DATA:
 		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
 			goto out;
+		ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 		ublk_fill_io_cmd(io, cmd, ub_cmd->addr);
 		ublk_handle_need_get_data(ub, ub_cmd->q_id, ub_cmd->tag);
 		break;
 	default:
 		goto out;
 	}
-	ublk_prep_cancel(cmd, issue_flags, ubq, tag);
 	return -EIOCBQUEUED;
 
  out:
-- 
2.53.0



