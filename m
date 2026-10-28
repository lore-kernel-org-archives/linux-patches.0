Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210051;
	b=xTVbaUzhtVJF0LRU7PWifZf71pwHy53A/iAdbsOz3uhCfxfokuknaJJ01UwtXisTt7xy
	 A2TC65fePE6N76Qzk/4Pa/QnQkR+EYIj+4Ps+KZYHXxR87v7ctrsR/1z06pmXbphN12vC
	 iLcydfMFKY96p+NqwGotpP1EIQgHCMdaX4TFEZxmu6eqbBLbrPu+8/mTRwBxNDyninNLS
	 Z0+4aFm0FLexCXVLs555WScrpA2PpsBoBhqp1g/hiYpd9XJyYLlSgefuQUsBwZsLMFIav
	 iRNpM7BziaPkIHq+21J8Nw9zuaMs4Oge/FqIUGDRD9wNTChvvd3nzLQu32L3fkcy5HQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zz7GgKa3qReyko6pxBxFpadD8xUAUXcwuIBZRmq/w94=;
	b=cZ+Of8dniV266nt905MN5LIc1TsNUJzXRsvle5M/YzpKTZtPmNw9LEGo/qeteLbWo9aj
	 ADrWCpGljpWL+h4jeg/6UfW1JAZkng9ppWjC5zCv9RQP9R/R49y0GWzA/kL1g/XcK7p5g
	 GYgJOItzJ4PA9Uz+klKdQu4L7xI1v4umlW6jnFOSDLhj/clcLw7lFhJvz6bK5fTIsp+10
	 eANQQxJ+MsE64ewrDJg9kRpp477ZbmDtjO6B0dujSxnzfreOBo8hxja00ugEj6ug9UEhE
	 kMKDfkIQCXXy5TSgDN75cIhE8Sc5B+xsjwrTsbfjFcm6tmvAACcq8EnlKzRjkXF3k4Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KATn8uM+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9225606A31C;
	Wed, 28 Oct 2026 17:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KATn8uM+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151CB1F01825;
	Wed, 28 Oct 2026 17:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210050;
	bh=zz7GgKa3qReyko6pxBxFpadD8xUAUXcwuIBZRmq/w94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KATn8uM+NkI8XM30mw/vSpLa7RJvNyEIVlUVLtACCkXiNtrKRho4a3/uX6KrqISgS
	 F9d/Z3sMEulqQ4HCmy9SBHC3Drgrf1eq67tVJcmK+yesZfCMzjLwl2AtNvjT7Ui2SG
	 r3rKaNqyDukhkGtqHKyG9NuiD2ma5kP5EEVgziVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 060/168] tracing: Fix the shift out of bounds in the log2 histogram modifier
Date: Wed, 28 Oct 2026 17:59:56 +0100
Message-ID: <20261028165944.505113776@linuxfoundation.org>
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
@@ -283,7 +283,7 @@ static u64 hist_field_log2(struct hist_f
 
 	u64 val = hist_fn_call(operand, elt, buffer, rbe, event);
 
-	return (u64) ilog2(roundup_pow_of_two(val));
+	return order_base_2(val);
 }
 
 static u64 hist_field_bucket(struct hist_field *hist_field,


