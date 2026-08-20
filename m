Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B71037FF54;
	Thu, 20 Aug 2026 15:13:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238834; cv=none; b=tzCoHf07ZcFW80kir7bNs+VT8/WwIQm4L7WecH1xuHX5fnwwqxFkA5vzkRRJuG/KQX/rlVUWTbvY4ZbBmTUqU9mD39tWRjK3C+vC0Pu171P66n510s9qeBrXP2nvCRvnKwb54AUL3DQ7SEjnB3iK9t+kbNKjRO8XePtzVBTJWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238834; c=relaxed/simple;
	bh=+kaVlIhFx5AXGQeBavXqihf0aNuGllLHygjc2gICukI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ivqk2bD+io7+JKeo8d3TZZwV+7MpWAMP0txi/uSo158kJUSqRuehuCwFlgL5xohwN7sFk+v2iCt48ye3YurKHb+EB5APuWE66UzYbLMNkF/cuIM8Fk+1T7ujDd8Q1+wZ9DBFTYG3S0HDC+Nq1NunGh9zG7MsxHNgcrSCCfgTY+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e1t8d8m8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e1t8d8m8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D673B1F000E9;
	Thu, 20 Aug 2026 15:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238833;
	bh=CptqCGYC7tZp8Vh8zjHf9YDwhLPnhVGKFLT8uLnExkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e1t8d8m8zv7zrmd8EsJaZ9IDZ8m+Lf3T7lI3RGbr7M86lC6YknT5Yx2zI+X+u5cJs
	 0DCn9dV4I2hnHIUOwaKfV/3iAUGb9/T/vsU9khU6ltQpYwPIQPmtTjiYe59kO8EvS1
	 AJjUXWAkUmCYMw8b7j1yl6GxLmoWUKhjHfq150oI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 6.18 057/217] ftrace: Protect direct_functions in ftrace_find_rec_direct
Date: Thu, 20 Aug 2026 16:53:45 +0200
Message-ID: <20260820145239.336161768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: Leon Hwang <leon.hwang@linux.dev>

commit 63444b7617c09aeed36282e061c3f80818f2b600 upstream.

Fix accessing the __rcu pointer direct_functions with RCU protection.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260730150411.88667-2-leon.hwang@linux.dev
Fixes: d05cb470663a ("ftrace: Fix modification of direct_function hash while in use")
Acked-by: Jiri Olsa <jolsa@kernel.org>
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Leon Hwang <leon.hwang@linux.dev>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -2594,7 +2594,8 @@ unsigned long ftrace_find_rec_direct(uns
 {
 	struct ftrace_func_entry *entry;
 
-	entry = __ftrace_lookup_ip(direct_functions, ip);
+	guard(preempt_notrace)();
+	entry = __ftrace_lookup_ip(rcu_dereference_sched(direct_functions), ip);
 	if (!entry)
 		return 0;
 


