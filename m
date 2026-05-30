Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA70175A6B;
	Sat, 30 May 2026 18:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164818; cv=none; b=V+7wPY4g++x0Ki0g4YOuEt9C9rgPw5OwJPfdfi145KdQfsvE3h3a4NFFgD+1/X7rJkDTHvw/IgMrMwTDzl66g2kk+3GWfLKH/3ZUIQDrm1phdINDLtAPOLnSLjZXx5b0S4kcYw5Pi1nFlR4yhMFovs9V+HRA+zGaFsaTxagVPlo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164818; c=relaxed/simple;
	bh=5oFcqNuhJ4dukvVuzW/G6iBXNkEyC5KrbozYBFCC65A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HThlcB0EqwrdOV1P7chVMZ1K/4O11Pxow0NFnU9hMyVgJUBrVcAbgo5gJ7/QJ7U6QRaj8eO9m4Qz7sRzyVbLW16BrIghsw6QO7F0jpizEOIOIPByt2IxvUMWq/cFwjomTW1fd6ayaTmdEKCAmk0QAmpDK5pOfVcSw5P0UHzKpD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjWJYTdf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjWJYTdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AA871F00893;
	Sat, 30 May 2026 18:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164817;
	bh=n8qbpKJusQvnKsq4JBbr6ZeSOuUw2fmlQ4SCi1q02m8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjWJYTdf7yYlWl8TlVNU0MQk2ZcnbpTJ4EfYvU8ANChF6ZpDEw51mE797PklNWDSJ
	 3z7tTa+MaElYdq3BJ9P1esNnDx/Pyl82JTZXt+vyHzMB2OuNvUYW4qxEnpsdyHGcpg
	 25vEAJWgRlt1IY6klVVnIAWcO01FTSOkiPVzP8DM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Li Zetao <lizetao1@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 669/776] io_uring: prevent opcode speculation
Date: Sat, 30 May 2026 18:06:23 +0200
Message-ID: <20260530160257.169405737@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 1e988c3fe1264708f4f92109203ac5b1d65de50b ]

sqe->opcode is used for different tables, make sure we santitise it
against speculations.

Cc: stable@vger.kernel.org
Fixes: d3656344fea03 ("io_uring: add lookup table for various opcode needs")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Li Zetao <lizetao1@huawei.com>
Link: https://lore.kernel.org/r/7eddbf31c8ca0a3947f8ed98271acc2b4349c016.1739568408.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Use req->opcode instead of opcode here. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index cb54ebda0a8a7..8ecf01f1b689e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -7366,6 +7366,8 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->opcode >= IORING_OP_LAST))
 		return -EINVAL;
+	req->opcode = array_index_nospec(req->opcode, IORING_OP_LAST);
+
 	if (!io_check_restriction(ctx, req, sqe_flags))
 		return -EACCES;
 
-- 
2.53.0



