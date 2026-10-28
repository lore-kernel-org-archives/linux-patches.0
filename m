Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207651;
	b=mtkFjmBcscmG9QzkOfd+gkIzxs/kbZQNgoaO2S66IQxG7CMopXcL9sudNuGBDs+1jQl6
	 /guKbfvQtYUrO1SKPcyX9xatRRzFS/EApwTvjRoF2Qg9zlCpVuqVlzZDgdpAolebMg2SY
	 N/Lbooc3QCShIxqUyeoFzXkoJti/FYY472wSamU5uATgASb7VG8B7QvnLKIidYtjACR8/
	 B2P10+j7eh4F1OWO/a9yh1alBPFVovisqttct+abqYWu87937dPfFAyOg09iNW2CQaoe2
	 GGpsBCIesOoGNS7vY0mTpfw8p6qNeORjlGYBoY5yil95Yo679KyaD5mhzyol4XhCCVA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tAXiGXhzSaKq3rcCdAGfjUNZS5+kZYf7pE3twLBUnQc=;
	b=qgeKkqyIJS6DO19+/he+oNtSySIEm/dt6+I8mkZxv0iGofm5JSPt/hNOGYaJ8n/zbDcN
	 jsnbeFanlMnvCY2J2pqMfaq1LdeghAqh72G6j/2eXYDBBc2heNw6jk0QzMZ58KKKrC7Ms
	 PvYrl/p063wtHl2R/W82lTlz5kGjQMWZCxVEO8PSdJxUho8xsvWxKT3CjU8NzO4zFoW7A
	 is1cp+C6VqBF0Bym/jhgY9gcfEMDMocBKxM7r8ye7GEyLldMX3ItDQ5V5ra//qvuC5lwj
	 9Eynz665eLs7gFyAMcZzZlj2k5rWYI27po/qwRNpC71zvM9YcfyhvaiTIsu1PVas9cw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p36mHGWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4681606A31A;
	Wed, 28 Oct 2026 17:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=p36mHGWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1801F01825;
	Wed, 28 Oct 2026 17:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207650;
	bh=tAXiGXhzSaKq3rcCdAGfjUNZS5+kZYf7pE3twLBUnQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p36mHGWkCYVYHmDyQKG34Q5vYEXXVsh4mGdiZyguckmG61uFnyFDUMNoZer1JxfAC
	 I1VagK9EGRwI+Jspmin/22sA9FVpGlt1sb5Q599pfflswiZpQ1ZFROTKSXVCvsMUQH
	 onXidoldLXvTzBc2LQs6hrx0jHX62rktkKWnR3E0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.12 092/247] tracing: Check operator stack capacity before pushing
Date: Wed, 28 Oct 2026 17:58:15 +0100
Message-ID: <20261028165949.572618988@linuxfoundation.org>
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


