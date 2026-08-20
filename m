Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 446D83815E3;
	Thu, 20 Aug 2026 17:38:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247523; cv=none; b=QyEbNWVxRj9iy1OOAGQIhupi18ssV5IIG8IfwufpDou7EHbTdbS+goWEaxTBuUUMhpTSAnO8lCm8oD773f35bpcmKxPMS7Dxdbn/qlFJNkT+oXDWW0EZ3tWX+3++qgmIL/6Fl8SrmnhID2x7MDsKT+riB9WqSRcuM3y0Qmci66w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247523; c=relaxed/simple;
	bh=pX87KsiqfuUgp4BCm5KYdlLjO95pWb3JaOBv3kVFur4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bL8OU3TaaJsQkt/mc3ub0QoMDUcSTzZGCnvlFwa5rjM8jhuGACfYwnvl0uc1TzLRQcKsNgRLdw3+Dh/+1Bj+ou+8YVp8kSRwIlIAQJataL2zsrPfvujmca687QUJbpxa3usJEatlsldibuTtd/sYSBEHMVGLHfFVpvKx9K72UFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZf2glGR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZf2glGR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70F601F000E9;
	Thu, 20 Aug 2026 17:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247522;
	bh=ol26SHiDpRFUBfLo2JvgQzoP5SCHfN9SlTL+qfgFyiA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZf2glGRj2fnEhTqB72Cw2XX0g9f5ulRF76I+R/17Mh0VQA2j8eGlef6ZssrTBNL/
	 HrB4/i5rXToSNd8iK+ij2AuBQ1WIuPCjS2AfptnVpDKkmbWx0XQN5mBzUajbcQ0Oc2
	 F3sa+cDKeYEXcflk/bUxTeVjC3fBEQFlXCLLuJWY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 6.6 036/166] ftrace: Protect direct_functions in ftrace_find_rec_direct
Date: Thu, 20 Aug 2026 16:54:55 +0200
Message-ID: <20260820145212.266194343@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
References: <20260820145211.194104353@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2562,7 +2562,8 @@ unsigned long ftrace_find_rec_direct(uns
 {
 	struct ftrace_func_entry *entry;
 
-	entry = __ftrace_lookup_ip(direct_functions, ip);
+	guard(preempt_notrace)();
+	entry = __ftrace_lookup_ip(rcu_dereference_sched(direct_functions), ip);
 	if (!entry)
 		return 0;
 


