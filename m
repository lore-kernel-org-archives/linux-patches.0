Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EEE31EB5E3;
	Tue, 30 Sep 2025 15:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759245554; cv=none; b=jOJQ3UJdueJo5RBTaogU3/fZcm/Al32wpS2ubvXsJYlrva0edJcPXDJMfvEI/UFBO5/YElbBnq/7/clT58yOCOp9+HhBQmor81puq4ofv/UjkhYh4ixGuHlojuvw60N7vI+u6s2M4KePCxuMVGlC3bdoqt5r64fyg4F278SiJxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759245554; c=relaxed/simple;
	bh=FlNtqTkyfYKmqiEchnFYswogoNVMseztayOGTzK7LhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANQcHI6DtYkyf/ZD76HkYTVW0bblu7bSCTOO+UBa00GiOuVXHjDJccuWYWKQvZ7wBEByLkJxF9JrG9Od6WxNe3EIjZXzMldFqWpHpSU7GFcZm3JmYU/Kqb/VX0OfYfJwoQFmRVdxRHlNUBdL4YJwYr1OOjodSVa5Nao+sEyjowE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoGfJ2HZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoGfJ2HZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0209C116D0;
	Tue, 30 Sep 2025 15:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759245554;
	bh=FlNtqTkyfYKmqiEchnFYswogoNVMseztayOGTzK7LhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AoGfJ2HZuCF7BOjMRHAXonztO+5kNj6qnGdV1GMHCzKZxvG43MFY49ZoPFcTYjlhA
	 hJ3mHsOZcFEiNd76vdkMNVwIXzOeQDxo3FG2l8GWm8HqGtujt6tIk7BpL6MTBUWFuY
	 +XocSdfUx36Bzrgv36liZGkkKdjjCS+YpB2urYYo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 52/73] tracing: dynevent: Add a missing lockdown check on dynevent
Date: Tue, 30 Sep 2025 16:47:56 +0200
Message-ID: <20250930143822.798406443@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143820.537407601@linuxfoundation.org>
References: <20250930143820.537407601@linuxfoundation.org>
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

commit 456c32e3c4316654f95f9d49c12cbecfb77d5660 upstream.

Since dynamic_events interface on tracefs is compatible with
kprobe_events and uprobe_events, it should also check the lockdown
status and reject if it is set.

Link: https://lore.kernel.org/all/175824455687.45175.3734166065458520748.stgit@devnote2/

Fixes: 17911ff38aa5 ("tracing: Add locked_down checks to the open calls of files created for tracefs")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_dynevent.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_dynevent.c
+++ b/kernel/trace/trace_dynevent.c
@@ -239,6 +239,10 @@ static int dyn_event_open(struct inode *
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
 	ret = tracing_check_open_get_tr(NULL);
 	if (ret)
 		return ret;


