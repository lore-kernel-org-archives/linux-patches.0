Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F7ED13B2B8;
	Tue, 27 Feb 2024 14:27:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709044070; cv=none; b=OuPv2tdixFIaQ/oL87hNyQasEdeNF1yRHGXvJK85Mdfs291bXuyKbL7RbluQTcMY9XJfusLdOXp+X9Jv3b95dx5bOFdwHO6f19WsBABwwsYBIEKMgLz+ib/+XymRY9HxcMd0Bqm42pbJ2FA59cveO7IhIu94kKR8U6C+PMDPNXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709044070; c=relaxed/simple;
	bh=gBsMpcVaLbZ3ODqvQLp5hFjW2UnWbW54txuvuuVQFmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NV69kjoSjWnuo69xEjCrW3kVZwdTjonxb8tU+v57BXTrnrVCYD2Lnd4HoaX10np6WP1GF7+zr+5y0cfRzWaODB+2tnVfmWbga7/CEUtR0vJwEm923gn+UwG7SwpC9lwP+oIcC/jMQ+wTW9C1zDRmYQ00l5wCwlLZKPiokg31J2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F2tiO85Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F2tiO85Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1183C43394;
	Tue, 27 Feb 2024 14:27:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709044070;
	bh=gBsMpcVaLbZ3ODqvQLp5hFjW2UnWbW54txuvuuVQFmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F2tiO85ZnJ1Ty+gJt5aKqcpXjKQnYyESE/3EBc5bum9aNzAqIqBZLex1F/E4FNplb
	 579fiF2+r1fXAVIC5c8sjrtEKMWGb9Km5ZqF/kxyShPcX0KuXGTuz89ylwakGUFRBx
	 wGutABPmUgRpLV/pUdTqS0Zc9St7IpjZV6wUQUXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Schmitz <schmitzmic@gmail.com>,
	linux-block@vger.kernel.org,
	Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 052/122] block: ataflop: fix breakage introduced at blk-mq refactoring
Date: Tue, 27 Feb 2024 14:26:53 +0100
Message-ID: <20240227131600.411339058@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131558.694096204@linuxfoundation.org>
References: <20240227131558.694096204@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Schmitz <schmitzmic@gmail.com>

[ Upstream commit 86d46fdaa12ae5befc16b8d73fc85a3ca0399ea6 ]

Refactoring of the Atari floppy driver when converting to blk-mq
has broken the state machine in not-so-subtle ways:

finish_fdc() must be called when operations on the floppy device
have completed. This is crucial in order to relase the ST-DMA
lock, which protects against concurrent access to the ST-DMA
controller by other drivers (some DMA related, most just related
to device register access - broken beyond compare, I know).

When rewriting the driver's old do_request() function, the fact
that finish_fdc() was called only when all queued requests had
completed appears to have been overlooked. Instead, the new
request function calls finish_fdc() immediately after the last
request has been queued. finish_fdc() executes a dummy seek after
most requests, and this overwrites the state machine's interrupt
hander that was set up to wait for completion of the read/write
request just prior. To make matters worse, finish_fdc() is called
before device interrupts are re-enabled, making certain that the
read/write interupt is missed.

Shifting the finish_fdc() call into the read/write request
completion handler ensures the driver waits for the request to
actually complete. With a queue depth of 2, we won't see long
request sequences, so calling finish_fdc() unconditionally just
adds a little overhead for the dummy seeks, and keeps the code
simple.

While we're at it, kill ataflop_commit_rqs() which does nothing
but run finish_fdc() unconditionally, again likely wiping out an
in-flight request.

Signed-off-by: Michael Schmitz <schmitzmic@gmail.com>
Fixes: 6ec3938cff95 ("ataflop: convert to blk-mq")
CC: linux-block@vger.kernel.org
CC: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
Link: https://lore.kernel.org/r/20211019061321.26425-1-schmitzmic@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ataflop.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/block/ataflop.c b/drivers/block/ataflop.c
index 3e881fdb06e0a..cd612cd04767a 100644
--- a/drivers/block/ataflop.c
+++ b/drivers/block/ataflop.c
@@ -653,9 +653,6 @@ static inline void copy_buffer(void *from, void *to)
 		*p2++ = *p1++;
 }
 
-  
-  
-
 /* General Interrupt Handling */
 
 static void (*FloppyIRQHandler)( int status ) = NULL;
@@ -1225,6 +1222,7 @@ static void fd_rwsec_done1(int status)
 	}
 	else {
 		/* all sectors finished */
+		finish_fdc();
 		fd_end_request_cur(BLK_STS_OK);
 	}
 	return;
@@ -1472,15 +1470,6 @@ static void setup_req_params( int drive )
 			ReqTrack, ReqSector, (unsigned long)ReqData ));
 }
 
-static void ataflop_commit_rqs(struct blk_mq_hw_ctx *hctx)
-{
-	spin_lock_irq(&ataflop_lock);
-	atari_disable_irq(IRQ_MFP_FDC);
-	finish_fdc();
-	atari_enable_irq(IRQ_MFP_FDC);
-	spin_unlock_irq(&ataflop_lock);
-}
-
 static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 				     const struct blk_mq_queue_data *bd)
 {
@@ -1488,6 +1477,8 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	int drive = floppy - unit;
 	int type = floppy->type;
 
+	DPRINT(("Queue request: drive %d type %d last %d\n", drive, type, bd->last));
+
 	spin_lock_irq(&ataflop_lock);
 	if (fd_request) {
 		spin_unlock_irq(&ataflop_lock);
@@ -1547,8 +1538,6 @@ static blk_status_t ataflop_queue_rq(struct blk_mq_hw_ctx *hctx,
 	setup_req_params( drive );
 	do_fd_action( drive );
 
-	if (bd->last)
-		finish_fdc();
 	atari_enable_irq( IRQ_MFP_FDC );
 
 out:
@@ -1959,7 +1948,6 @@ static const struct block_device_operations floppy_fops = {
 
 static const struct blk_mq_ops ataflop_mq_ops = {
 	.queue_rq = ataflop_queue_rq,
-	.commit_rqs = ataflop_commit_rqs,
 };
 
 static struct kobject *floppy_find(dev_t dev, int *part, void *data)
-- 
2.43.0



