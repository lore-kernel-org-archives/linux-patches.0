Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 044F75383CD;
	Wed, 23 Sep 2026 14:43:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174590; cv=none; b=J6TeiQi3Tadz0frXfkBo0Ak0uEx99YKagQlqyBBGOoeYloWtvDBvq7MiP9uI9B3Njs66KXwzdFM5+E2AV63SfUKQiLu9aafexne4tBuxX82WLoktT7UwKczaHImoa4xYaRa0H53BmQF5bYxfcdICv19SClqhXs7zqadBh6XVWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174590; c=relaxed/simple;
	bh=jLhTJQ5a5PKA4FQDTBH8V5GgXVhrw7MzH8/3PlvCmMI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGuQUyePi+Y+28/fHPZYmf/vQM+iHXF2SbbG8J+E6VWW9ZMS70DMQTodAFznW1/t8eG27pGog/ConWZLdGKebB5qnFtkAXvGFtwwqjBQNKablrPhu6QLY5FbBYsTvaAhSydRKxjt6JLnQQeOmUdjWoGeYOGER/Dk+88yPpAePJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l63szVgF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l63szVgF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC4C1F00898;
	Wed, 23 Sep 2026 14:43:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174588;
	bh=6pPwl/ON9nt59soQoZBy3IOLmUWAQzfnoN7ooWfgkr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l63szVgFWuoLs5EPDASB7BhXlDE3rC0lgNXLiam3cxVlAkE74lgXhzY+mmF2UKeVn
	 AiCVaYKloHF1Wnu/r/BWZiewnoBfIXeC6pdBeC51t24haRODWG2QcTm3Ir4zeI0FKp
	 g96lwX/wGTL1VGgEMIfMKYZgZQbGhLkL0695goq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 163/398] futex: Also allocate private hash on vfork()
Date: Wed, 23 Sep 2026 16:03:57 +0200
Message-ID: <20260923140647.662426238@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra <peterz@infradead.org>

[ Upstream commit b61b6f95d6722ddbbbd09e689fa41b55fd36f9a5 ]

As Jann demonstrated, it is entirely feasible to access the mm through vfork().
Therefore we need to allocate a private hash on vfork() as well as any other
CLONE_VM user.

Specifically, it must be avoided to have (private) futex waiters before
allocating the private hash.

Fixes: ee9dce44362b ("futex: Drop CLONE_THREAD requirement for private default hash alloc")
Reported-by: Jann Horn <jannh@google.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260911090447.GT788244@noisy.programming.kicks-ass.net
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/fork.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 295cf8cf719ea..7be5736d44c7f 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1918,9 +1918,9 @@ static bool need_futex_hash_allocate_default(u64 clone_flags)
 {
 	/*
 	 * Allocate a default futex hash for any sibling that will
-	 * share the parent's mm, except vfork.
+	 * share the parent's mm.
 	 */
-	return (clone_flags & (CLONE_VM | CLONE_VFORK)) == CLONE_VM;
+	return clone_flags & CLONE_VM;
 }
 
 /*
-- 
2.53.0



