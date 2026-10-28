Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210304;
	b=ag5jiYGaE/Vz+bvFO66LMITbucKio1T4vez44I4NVzLX9p3RumQWHtCoxzkWCUaoAz8n
	 Ws479VIEXPupIRPkUdCN1R9tO8WXLRegX8VUNl+XE2gCtrxQi8wT9L7l1pNj+3jnzeNP4
	 R9ED1OtKCqN/r/BesZSGUAdoTd6wwJFm0ZvkfI+LWzy/FwgZ/W0z19/ATgaeJwfLHTlE/
	 FwBxe1j4bbA1FHldhEZW+nS5u+oQpCcu62lEzTID167gWsNkJwmHYNF8ArOZAWcgGA8S5
	 6lXe1P1NC688WKyQWUs+wU4n6MD/M8+cNTxWRRlB5emJaQALzAN+9ThHgKMilZtZ86A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210304;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GOyHkdCkSP0NR/h3qpb++chJ0hkU7x2ZqzQ6dW/dh7k=;
	b=J3I6ciqkmJ/WKG/5eoBMLvcCt3Vr6ys2d6l9q9pyNmBfrUUwyrprieyZ2Bzb1OAmweAz
	 A11dSM34V1w1Sq6HCIrr7zBzmI8i9LqdWBhcWY3TzhOkasHdUg41Njoliu6U3FOuAyumD
	 QpxQGNL0y4pO/PgteiOHkpaicleRxwkt4RGx1yaKis4nGQQ0Nh9FDZB6v7uHhJvdav1yk
	 9qpE21XTrh0O6RrNNqr2Ga5LknaxTMG0gpvOBg9fCV8r2TjBi28HkEy76fkRJEUM/rhqu
	 7wKFXTBfJMvbX7fTEOqX1DmqmVkKtPcayJz0KwPNpy1rBPzMifrdN1pQdHSL2mFPnHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXjOhT0d;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF93606A31A;
	Wed, 28 Oct 2026 17:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LXjOhT0d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 276221F01825;
	Wed, 28 Oct 2026 17:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210303;
	bh=GOyHkdCkSP0NR/h3qpb++chJ0hkU7x2ZqzQ6dW/dh7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LXjOhT0doHYWjDohEvi+tKnK27OmkOwJBpNsfyLzcD1mR/JQgdGi8Y1FTK1ujBDJS
	 kvjjf5WoWB/EShEQjOkuwrVBzhdhj9P8DtIgXRYGr3zaTg+OfpXwrleEwUYtqgFpkx
	 ARbTHSTBoBP7miPWNMJyAUgHmXms4tNn9/797HGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 103/168] tracing: Keep the predicate limit separate from program capacity
Date: Wed, 28 Oct 2026 18:00:39 +0100
Message-ID: <20261028165945.526497197@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted kzalloc_objs() allocation to kcalloc(). ]
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



