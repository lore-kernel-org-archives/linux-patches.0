Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 233201EFF93;
	Mon, 17 Aug 2026 15:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979595; cv=none; b=XoKfsslUojq7Hw6Zl51OpxuQrOD7F4sLqTAoSYMnC1nP4uNxHn9PI6HrObJmFXFZpxVCQpJ5GKE7ZhNS91HKUrVdatnvuEAM57tqMLigJqFIshMu7XDUSnQgF7twZomDdq/aYafEohZhqGi/PhD0Q5G9BsfEyrSjnzWUk+EP7xM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979595; c=relaxed/simple;
	bh=6GElHDVNcZC1a4mLTNwpemeqaHwMRLxuxkL5nr8CCyo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZNLKGLv4zXo0pufiz6vJr9b/24YpZl+SeFDQyOEtnhgT5pgv2Lby/OPU20hqe/EZBARVsP3CHm1GqNA06oRtKzzs2nPafdavvmvIj3WOuPp3e1ov2ch3mcz/sayU8IsQvEYibjyK+S7+BPJxd+UGs/2/K+pIl/E2ua868+wneAw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aGr/nBCs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aGr/nBCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FC1D1F00A3A;
	Mon, 17 Aug 2026 15:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979594;
	bh=UbtEKOuUuKFPC5MBjQDCxwcM7UKY/G44vkbnA481ba0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGr/nBCsc3MtPDXQ5/mYwBbUPe57DInKGFv7WsIEGGoke+xj9K9Ont4PV159sz9V1
	 50hZYza9pnCASIuol7ceX/F4ynL5qiGgS8k7qcr7HFDY45bauHLUKOEqkLgEDqui5D
	 RLOdMYDGqcXmLbK0pvPzyXYkgl8IAXt2aoam+FOs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 240/609] tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()
Date: Mon, 17 Aug 2026 15:28:56 +0200
Message-ID: <20260817132552.108093360@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -164,7 +164,8 @@ static bool eprobe_dyn_event_match(const
 	if (!slash)
 		return false;
 
-	if (strncmp(ep->event_system, argv[0], slash - argv[0]))
+	if (strncmp(ep->event_system, argv[0], slash - argv[0]) ||
+	    ep->event_system[slash - argv[0]] != '\0')
 		return false;
 	if (strcmp(ep->event_name, slash + 1))
 		return false;


