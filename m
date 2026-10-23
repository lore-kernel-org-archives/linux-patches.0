Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774841;
	b=f5DCGiHFstHz27fml8m16IEJ4i8mOXzv9XIYsdRjx4nXp/hHU4uesrzA5WjQhhVQqt43
	 o82qMzW/T/ukKDVugrrFOREiEyHoYj38kPIbJxHC8nFjYp9vmTsvB9ZGHotIpf3QmASCx
	 DYutTVnFEx2EJOEAGYh4LHEk9DqeRaUTrH4F7+KrlXsHngBSDS9jW0cT6Y0ou6olEupZj
	 Jh1Bweix3ntvBRKkg3abi29VtfIGZXowpPIr5iRezfFBmzPelHKsBK8v5U5sV4Y5jh13A
	 3y/fZ7vfGhhyx73KZ7o9MGoJGjivTXqCStwmzvwLOjkUCIBI6mmMdgLGCHjvmIqLo+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YIrW05PrIe68Sq5PUQnVptNtSp8EXRLR9NYdkY8gxNI=;
	b=fiVKAdYvQPZzbTUV5v0L1lddMy//1v8QuYJB5ADLNnmxVC3YXooUO7p0lcQAJ+/+GtYF
	 4EKseit+nDwzlWF4CsYt6WFZ8ceIyVZTSjDkgQjWa5c+uOCh9Q+Oo/7bdv/GY59kaud66
	 k1hdn54fI5LjGYyFZ2gw7JebHsHN8r/QGeDrNNMECYCEU7xuRaZ+8CecdukuiLBEYAAtv
	 SJlzab1rl4mukKS/CziWP1vF8AovOSZt5m2An0kv1h8oE/uTFt/LleejbsVSURhU/x5IM
	 SZJoVT/yPpHk194eSEg8mEjh1uaTp6FBIz1Lt3kURXHAncheCS/TrsOi6dYNdICF9zQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ITWQ/QCp";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF3606A31D;
	Fri, 23 Oct 2026 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ITWQ/QCp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 113591F01825;
	Fri, 23 Oct 2026 17:00:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774840;
	bh=YIrW05PrIe68Sq5PUQnVptNtSp8EXRLR9NYdkY8gxNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ITWQ/QCpm/MgsjiNMzbw3VCTHmGmBdO6VMhlPY5UyqmEONUrc5SK6mxQNvprEL4H4
	 ArH6J75B+MUrWdmPS8m+p/lKmL0eK/6S4Rq2UFzGJwq2xLY4ncPIpKAG45x7XFwBwe
	 fRMVRlQU2iygtLGZaS2xwIzQxEwF2BhuVdNgJSVA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 169/242] tracing: Keep the predicate limit separate from program capacity
Date: Fri, 23 Oct 2026 18:40:11 +0200
Message-ID: <20261023163717.782763784@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261023163713.816071858@linuxfoundation.org>
References: <20261023163713.816071858@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taeyang Lee <0wn@theori.io>

commit 803aa6fc2dbea25ab9d3ed19eca1c96d0ab17445 upstream.

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
 
 	op_stack = kmalloc_objs(*op_stack, nr_parens);
 	if (!op_stack)
 		return ERR_PTR(-ENOMEM);
-	prog_stack = kzalloc_objs(*prog_stack, nr_preds);
+	prog_stack = kzalloc_objs(*prog_stack, nr_preds_alloc);
 	if (!prog_stack) {
 		parse_error(pe, -ENOMEM, 0);
 		goto out_free;
 	}
-	inverts = kmalloc_array(nr_preds, sizeof(*inverts), GFP_KERNEL);
+	inverts = kmalloc_array(nr_preds_alloc, sizeof(*inverts), GFP_KERNEL);
 	if (!inverts) {
 		parse_error(pe, -ENOMEM, 0);
 		goto out_free;


