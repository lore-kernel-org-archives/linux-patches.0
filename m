Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D68952FFDE6;
	Tue, 30 Sep 2025 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244393; cv=none; b=twZgkQQZQMd+QZse4pVDJ8D2MNxuh/ane3/RlJ6l9bbnvtycPARQ7r3uJb9u5PyErpuUhg4p5ujHu29ZfUFuqmxqFDehWOwnAG7atIFgPfckdeN5ABe6LswmqTZk1sM24Vg99v5hh1lNUwZEMSjV/uNbQE2wqbQS54Base6LgUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244393; c=relaxed/simple;
	bh=+ckqKY/YALluNXjuqf6p+ltBMFJW6h/UWALqK38DUrk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UitJUvcat2TLSa8j/22uyzWmQDuqoZr0kQRX7hTYnRr6xj23eSQMbIyig+YHWLLWz7hmMWABBEMcKDlyTEoo2O/QdrU979aW2FeWcC88ih1zTM3fgSPHjIdf1mRwckpXabT5ES/6xXmiKm5/YTFw66aJFdHjrfqnYRZvXjAEHP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XqDmq3M+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XqDmq3M+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ED78C4CEF0;
	Tue, 30 Sep 2025 14:59:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244392;
	bh=+ckqKY/YALluNXjuqf6p+ltBMFJW6h/UWALqK38DUrk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XqDmq3M+dAzSWN/Uepe+Qcbq3G6Ov9JlTgSaQbCGTrTIuLNbHG0HYkm0bfWwunYFk
	 +u7qneVWRwdElf0LahaYToVqWQY8TLgyckCCdRNSPZXXPAjoEiC8BRzV1bTI6lnCMC
	 N9SZYJhGdEBX18nvX0QPwFhtpCSP4zPqBvqlIg44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 114/122] tracing: dynevent: Add a missing lockdown check on dynevent
Date: Tue, 30 Sep 2025 16:47:25 +0200
Message-ID: <20250930143827.631864607@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -176,6 +176,10 @@ static int dyn_event_open(struct inode *
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
 	ret = tracing_check_open_get_tr(NULL);
 	if (ret)
 		return ret;


