Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E50B334251B;
	Sat, 28 Feb 2026 17:59:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301546; cv=none; b=oekuCK9qHZaEjA/GqE0ui7w6T4LDeGxBFisRCxJverWow+T3sSsxj+dg9gOwSil5QMUBEE9HXM3r83l8MzH0WeCiMayRVY8FdCkZg1Oms+9Tgmhhzx5HWjI4HrbhEj35VvOSJPHVQ6FD8+ZHP3rWaQuovUaO3QbJc3QU3+MMVeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301546; c=relaxed/simple;
	bh=eTYdU7BqEee6tBeIda1a/OQfhB8tt4HrLb6dHz1TyCE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CL2LF8p3132Rf9Bfo/1R0imuPJ9lWPG4Q1tJKZTUr/CNideXnp6d44DZ+dO7XZowr7reyns9TAGDoHEXlr7eiRxUlHY8TW/cildDW2lEEG71zPL4aXcunNxFG3Aa8Gihi+2adaEaEEAIVdiJ8lHc4YPoEr4lL0wS7qSGURWwbgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dJ8OpXBZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dJ8OpXBZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB1E9C19423;
	Sat, 28 Feb 2026 17:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301545;
	bh=eTYdU7BqEee6tBeIda1a/OQfhB8tt4HrLb6dHz1TyCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dJ8OpXBZ8j3l/K171bIZ2eVj6yq/Leahl4XeW+9ibyb1kwFEtQGbRKmRuDjkkT0Kj
	 OLIC8WzV1OhTOh24/+e4eQ9SM29GB/6tJ3waXqjtSuDQHtncZgpVJqbdqEtk8C5UYk
	 KsSVGCfCx3KLLYev8IVGW38fH8WUQatNq5ILmnloJNqLi3tKarOrW90Jg8kQY1l+bJ
	 3o0jTUQi/d1hqZu5RMptCyWPR5wwfU650OmSF4WADP36rr2LUeTJ8Q1pwMFv+WlSzk
	 4Cj+C4Qja9mfEUWdmmG1XgQlYpbEkE92D3WZyJgQOpBf5GsVTcM4VNNhBg4w4J5R8p
	 bp2SSdVc3jprw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Asbj=C3=B8rn=20Sloth=20T=C3=B8nnesen?= <ast@fiberby.net>,
	stable@vger.kernel.org,
	Gabriel Krisman Bertazi <krisman@suse.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 728/752] io_uring/cmd_net: fix too strict requirement on ioctl
Date: Sat, 28 Feb 2026 12:47:19 -0500
Message-ID: <20260228174750.1542406-728-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Asbjørn Sloth Tønnesen <ast@fiberby.net>

[ Upstream commit 600b665b903733bd60334e86031b157cc823ee55 ]

Attempting SOCKET_URING_OP_SETSOCKOPT on an AF_NETLINK socket resulted
in an -EOPNOTSUPP, as AF_NETLINK doesn't have an ioctl in its struct
proto, but only in struct proto_ops.

Prior to the blamed commit, io_uring_cmd_sock() only had two cmd_op
operations, both requiring ioctl, thus the check was warranted.

Since then, 4 new cmd_op operations have been added, none of which
depend on ioctl. This patch moves the ioctl check, so it only applies
to the original operations.

AFAICT, the ioctl requirement was unintentional, and it wasn't
visible in the blamed patch within 3 lines of context.

Cc: stable@vger.kernel.org
Fixes: a5d2f99aff6b ("io_uring/cmd: Introduce SOCKET_URING_OP_GETSOCKOPT")
Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.net>
Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/cmd_net.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/io_uring/cmd_net.c b/io_uring/cmd_net.c
index 3b75931bd5695..54d05a205e623 100644
--- a/io_uring/cmd_net.c
+++ b/io_uring/cmd_net.c
@@ -139,16 +139,19 @@ int io_uring_cmd_sock(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	struct proto *prot = READ_ONCE(sk->sk_prot);
 	int ret, arg = 0;
 
-	if (!prot || !prot->ioctl)
-		return -EOPNOTSUPP;
-
 	switch (cmd->cmd_op) {
 	case SOCKET_URING_OP_SIOCINQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCINQ, &arg);
 		if (ret)
 			return ret;
 		return arg;
 	case SOCKET_URING_OP_SIOCOUTQ:
+		if (!prot || !prot->ioctl)
+			return -EOPNOTSUPP;
+
 		ret = prot->ioctl(sk, SIOCOUTQ, &arg);
 		if (ret)
 			return ret;
-- 
2.51.0

