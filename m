Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29F2524C2;
	Thu, 30 Nov 2023 16:26:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f4aRrI3j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AACFC433C7;
	Thu, 30 Nov 2023 16:26:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701361585;
	bh=1/ikv5T14WaQyUEqkDw52CGgHuSGzmMgVkEFdRPTJBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f4aRrI3jxF46LNbVYoK3EVHKiANsvs8LVoD/mCDFNj1PlwgJ7bdYeVmRsWCusZOy1
	 Nt47VfHzXGYnLhTgQAcs+ElERyYVikI7qwAOuJYOXabQl9XjaQV2/jZXitjT+pT/8w
	 yS6jQj6HCloEeDu55vUcPJ1YuFP0pNQhsX7FAAJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/112] lockdep: Fix block chain corruption
Date: Thu, 30 Nov 2023 16:21:43 +0000
Message-ID: <20231130162142.104036462@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
References: <20231130162140.298098091@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit bca4104b00fec60be330cd32818dd5c70db3d469 ]

Kent reported an occasional KASAN splat in lockdep. Mark then noted:

> I suspect the dodgy access is to chain_block_buckets[-1], which hits the last 4
> bytes of the redzone and gets (incorrectly/misleadingly) attributed to
> nr_large_chain_blocks.

That would mean @size == 0, at which point size_to_bucket() returns -1
and the above happens.

alloc_chain_hlocks() has 'size - req', for the first with the
precondition 'size >= rq', which allows the 0.

This code is trying to split a block, del_chain_block() takes what we
need, and add_chain_block() puts back the remainder, except in the
above case the remainder is 0 sized and things go sideways.

Fixes: 810507fe6fd5 ("locking/lockdep: Reuse freed chain_hlocks entries")
Reported-by: Kent Overstreet <kent.overstreet@linux.dev>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Kent Overstreet <kent.overstreet@linux.dev>
Link: https://lkml.kernel.org/r/20231121114126.GH8262@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index e85b5ad3e2069..151bd3de59363 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3497,7 +3497,8 @@ static int alloc_chain_hlocks(int req)
 		size = chain_block_size(curr);
 		if (likely(size >= req)) {
 			del_chain_block(0, size, chain_block_next(curr));
-			add_chain_block(curr + req, size - req);
+			if (size > req)
+				add_chain_block(curr + req, size - req);
 			return curr;
 		}
 	}
-- 
2.42.0



