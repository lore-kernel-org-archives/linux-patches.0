Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E32669DF9;
	Wed, 21 Feb 2024 13:22:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521771; cv=none; b=PDYeuzix4IjMmWtg6OfrZrFSxxmtg0cwYCmolFHi3QGhPrV5XWYyaETlu8/vm34wK+DlaGbPyoUyRZPis7/vv260Kux34nIAT44OvBBevzOTt9ZWlQJt2dstZ2YdkksWzRS7Jl47E5/Y6A2BMmtBbgMChIKMtbXZ2GZGKF+VqfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521771; c=relaxed/simple;
	bh=BTLrQXDX3YOfJX+hAn8PmWgI1lm3n6k7YrSbsv4+opE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=akMxO/DdD0KguprBzK7X6T4owHWVotkMEBDMIRXvhEb1sNUJuOpo18SZd5XSqbwpU0MIR85DIPxi4cVkhg9wXDTDD2XHrwHFOprA8Ee9mVLPm78CJnA4fPFVycu+QlShNTAEmiD+n582N95Sy77GPPYLlM5j+iobbqqu6ezzNzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1oVeXp4y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1oVeXp4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19556C433C7;
	Wed, 21 Feb 2024 13:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521770;
	bh=BTLrQXDX3YOfJX+hAn8PmWgI1lm3n6k7YrSbsv4+opE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1oVeXp4yu603QCaik+PNyyseJ9sdcrNNPx0+IsdX3VGr5HOnHp2+Ry5IUeWsqAZ3L
	 3gJXzoZidsncCC/+Ftdx3JdovVqGmMCi/BhjQCCmJtqm6h7mecqv5KLVGr9CvkrVWl
	 f8Y8ISHaiXNSdLPEaMWq08CMql+AWfguRqbZcGuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 4.19 173/202] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Wed, 21 Feb 2024 14:07:54 +0100
Message-ID: <20240221125937.398207399@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221125931.742034354@linuxfoundation.org>
References: <20240221125931.742034354@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1133,8 +1133,10 @@ register_snapshot_trigger(char *glob, st
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


