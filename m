Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475C84EC67A;
	Thu, 17 Sep 2026 15:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660091; cv=none; b=TuV3Wt/l4R6tYmAtyylbZ9zgNBf+R+gnYhqNsPGNlaZO8erkj0fZ/eoG3axkEJX/2E6qJlLvo5bGWjLifpGUJdYaTPPy8SAiY50JDskQ+CE8mAr0MDFsLyD9iEg1fCt1EoJT2p4FlKEpDZPkDyD5cMkAv+gIj98scNTzVWLUJFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660091; c=relaxed/simple;
	bh=DdSHn3ja8ZuDivyrGEKUcjGneUH4khrAMb7034++9Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mN+5+ciraDmyEe5dpXRYM0mkrwvS2xdfVaWKV5jxDaT2Rypg23Jdu+sBitG0bdbQLywv+IZdkAP45xmdopFrMAKAcHxWotyZTdemW85cyMqYF6JgVfV3UnlyaqD8kitiqHgQZrYg4P8sqMxtKBWDBSClqjhi/M5NGRfgMjvK43Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fiCbPolb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fiCbPolb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 262BB1F000FF;
	Thu, 17 Sep 2026 15:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660085;
	bh=JjMQYySHUT+JQD8KjtTEPNv+wIt485bBhqs4sYMvk+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fiCbPolbVN2f3Z6mtLUQ1vMeFZmIrbt71bQWa8ylT4RLHmNlDcZyc6Pe9R3K9vFpe
	 xU3lgNp5Nd15ydkByT4KcdnafUqswkES7ZmNYnv378gCQxbglBw+E9e9hJY6tDL5AR
	 Bs4pLLLpsen16z94vO/aanvjfcC+YLEviJ5wqZ5k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	=?UTF-8?q?Ali=20Ahmet=20Memi=C5=9F?= <aliamemis@disroot.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 474/733] tracing: Dont dereference trace_event_file in deferred trigger free
Date: Thu, 17 Sep 2026 16:13:02 +0100
Message-ID: <20260917151403.809927148@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ali Ahmet Memiş <aliamemis@disroot.org>

commit bcfe2816e6ec46c3f4c58aa4264476665ddb3f69 upstream.

The enable_event trigger defers trace_event_put_ref() to the
trigger free kthread, but the trace_event_file can already be freed
when the instance is removed.

Keep the trace_event_call directly in enable_trigger_data so the
deferred free does not access the freed trace_event_file.

Cc: stable@vger.kernel.org
Fixes: e091351b3881 ("tracing: Delay module ref count for "enable_event" trigger")
Reported-by: Alexander Gordeev <agordeev@linux.ibm.com>
Closes: https://lore.kernel.org/all/20260828134340.2501683A24-agordeev@linux.ibm.com/
Link: https://patch.msgid.link/20260911155650.354844-1-aliamemis@disroot.org
Signed-off-by: Ali Ahmet Memiş <aliamemis@disroot.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h                |    1 +
 kernel/trace/trace_events_trigger.c |    4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1953,6 +1953,7 @@ struct event_trigger_data {
 
 struct enable_trigger_data {
 	struct trace_event_file		*file;
+	struct trace_event_call		*call;
 	bool				enable;
 	bool				hist;
 };
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -1728,7 +1728,8 @@ static void enable_trigger_private_data_
 {
 	struct enable_trigger_data *enable_data = data->private_data;
 
-	trace_event_put_ref(enable_data->file->event_call);
+	/* The file may already be freed here, only the call is kept alive */
+	trace_event_put_ref(enable_data->call);
 	kfree(enable_data);
 }
 
@@ -1801,6 +1802,7 @@ int event_enable_trigger_parse(struct ev
 	enable_data->hist = hist;
 	enable_data->enable = enable;
 	enable_data->file = event_enable_file;
+	enable_data->call = event_enable_file->event_call;
 
 	trigger_data = trigger_data_alloc(cmd_ops, cmd, param, enable_data);
 	if (!trigger_data) {


