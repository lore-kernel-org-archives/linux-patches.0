Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F9B2DF3C9;
	Tue, 17 Jun 2025 15:40:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750174840; cv=none; b=slx6c9c3uF+NAY7T/BQjx4/8seV2AWNkbFceFc9NUMV/6A0Bg+REkbBsTB8vMnKk7tFUbwxJt/GSYsrcGCht6zows7ep/YNZk1AaRIlZUdRSCYyDTPeI18DXJV2r0KwZcDEOCF3rVzNzI5K68jgEdPKn+jca/Xqj0Yy3k1nt0UE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750174840; c=relaxed/simple;
	bh=j4eWm/wr3NgXfcC2aBap/9bGvccrLZCWzpC3G7erPsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KWXZTq3xrm2pioYJo+PwW9O9oaCmHmtUeJdNsU53NxxRUNpLgGNE6HM+v7K0FWbazsyD84zz8WY6BHpwb8RDU2R1Iq0yF/y31xbfX+04ulvNK3Gj9/Oo8kDHUYILEUervzIH9vzjSi+jTlHAtR+Q4R8rRd87cQw+eulsHHRkSX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aZLWaMsR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aZLWaMsR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B199C4CEE3;
	Tue, 17 Jun 2025 15:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750174840;
	bh=j4eWm/wr3NgXfcC2aBap/9bGvccrLZCWzpC3G7erPsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aZLWaMsR++G9jeiORq6+v5O8XLj0euZ3XxbfP9CoZBYB3wtTQx60JuaaCZU+oY7Ie
	 WlylW2PnRmndwZnWQmUENfO9xybUxj5nSL8B/s0oPKLCR/qQz6E+mu2Mv1jHzZq4cX
	 KMrwRuu7A16fUaDw4CjDQWHR4+B7FCZ7Ehrr/r1A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	Miaoqian Lin <linmq006@gmail.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 118/356] tracing: Fix error handling in event_trigger_parse()
Date: Tue, 17 Jun 2025 17:23:53 +0200
Message-ID: <20250617152342.977412318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit c5dd28e7fb4f63475b50df4f58311df92939d011 ]

According to trigger_data_alloc() doc, trigger_data_free() should be
used to free an event_trigger_data object. This fixes a mismatch introduced
when kzalloc was replaced with trigger_data_alloc without updating
the corresponding deallocation calls.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://lore.kernel.org/20250507145455.944453325@goodmis.org
Link: https://lore.kernel.org/20250318112737.4174-1-linmq006@gmail.com
Fixes: e1f187d09e11 ("tracing: Have existing event_command.parse() implementations use helpers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
[ SDR: Changed event_trigger_alloc/free() to trigger_data_alloc/free() ]
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_trigger.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index 4c92def8b1143..fe079ff82ef1b 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1000,7 +1000,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 
 	if (remove) {
 		event_trigger_unregister(cmd_ops, file, glob+1, trigger_data);
-		kfree(trigger_data);
+		trigger_data_free(trigger_data);
 		ret = 0;
 		goto out;
 	}
@@ -1027,7 +1027,7 @@ event_trigger_parse(struct event_command *cmd_ops,
 
  out_free:
 	event_trigger_reset_filter(cmd_ops, trigger_data);
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 	goto out;
 }
 
-- 
2.39.5



