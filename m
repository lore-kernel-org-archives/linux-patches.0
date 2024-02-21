Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C31D78B4B;
	Wed, 21 Feb 2024 13:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708523194; cv=none; b=nAZyVQeX4MsEBm4YG8+9jaFDb25zxtBxMYvVjqYrGGElsN5k+R5C9/uXdHQsjiifh+3nH/mERrmdpcPrQv7+gEJqliDljwYFI9VqzffcwmRnFduv+XRJzRWITYhQxLyHjUgDmSXkKPPberNKYaLzaB486jF2LE6Og23F5V0Tu7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708523194; c=relaxed/simple;
	bh=eyvOTqH3yMdghiou4EM/w8TwaFYc2RpK8ZiX+hIuKdY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ay2tcwsdrUBgJvPVeenHOpN9ppWz7StKEOYwrRaM4ywKVmh08wInMdhFbP5rMdjmCuWxGsLq0/rCWuP/NWiY7Ett8yHmyY3xth5A/0v8llbdjJ3yZH8x+Zj0ABMDkGkDTTMDdfjIPtZ+RnvVKEQGECtREr8baq+K/aQ41/fr17o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aSJYB2rv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aSJYB2rv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F9D3C433C7;
	Wed, 21 Feb 2024 13:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708523194;
	bh=eyvOTqH3yMdghiou4EM/w8TwaFYc2RpK8ZiX+hIuKdY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aSJYB2rvRX3dhQG3f5s7MJEEjdlxocXIPeq7gPNrSVYzXssIpSGj8M7r8deH93UdG
	 GrV8zMajNH0h6frSWcqlCwosBuRHoV03JGcv/GXDHEZZxA6FcMbxZlFnbl5glV6ofS
	 7sU0p7Ffmerdtm0EkDfRSFlLiubx/FoTWlOcp+c8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 5.15 357/476] tracing/trigger: Fix to return error if failed to alloc snapshot
Date: Wed, 21 Feb 2024 14:06:48 +0100
Message-ID: <20240221130021.199822181@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1161,8 +1161,10 @@ register_snapshot_trigger(char *glob, st
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


