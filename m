Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66B72EBB84;
	Tue, 15 Jul 2025 13:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587118; cv=none; b=tI/IG7s1K5kY/RvDU+z09SUKVNbtMce5Q5ACrtO4X6Gzhvc2WOcgWNyR8wNxHLdFevDvgZ+jIjNNX0wPLhS4mY75TsWiPZJiKMgDUfJe3LIopKv1DLxdia6sp4FuhjiwstpHT1toAmWevvtr3/2ILPgpDIk/4zisMVZBNS6TyX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587118; c=relaxed/simple;
	bh=E1tV42f+spZ+8sN8JgA4oZbCX0Ka5SD1kWNoPtFrYsY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceHhh64wmVrGrTab1PHe20UvFlFqwKHYhFArCy5bLGJjgc4x4gmAcQnlJF+Pff4iy0DahUBoQ9Imx4zMaF31MaI5SwAFBTEtulm/KLFbZM4iR8tXtN07kgGmpasBzPJdSjS7UZX7WvpKJ0VsTLIElhYUYvtROwzlo9lhqF5NkEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KP6K1zFV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KP6K1zFV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3969FC4CEE3;
	Tue, 15 Jul 2025 13:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587118;
	bh=E1tV42f+spZ+8sN8JgA4oZbCX0Ka5SD1kWNoPtFrYsY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KP6K1zFV2iurrjjGEm15bZCPRKxZgSsBqd+MiH1Dc5vMS2eF4g9UwSHjbYzsgZuY9
	 o0c7Cp53heNKL54HwaatHCw6mTK1n+jqD1LF4MmyyepFELBa8Dfo96z/RAKJ8mjomd
	 eyTuR/x60eWxC1qfUPiD5xGzlPEppG/L/nNHUmxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fengnan Chang <changfengnan@bytedance.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 174/192] io_uring: make fallocate be hashed work
Date: Tue, 15 Jul 2025 15:14:29 +0200
Message-ID: <20250715130821.896150648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fengnan Chang <changfengnan@bytedance.com>

[ Upstream commit 88a80066af1617fab444776135d840467414beb6 ]

Like ftruncate and write, fallocate operations on the same file cannot
be executed in parallel, so it is better to make fallocate be hashed
work.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
Link: https://lore.kernel.org/r/20250623110218.61490-1-changfengnan@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/opdef.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 489384c0438bd..78ef5976bf003 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -216,6 +216,7 @@ const struct io_issue_def io_issue_defs[] = {
 	},
 	[IORING_OP_FALLOCATE] = {
 		.needs_file		= 1,
+		.hash_reg_file          = 1,
 		.prep			= io_fallocate_prep,
 		.issue			= io_fallocate,
 	},
-- 
2.39.5



