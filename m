Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF46337C92C;
	Thu, 30 Jul 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424738; cv=none; b=JK9Mz87FnAslT2hzOLpkKmXjvSjYRhTJAh0/OwPWavCtj7zebWUQnwzLszfn8rk/3g26L08vC4jm7KeVJ2a9USK1pCQB6FdbAZhGGNnwWeQq+OsTgbxkWxsXAjb3myvE4dfMQAROTaWYD+/xebZcqn9BdaL/sAKBhN1L307A6Jc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424738; c=relaxed/simple;
	bh=mO363elRc2z/4yl4VNbPMRDnKG9ZzP9+OQc2kpBQ070=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OWHQ7mZeJ8S52310HYMaqtOFGV32i24zxArf0B1P3Oorf0NRdZfOmtmLbHAqb/CF8iIo4HIymwgn6ks2u3UKQz9haqYXrfLB5j3Nh4604umiDsGDk0w8R3s02cOpuVy6nPJ1c0Edcu7BQhfTsKca8VzgI6AkagwKxKzmMSdnzBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qsb1wY9N; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qsb1wY9N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 283301F000E9;
	Thu, 30 Jul 2026 15:18:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424737;
	bh=jz9DMFJg3F6ooTQh8aH9odicyCATz0aeAUhJ+NLIud8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qsb1wY9NEct0zd5YY5l5VA6kD6MhgWsqsiH+NIWiJJ6d16ZE5nJSxX3gnpUJ2uAg0
	 IvGegDKRlKa+AC6GoEgskuJfaHpIaJ+ymDChhdHJrXWOZ9vLps7StMXcfZfF8cF96n
	 lFL6xVzg3WCyEDh++VCQm/jGnMAXArgV/EOixj0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 497/675] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Thu, 30 Jul 2026 16:13:47 +0200
Message-ID: <20260730141455.689591344@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit a9d6fb284039a5d3858a1d9f9a0d7e46cfb7c2d4 upstream.

If trace_probe_log.argc is 0 in __trace_probe_log_err(), the loop
constructing the command string will not execute and p will remain equal to
command. Writing to *(p - 1) will cause an out-of-bounds access before
command. This should not happen, but better to be treated.

Reject if trace_probe_log.argc is 0.

Link: https://lore.kernel.org/all/178454233992.290363.18323091580600697731.stgit@devnote2/

Fixes: ab105a4fb894 ("tracing: Use tracing error_log with probe events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -187,7 +187,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


