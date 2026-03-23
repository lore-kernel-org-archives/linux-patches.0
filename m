Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00EF23803EF;
	Mon, 23 Mar 2026 13:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774274358; cv=none; b=PWqVjLSgQxqJm91+HjWb++nvm5uNdA26+IBNm3XLHMml5N61kTNPBHucPH26m0nPpi8wg8Sa3071p4qQGKngak/9GsPj5l5QHf5TQLuLHT2CJCA6Se3IW5l5qjd8nLEZijgEZM+kRCMs7MjByi4YKnZS6wf/SBhSTBGaQgxva24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774274358; c=relaxed/simple;
	bh=vBcLsWTHauozpKMoh5IushIfqMsTwmgwoH7IlbhVz78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DyJH/T2V/13NQOfZsF1ryB+MCauQpq1ezXnE07B1p/a79s+j8XHHNdg9LmKobpEAqBAUaz0L5v0DiG0bzScVATZSdJRN5fiICUlhQWVxWTt/+jOMNAUfYzm/9wTzjeLbqvmZEeHYs63Q1Jdduio8WqH0c/fY3UK68RCc6zzwk50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VC+r4Vcs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VC+r4Vcs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E679C2BC9E;
	Mon, 23 Mar 2026 13:59:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774274357;
	bh=vBcLsWTHauozpKMoh5IushIfqMsTwmgwoH7IlbhVz78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VC+r4VcsozJQ4lnnBaCBZr1V/N3op/NdbECrtL7StsNx53o+FqGyeBlrsUu6cwpqb
	 pCFvw6izvIzAVrN6QzSlOfrkbKFllzUGpcWtKkLnp5H9YrxrWk4bpplHGc+30u4zCH
	 ylJ9NqzF/KBMSvhsHBEYytaCR6umLAzChhFgzXLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ian Rogers <irogers@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.19 192/220] ring-buffer: Fix to update per-subbuf entries of persistent ring buffer
Date: Mon, 23 Mar 2026 14:46:09 +0100
Message-ID: <20260323134510.658764773@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
References: <20260323134504.575022936@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit f35dbac6942171dc4ce9398d1d216a59224590a9 upstream.

Since the validation loop in rb_meta_validate_events() updates the same
cpu_buffer->head_page->entries, the other subbuf entries are not updated.
Fix to use head_page to update the entries field, since it is the cursor
in this loop.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ian Rogers <irogers@google.com>
Fixes: 5f3b6e839f3c ("ring-buffer: Validate boot range memory events")
Link: https://patch.msgid.link/177391153882.193994.17158784065013676533.stgit@mhiramat.tok.corp.google.com
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2052,7 +2052,7 @@ static void rb_meta_validate_events(stru
 
 		entries += ret;
 		entry_bytes += local_read(&head_page->page->commit);
-		local_set(&cpu_buffer->head_page->entries, ret);
+		local_set(&head_page->entries, ret);
 
 		if (head_page == cpu_buffer->commit_page)
 			break;


