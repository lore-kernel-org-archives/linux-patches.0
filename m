Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4F081547D8;
	Wed,  5 Feb 2025 15:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738768449; cv=none; b=kdN1CHqp8YDfSKkf9xxy96ddzB6wShrCf/SBZELpXqMYDXyFdtzJD31VVl9Dn0a7eoYwi+epuYhVxE/xpnEauunBqFwmf/UizJAgIN8kAMPBOlXLrdeQmnndhLwssnPf6lnsq6t6VmjTq2a34KMVGWTG2+63yMQ92ESUSmAstPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738768449; c=relaxed/simple;
	bh=K5KvwvHkPmZfwgLDi3SR3Kj2UTwppy01HjvzeXScF+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlFGDacV/27iHZZD78HuyWsJFpXk6TS7uGA2+Nef0sXTs74mGujR6H6RGDe+f5fDdLUimWP927AD1amNJOd3Q/aI+eb9hRqF0xWJt7d4mNSgUwHKrnfGhT898KJPCh1Y1lLfNkPZg1g1kjiHL6Fb98ZqhFywMv0YOFeZXx1cINY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZpLDqcMl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZpLDqcMl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41FE2C4CED1;
	Wed,  5 Feb 2025 15:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738768449;
	bh=K5KvwvHkPmZfwgLDi3SR3Kj2UTwppy01HjvzeXScF+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZpLDqcMlz87D8IkrgzGhqsCHUjbD+Ynloli8SGbBiCgIUkA8NRVgPLqmHbk70KPns
	 0yHDS+eW8q4dzRi0z0qkZeQzF9zRQ7Y/rKVn9VMcIsV88G7T9vOSfFp79uKm+reslm
	 fyS/QRQpwdZwKxfLHvEQDr3MWVZ+Vw7Jy38g6qQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 561/623] io_uring/register: use atomic_read/write for sq_flags migration
Date: Wed,  5 Feb 2025 14:45:03 +0100
Message-ID: <20250205134517.680263165@linuxfoundation.org>
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

[ Upstream commit a23ad06bfee5e51cd9e51aebf11401e7b4b5d00a ]

A previous commit changed all of the migration from the old to the new
ring for resizing to use READ/WRITE_ONCE. However, ->sq_flags is an
atomic_t, and while most archs won't complain on this, some will indeed
flag this:

io_uring/register.c:554:9: sparse: sparse: cast to non-scalar
io_uring/register.c:554:9: sparse: sparse: cast from non-scalar

Just use atomic_set/atomic_read for handling this case.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501242000.A2sKqaCL-lkp@intel.com/
Fixes: 2c5aae129f42 ("io_uring/register: document io_register_resize_rings() shared mem usage")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 371aec87e078c..14ece7754e4ca 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -553,7 +553,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	ctx->cqe_cached = ctx->cqe_sentinel = NULL;
 
 	WRITE_ONCE(n.rings->sq_dropped, READ_ONCE(o.rings->sq_dropped));
-	WRITE_ONCE(n.rings->sq_flags, READ_ONCE(o.rings->sq_flags));
+	atomic_set(&n.rings->sq_flags, atomic_read(&o.rings->sq_flags));
 	WRITE_ONCE(n.rings->cq_flags, READ_ONCE(o.rings->cq_flags));
 	WRITE_ONCE(n.rings->cq_overflow, READ_ONCE(o.rings->cq_overflow));
 
-- 
2.39.5



