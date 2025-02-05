Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC3661684B0;
	Wed,  5 Feb 2025 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738766368; cv=none; b=YGHkvGO/SSsJdoOSM37Om2OhFxefLLbWHD7+eBI552gL0NIFJF1v0caLbmUMiS4OAK7LaHDOlrxv94Fx5YIfmU+yEHjv7ejnFzjTM9DILYQaDbn6ZlsLXpn8JlYPn41Em9HOeR381cOVyyTb+kB2beq5l2peeRVXvJDdgW045Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738766368; c=relaxed/simple;
	bh=Th3fMlHhlDKLJjrJyUXIurCUcBRKYvs/gVB1epkn3ZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inaEq6DZZ8A5D10NKXVp3DvINN/etX+mBE0i4qiu8WkSmK0DIARtU+d4zJ+z7AjN2dRC+vj52O4g3VmkzWnmJFzr29PTBPdAfBYCJbgDLOx2/4EA91ucedpyeFURrZeE/iMQZyq1ryOiNRT0Rh4iE2WTZs+fWDn3jZ37yP17s3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eYAScIhX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eYAScIhX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A495CC4CED1;
	Wed,  5 Feb 2025 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738766368;
	bh=Th3fMlHhlDKLJjrJyUXIurCUcBRKYvs/gVB1epkn3ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eYAScIhXGragiOMKxeLv8/wkmTKkgs/LZ+hKEArGXJNQZGEm1hhX7fmNOqXCNbRUn
	 4kNu8AI0rSRphvN+/ab97Blub3U8JFeXjcP/Yxfuz+/Whd7PBMI9k2lSfY7bHMV3ux
	 cgGmSJ7KJqe8layGQmmNboYf5rGkN2tguF5xWkOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 356/393] io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
Date: Wed,  5 Feb 2025 14:44:35 +0100
Message-ID: <20250205134433.922562189@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 5fa19861cda54..2cbd1c24414c6 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -175,7 +175,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!prot || !prot->ioctl)
 		return -EOPNOTSUPP;
 
-	switch (cmd->sqe->cmd_op) {
+	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
-- 
2.39.5



