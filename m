Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211989;
	b=jdR/FNGACfYlcK+A4mo6TpcB0/fcUcDQSjnRVvi88NqAlGBnccrgo2RkPu8Q50bthQB2
	 /GZPsUmUtNllYH4381Hy7fQD4IpNsSlS/Wm4fHN56JmGiP5f40wClVe43tcFUKlpLpb0f
	 YPkDrWhM8M52UEduduxc3VO+Rb+YZ61gfaCyOZH1h0LuvZCUyrElVWIFJH7XtK+YE0dC2
	 BQ2S/L3jWPSBnHPW3gTM2zSEMdoG/ilngjj+Kf4/I+3/DLjsn59gsdwrCJAw6pIQRzRH+
	 W+Sf57urVMepXplprYud31FkKIFacdGHZwAVPpue4tfJwt1UdgoOuC63xGGBrYuS1Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211989;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PY37SMYDvirWPkZLaEVqqFdCndLeqSml7eI0WUGYfec=;
	b=y0BsYCahOmnTXUaKbKJ4QfIhbYzU0hIQ3oyF9kWs5P4LSuNd3X8auDOIY0YCf5XMu5gQ
	 3JJ0B9MrYVk5tvul2IOPQ45tV2iI2lyGNEgOMdo50Dr1O36XMqhvpYWAeGJETz3puNTpi
	 gcB+OidU9p7Emsqn+RLZYc5q0HPCdyoGn9mRBhwP5ItJ4nDfelwSt6Cznivp6SVHaFZGJ
	 VX/c8MUj7gU900Qd1N2zF0tBdylv8bLy9EVR1etgBrHFXwBg5U2GBqszc4jgWrq4nqD4j
	 WeLGP4cNN+7rZSBb9drWekp5BoAED07FzAgz6h7NjahWyU26NUGi5qMKZxaf9Qz/Q1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5E6Tzbu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0934C606A31A;
	Wed, 28 Oct 2026 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K5E6Tzbu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 131F61F01825;
	Wed, 28 Oct 2026 18:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211988;
	bh=PY37SMYDvirWPkZLaEVqqFdCndLeqSml7eI0WUGYfec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K5E6TzbueU4SDRxu41pMTBxbIoYUjIws+sk+liWOZB0Cksypjae5RIaqek2L6VkrM
	 cQeD+bJOm5pW/GXKy8/uISXyTx2Sp76J5ICDZEBe66ZIHh42JUJA/vOwOli+lk0kmZ
	 cFYV3Q9fYL9LHEkZfUFhOWK7dPJbjbHoWVAuoQh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 5.15 561/571] tracing: Fix 64-bit and signed histogram fields on 32-bit kernels
Date: Wed, 28 Oct 2026 18:01:48 +0100
Message-ID: <20261028170021.345555998@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -294,7 +294,7 @@ static u64 hist_field_unary_minus(struct
 {									\
 	type *addr = (type *)(event + hist_field->field->offset);	\
 									\
-	return (u64)(unsigned long)*addr;				\
+	return (u64)*addr;						\
 }
 
 DEFINE_HIST_FIELD_FN(s64);


