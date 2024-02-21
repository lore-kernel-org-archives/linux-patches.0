Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3284C62;
	Wed, 21 Feb 2024 14:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708525628; cv=none; b=oCz79IfmuSHjgvKwiRglil/MQasiphEG9kB3b7VKmdRhxdV06xqh4kXddPUHKoVsGvxQuhrHv+inHuai1eIingLYlgBz+HPIlmarvkSKjv4gYWio7/xNmWJPHb2v14pSFQUkgPx4n95qFV/KFx6C2mg+aR9JP5KyDYuKpJq3HwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708525628; c=relaxed/simple;
	bh=6BJmONngOnGTA7gbuB4RB8MZqndroCtX1PnCE3DIryg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z8U2L0prWYeh1Kt4dnIcyzrCKpCMa/LKnQcSFZ4sTo3h5n6D8zXlr6Yq/47RzDDxjv6bacevgRjI/5YCqJUWNaR5aAsqu+9+bFivvf+E/wlrnExnxhyU16Ts0VjKppJoBP7KIRN1UJcjJ7PzRv+SBPOnCjiG3akv7lbhBxfKh1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iXH3Xk4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iXH3Xk4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D243DC433F1;
	Wed, 21 Feb 2024 14:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708525628;
	bh=6BJmONngOnGTA7gbuB4RB8MZqndroCtX1PnCE3DIryg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iXH3Xk4Z1OU3D/Z5aHIKhrkbdL9dl/L/Pa0Djgx1KfO4Z98UHTa+ydUi+wtvQjUio
	 07mYza1+JOIChQngVq9NKJSFWs8mTU8HhMUmktMAIkCwYygVC6HLsmyQW1c55tmmK4
	 ooWTZh3y/iFD1mXVImZCXGUd5nZGg/3bVWeY3T6Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.4 213/267] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Wed, 21 Feb 2024 14:09:14 +0100
Message-ID: <20240221125946.894200215@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125940.058369148@linuxfoundation.org>
References: <20240221125940.058369148@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 0958b33ef5a04ed91f61cef4760ac412080c4e08 upstream.

Fix register_snapshot_trigger() to return error code if it failed to
allocate a snapshot instead of 0 (success). Unless that, it will register
snapshot trigger without an error.

Link: https://lore.kernel.org/linux-trace-kernel/170622977792.270660.2789298642759362200.stgit@devnote2

Fixes: 0bbe7f719985 ("tracing: Fix the race between registering 'snapshot' event trigger and triggering 'snapshot' operation")
Cc: stable@vger.kernel.org
Cc: Vincent Donnefort <vdonnefort@google.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_trigger.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1140,8 +1140,10 @@ register_snapshot_trigger(char *glob, st
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	if (tracing_alloc_snapshot_instance(file->tr) != 0)
-		return 0;
+	int ret = tracing_alloc_snapshot_instance(file->tr);
+
+	if (ret < 0)
+		return ret;
 
 	return register_trigger(glob, ops, data, file);
 }


