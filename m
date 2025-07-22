Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E51A32;
	Tue, 22 Jul 2025 14:02:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192960; cv=none; b=OzhFY+xYbP8pltihylcgbTZls4Lkbis1JvfRPjxRtcqriCyzIeZY/WfhQshhRpIS5hCxIL4oZZfczN3kS68JFI0wFAVLQYh2Yd0h9YVZi9LWUjHxWU+oV5y8GL4mXjhNUsLBveGHFg7x7l9Tp6V04ErsA5RTkM8jCBmxOSnoKFw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192960; c=relaxed/simple;
	bh=o48poMhJqxaa4ahD6TshB9RbTCX8nmvCA9QmEBZcKiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YZ/agbZcLgWhfEUWb7RB9TkxDFsuSGyS3ogjlvC0HHXGQrINZmBF/54q5GBfwTIn3R2h5t0TVsHqFSpUIchWiSTy+QWKx4dzXnOnNyYBNNcfE2oinyDgMz31PTiMRRG3XCRm9e8XFbxdPi20x73eX1S62EeurwxuhhNi+GxlDgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zZRRa+dn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zZRRa+dn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A07FC4CEEB;
	Tue, 22 Jul 2025 14:02:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192960;
	bh=o48poMhJqxaa4ahD6TshB9RbTCX8nmvCA9QmEBZcKiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zZRRa+dnGqdYlZSNOqAb7ZSN/t3qC3LfNFZx1gkfnbSdS5gFOPwRQkfkmTVqLzwrb
	 PY7MyJwN9NyCyfkz2d+XEk4v+cTIxKqW5I53vV3e+NO2XgTLod1NNxsd2sMx/wRdft
	 71xU/Dulud3HQgVXPx1O8gtxrtwvorGdTLdJXe7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhui Zhong <czhong@redhat.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 110/158] loop: use kiocb helpers to fix lockdep warning
Date: Tue, 22 Jul 2025 15:44:54 +0200
Message-ID: <20250722134344.853543785@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit c4706c5058a7bd7d7c20f3b24a8f523ecad44e83 ]

The lockdep tool can report a circular lock dependency warning in the loop
driver's AIO read/write path:

```
[ 6540.587728] kworker/u96:5/72779 is trying to acquire lock:
[ 6540.593856] ff110001b5968440 (sb_writers#9){.+.+}-{0:0}, at: loop_process_work+0x11a/0xf70 [loop]
[ 6540.603786]
[ 6540.603786] but task is already holding lock:
[ 6540.610291] ff110001b5968440 (sb_writers#9){.+.+}-{0:0}, at: loop_process_work+0x11a/0xf70 [loop]
[ 6540.620210]
[ 6540.620210] other info that might help us debug this:
[ 6540.627499]  Possible unsafe locking scenario:
[ 6540.627499]
[ 6540.634110]        CPU0
[ 6540.636841]        ----
[ 6540.639574]   lock(sb_writers#9);
[ 6540.643281]   lock(sb_writers#9);
[ 6540.646988]
[ 6540.646988]  *** DEADLOCK ***
```

This patch fixes the issue by using the AIO-specific helpers
`kiocb_start_write()` and `kiocb_end_write()`. These functions are
designed to be used with a `kiocb` and manage write sequencing
correctly for asynchronous I/O without introducing the problematic
lock dependency.

The `kiocb` is already part of the `loop_cmd` struct, so this change
also simplifies the completion function `lo_rw_aio_do_completion()` by
using the `iocb` from the `cmd` struct directly, instead of retrieving
the loop device from the request queue.

Fixes: 39d86db34e41 ("loop: add file_start_write() and file_end_write()")
Cc: Changhui Zhong <czhong@redhat.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Link: https://lore.kernel.org/r/20250716114808.3159657-1-ming.lei@redhat.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index e9a197474b9d8..2f42d16446184 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -323,14 +323,13 @@ static void lo_complete_rq(struct request *rq)
 static void lo_rw_aio_do_completion(struct loop_cmd *cmd)
 {
 	struct request *rq = blk_mq_rq_from_pdu(cmd);
-	struct loop_device *lo = rq->q->queuedata;
 
 	if (!atomic_dec_and_test(&cmd->ref))
 		return;
 	kfree(cmd->bvec);
 	cmd->bvec = NULL;
 	if (req_op(rq) == REQ_OP_WRITE)
-		file_end_write(lo->lo_backing_file);
+		kiocb_end_write(&cmd->iocb);
 	if (likely(!blk_should_fake_timeout(rq->q)))
 		blk_mq_complete_request(rq);
 }
@@ -406,7 +405,7 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	}
 
 	if (rw == ITER_SOURCE) {
-		file_start_write(lo->lo_backing_file);
+		kiocb_start_write(&cmd->iocb);
 		ret = file->f_op->write_iter(&cmd->iocb, &iter);
 	} else
 		ret = file->f_op->read_iter(&cmd->iocb, &iter);
-- 
2.39.5



