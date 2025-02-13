Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F1B0152532;
	Thu, 13 Feb 2025 14:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458392; cv=none; b=mzewxnHTdWAFyc6nXzoTeZju2tooNIUqfLb85TRxoddcA1uIc41kqu/2IQsa9ag1lUC8rBwBpjCkpJTtes+SaRGYppP5MzTAxMw8SwfqxGJcTDsFgvzjNPYzgNk78Jjr0Nz3qSUycWt3lWd3HLZbg+zXSTAqh6qfvEw+tu+Bmx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458392; c=relaxed/simple;
	bh=2QAPrzvf8KN3Y/3Yk2Bo1GuVuJ6GWzx841WxokvJTCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NyU830F3OBaFN4vSGVmd7CeCu1GukYjasKv8atod0sGK6SwA2liWUO/P/F5TUD5g0gzZore41nuRoTd3ahkSn8Hf3vRj8uh7LFldBHFsIfQVYFjxMAsZkViKvK5DPneJ2tmDMFWXPChpmsGKyuCckFFgk6DL68QCwf32/pAbxyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGtxg5vK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGtxg5vK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C366EC4CED1;
	Thu, 13 Feb 2025 14:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458392;
	bh=2QAPrzvf8KN3Y/3Yk2Bo1GuVuJ6GWzx841WxokvJTCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGtxg5vKegTVrmDj80ToWjZIzIofBoe96J+vdFtJSmB8GFf++9pzD6/+wo0+/GW0w
	 /WJrC4oUw7YVIKfht90XtkHfzbzw/defUi6+4XtS1yiL/1tphf5Lab1sreaOHND1iN
	 qBxu4Pqs2xebxgZXPg9yAExxZHteOgyTelipiHKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 386/422] rtla: Add trace_instance_stop
Date: Thu, 13 Feb 2025 15:28:55 +0100
Message-ID: <20250213142451.442627929@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tomas Glozar <tglozar@redhat.com>

commit e879b5dcf8d044f3865a32d95cc5b213f314c54f upstream.

Support not only turning trace on for the timerlat tracer, but also
turning it off.

This will be used in subsequent patches to stop the timerlat tracer
without also wiping the trace buffer.

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Gabriele Monaco <gmonaco@redhat.com>
Link: https://lore.kernel.org/20250116144931.649593-2-tglozar@redhat.com
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/tracing/rtla/src/trace.c |    8 ++++++++
 tools/tracing/rtla/src/trace.h |    1 +
 2 files changed, 9 insertions(+)

--- a/tools/tracing/rtla/src/trace.c
+++ b/tools/tracing/rtla/src/trace.c
@@ -197,6 +197,14 @@ int trace_instance_start(struct trace_in
 }
 
 /*
+ * trace_instance_stop - stop tracing a given rtla instance
+ */
+int trace_instance_stop(struct trace_instance *trace)
+{
+	return tracefs_trace_off(trace->inst);
+}
+
+/*
  * trace_events_free - free a list of trace events
  */
 static void trace_events_free(struct trace_events *events)
--- a/tools/tracing/rtla/src/trace.h
+++ b/tools/tracing/rtla/src/trace.h
@@ -21,6 +21,7 @@ struct trace_instance {
 
 int trace_instance_init(struct trace_instance *trace, char *tool_name);
 int trace_instance_start(struct trace_instance *trace);
+int trace_instance_stop(struct trace_instance *trace);
 void trace_instance_destroy(struct trace_instance *trace);
 
 struct trace_seq *get_trace_seq(void);


