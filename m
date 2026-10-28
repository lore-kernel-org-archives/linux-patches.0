Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207173;
	b=tMUhHpgt62A/ZSKV6bUeh3lhzPUM0vfMDFXazPO8ClqTlR+GUFQs+jg6Ab6kl/ZSrBwl
	 s5ANwa56noOMfc7Zyk4cywOc0srTPr9fttVW2qBDEezFbl1gB6uQQ+Q7Fx8kW0twp+GIV
	 JUpUnr/QSHuuQV1dF/As7EFCphHtltyCvUw1Am2+3ogtvB1R+C9i45AjHoBZjvL/cdxxR
	 WA6YXxa30225GLAL+YG0IdzRdQ6/Ro3dO6gh4euaMl+ZIAjmQ6d9Zly2n79Ur8HZUOuQY
	 zOM6byJl5/Q3jj41IgN6dW8r/mSfEn9tMDGbR42KtPWRP0GiLxEz06ikyhJdmaoAGEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207173;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=axpP+Ej5XcD28w+qxR8djXhX4MS6I6gQg/bOkBiDVdw=;
	b=IY8FUd2NTJ35BmGACVmeAHa3+UlexDwxuyndP+rr+ln5Ycjrhpn/gUKbnkqZ91qDdZ/1
	 agjjhKhBKsnyEmPU+Is9jEuN18uhiqLnHmlqgB4FtRhZp+3qw2yD14IDJ+V+kJlmajIW/
	 zvu7w813piUl8pID6PrPaW6f5smhwVPxzik01BHoHPdhW2CM/hB7s7uUM6e1gvxTzbSN0
	 ZJBcGOXxjnO4X0aleNHEuFDBXwxORYFviOcn744BE2jvjff9DDY3YI2qugD7YR2GjM8OC
	 V54KIIQPot41mgS5cMhCgv4oqpATo1KE/U9hWF+YtVw9Lpxd8ULq8/N6K7vTjqPtIwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0nxN37I5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955DD606A333;
	Wed, 28 Oct 2026 17:06:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0nxN37I5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F7601F031EC;
	Wed, 28 Oct 2026 17:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207173;
	bh=axpP+Ej5XcD28w+qxR8djXhX4MS6I6gQg/bOkBiDVdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0nxN37I5zvu7yqoEHXHaXiRg6b6pesmMTZVgr5176D9hM4++hIxrrk4j0h0WJGg9H
	 WNE63PzTw7uBeSgRM7vcQbZWS4kOea9RuximNfSJALbyRHjLsr1yKYlhX3aJQoM8hS
	 BlLSIhTUKul+iSrGsLK1roPVbRlLV63BqC2EO+3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 13/88] tracing: Fix 64-bit and signed histogram fields on 32-bit kernels
Date: Wed, 28 Oct 2026 17:59:21 +0100
Message-ID: <20261028165942.427325638@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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
@@ -467,7 +467,7 @@ static u64 hist_field_unary_minus(struct
 {									\
 	type *addr = (type *)(event + hist_field->field->offset);	\
 									\
-	return (u64)(unsigned long)*addr;				\
+	return (u64)*addr;						\
 }
 
 DEFINE_HIST_FIELD_FN(s64);


