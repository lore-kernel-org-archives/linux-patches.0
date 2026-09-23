Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D89873C7691;
	Wed, 23 Sep 2026 14:39:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174397; cv=none; b=MPXVh7+0y5UXHwc8E0A1ITx8/fcvXzfZCjXzgzuAxL+aKLkNryTt3KtME96BIKA3jHe5T6TnJdjlT8/59R4QkAP1Xqu1Gu1d36aLQxjjhpyjwFgih6bmGNpdGdhkbb1UvIgIe9sgZ3aMk9TyW+L+K2h02LxGILG5cbxw4mGAuko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174397; c=relaxed/simple;
	bh=jpnn1hgjT6J2zBHRh3GJPoLnm+aQm6lQWBpNzEZeOro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y5NqDS0jBRkmQXGKx8cYYqNkAhXij6B9+BBc01gi+m6slT/dcX+wcdonXjROc4jg0UMotWgJh+8KssmHB1VCcFN5mEgsmTGQqeSGYLU0dOlL3jtMAxWTBfhwLJ2p9Toc7J+aWhs8Bhkg/IsdyK5EfluiCLYxWGc8pd8Q9SZteeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q5U45BFQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q5U45BFQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E581F000FF;
	Wed, 23 Sep 2026 14:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174395;
	bh=SxTc3YLakjy+JJKSGPLxTwJk1vneiFrcFmFFy3kGzTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q5U45BFQHe24Q2cqhDukCfVuGr+lZfF3iU4ehzqWnNXi2MP3J7zCy1P1nn4H0XFAf
	 ald62EhfgvrK24EIfX6ACcPo54wEJVvX/9vOjU7azENM//xKivnbfqJKSQ0cNklp0T
	 laXqOjP57ExS9/oaUi/7QZiNYBo/FmNJKm8sTBE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 099/398] keys: fix lost wakeup when reaping a dead key type
Date: Wed, 23 Sep 2026 16:02:53 +0200
Message-ID: <20260923140646.004439233@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 2725ab3f5ad1c5f375c7c9fee4af02a9b138f701 ]

clear_bit() is atomic with respect to the word it modifies, but it is
an unordered operation: it implies no memory barrier on either side
(Documentation/atomic_bitops.txt).

key_garbage_collector() clears KEY_GC_REAPING_KEYTYPE with clear_bit()
and calls wake_up_bit() after reaping a dead key type. wake_up_bit()
uses a lockless waitqueue check and requires a full barrier after the
clear.

The existing smp_mb() is before clear_bit(), so nothing orders the clear
against that check. The GC can see an empty waitqueue while
unregister_key_type() still sees the bit set. The final wakeup is then
lost, leaving module unload stuck in wait_on_bit().

Use clear_and_wake_up_bit(). Its clear_bit_unlock() has RELEASE
semantics, so the completed GC work stays ordered before the clear, and
its smp_mb__after_atomic() orders the clear before the waitqueue check.

Fixes: 0c061b5707ab ("KEYS: Correctly destroy key payloads when their keytype is removed")
Assisted-by: Claude:claude-fable-5
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://lore.kernel.org/r/20260821025327.61488-1-kmehltretter@gmail.com
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/keys/gc.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/security/keys/gc.c b/security/keys/gc.c
index 748e83818a760..eda445f815d47 100644
--- a/security/keys/gc.c
+++ b/security/keys/gc.c
@@ -318,9 +318,7 @@ static void key_garbage_collector(struct work_struct *work)
 
 	if (unlikely(gc_state & KEY_GC_REAPING_DEAD_3)) {
 		kdebug("dead wake");
-		smp_mb();
-		clear_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
-		wake_up_bit(&key_gc_flags, KEY_GC_REAPING_KEYTYPE);
+		clear_and_wake_up_bit(KEY_GC_REAPING_KEYTYPE, &key_gc_flags);
 	}
 
 	if (gc_state & KEY_GC_REAP_AGAIN)
-- 
2.53.0



