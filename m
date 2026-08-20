Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911E033263B;
	Thu, 20 Aug 2026 15:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238205; cv=none; b=aNxPp4xlrswM6A9ywak+vPmWYhNBJvIsFTVRAHyDyFXSD+bL0qI+hyhtLZHC/bZCt7hz/T9AyUr5Tr/FvzC8y0sWU4WdAvr086G76veNphE73EejNuGeCtTUJnFVJUPLy0cmy7rG5Z9ix9H5igY3tZUOC7Df3VOJ4x3the3wINE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238205; c=relaxed/simple;
	bh=coa7tnSpY/yiIZJOBVqRfeigPgeQhioOffQLl7D2zdc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uTu0CPVZ5AH8POLpB1C7uAg3zeLYLJBFyobk+7seZkupI+13FgsYY8arsUN8DXoRtaP1ppzzIqYia7aigXjNunXNbjuDBOx3PXi98aGHNnEHo/tzNqIWMt5IscnPDPIAwtEBwpvb7UCd2njtwFexi+7DlzBo4F+FBlHIbRE8Wek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IY67sang; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IY67sang"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC1771F000E9;
	Thu, 20 Aug 2026 15:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238204;
	bh=jqW3FTkcRjz5Fwk2rd1s2ubnAmAC6e2Dyx4AceM7KGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY67sangMtvsSxO+zcvjUkQKNhFpysDBZzwHeQtisj34rdLnoEYuhzFfKdYQEaEs2
	 dEMet4LtoVRBIJwdUnPL6eVVXxWLSq6Zfe3YiChQ0+VN2imaQq/K+fWiYozVvvgwjj
	 49Y07RwyAM7Q5Nbp54LHJWku/4ggNPJGT2/f6gD0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Olsa <jolsa@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Leon Hwang <leon.hwang@linux.dev>
Subject: [PATCH 7.1 068/228] ftrace: Protect direct_functions in ftrace_find_rec_direct
Date: Thu, 20 Aug 2026 16:53:30 +0200
Message-ID: <20260820145246.530683310@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2627,7 +2627,8 @@ unsigned long ftrace_find_rec_direct(uns
 {
 	struct ftrace_func_entry *entry;
 
-	entry = __ftrace_lookup_ip(direct_functions, ip);
+	guard(preempt_notrace)();
+	entry = __ftrace_lookup_ip(rcu_dereference_sched(direct_functions), ip);
 	if (!entry)
 		return 0;
 


