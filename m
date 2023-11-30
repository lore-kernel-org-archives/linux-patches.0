Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30CBA10EF;
	Thu, 30 Nov 2023 16:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PpSJAhRA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A19CCC433C8;
	Thu, 30 Nov 2023 16:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701362012;
	bh=77W147Gi9TWtjzISkaxerQok9T6kzp9lQR4a9N1KpDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PpSJAhRAeZ4Gfr6IDKf3gw9jZ4SNE+Ac83Cr54OKEBGlcljo0iQPI+uzYQW3CFWPJ
	 CE2cQ2KuuJI+Qsewon9UaxFJMPxo1FjTH0Z9xhGj7qklX3azs7doNyCRoTtQ4uLhOS
	 uktNsbx7BMcFnAGKI+1pOL6z8tPk+EMwPoiCBwPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kent Overstreet <kent.overstreet@linux.dev>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 27/69] lockdep: Fix block chain corruption
Date: Thu, 30 Nov 2023 16:22:24 +0000
Message-ID: <20231130162133.968896224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e6a282bc16652..770ff5bf14878 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -3416,7 +3416,8 @@ static int alloc_chain_hlocks(int req)
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



