Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210053;
	b=hlteHCY9tvavAQawonduHYVjZxO4KdhZrtVGIisxcsKPhcQrf8DuDcK7WjXbulVEEjei
	 M+p0X1VuGKprN9DJ1Rvkbg5KYzvtEuLBvwWx2W0EaCdKv3f5J5J+1x2wUCeEfmPeSUvEY
	 u8rJAQ40Q28gFeqzJuzYfVFM8oi/cmSf5nnWcEPI6AEnvFBE+n1uBrVrjctgiMC7U6fd4
	 kmUsJdIDCDBu4JqfnmlHVClA2t6nv92GG7zdej9FHGqbNXrPJNTAett4ivB0En6/Zeor0
	 33EYAuE6fxi5UlGRVMyUsPExcbQzJu+Jz8oMASpOinKN58OvRibGBg+RBHz/PXKyDBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jqQegcmtSYkIQtrcKgk6gz+PIFYJ2/2FmCrVjk98aUA=;
	b=B2EdGXMogUFBKU9KBgD7t9LFZ5HJnw+cb+YQV+ZeeYYfVujrVKt+V9djw9dSGhczi0vz
	 SZCBUL3MzEwRNocU+kAH/yH8BUWVr3eroxNist+r76fO0OvNF/oY2nSKFIwbs/IY/mx4k
	 qDDUjHOGOD+5uHsZAhIYMHDDgywNM8Hr21ibRTXR3LbbnsFjALMM6AwdFw+yQ2Y4Z+hRy
	 wjfDbHHjf7OyQ0Ep8UlXqUBZGIfN/JPYHeouNF8rIdZmFiRa/O7wChOTRolleCAzUe8ef
	 UmTyPFWiudDWmepa6wyvxktK6bGNae0d72zo9RpRCJM/2cdfEQ9NJtxCcolpNXa3dMA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtBO3Yhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D960606A31A;
	Wed, 28 Oct 2026 17:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtBO3Yhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBC5E1F01828;
	Wed, 28 Oct 2026 17:54:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210053;
	bh=jqQegcmtSYkIQtrcKgk6gz+PIFYJ2/2FmCrVjk98aUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtBO3Yhi67N4JrCfjpbEqz06nRBGUX3zaEcCItAdzZczH+yTSCxMUdOuY4DoGKTIa
	 Fa3ZqrdRC4DJZajruGNYVLp3G5p/38YsYizYlPJ/mNfUOy9DRxqvJVQINZQJyLDSJH
	 tAYdj5YiG51brbxtimAc0SJTLggUPmrNJI397fcE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 061/168] tracing: Check operator stack capacity before pushing
Date: Wed, 28 Oct 2026 17:59:57 +0100
Message-ID: <20261028165944.527819015@linuxfoundation.org>
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


