Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F43E1AF0CE;
	Tue, 15 Oct 2024 13:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998425; cv=none; b=qeZb5NJ2i1CpZ1dBJeCewBS/oq3FHBPsVraAoqnvHLuAzM5t9Lr3DoCpiTlw3eZte600Syh8P1Zi9BroszsNqSMEfchq8rJIAh7NjlbanyQaXOFuUyYYbPPvocEm8FxsiRyZq8bEmTKXbnKoL1XkvolHJH+2myxz2ORu+CHxqM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998425; c=relaxed/simple;
	bh=Wba/AYzIbHFXp/QbEqKdsrtyUFk4Obd5XIcRn0U3cgI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FG1l3JCUOGzxiv+hJZ9ZpWb4neiTosEyLeVmltWEYZBO/Mmd6IRCXirYIwEl0dl//TPHCYBO5dNJP7MgJ+1zGFTVWJaVBg/7uGYu/T289O5Fw0699ah7P+joqFOrVaPGCCtefxOukEL5AHF1h63YxFt4jsSS63BXATrbAp2YOJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQfHduDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQfHduDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AD5C4CECF;
	Tue, 15 Oct 2024 13:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998425;
	bh=Wba/AYzIbHFXp/QbEqKdsrtyUFk4Obd5XIcRn0U3cgI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQfHduDkbX5iHtpyRzrOE9sT+Z7mUhD9cMIaKIZ+YRF5c9JSdZI3+YqLoWr2FEViz
	 XxnQ7xJqKLeddtl/+HvLcYawV/J3swdHVrUnn4r+NJBaWfyqWnuuLnvnUe1cHKrEtT
	 q0ghhoqarYBbLrv5r9/1Zjwh/awPQEwsCjjO/J2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Vincent Donnefort <vdonnefort@google.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Mete Durlu <meted@linux.ibm.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 442/518] tracing: Have saved_cmdlines arrays all in one allocation
Date: Tue, 15 Oct 2024 14:45:46 +0200
Message-ID: <20241015123934.065019192@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 0b18c852cc6fb8284ac0ab97e3e840974a6a8a64 ]

The saved_cmdlines have three arrays for mapping PIDs to COMMs:

 - map_pid_to_cmdline[]
 - map_cmdline_to_pid[]
 - saved_cmdlines

The map_pid_to_cmdline[] is PID_MAX_DEFAULT in size and holds the index
into the other arrays. The map_cmdline_to_pid[] is a mapping back to the
full pid as it can be larger than PID_MAX_DEFAULT. And the
saved_cmdlines[] just holds the COMMs associated to the pids.

Currently the map_pid_to_cmdline[] and saved_cmdlines[] are allocated
together (in reality the saved_cmdlines is just in the memory of the
rounding of the allocation of the structure as it is always allocated in
powers of two). The map_cmdline_to_pid[] array is allocated separately.

Since the rounding to a power of two is rather large (it allows for 8000
elements in saved_cmdlines), also include the map_cmdline_to_pid[] array.
(This drops it to 6000 by default, which is still plenty for most use
cases). This saves even more memory as the map_cmdline_to_pid[] array
doesn't need to be allocated.

Link: https://lore.kernel.org/linux-trace-kernel/20240212174011.068211d9@gandalf.local.home/
Link: https://lore.kernel.org/linux-trace-kernel/20240220140703.182330529@goodmis.org

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Tim Chen <tim.c.chen@linux.intel.com>
Cc: Vincent Donnefort <vdonnefort@google.com>
Cc: Sven Schnelle <svens@linux.ibm.com>
Cc: Mete Durlu <meted@linux.ibm.com>
Fixes: 44dc5c41b5b1 ("tracing: Fix wasted memory in saved_cmdlines logic")
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index b16291f4c5731..9f5b9036f001d 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2244,6 +2244,10 @@ struct saved_cmdlines_buffer {
 };
 static struct saved_cmdlines_buffer *savedcmd;
 
+/* Holds the size of a cmdline and pid element */
+#define SAVED_CMDLINE_MAP_ELEMENT_SIZE(s)			\
+	(TASK_COMM_LEN + sizeof((s)->map_cmdline_to_pid[0]))
+
 static inline char *get_saved_cmdlines(int idx)
 {
 	return &savedcmd->saved_cmdlines[idx * TASK_COMM_LEN];
@@ -2258,7 +2262,6 @@ static void free_saved_cmdlines_buffer(struct saved_cmdlines_buffer *s)
 {
 	int order = get_order(sizeof(*s) + s->cmdline_num * TASK_COMM_LEN);
 
-	kfree(s->map_cmdline_to_pid);
 	kmemleak_free(s);
 	free_pages((unsigned long)s, order);
 }
@@ -2271,7 +2274,7 @@ static struct saved_cmdlines_buffer *allocate_cmdlines_buffer(unsigned int val)
 	int order;
 
 	/* Figure out how much is needed to hold the given number of cmdlines */
-	orig_size = sizeof(*s) + val * TASK_COMM_LEN;
+	orig_size = sizeof(*s) + val * SAVED_CMDLINE_MAP_ELEMENT_SIZE(s);
 	order = get_order(orig_size);
 	size = 1 << (order + PAGE_SHIFT);
 	page = alloc_pages(GFP_KERNEL, order);
@@ -2283,16 +2286,11 @@ static struct saved_cmdlines_buffer *allocate_cmdlines_buffer(unsigned int val)
 	memset(s, 0, sizeof(*s));
 
 	/* Round up to actual allocation */
-	val = (size - sizeof(*s)) / TASK_COMM_LEN;
+	val = (size - sizeof(*s)) / SAVED_CMDLINE_MAP_ELEMENT_SIZE(s);
 	s->cmdline_num = val;
 
-	s->map_cmdline_to_pid = kmalloc_array(val,
-					      sizeof(*s->map_cmdline_to_pid),
-					      GFP_KERNEL);
-	if (!s->map_cmdline_to_pid) {
-		free_saved_cmdlines_buffer(s);
-		return NULL;
-	}
+	/* Place map_cmdline_to_pid array right after saved_cmdlines */
+	s->map_cmdline_to_pid = (unsigned *)&s->saved_cmdlines[val * TASK_COMM_LEN];
 
 	s->cmdline_idx = 0;
 	memset(&s->map_pid_to_cmdline, NO_CMDLINE_MAP,
-- 
2.43.0



