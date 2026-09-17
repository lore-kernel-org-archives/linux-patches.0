Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068734D1790;
	Thu, 17 Sep 2026 17:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667046; cv=none; b=oynjCWoEHLmo+mQJDDIK2RPAQ4QHLHt+1o1u4mDyhSmj9icFuA7965UUfCZ9cbM278d6I3oOCPrm0Kda0uAdKqPlCfQ7byQR9YLyZbsdD6NrMXnHSrpLduieYNZwpw/b0vq18IG3aRTB76f9vR7HqxYKp9R5itkQmZlw9mBMZUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667046; c=relaxed/simple;
	bh=F7H/OwAk+ay/+su/4f+FA7Em4FB4v44P1RLf8kiRUzM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qT2ScDwWLXeY5A/0QnChSWw5tEuEtVWVQm5T07pkqTjnct4n3t5kdGuT2aYn5q/RCFrvBFtYNHVqqjER9Vjg0catH83c0yF+gpFbRby91WVc/g74QO3ctDIHq7Rb7x0B58qSL272uE+MZixkA+EY3Tvl+pEbaR1NUGQb/0+Dzlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9jPgq0X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9jPgq0X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDF81F000FF;
	Thu, 17 Sep 2026 17:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667044;
	bh=fpfdWiEWxVq3vTqcv1Rmx5GZ7cqE6S/oZN6BIzvkb6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9jPgq0XdK64KvnqinkcLlY8xpkhYOlXBOGa0l1AIMrtgp6DrThPYrFWQmSqi1a3T
	 mwMLT2qZlLIVBKrfE1KsT6czBCTm7SBerDU27ohLiZZ+9oxx5Wx/XKi6TN9nR9hj3j
	 grakui7VDLw7igf02kOWAWshx8BrbcFxNjFSKuH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI <sashiko-bot@kernel.org>,
	Donggeun Yoo <donggeunyoo.kernel@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1210/1250] tracing: Undo the registration when enabling the histogram trigger fails
Date: Thu, 17 Sep 2026 16:16:45 +0100
Message-ID: <20260917151625.080758360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Donggeun Yoo <donggeunyoo.kernel@gmail.com>

[ Upstream commit 92383cef66791a0c63a2f27755cadbdb2fbf270b ]

Commit 6f86bdeab633 ("tracing: Fix bad hist from corrupting named_triggers
list") described how a trigger that is registered but not on file->triggers
ends up freed while still on the global named_triggers list, and moved the
registration down so that hist_trigger_enable() follows it immediately. One
path still gets there. hist_trigger_enable() adds the trigger and takes it
straight back out when the event cannot be enabled:

	list_add_tail_rcu(&data->list, &file->triggers);

	update_cond_flag(file);

	if (trace_event_trigger_enable_disable(file, 1) < 0) {
		list_del_rcu(&data->list);
		update_cond_flag(file);
		ret--;
	}

so the list walk in hist_unregister_trigger() matches nothing, test stays
NULL, and the ->free() that would call del_named_trigger() is skipped.
out_unreg falls through to out_free, which frees the trigger anyway:

 BUG: KASAN: slab-use-after-free in find_named_trigger+0xac/0xc0
 Read of size 8 at addr ffff8880091d3160 by task init/1
  find_named_trigger+0xac/0xc0
  hist_register_trigger+0xc1/0xa00
  event_hist_trigger_parse+0x3146/0x6af0
  event_trigger_write+0xce/0x160
 Freed by task 69:
  kfree+0x154/0x420
  trigger_kthread_fn+0xfd/0x160

Leave the trigger where hist_unregister_trigger() can find it and let that
undo the registration, which is the only code that knows all of what
cmd_ops->init() took: the named list entry, the hist_pad reference, the
reference on the trigger a named histogram is shared with, and the copied
cmd_ops. It also pairs the failed trace_event_trigger_enable_disable(),
whose sm_ref and buffered event reference are otherwise left behind.

Since ->free() releases trigger_data and, for a trigger that does not share
its histogram, hist_data with it, out_unreg can no longer fall through to
out_free. For a trigger that does share, hist_register_trigger() has
already destroyed the caller's hist_data, so the fall-through was reading
freed memory there as well.

Move the enable_timestamps check in hist_unregister_trigger() above the
->free() call for the same reason: hist_data does not outlive it once the
trigger being removed is the one that owns it.

Cc: stable@vger.kernel.org
Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
Reported-by: Sashiko AI <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/linux-trace-kernel/20260907092944.3950E1F00A3D@smtp.kernel.org/
Link: https://patch.msgid.link/20260907124420.607097-3-donggeunyoo.kernel@gmail.com
Signed-off-by: Donggeun Yoo <donggeunyoo.kernel@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_hist.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6633,11 +6633,12 @@ static int hist_trigger_enable(struct ev
 
 	update_cond_flag(file);
 
-	if (trace_event_trigger_enable_disable(file, 1) < 0) {
-		list_del_rcu(&data->list);
-		update_cond_flag(file);
+	/*
+	 * On failure the caller undoes the registration, and
+	 * hist_unregister_trigger() can only find the trigger here.
+	 */
+	if (trace_event_trigger_enable_disable(file, 1) < 0)
 		ret--;
-	}
 
 	return ret;
 }
@@ -6715,13 +6716,13 @@ static void hist_unregister_trigger(char
 		}
 	}
 
-	if (test && test->cmd_ops->free)
-		test->cmd_ops->free(test);
-
 	if (hist_data->enable_timestamps) {
 		if (!hist_data->remove || test)
 			tracing_set_filter_buffering(file->tr, false);
 	}
+
+	if (test && test->cmd_ops->free)
+		test->cmd_ops->free(test);
 }
 
 static bool hist_file_check_refs(struct trace_event_file *file)
@@ -6926,6 +6927,8 @@ static int event_hist_trigger_parse(stru
 	return ret;
  out_unreg:
 	event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
+	/* The unregister frees trigger_data, skip out_free */
+	goto out;
  out_free:
 	event_trigger_reset_filter(cmd_ops, trigger_data);
 


