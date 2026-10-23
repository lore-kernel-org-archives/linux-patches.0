Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774077;
	b=0HvFY8OddTlPE9/65vtE1QEyMOXNpOww+Zxeq1hsiPvWe3T4LCIcb1yl+5K+weXIty1i
	 +QKE1fj9a19z/n/xEQCem4Di2JvQoeqlbLBc99D/LUWzh9vjP+iURrhPVwYkGYOaVtTJW
	 WfLJcvCuAFBB+kQX7iUvwrIs2bDA7tgsn4nu0h9QYM4EJEULSW+vF3t/eTon5XMXQAvmd
	 9KAUWgeRbq+egUPoBiDUNQta0mBXIr1/m7rwc/6stpoM+TOqdmXj1Kxo6M2vCyKOX8rC7
	 DvplC6RFs6Tq/Kb5Yrd5qkPUKNYF30DFCRkPOwrPPQe74pK1eGJrqtF0ezIADoCLNuQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774077;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GDbu0YRIWDERRWSW+rRRc4p0m9q2BM9VYmRVKChIlKw=;
	b=W2mBvUhdz31o8ZpDSjT8MIrs8fr6hhYn0X9nsfJWOpYLf3dT3rkcm9gyfwT5/gW2IBUY
	 ZGKWwvU5XyPIEJcDFjM0eBSkfAOw2r7HQrnsi2M92bCXBBDtcOiUQnmJ/SPIC9UToYvd4
	 tAKDcj/Hiw5TqohBt2tppgsf46ziE34gN1rOQCdQaF2fxlXr18ZV0bZlNCHsihhbGbilS
	 vEb1dsYd3tE5V2s41ZWI8zEcU15++zq3/18/RBWc6NWYi7USdgfZ9tqSSEDt2Rct9XxWR
	 pmn7h2riZt3/kbkDB05xHlyt5NDj5FUWPRnIatQkogs6cF5Mt1oYocn1oUqnCEn5YRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtgiPtlH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6688E606A31A;
	Fri, 23 Oct 2026 16:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xtgiPtlH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B55441F01825;
	Fri, 23 Oct 2026 16:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774077;
	bh=GDbu0YRIWDERRWSW+rRRc4p0m9q2BM9VYmRVKChIlKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xtgiPtlH9+fHUepYA9nY36PLXB60zhEdpWFeRkyJX9tLyymrG3PS5tvIQ4Mc1IgqT
	 fEgYWKO7b2qX7+9gixZBHMSKWO9y19Mg4mwYg16Toosgbx30CHb9lPM52vw67JMnYs
	 Rk0OVHEu/AIAGwxyEj99g/vZ1dFBp7N/Nvp1zLS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 113/193] tracing: Check operator stack capacity before pushing
Date: Fri, 23 Oct 2026 18:36:30 +0200
Message-ID: <20261023163716.879992073@linuxfoundation.org>
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

commit c47a7b11bcb3d45e29723afcf6336866476b1d08 upstream.

predicate_parse() uses the first operator stack entry before processing
any opening parentheses. A push then increments top before writing.
The existing check still permits that write when top already points to
the last allocated entry, which can access beyond the operator stack.

Reject the push when top reaches the last allocated entry.

Cc: stable@vger.kernel.org
Fixes: 39f7c41c908b ("tracing/filters: Enable filtering a cpumask field by another cpumask")
Link: https://patch.msgid.link/atELO9L0I9kg5CpC@Taeyangs-MacBook-Pro.local
Signed-off-by: Taeyang Lee <0wn@theori.io>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -512,7 +512,7 @@ predicate_parse(const char *str, int nr_
 
 		switch (*next) {
 		case '(':					/* #2 */
-			if (top - op_stack > nr_parens) {
+			if (top - op_stack >= nr_parens - 1) {
 				ret = -EINVAL;
 				goto out_free;
 			}


