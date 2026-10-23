Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774964;
	b=UZYF2MNKDNpAQlnyRRH4ISFF7dM1eoZECg7X31uOMMnqJOgAO4Fc798ftNjVanyQ1Kgd
	 hbdpIsg7xWIzP3F0KQB7Hkxk6Ai9Iw9FCWJvSw/Y0oj6BN7jDcePnY2gHZLvgBtwK7k/N
	 tJhVkQNc/ZzlR2+BelAGsWmpBd5P6dn61HTTH1+DClyYiT/HRbshfKp3BbdHSib7o27Gs
	 I+1Ii9qfbTId0/i7oHc1PbgYRO2EOMbk6n0pq/xHzwQMhHRMPsBI/l9aYknStM4lSCkco
	 O8nyHQxmZBrOVhpM2wca+ykS1S6Qw0T6WsLEyB0wkJm8xWVMDiOLIWhd0Qz9QbJiDeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774964;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EcV5Rlq1hvuRqnd16BN0w2UwzVCCFma1NIcWt0fF1W0=;
	b=x3tafViiRb9/xBAbv2kXGrog/qdGdMmVyLSfa92TlOrqUMSoJTqaG92gkAyZkX+J4CdJ
	 MPFZ9HTalHDKEub+DXm1slvU9MLfiuD3y+7mgk6Jh3KXXSo30JG0QG/puNeRfHpqVPukD
	 pDwgioSWVBZtO4jirnGZhCXb+iDgWYcKU8R14dnzwEP5GZdLa+JB5X7+wOnbFTBB9DKiu
	 HLsQgsEdGcdRoLChMdgi9E3VQ/5x1sZUU5f2DxUjt65AsEvqFj0o8UsZlZ/9J1ZrildE8
	 36w0BJoe0cpdAvpny/8zz/oa1XIkJZ37C9au4DLjsaDY/6P2C+gJJ63Q5aWJZrW68yQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giYxaEMS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1596606A31B;
	Fri, 23 Oct 2026 17:02:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=giYxaEMS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 027C21F01825;
	Fri, 23 Oct 2026 17:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774963;
	bh=EcV5Rlq1hvuRqnd16BN0w2UwzVCCFma1NIcWt0fF1W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=giYxaEMS8S1ZOVDt4lI6AAZ43DBHNqzjq834fCWJD77+I2KU6tDZxdHIZEWRUoyFU
	 5nFSlPTMWOWRY46gl1lF1UuBVNvTQogOD3ENn+XXUpOjiTl+uGTCyKbLxTRQ8W7VZR
	 8BNKrGeGRlSxlJbjDNuzP4BH4aNfQQnXFfpT31OE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 168/242] tracing: Fix the shift out of bounds in the log2 histogram modifier
Date: Fri, 23 Oct 2026 18:40:10 +0200
Message-ID: <20261023163717.758781484@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

commit 647c2f97fcb94bc642cefe6db004999974563f06 upstream.

The .log2 key modifier files a value under its base-2 order:

  # echo 'hist:keys=bytes_req.log2' > events/kmem/kmalloc/trigger

hist_field_log2() computes that as ilog2(roundup_pow_of_two(val)). The
out-of-line form of roundup_pow_of_two() is

	return 1UL << fls_long(n - 1);

which shifts by 64 on a 64-bit kernel both when n is 0, where n - 1
wraps to ULONG_MAX, and when n is above 2^63. Both are ordinary keys,
because the field fetch hands every value over as a u64: a syscall
argument of 0 reaches the first, and one above 2^63 reaches the second.

Keying sys_enter_lseek on offset.log2 and passing 0, 1, 2, 3, 1000,
2^63+1 and U64_MAX gives

  { offset: ~ 2^1  } hitcount:          1
  { offset: ~ 2^10 } hitcount:          1
  { offset: ~ 2^2  } hitcount:          1
  { offset: ~ 2^0  } hitcount:          4

Keys above 2^63 land in the lowest bucket. With CONFIG_UBSAN_SHIFT=y
the shift is also reported:

  UBSAN: shift-out-of-bounds in include/linux/log2.h:57:13
  shift exponent 64 is too large for 64-bit type 'long unsigned int'
   __ubsan_handle_shift_out_of_bounds.cold+0xdd/0x1cb
   hist_fn_call.cold+0x8b/0xd9
   event_hist_trigger+0x1cc/0x790
   ftrace_syscall_enter+0x197/0x360
   do_syscall_64+0x402/0x4b0

Use order_base_2(), which is ilog2(n - 1) + 1 for n > 1 and 0 below
that. It returns what the old expression returned on every input the
old one was defined for. Where it was not, 0 stays in bucket 0, which
is where x86_64 had been putting it, and the keys above 2^63 move into
bucket 64.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260916002735.808520-1-donggeunyoo.kernel@gmail.com
Fixes: 4b94f5b7b4a5 ("tracing: Add hist trigger 'log2' modifier")
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Assisted-by: Claude:claude-fable-5
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -290,7 +290,7 @@ static u64 hist_field_log2(struct hist_f
 
 	u64 val = hist_fn_call(operand, elt, buffer, rbe, event);
 
-	return (u64) ilog2(roundup_pow_of_two(val));
+	return order_base_2(val);
 }
 
 static u64 hist_field_bucket(struct hist_field *hist_field,


