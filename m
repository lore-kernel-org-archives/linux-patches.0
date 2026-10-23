Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792774908;
	b=ZSoxbLgMJIXskVcPJMRb6ETBedRMHBqzcwawrMb0mdSjt+v/y2QPDff2Fl7kur//ykHR
	 ICZA0uSKD/SpIGlkxnh4mIGyi3w6J2J5k/bJMizAppXlAzlM8l0szfYecNCIGqnDK3IZn
	 PXzFxHi9PkX/Ma4HHdQzSvFT183H8fMpIihASH4JDOj9RQFT+sT1j+x3aGjNDeD/GLyyP
	 p5/GRspN17554bOqobBMqLyUne0PbLQUsVLIHgP9Foh9miTC04b/qhIIk88n/M+eefAV+
	 Mi2+uzF+ZK/qnh2Mi8lb8/MI4nzMdAdlpw6GRfYl5t8n1IWmCkdyREn7bj0i99mJsmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792774908;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nigTmdfod3WETZ3O8dFnmEytWe2W5egxDquUDwIUSGw=;
	b=UJcl7Y9S0QFlmVeGmM0DLPZsE00Ze84eZSCLGopXB9d4hJQlw6mvHrX2MvRLzVbqfIic
	 3+bhn/RNq6bDgoQgXntVE5QqeijahwkHrjC0omma9cEeh2MB5V+G982IEhtU3RLmnD2FQ
	 NDeT3MBT2HgseosHP2KL404lbbUBGdAN6KE5XUN25hVEcZ3GhmMJU2BEn1adiOWptOaHF
	 CbV1PQ3H7Xp1DyPHWR9vMpmgXNF9psPnpfQyNczq8NwmftJf8+UQk7hXYNL9YlnijiutH
	 6Om30hhRyOukVTOJeizIfTGVZbdP5h5cPbd91nskFoV5d2KEmn4HtCDFAvuAeZgnklw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPgzAG8l;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CAC606A31A;
	Fri, 23 Oct 2026 17:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sPgzAG8l
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C4B1F01825;
	Fri, 23 Oct 2026 17:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792774907;
	bh=nigTmdfod3WETZ3O8dFnmEytWe2W5egxDquUDwIUSGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sPgzAG8lnjMdJCs9wL2rSA75khpVYMmLZbZTV+9J+hFXIYJEke9t9d0iiR8jquVac
	 U8J799lqy3uvHaeRDLApmhxel9ciku1YR9RD4T2MvzYrF4Tzejv9ayYJWzmiQLDhvE
	 NxOYVOLXLE3MKhhhEIWF41fiecchSLvX93I9Mwms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taeyang Lee <0wn@theori.io>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 171/242] tracing: Check operator stack capacity before pushing
Date: Fri, 23 Oct 2026 18:40:13 +0200
Message-ID: <20261023163717.831140378@linuxfoundation.org>
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
@@ -511,7 +511,7 @@ predicate_parse(const char *str, int nr_
 
 		switch (*next) {
 		case '(':					/* #2 */
-			if (top - op_stack > nr_parens) {
+			if (top - op_stack >= nr_parens - 1) {
 				ret = -EINVAL;
 				goto out_free;
 			}


