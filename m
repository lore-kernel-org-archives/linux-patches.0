Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A54B36212F;
	Thu, 20 Aug 2026 15:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787239461; cv=none; b=cFMaFbbELqRM0th5C4PjuE6FVu6Euu9z68RyUzbX/dyveJvSUTA+4h6gtj5v8wzwnc9vKS9o/NxCTMx1BCPMGsV4rVG6MrFrvG3GiEeBG6sxp6UoGzVE97w6TxabWNXhjWSNfAP4YQu4nXdwVRXd+/bodGDJW9hcCEoIXrTJx3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787239461; c=relaxed/simple;
	bh=3ncN4PEpthc4+Ejz7SJhnXa6Jj/ge/2UK33urlHYIuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YSwkfLbigTTRLt5JQ6ybFwlApezubfGzXO/mF3ddUkkKG4GiSxULC9Gz9CXZ9uaJM1pkvSXmjXIMGFm1GoN8nNclB329vbcXX5ITPMTG5yNZ782ooA7mb9BQ6V8hLUsXgkstLX+fiwyh/PeMa/vfuhEJdj66bfgliO3BhaqYhuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uQdo0jNs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uQdo0jNs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74CB81F000E9;
	Thu, 20 Aug 2026 15:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787239460;
	bh=oD0IUQFPQX6nBfdhOHQPsm0WRFoHMmsSf+lGEHPg57Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uQdo0jNswT72kx3muSfxiseKDQpxQn7TV9VL1MkWumHw7+FmKOw8QnIVoPch+xEml
	 ITIyKkCtySsPwkDxYToAxshdaMy/KZbv5NogKsBxdL9SMxNz3eCQlIPhYhms2FseOr
	 dkd0aJzGIVjDdu4AUHQOn5GqPZPFfggsv/JDyLcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 6.12 055/220] ftrace: Protect direct_functions in ftrace_find_rec_direct
Date: Thu, 20 Aug 2026 16:54:05 +0200
Message-ID: <20260820145225.149633968@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2593,7 +2593,8 @@ unsigned long ftrace_find_rec_direct(uns
 {
 	struct ftrace_func_entry *entry;
 
-	entry = __ftrace_lookup_ip(direct_functions, ip);
+	guard(preempt_notrace)();
+	entry = __ftrace_lookup_ip(rcu_dereference_sched(direct_functions), ip);
 	if (!entry)
 		return 0;
 


