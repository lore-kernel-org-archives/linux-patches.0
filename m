Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3704C1509AE;
	Tue, 20 Feb 2024 20:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708462788; cv=none; b=CZOtc+mrikRVSqNrxm8jICwd3EmdOhE4+LD7IC5FMKA2On3T7pwPpf/12QsuW70Cr7pOnB5qS55vYvAQFR9iTpM7c7MQb8K809vy4rlqU0hyw3vY97IrQ5imhYepjEXDStrqW9Uo5K33P4i6kSYnu3LRPaDk76UPvj1UkVW7cV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708462788; c=relaxed/simple;
	bh=VkVROCqU1nfvBO+vdJGsqcQBmKGLg8Pi8uiXEZt2npU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J4FtpCamId8HFDJtNGzHsJOBgda7LzZbKxyXoOU+GHEF/dr6ivDmQKSB+7/2pSOMqo/8ZhDq/ePjUh9Ia36pqvPpfP7LVT2wHQsklOWmdKLyVjhqH0aTYdGYi7uKbrayan96tjt67LBINT+xUK7oPD3M7knymf1ntokwXGXWY8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u1369Poi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u1369Poi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74E88C433F1;
	Tue, 20 Feb 2024 20:59:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708462787;
	bh=VkVROCqU1nfvBO+vdJGsqcQBmKGLg8Pi8uiXEZt2npU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u1369PoimEV7fDy6W0Swj0fHiIaTVyBQdJYPGk6HoA+2ampXrM5N/5BwFom2IS9bX
	 zPNyexhvrsB0cXD/pwhMOiVjYj3I0PgWnkQEivPC+6qIUj0stqRVWwZVdsD7+Uf5mr
	 PuwH9QNBikQTAfAAANALamuH+HSPR7FnzcW4bz+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.1 035/197] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Tue, 20 Feb 2024 21:49:54 +0100
Message-ID: <20240220204842.129892253@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1455,8 +1455,10 @@ register_snapshot_trigger(char *glob,
 			  struct event_trigger_data *data,
 			  struct trace_event_file *file)
 {
-	if (tracing_alloc_snapshot_instance(file->tr) != 0)
-		return 0;
+	int ret = tracing_alloc_snapshot_instance(file->tr);
+
+	if (ret < 0)
+		return ret;
 
 	return register_trigger(glob, data, file);
 }


