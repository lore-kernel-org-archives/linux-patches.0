Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE1C846F;
	Tue, 30 Sep 2025 15:06:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244780; cv=none; b=TtDQoWb43c4j421mGK2elKFHukPTUmEO6fxGWteweqvLZN/xZMSeqLtQ58ump7guTwQ9Obc1NsIHX2+UhMNwaJRRRu+nCKp/kfMUtnaK9JSQfTVnFPqa9oJSxfbN/hvW5F1SztmD2QdqmC3drHJRQakxz6rsp5PxOCi4lpJoHYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244780; c=relaxed/simple;
	bh=JeD6GkkkPgjSmSb2n0g5DZhWRrq6w/+9pczmmYKVWrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvR2WPOa1xwQz6knjL1DC0IOoZRW48wp8EDYynlcWmufo5ChEVv67ZPrus+r0DuyBM7Aur6nIrVK6KB++Y8timK5TBk+E7iXDfT0+BaNQ+MFp7d6sQZuLIw9JTlqPqD9FpCXfZDjZqshpObZh0wAoYEKCmxQNjNP2MWDnXVGvKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ogjxp0wY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogjxp0wY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1880BC4CEF0;
	Tue, 30 Sep 2025 15:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244780;
	bh=JeD6GkkkPgjSmSb2n0g5DZhWRrq6w/+9pczmmYKVWrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogjxp0wY162UH/toPXC1cOSxT5DI3vBgJDhCLwT4+RpWfxuRbeH96FCDmksXatEqZ
	 6yuzW2j8hV/cumQpI/dPLPvT94dgbNbsDEJtIpwtV3BMtMwgadNtZdSZZ9m5C1VYu2
	 4PRy6KsW8dNAXO8PIWZh2pJ2LNoSyWXpaBXcQAH4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.16 111/143] tracing: dynevent: Add a missing lockdown check on dynevent
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143835.657750305@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -230,6 +230,10 @@ static int dyn_event_open(struct inode *
 {
 	int ret;
 
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
 	ret = tracing_check_open_get_tr(NULL);
 	if (ret)
 		return ret;


