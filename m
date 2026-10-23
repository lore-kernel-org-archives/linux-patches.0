Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774244;
	b=ZKNcuGmGVwPBRDxRxpFNVyUuyfMm1IM00R/lx1iVYvnMRWrCG9FEQiAN17jUFY2ySVk0
	 J5TfMdBM9/mhPpPCAfNCpfjDxXn8YR724/PK+6IGEKYUJO7xDVcnKRo9WqnubhCRB1NRP
	 sh02xLf5nLD1t2ndVqDb9BWFZ8lC6iTtwCiCIgIFH4qdU808fYBmUh7VKPOasIHbW3ZNV
	 wX5YyUHxHw0JtbtnNVpYXO5OoBw4sqoHxi91Ev9/n7LD8J5tU1k+9wXG2p4phxXRIquio
	 HKEj2NHsSNnNNO0exdU/rGspE/SQGENAVr+a+7TadtJsr99L96FtqckGyBeYj7OXTtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774244;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RKYh9B5CNfSy8Etq6Zv2iR8t4W9dtIW0YsafTn4OQBM=;
	b=OqHR1QV9KDEBbAdC0Ul7GQDj6zuWC2xugFAoh9QXQK6lnszx0QUN4Q22GBSxy1YpwWRu
	 2Qfmqmvq410INq1T+lCYKopuPYQTVVoa8+VmYHgesDueDqoLQDY8+3rSDTLlSXpDUfj7v
	 PDpkgPwLQJilwO6MwicPpCSNSoPnmOp7uc0ZKwbv8uKbEQPmm2W8ga/F5LPN4yBMZNqBk
	 UAMf0zcNVtmJTMc15zYE6MF2ZeeZYSuHCKX2y2FeQecw65Eplt1R3pKbDYijxPqcUw8+P
	 gWALMV037iW+WYjfDwqqQFrVwRDOdvJlCq/7SSMJDWkIsgi/javuv1QP4UaADBYEXIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdLKxNdt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7EAC606A31A;
	Fri, 23 Oct 2026 16:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HdLKxNdt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 123AB1F01825;
	Fri, 23 Oct 2026 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774243;
	bh=RKYh9B5CNfSy8Etq6Zv2iR8t4W9dtIW0YsafTn4OQBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HdLKxNdtE8PL+56zj/CTKNorr9AnPOZA+lQvkjYY/C9XxAwXHbSJVJWnz0s5eXwgS
	 jYbJiVKfIhuze5c45tWq+v7uwbSwp3pAekzmFhYDaNoECwAnIZq8sfNGuih7oknrYM
	 fcQ0pCuwueEgy9TIcUHUPm0mAYOM1aRa5qmp8S3Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 168/193] tracing: Keep the predicate limit separate from program capacity
Date: Fri, 23 Oct 2026 18:37:25 +0200
Message-ID: <20261023163718.186160105@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
References: <20261023163714.201276352@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Adapted the kzalloc_objs() allocation to the existing kcalloc() call. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -482,18 +482,17 @@ predicate_parse(const char *str, int nr_
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


