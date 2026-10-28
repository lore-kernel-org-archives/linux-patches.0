Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209731;
	b=DBmv37hzpQvRNeHWNOKvsC21BMwv6wfcKBscgfKAZr7tpi5jEci+jQYxPSgsUgZBqsJ8
	 EhVDAQ75adf8msm8ef7S2HHbyUCa9tbFI3i28/HfyxVyl2IYACUj1gfca5f0NqjQkLDYR
	 SMavJkLN2t+5Sqtedh5pli/8iq1flYk6J0UJ2DRQrs8lq2fNbNMxJvcTh7CGlhw4vn4VM
	 BLRfJIqzU4OjwCe+JJLHTERz/Vouf9s/WXEMODIhD8sbK8Z9BVWifHVQCN/ArURNiNlK/
	 p2GOF2JFGg9H6PE67rPZOEoKf0/IM2E7lfxlWz2ewEPtFTjMkmPuNS8e3zXqLxTD16A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209731;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pDGQsApdZll/7HNX2lLna3egT8pWBt5cO9F3Roeap6U=;
	b=g233mVKRqEAtrQ8o1mhHUUW3v8Bs+GnkCPgDusT2XhZO/rssz0l8z120qMVmkbYrUFBx
	 ZhnXUsOQilO9ojTgiH9TITyQLg0m/LxRHKFBBKHqvlSWzCRa4B98g48XZhacZsELM0VXc
	 1c8zc4Omgd4VFG3wQPCzOBbGZ2ar46jcQCCB0y65s1B+o9oitHbBq8cChUKFkStaSUIAy
	 4m352YuCANsNVBK+C18v6nRxKSy1h89wELCdiaiO0yq34/lLLTn7k/wbNxFDMLZH0ziNG
	 OIUjc93jqKMM6CRI/f6jDPE5b+30bhlEd183UsgLBCS4w1yEjxU7MFUY3DHbRQHIy/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktVrDUv1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24F27606A31D;
	Wed, 28 Oct 2026 17:48:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ktVrDUv1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 744AE1F01825;
	Wed, 28 Oct 2026 17:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209731;
	bh=pDGQsApdZll/7HNX2lLna3egT8pWBt5cO9F3Roeap6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ktVrDUv1enA3d0E8mUpb1u2FlC5pgU1NHCWN7OpxrWbs/CojU91I7Fi662NR+lnF8
	 wZzJnjoKTDB0l5IWkhTKNbHZtTe5kqUaPcm38RnlqacCaJ8LNdrE2aYERx/+S2/O3R
	 81A77BGgv2uorRsEoeFHAX3/DqeRBTTiu2ZAT+qY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 040/109] tracing: Fix 64-bit and signed histogram fields on 32-bit kernels
Date: Wed, 28 Oct 2026 18:00:24 +0100
Message-ID: <20261028165943.305842056@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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
@@ -461,7 +461,7 @@ static u64 hist_field_unary_minus(struct
 {									\
 	type *addr = (type *)(event + hist_field->field->offset);	\
 									\
-	return (u64)(unsigned long)*addr;				\
+	return (u64)*addr;						\
 }
 
 DEFINE_HIST_FIELD_FN(s64);


