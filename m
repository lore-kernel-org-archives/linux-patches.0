Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 121973D6465;
	Mon, 17 Aug 2026 15:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979485; cv=none; b=MSy6BQgLOD5teW4DT0htH6rwBK7KZg1euOXBL0Ergo29kiQVqUUqnyhbtKzdi8MXMGhp1DfXs84xkSRBEmeleUSmk8fz0AHrfpys3pe8xn982XbGlkbYzYmQi16OaqiPw+51Mg/fPcdywInjLR6ebXVb6iR1LP7ktuTa5NW+6/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979485; c=relaxed/simple;
	bh=HqP677ybrInjZ/6fQKNAboTqCfCaXifDzMVBL7iq6kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wwgui8rjRDt8ezWm54OVTZEC6lJvVdKcXMK5Y0GEzrN9Q01c46GjrUHYpqxuKSFzO1nj8XbKASKR3M1g1IN72MeUgq4HQExPyNBvuL4TbT2RHfOdnRYaRGY5WaxrE3KMBeiQSxcC4iBex5b1Uu1xVNxZZOErFSZ2wW1zkFQD9is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t3IZkI1t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t3IZkI1t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7ED1F000E9;
	Mon, 17 Aug 2026 15:11:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979483;
	bh=3KuOu2MRcq326/wC2qJJP1AAApqoVAkRdkGpZq+hark=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3IZkI1tS2ulWpLlEJilTs3Jr+VQBhEQ1YwjXGGcZ0ed2gDm6XQr37er0j90X03Yy
	 L37jhcwViHXxCeZhoeXgohVPVeDD3kZvaxOKbiKdyKjdbUj/0Zb2dH1czEdCeMYisX
	 wbgj0JfbQIa1QHu2HaOGpm9ibg4Lz5QeimDx4K10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 243/609] tracing/probes: Prevent out-of-bounds write in __trace_probe_log_err()
Date: Mon, 17 Aug 2026 15:28:59 +0200
Message-ID: <20260817132552.212793110@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -176,7 +176,7 @@ void __trace_probe_log_err(int offset, i
 
 	lockdep_assert_held(&dyn_event_ops_mutex);
 
-	if (!trace_probe_log.argv)
+	if (!trace_probe_log.argv || !trace_probe_log.argc)
 		return;
 
 	/* Recalculate the length and allocate buffer */


