Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9F7386567;
	Thu, 30 Jul 2026 16:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427787; cv=none; b=Bzn17VkGINoUHG5L8vmiUrJatA2omvaziEnTbHeBaaozF2l9/Vmv3bWulTF9IYCGdu8gceEUfj7NXVwlw4tRbnUyCmOgXeX0XcI2YWCeitjW4vgyuldL81Cxe9ofSfGLdyxSIo8630gIYb/QBkt3Db2IpN63dYvLsDD9Ud0K+O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427787; c=relaxed/simple;
	bh=WzGhY1dY9Zc4MDsZYjgBovDSEdTTgzs+gNF6cz/wPSU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CKaVR2uRsXKQOC/SI2zjxbQRLPup1DyodhYwmk5C6BjH9fpDe3gX5I3b+PzwedOOrW2KVzFnWcYVFotlFwLHqK8XwdhP2oeNIZsMbLAZ5iOAJjpsLSVdJW7KUnk9M6zD2IBTfqe++d+cksiTr70lFWUBsNDJzLLQVBIMPhJe5ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eQGOtFki; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eQGOtFki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5001F000E9;
	Thu, 30 Jul 2026 16:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427786;
	bh=LeS4sSKhL4ng9la0aTvdrmVZITm9k/UdSQwqYYuKusM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQGOtFkix2qTXtj5RM/1QMre5s9mZvpO3l1xcycZloQYohNmcnMTeBe2IO82TXS8D
	 WExdv37SCBF/tG+dx1PhaJzhvClzcweKUHVdyCz4/ul9rci8WtjZ7GTSzXYrx/ltwa
	 xvkY2mRYnlYcoVRWR9f5myoCZtytdIuq6hKO+sX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 293/484] tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()
Date: Thu, 30 Jul 2026 16:13:10 +0200
Message-ID: <20260730141429.860629060@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f418d68d71fd4a0a9cef92377bc8c4c3334b5b53 upstream.

eprobe_dyn_event_match() checks if the target event system in argv[0]
matches ep->event_system using strncmp(ep->event_system, argv[0], len).
However, if ep->event_system is longer than len (e.g. "eprobes" vs
"ep/event"), strncmp() still returns 0 because the first len characters
match.

Check that ep->event_system[len] is '\0' to ensure exact system name
matching.

Link: https://lore.kernel.org/all/178454235856.290363.14872590900774231133.stgit@devnote2/

Fixes: 7d5fda1c841f ("tracing: Fix event probe removal from dynamic events")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_eprobe.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_eprobe.c
+++ b/kernel/trace/trace_eprobe.c
@@ -168,7 +168,8 @@ static bool eprobe_dyn_event_match(const
 	if (!slash)
 		return false;
 
-	if (strncmp(ep->event_system, argv[0], slash - argv[0]))
+	if (strncmp(ep->event_system, argv[0], slash - argv[0]) ||
+	    ep->event_system[slash - argv[0]] != '\0')
 		return false;
 	if (strcmp(ep->event_name, slash + 1))
 		return false;


