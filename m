Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EC1C403135;
	Tue, 21 Jul 2026 17:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654803; cv=none; b=ij8X/+coGxFLBah2t3D70ehBJG6V7JyKJ9MZRDBAf7IWIVx+wvV1nQvmNnhRbU70xAqJ3FdzD/g+DDbXJaM+H1Rxm7QzDzhsCnlGkwWKw0tMUQDMiot+jvrVoi2VBZbNji+jupKLeifiS5oXUfiwqHxZfcyeNPn6AzJ+q9sPs5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654803; c=relaxed/simple;
	bh=LuVkiePYG4KaV7AU4HCm1MWEnCFTw+p+MDb1I2GsiGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G4l/15ROpH3p/EHJuUyieTEWoDXAEOIcvhv4Cim903DtOW/hbtmQt+P7/S8u822vSosrPEKm/G4eF2TIIYQ0S/cOCoxUNhFNpOGwAee8fY6jyQo/3HilKEIg4+off6KLBKYqxmY5tOC024xIlGDqbb77JHVpeCXGham4OWY/6yM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UMyw7wAu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UMyw7wAu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F881F000E9;
	Tue, 21 Jul 2026 17:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654802;
	bh=UbgVhQ55ZHGwch+QX5thppruMllDmJtnKJprRstT258=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UMyw7wAu7RwihW9Tn5HBGYdJGplBbvoLOzsSGi6edAzg0jOvKdMn5ivF5wEVp/5mV
	 3/crlnwjXGIv2skQkwj2qIl4o5ng4FnQexGzO8NedNqhkU/bq/5S4ZZtAMNUklJhDk
	 N90hWvCCvD1emchFeGs6NbVnkpSupfCyVl+RURDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yitang Yang <yi1tang.yang@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.1 1841/2077] block: fix IORING_URING_CMD_REISSUE flags check in blkdev_uring_cmd
Date: Tue, 21 Jul 2026 17:25:14 +0200
Message-ID: <20260721152636.160729380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yitang Yang <yi1tang.yang@gmail.com>

commit 4f919141be38ea2b1314e3a531b7b998eb64e8bc upstream.

blkdev_uring_cmd() checks IORING_URING_CMD_REISSUE to determine whether
this is the first issue. However, this flag lives in cmd->flags instead
of issue_flags.

Coincidentally, IO_URING_F_NONBLOCK shares bit 31 with
IORING_URING_CMD_REISSUE. As a result, the SQE read was never performed,
bic->len remained zero, and every BLOCK_URING_CMD_DISCARD failed with
-EINVAL.

Fix it by checking cmd->flags as intended.

Cc: stable@vger.kernel.org
Fixes: 212ec34e4e72 ("block: only read from sqe on initial invocation of blkdev_uring_cmd")
Signed-off-by: Yitang Yang <yi1tang.yang@gmail.com>
Link: https://patch.msgid.link/20260616155129.406057-1-yi1tang.yang@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/ioctl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -951,7 +951,7 @@ int blkdev_uring_cmd(struct io_uring_cmd
 	u32 cmd_op = cmd->cmd_op;
 
 	/* Read what we need from the SQE on the first issue */
-	if (!(issue_flags & IORING_URING_CMD_REISSUE)) {
+	if (!(cmd->flags & IORING_URING_CMD_REISSUE)) {
 		const struct io_uring_sqe *sqe = cmd->sqe;
 
 		if (unlikely(sqe->ioprio || sqe->__pad1 || sqe->len ||


