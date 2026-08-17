Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFCA3EAC68;
	Mon, 17 Aug 2026 14:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977158; cv=none; b=SGVuj28Fkia1F2gF58MyixBnkBvJSZuZuyfnIUTp3w28O581PYhwhBMWmABdA6NbbYBdfzEtNYIDSxZ7qUnifY168LY9fTcV3RpiK3Gy8M2PTCceeBQLojBVQtf269my2Z6T4U+vBM44K7Z1LZis/GjX5CYY1ErFOaY1ux3XGPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977158; c=relaxed/simple;
	bh=Nuz1BGmAj4qb+IJeNY3SrddNncW4s4Phgd+ECSzmtNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O4ym6tey+03R8bmnW4VVTd86IKoa+Y5PKffLOjCQoFUyfvIE3PR9NwtxNdMs086QeFeIpjO7KSLwnAscJk0eBaJM1Lm+UoeaRUXZAgQHFP8GQoyE80wW+mSZ5EgSF2OBIxw8LWEqsgCxE2DuG9BtLjuWsu4nCH6eOD3xwvm/sS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i1F3jBrx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i1F3jBrx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0DF61F000E9;
	Mon, 17 Aug 2026 14:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977157;
	bh=8K8WiZXpXvOWgTd60rRyeWNL8e56OJzj8m1J3dN1Kk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i1F3jBrxlXOCxkZKnD2XmMKvHTahsUBxb1cE4TwHSAtFhHZ2HZBOWTp2QTczhm6Mj
	 gc/SYWitZIJJBq8IUZCHU59I3lwa8YwTZ37VVy5i7PCg23OFBQUXRjFZFXW2LzN20k
	 dXlhcRtF4eRREOs2t7zWEASPPixjRZuDnAJGgjy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 193/456] tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()
Date: Mon, 17 Aug 2026 15:29:43 +0200
Message-ID: <20260817132547.668546166@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,7 +159,8 @@ static bool eprobe_dyn_event_match(const
 	if (!slash)
 		return false;
 
-	if (strncmp(ep->event_system, argv[0], slash - argv[0]))
+	if (strncmp(ep->event_system, argv[0], slash - argv[0]) ||
+	    ep->event_system[slash - argv[0]] != '\0')
 		return false;
 	if (strcmp(ep->event_name, slash + 1))
 		return false;


