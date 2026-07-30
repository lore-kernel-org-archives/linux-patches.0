Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA51217723;
	Thu, 30 Jul 2026 15:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785424730; cv=none; b=dly+qKUuaXTPPLYIEa37NnRoMTs+iYYDwoQ27v9KKNlmpeIZSDtGUpzOdBbDFh8yq1PUcyGIfKLhvDADL9iGiuMQMe2NxMI0DXOI8xDRn9QCoAMx/2K8onWrWdKq7xgwL8ZXetCIR3cdT0kRltjBmbtazG2kF7ugg45bKYKUJTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785424730; c=relaxed/simple;
	bh=oNAeqLirOIO0Xnm2wmcRyjxwre6Y00an/vS5p/ZH5MA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WOF6BQFd+gCtRy+nTtYs2smyk2OmhUHe5D6JU4jkqMFI6EqDZNhqbuW8bx+mrFb4abxoRaCpV11EOD6MP5esYCFwAN/GdZfrdujxMJmf7FIFR98+R+0uiRfP0k+ziMuQ1njZ3oGEYWQZdHUvKWOn1BaAOA242BD4x0KDRIQLhVg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ofnejYRV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ofnejYRV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D711F000E9;
	Thu, 30 Jul 2026 15:18:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785424728;
	bh=Vlyc5uxouSFSFHg/h7Nnn/Oob6+CHwE0k4cGN1gKpLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofnejYRVa5qcEFutTjJTCyG0vM8UGVLvvtrNxBzQtsUqxtPbQ9OsC4edtLKTKEnWM
	 tDDIrpdlruO05r+vvvOffsr0AJlQmKP6hLYB6gxCJ+TSksuTB/PkUHcrFUQapYOMWJ
	 x8xLtIe06WZ/5ayfc0/AiFzxCXSdMbdMfhlTVGJA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.18 494/675] tracing/eprobe: Fix exact system name matching in eprobe_dyn_event_match()
Date: Thu, 30 Jul 2026 16:13:44 +0200
Message-ID: <20260730141455.622260380@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
@@ -169,7 +169,8 @@ static bool eprobe_dyn_event_match(const
 	if (!slash)
 		return false;
 
-	if (strncmp(ep->event_system, argv[0], slash - argv[0]))
+	if (strncmp(ep->event_system, argv[0], slash - argv[0]) ||
+	    ep->event_system[slash - argv[0]] != '\0')
 		return false;
 	if (strcmp(ep->event_name, slash + 1))
 		return false;


