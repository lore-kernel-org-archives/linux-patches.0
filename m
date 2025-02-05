Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B584121345;
	Wed,  5 Feb 2025 15:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768077; cv=none; b=iCzXrGPDBLuyaG6osksa0evbvMOzrYyRBdlaGLJcpP/9QSBrbGkH298BZJtfLhY1tYYHTAzpgZ0mIsKvhCIHvPGwcYp9j2xbCaAjDXSbcr0NrbxP+demYJy5H5DRN6fFQjVPGCeWC4phT7qEECbV/YJvGXV/KjR6CS1YaeboShc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768077; c=relaxed/simple;
	bh=qr2zeYwqGTFgXc5MqgVDgl7W1JyKmuIuwYPpflwoEEQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T7N3szJbshy4L0zFmhRvmyOYtYchGfY/hQeZru4Kt/D/0SIH4ZVt5fzVoKzlrIr9Etm6yt3ATEqZapLnFTxKm/N6dldV5txUa2DVr5toQkBAYS3BTO5q6YuTxMya8ocFendsR0E7L/IgibaKeLtr+YO4F8wDSQllauJ9aCoRqEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K2qk3Ern; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K2qk3Ern"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFB8C4CED1;
	Wed,  5 Feb 2025 15:07:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768077;
	bh=qr2zeYwqGTFgXc5MqgVDgl7W1JyKmuIuwYPpflwoEEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K2qk3ErnbaecdPDW309AvmJxkb8EPlz+/WEDFDmgF9btsKqVhGoUiZpKldEsZ7K0c
	 n5OBYpLWPRBauOTUlNdmlwcQmcZSBGDkg9SSvFiOUTTH2cuZHozxpP3ISArFNoT5g3
	 dBW20JQWNECFiGOgOWUZEKv0PnR+ET5MXvg7MzBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 527/590] io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
Date: Wed,  5 Feb 2025 14:44:42 +0100
Message-ID: <20250205134515.427122532@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134455.220373560@linuxfoundation.org>
References: <20250205134455.220373560@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit d58d82bd0efd6c8edd452fc2f6c6dd052ec57cb2 ]

io_uring_cmd_sock() does a normal read of cmd->sqe->cmd_op, where it
really should be using a READ_ONCE() as ->sqe may still be pointing to
the original SQE. Since the prep side already does this READ_ONCE() and
stores it locally, use that value rather than re-read it.

Fixes: 8e9fad0e70b7b ("io_uring: Add io_uring command support for sockets")
Link: https://lore.kernel.org/r/20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/uring_cmd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index 883510a3e8d07..874f9e2defd58 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -340,7 +340,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!prot || !prot->ioctl)
 		return -EOPNOTSUPP;
 
-	switch (cmd->sqe->cmd_op) {
+	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
-- 
2.39.5



