Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D1B2C687;
	Tue, 23 Jan 2024 00:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969528; cv=none; b=OfLtGDDSYGPR213rXCtPrLSa+z1aQnuTaFILRNyvfJW+FJKyatJ2z0UK/ZoQYVMERH4gltJ/gcMZYoEh8cqM9veZ6XWlGfeU9S6Fw41yTgbhfhwAx9IE7vLbByJeD4CbGgxmRqy0qgrP8nkf82bLI6Ukz5SL/efNfT3cjLRRcKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969528; c=relaxed/simple;
	bh=97W6G7Ijd7Kejit2msU96t8NNkppR9gIcFmWgK0nnXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bod8QIRruzUdIbX+GAOCVmaxFbL4CCP2H7pQkqSH0Cgf04KtAuM//cQHkFLQ9jkDOUsv0nE+412AVJw3CmhaJaDAG+nOz5gYZkn46zU6f69x6NqCLfgxjpLIK/sVkQc2v2WjJtt3JIwxcTooQ8vI0GDv8DZLVLSW/onIlOxluEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yPmjaxI1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yPmjaxI1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EAE4C43390;
	Tue, 23 Jan 2024 00:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969528;
	bh=97W6G7Ijd7Kejit2msU96t8NNkppR9gIcFmWgK0nnXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yPmjaxI1+cuDr38uaGwUvBl4vU7t+hN2+tVbQvfhljRkzUnQ8+FN0L2a6nD5UXzY/
	 0e0xtLFq2YIVDE3CmucwH+KcVla4uDr6rUhFOzjv3g4ZqMdTpT2/X/v9gUT8oLZkf5
	 bVG4Xeax7Shd+mv9pGkyC3QPENL0vt7wcXkLAEJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	"Dr. David Alan Gilbert" <dave@treblig.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 306/641] media: videobuf2: request more buffers for vb2_read
Date: Mon, 22 Jan 2024 15:53:30 -0800
Message-ID: <20240122235827.490836863@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 350ab13e1382f2afcc2285041a1e75b80d771c2c ]

The vb2 read support requests 1 buffer, leaving it to the driver
to increase this number to something that works.

Unfortunately, drivers do not deal with this reliably, and in fact
this caused problems for the bttv driver and reading from /dev/vbiX,
causing every other VBI frame to be all 0.

Instead, request as the number of buffers whatever is the maximum of
2 and q->min_buffers_needed+1.

In order to start streaming you need at least q->min_buffers_needed
queued buffers, so add 1 buffer for processing. And if that field
is 0, then choose 2 (again, one buffer is being filled while the
other one is being processed).

This certainly makes more sense than requesting just 1 buffer, and
the VBI bttv support is now working again.

It turns out that the old videobuf1 behavior of bttv was to allocate
8 (video) and 4 (vbi) buffers when used with read(). After the vb2
conversion that changed to 2 for both. With this patch it is 3, which
is really all you need.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Fixes: b7ec3212a73a ("media: bttv: convert to vb2")
Tested-by: Dr. David Alan Gilbert <dave@treblig.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/common/videobuf2/videobuf2-core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/common/videobuf2/videobuf2-core.c b/drivers/media/common/videobuf2/videobuf2-core.c
index 27aee92f3eea..19f80ff497b7 100644
--- a/drivers/media/common/videobuf2/videobuf2-core.c
+++ b/drivers/media/common/videobuf2/videobuf2-core.c
@@ -2648,9 +2648,14 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
 		return -EBUSY;
 
 	/*
-	 * Start with count 1, driver can increase it in queue_setup()
+	 * Start with q->min_buffers_needed + 1, driver can increase it in
+	 * queue_setup()
+	 *
+	 * 'min_buffers_needed' buffers need to be queued up before you
+	 * can start streaming, plus 1 for userspace (or in this case,
+	 * kernelspace) processing.
 	 */
-	count = 1;
+	count = max(2, q->min_buffers_needed + 1);
 
 	dprintk(q, 3, "setting up file io: mode %s, count %d, read_once %d, write_immediately %d\n",
 		(read) ? "read" : "write", count, q->fileio_read_once,
-- 
2.43.0



