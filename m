Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0163331A64;
	Tue, 17 Mar 2026 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768184; cv=none; b=JXfWDF9OLUeduZOu7VF6xKGCtvEiJPijPbI3sga+VJFHsRu8ZEmGS5SNXn56k5sXh1+hzjbX7aETHtceqwUkhe3FSnEoNYuspNMg6ctpAAgoskvvG3ZOMe73CB8b/O9kesrc7pXoLIV/2CCfDXv30oNmD7O7Z+GBRyAnhUNBpqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768184; c=relaxed/simple;
	bh=SXob0keLDaAH5txR+TW2duJsvweHQcfWMf3QagB4KwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gtz81fubmJH9nwS0at/wGXeGl9aK0wLcBGP6MruLINaIQmAjNgxXfCqqUx/kufcZk3Yr1KQcvERfO9WYc4g3XzMCYMifvmpxC1OHe/eUuc3BhCHe5gIPUI57jdKPLXvNDM3KFp/PYmX8K1hj6ZfcXKKTS3Z5WOyV81snCW6uFYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=trtPPDao; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="trtPPDao"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29D6AC4CEF7;
	Tue, 17 Mar 2026 17:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768183;
	bh=SXob0keLDaAH5txR+TW2duJsvweHQcfWMf3QagB4KwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=trtPPDao0wNpyjds6QGkh71vdkrZpk2+VOmxwVjD1eRy32F9RAIpvF8SlVCoKAQ39
	 nS+YyO6q+VKdfL0bWPDLGkQrq8SQs22Kr/y5Mt792JoWo4ohBxYTcvpWiyQWmTfESY
	 lI7surm+BD+cbUpSwlV5PYfIRnsA0e/iE7yb/Rd4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>,
	SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 208/333] mm/damon/core: clear walk_control on inactive context in damos_walk()
Date: Tue, 17 Mar 2026 17:33:57 +0100
Message-ID: <20260317163007.074098002@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>

commit d210fdcac9c0d1380eab448aebc93f602c1cd4e6 upstream.

damos_walk() sets ctx->walk_control to the caller-provided control
structure before checking whether the context is running.  If the context
is inactive (damon_is_running() returns false), the function returns
-EINVAL without clearing ctx->walk_control.  This leaves a dangling
pointer to a stack-allocated structure that will be freed when the caller
returns.

This is structurally identical to the bug fixed in commit f9132fbc2e83
("mm/damon/core: remove call_control in inactive contexts") for
damon_call(), which had the same pattern of linking a control object and
returning an error without unlinking it.

The dangling walk_control pointer can cause:
1. Use-after-free if the context is later started and kdamond
   dereferences ctx->walk_control (e.g., in damos_walk_cancel()
   which writes to control->canceled and calls complete())
2. Permanent -EBUSY from subsequent damos_walk() calls, since the
   stale pointer is non-NULL

Nonetheless, the real user impact is quite restrictive.  The
use-after-free is impossible because there is no damos_walk() callers who
starts the context later.  The permanent -EBUSY can actually confuse
users, as DAMON is not running.  But the symptom is kept only while the
context is turned off.  Turning it on again will make DAMON internally
uses a newly generated damon_ctx object that doesn't have the invalid
damos_walk_control pointer, so everything will work fine again.

Fix this by clearing ctx->walk_control under walk_control_lock before
returning -EINVAL, mirroring the fix pattern from f9132fbc2e83.

Link: https://lkml.kernel.org/r/20260224011102.56033-1-sj@kernel.org
Fixes: bf0eaba0ff9c ("mm/damon/core: implement damos_walk()")
Reported-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Closes: https://lore.kernel.org/CPUPR80MB8171025468965E583EF2490F956CA@CPUPR80MB8171.lamprd80.prod.outlook.com
Signed-off-by: Raul Pazemecxas De Andrade <raul_pazemecxas@hotmail.com>
Signed-off-by: SeongJae Park <sj@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[6.14+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/damon/core.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1526,8 +1526,13 @@ int damos_walk(struct damon_ctx *ctx, st
 	}
 	ctx->walk_control = control;
 	mutex_unlock(&ctx->walk_control_lock);
-	if (!damon_is_running(ctx))
+	if (!damon_is_running(ctx)) {
+		mutex_lock(&ctx->walk_control_lock);
+		if (ctx->walk_control == control)
+			ctx->walk_control = NULL;
+		mutex_unlock(&ctx->walk_control_lock);
 		return -EINVAL;
+	}
 	wait_for_completion(&control->completion);
 	if (control->canceled)
 		return -ECANCELED;


