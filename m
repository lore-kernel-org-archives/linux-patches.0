Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207929;
	b=MIEiaF03dINulFP4xdCOYOf/1gqOkDHT/Qnlg4oFKVJop3SvcYGRyWBBR4efafQdqX0J
	 1w26G9ICVDdJuKDX82w8Y8PkyQeenxLpeux0cNc8/NCtes9wgWYKJJM0sOyR/cZybe9y1
	 H/0WgcM7zBa5fZghEceKNCAKQn8ru4U4R3YdjcQWyvKwmRqezTkV97efZn59BjYbH1uk4
	 YMmUxlhtwZtJP4T48YtpKfdRmmHJfc8gfx6lNA8Zidg8idXMKkAWLJ2UnLBjD0zFakZyD
	 pt9i6L8s7hBRLNhOlcGOzzR1Hi8/d8wNJxYDK+m7AmUgwMSG88WowVzRtZVNvXF4cLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207929;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hb6++S/FEuHcYtIl1JbiEHnLRkyrv7oAuGfanQ5J8Y4=;
	b=QoNVF/vbxdwANckOyBxcEdRujJz2G1gC0QrRjR7MrBKqGRbPMVC7qia7BHleh7/OrsN9
	 AdtVMHhb5YECqw5gNg4Sl92Ie7iWng8GHCd27tFuDAETsRRujj8uqWYGO9RjJIfzmV7D8
	 lmslHyhvBviZHZ9CENm/6eiBiyHQJX/ukgFHmstAuZDZmhyLcfIlDb7so2Deopkg7Vuok
	 QVH9GQom06aa92hajmeVX6Tls1JcxyAT5eXxz/PX3WuO+70VshrBHwdX326tvCiCtamFr
	 d03MmvsmBEnRPxvrqK1CgGCEqhxyBYbMe1sPU8j7PS5pVEkMtUH7NZaqCgsIfJooFqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SCD/XQbN";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2965A606A31F;
	Wed, 28 Oct 2026 17:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCD/XQbN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 799871F031E0;
	Wed, 28 Oct 2026 17:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207929;
	bh=Hb6++S/FEuHcYtIl1JbiEHnLRkyrv7oAuGfanQ5J8Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCD/XQbNnXuTTrUwnCC/DgFVi2CSdSCIe1RBGO3sb6eZAcl+Y2ubsTezoT6mUPlJJ
	 PSHoxi/Lk9RwZi3anlhLryUWoPV1NfP6NHGWAXCGmENRDE1F2B3xpEwCmCtRJnw8+2
	 qjYFXxBVXg4tkwaFK/7LFTlm/U+dm9CHQ8HFvsVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 190/247] tracing: Fix 64-bit and signed histogram fields on 32-bit kernels
Date: Wed, 28 Oct 2026 17:59:53 +0100
Message-ID: <20261028165951.917519056@linuxfoundation.org>
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


