Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207787;
	b=GYsKZzA/C2KTcTNEnXnuECrgx8f5x6yxZCzEXnboXWsbZG82aTugztoNWNn7FyXvrzwu
	 DSbpR9f0+PlHRU87GMvz+JYYqBVvcHpqMcoAarE1/UMPtDLKeJoOg36iT4bYmt6ktlP2t
	 0CDLZCFIOKmR8u7mDPgMBA6Bf0rF4YsK86DxV9PfpUvIwMWCKtJW8od2dIStmD86aWiVB
	 msGwtECjPkFot+XB2OUrfgpV9aLRf3VEkNGVyLqJOWUQR9Oq0g7wGxCJUiERH+X2SJ/d0
	 JsZOOZb0hUPFpmDdJT+pgSO3zopH9yxEbQ2yPD/QoqfoUmZeeipF3L5qnF3zMysFnSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/r6EYK9gpIrM8GHXKehf2EDfOGWm5E9YjcOhzPhaVYw=;
	b=LlwZ5CQ+Mbj10YNH3vlxYvWOhEAX4irDJZ470Egp+dOR/wXedyq76+yokQk3fulcOl8C
	 3OU+A7UROk9qXt/BeX9oPSK1D9XitPrYgk+LmiKSz1+mCkjSEe5wU3dm925AHi9iRsvHT
	 o/VlCrP+nZv/r7fg0Qrc4LxrUHrnrCqA7+E0fZX0EXFY08BkG4DAfACVHrwfR4gWhdDnF
	 2eq46wD8zetIK1UPPYg8lbtok26ryd0wmK7dPpKfL40TNgrYSjVmQtxvB5ad3adJMPP5v
	 LWeqlHXoPmavsC3HLw/ZWJ4tRT3J+0l4fYrHQ9Ec8R2A7rq81jsUyeY7hioozS+mWkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL25nOWN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A94606A31D;
	Wed, 28 Oct 2026 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nL25nOWN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509831F031E1;
	Wed, 28 Oct 2026 17:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207786;
	bh=/r6EYK9gpIrM8GHXKehf2EDfOGWm5E9YjcOhzPhaVYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nL25nOWNE6b43DzZt7hR69yaZ7dUvDC8M72gVuXSta/JJYsaRDTyuJw1C54MEFHFR
	 ZpYGeAqcjiwWIS5gs3LvO6/UUIhT6w+4h/A1sODfLY02w8tTAjJEvgdVuVPvigBIk6
	 FogeH1AOPye7NugQNq9zVDn0xylzXb5V2VoQagWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 140/247] tracing: Keep the predicate limit separate from program capacity
Date: Wed, 28 Oct 2026 17:59:03 +0100
Message-ID: <20261028165950.724535174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taeyang Lee <0wn@theori.io>

[ Upstream commit 803aa6fc2dbea25ab9d3ed19eca1c96d0ab17445 ]

predicate_parse() adds two to nr_preds to reserve the terminal TRUE
and FALSE entries. It also uses that increased value as the limit for
parsed predicates. If the initial count is smaller than the number
actually parsed, the program can fill the allocation and subsequent
accesses can go past its end.

Keep nr_preds as the predicate limit and use a separate value for the
allocation size. This leaves space for both terminal entries and a
zeroed entry when parsing stops at the limit.

Cc: stable@vger.kernel.org
Fixes: 39f7c41c908b ("tracing/filters: Enable filtering a cpumask field by another cpumask")
Link: https://patch.msgid.link/atELCd1XjKVhrkFL@Taeyangs-MacBook-Pro.local
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ sashal: adapted the allocation change to use kcalloc() instead of kzalloc_objs(). ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_filter.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/trace_events_filter.c b/kernel/trace/trace_events_filter.c
index ada02ae893c20..cd89fbf2fb208 100644
--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -482,18 +482,17 @@ predicate_parse(const char *str, int nr_parens, int nr_preds,
 	int len;
 	int N = 0;
 	int i;
-
-	nr_preds += 2; /* For TRUE and FALSE */
+	int nr_preds_alloc = nr_preds + 2; /* For TRUE and FALSE */
 
 	op_stack = kmalloc_array(nr_parens, sizeof(*op_stack), GFP_KERNEL);
 	if (!op_stack)
 		return ERR_PTR(-ENOMEM);
-	prog_stack = kcalloc(nr_preds, sizeof(*prog_stack), GFP_KERNEL);
+	prog_stack = kcalloc(nr_preds_alloc, sizeof(*prog_stack), GFP_KERNEL);
 	if (!prog_stack) {
 		parse_error(pe, -ENOMEM, 0);
 		goto out_free;
 	}
-	inverts = kmalloc_array(nr_preds, sizeof(*inverts), GFP_KERNEL);
+	inverts = kmalloc_array(nr_preds_alloc, sizeof(*inverts), GFP_KERNEL);
 	if (!inverts) {
 		parse_error(pe, -ENOMEM, 0);
 		goto out_free;
-- 
2.53.0



