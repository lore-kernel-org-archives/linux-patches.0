Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208912;
	b=uSvqr9Xlr5NNK5Dz7dPxWLgmgmhehfxm3AIZFau7q8UBIgWIr/vLIwigtNWAa6ku8MAn
	 4KagikZ0JStp0zCFSA7TXs9atfvTht2xH2KoImoDPlF6IdZobi4WCQ3TXdFYzmbjKjetX
	 j3CFbzvYg87oGipryhKEIYgIcieoE13aFb+hC0lO+hoLndUfoPkFAvBuo84pyVkUHHXr/
	 GRykTBTVc/a+LLmK9dXtvA1tswbNr5VxNtE38vEgEg/9/T4A9cjCJGwLag1VZomcl7XXt
	 9KxSo2LVzEPG0DicA9A2H8ygDpo3kYirirv+bCytxlHJYhooY+eDCg4QpbTeE9cCtoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208912;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qOhYZ2W1v6m6fXx1aNAJZj/KommjrU5me0LNMC1xGDE=;
	b=ok1sPa2fgqhJMey16doFKOxyXC/l2OcJCE7VLoAr8dJI4UdBN9fgI+WhXdnTHJFgZbR6
	 5zs504cTfasulWt0J3KpMed1SQfzZxYad0FiCEJHo/bR4dVmtcVnZ0w/hZKASCe0nXZga
	 IK+9xl2fv8yOZ4CFWV9gswxDJKxUZGmE2i9wTZCgMZtjG6dytvsXYTjHcNkabmpKCDMZz
	 KCFttvy7Or+z/eBya6g07KQ4qkTilJBntnfQV7YvuHpTQjrrz+nMiU2+3uXX62wNL9iTe
	 bPkSW77lVIq4kL2TtJX7cLKgR/YufBg+19LpVJGNqoSoHoUKIg8BcwEn1eALATUEGfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCOReltv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2BB606A31D;
	Wed, 28 Oct 2026 17:35:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MCOReltv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46E081F01825;
	Wed, 28 Oct 2026 17:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208911;
	bh=qOhYZ2W1v6m6fXx1aNAJZj/KommjrU5me0LNMC1xGDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MCOReltv+MDQbJmbT57vxJ4s3W1h/80UVfsW2UFjLB9rl8nhzhhImGn+RSQAk3K4J
	 7W8qmhlhEhZ5JbDXZux9BmlQg2RQCqkwNCgSn7He+TwFm3Ap0l60mEONZ3QVsnIGNh
	 mZzwHNPDDmoWKPhJS2aJnTzlWqyNUFJrtFoiNczA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Ming Lei <ming.lei@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Dan Schatzberg <schatzberg.dan@gmail.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>
Subject: [PATCH 5.10 243/516] loop: Fix use-after-free issues
Date: Wed, 28 Oct 2026 17:56:35 +0100
Message-ID: <20261028170009.257192068@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 9b0cb770f5d7b1ff40bea7ca385438ee94570eec ]

do_req_filebacked() calls blk_mq_complete_request() synchronously or
asynchronously when using asynchronous I/O unless memory allocation fails.
Hence, modify loop_handle_cmd() such that it does not dereference 'cmd' nor
'rq' after do_req_filebacked() finished unless we are sure that the request
has not yet been completed. This patch fixes the following kernel crash:

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000054
Call trace:
 css_put.42938+0x1c/0x1ac
 loop_process_work+0xc8c/0xfd4
 loop_rootcg_workfn+0x24/0x34
 process_one_work+0x244/0x558
 worker_thread+0x400/0x8fc
 kthread+0x16c/0x1e0
 ret_from_fork+0x10/0x20

[ Dropped the part fixing c74d40e8b5e2 as this commit isn't included in
5.10. Kept the part fixing bc07c10a3603 ]

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Jan Kara <jack@suse.cz>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dan Schatzberg <schatzberg.dan@gmail.com>
Fixes: c74d40e8b5e2 ("loop: charge i/o to mem and blk cg")
Fixes: bc07c10a3603 ("block: loop: support DIO & AIO")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20230314182155.80625-1-bvanassche@acm.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 3db4dad0d072a..dab31049bd4fa 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2032,16 +2032,24 @@ static void loop_handle_cmd(struct loop_cmd *cmd)
 	const bool write = op_is_write(req_op(rq));
 	struct loop_device *lo = rq->q->queuedata;
 	int ret = 0;
+	const bool use_aio = cmd->use_aio;
 
 	if (write && (lo->lo_flags & LO_FLAGS_READ_ONLY)) {
 		ret = -EIO;
 		goto failed;
 	}
 
+	/*
+	 * do_req_filebacked() may call blk_mq_complete_request() synchronously
+	 * or asynchronously if using aio. Hence, do not touch 'cmd' after
+	 * do_req_filebacked() has returned unless we are sure that 'cmd' has
+	 * not yet been completed.
+	 */
 	ret = do_req_filebacked(lo, rq);
+
  failed:
 	/* complete non-aio request */
-	if (!cmd->use_aio || ret) {
+	if (!use_aio || ret) {
 		if (ret == -EOPNOTSUPP)
 			cmd->ret = ret;
 		else
-- 
2.53.0



