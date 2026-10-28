Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210236;
	b=r9m6y2tA4Kl3b8+DMcVvPnw02RPhlvYhlpwite1kKPHcyQA3QAvwOwVfUQgG1HI2CAAI
	 +yn53qUNFGXpQvO9ohrGGwrTNHu/X/3M3rNhJQErGKdbVF6ZWmrTu9H8WEYTqfqepR3bM
	 tsOMk3nIQdByj/aXs5HdvijQ8cOkoxdJ/uOYfw/DHVYiKoPFxNF2y+DYBqES+wb+GWI61
	 3tHpXeYzaT2QAwxxy2v7NgpRRRci3ctJHrueFO1pevmF9omgKzeO5H0YlMs721tw5/LT0
	 vWkq3IG3hvzByMbBcACR2B3Z3PY4ymCfQS/7hpbWRqBkCxWlnluoeI17pcQsVSSEQQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210236;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=opx/M7qnYL0o8ru+VqpFovcFKN5rttGgGnwhR7gptNc=;
	b=hlNGF40yHOGFy6yh9593NPSo/hUtvyrFpdnxC0sg1g6eFEV6hiLjiIPE9muGBoRgSKWU
	 YH02a74w6P9zxnaZelPRr60vDBVLLQly6zo+pgw1dbOemmJ1GZom/a/S1EIefdG/Y8aJA
	 yvDLucVCR531dQCrK3gLLte4AmRYPIOYnjvA2uEKEW0G75rkqLm+V8F3awO+AU8MA/rxz
	 2CQC8Bl7gXitt5RnMWgGGRwWNqiYWHdWl+Fp1DMoA0I/RY8KWZgosrSAdYOFuSbNS5Cpw
	 int6+sc3nKwgOupvWZe6Lu6kqBEzkQNmr3F6M8l7S8hqnEUaOjQr/WYh+XCcOII8Blg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9VAr9+l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B101C606A31A;
	Wed, 28 Oct 2026 17:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9VAr9+l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C3B51F01825;
	Wed, 28 Oct 2026 17:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210235;
	bh=opx/M7qnYL0o8ru+VqpFovcFKN5rttGgGnwhR7gptNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9VAr9+lV2jq4KSb7Xz+scEWb9VPOgY5Rk0yX09o4oiYa0ElTIkKrQ2N8G11mgZz+
	 8SFX9hrCfrJVx55csvAkWVM7b8fBW315z1nRl8p3rPhSSWORMmjId9HwdIxxVx2VHN
	 KNhF/0+VwkodP4w7nVxApVauj4s8M82tCRF0jzMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 124/168] tracing: Fix 64-bit and signed histogram fields on 32-bit kernels
Date: Wed, 28 Oct 2026 18:01:00 +0100
Message-ID: <20261028165946.021812910@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 443d23176812803d0fa182b8d05ef066a7b8271f upstream.

DEFINE_HIST_FIELD_FN() reads a trace event field and widens it to the u64
the histogram uses as a key or a value:

	type *addr = (type *)(event + hist_field->field->offset);

	return (u64)(unsigned long)*addr;

unsigned long is 32 bits on a 32-bit kernel, so the intermediate cast
discards the upper half of a 64-bit field, and widens a signed field by
zero extension from 32 bits rather than sign extension from its own
width. Five of the eight instantiations are wrong there: s64, u64, s32,
s16 and s8.

The cast came in with commit 79e577cbce4c ("tracing: Support string type
key properly"), which also added hist_field_dynstring() and
hist_field_pstring(). Those convert a char * to u64 and do warn without
an unsigned long in between on 32-bit. DEFINE_HIST_FIELD_FN() converts an
integer and never a pointer, so it gains nothing from the cast and only
loses information.

Drop the intermediate cast and let the usual arithmetic conversions widen
*addr according to its own type. unsigned long is 64 bits on LP64, so the
two forms are identical there and 64-bit kernels are unaffected.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260917015532.103081-1-donggeunyoo.kernel@gmail.com
Fixes: 79e577cbce4c ("tracing: Support string type key properly")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/all/20260914054614.82A9B1F000FF@smtp.kernel.org/
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -460,7 +460,7 @@ static u64 hist_field_unary_minus(struct
 {									\
 	type *addr = (type *)(event + hist_field->field->offset);	\
 									\
-	return (u64)(unsigned long)*addr;				\
+	return (u64)*addr;						\
 }
 
 DEFINE_HIST_FIELD_FN(s64);


