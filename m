Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7823A19DF41;
	Wed,  5 Feb 2025 15:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768446; cv=none; b=ErZ7eb1+a5kBfqLJRXJYxeH243FaA4b34fEYa6uZ1KhcJs4cV96KeB9OMIjqvYW499zFuCH+BPDbVcpxsj2aS9pZ7PP1Zw17I7EQdOf87Qs5rBY9De/GqANIMoYux/3R+LmUckZNSrtXkgUbFHpkg5H4wlyH2OqdjQ5REruJ2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768446; c=relaxed/simple;
	bh=AZCmEN1LrnJcO7+tWskRfc4lJuygSYv2yOM1cRPDjq0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vsjw5nta+bdqx/qjXwU5LPE0L2nF+qxpT+wSjmywmOMIpiBZezIEOKI6HJntCrc+AFoo57Jv/QYXX5wrQh5dyEOL6tKYLxMJ89ipL2NoMvkAdThfBbl66UiTGwBC5KRelr5eaoS+/BfiFRMgSpX1sjXuhOWS16uUm+itM60C0UI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aNrF/BqZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aNrF/BqZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC337C4CED1;
	Wed,  5 Feb 2025 15:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768446;
	bh=AZCmEN1LrnJcO7+tWskRfc4lJuygSYv2yOM1cRPDjq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aNrF/BqZjD7H2irHGebPtQMLXKIiV8dqS4+GaFTKmij59gzDQmhbg+b3S9lPSNniV
	 IF9HZ4O5yulyv2ar5rdFaFaviezveM3JihGOGrQ0WJcExzRUmMcLNB2rr1W2bymzob
	 7ONG2WLj98q+FWq4j4ar0Z3y9BlRZlXGac5GOapM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 560/623] io_uring/uring_cmd: use cached cmd_op in io_uring_cmd_sock()
Date: Wed,  5 Feb 2025 14:45:02 +0100
Message-ID: <20250205134517.642598819@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index ce7726a048834..25cae9f5575be 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -362,7 +362,7 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	if (!prot || !prot->ioctl)
 		return -EOPNOTSUPP;
 
-	switch (cmd->sqe->cmd_op) {
+	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
-- 
2.39.5



