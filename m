Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04DD4224B07;
	Mon, 23 Jun 2025 22:15:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716926; cv=none; b=dBx8EpcoakqqCakpNtd91iG7YX1lPsOah8dmXsEeQAtuBm5w4RsuWOO8AcnECHQlGtLsXeKirogx1xGrsj5+FrrtrjlvxMrbjh3teZuDNE3G4xy38psT7V6Kj8aMYVMcSgqB3QdhR3vSyG68lziTIkmmCqA2GrmBZjcoakCa4r8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716926; c=relaxed/simple;
	bh=gY0gfT6qWDb7GR8/cxmRFvmd7zoOhZV8QzIcmWD00wc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GyKDs6TZEFogkK9IDjjAFMn+Us62fNCwawalDWarw8+WC3X2WBTtbkPYQ3sVKEFSLzdpdSSYhzU1pWvZJawmtUITHFGpmN1HSRuX6Zx9b68bWMsMQaiygZmdtHgaO5V6tQTylsuQ75QfCQbwyEN5LNdxVAKbM/4W20O991pON1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d8xF/j4Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d8xF/j4Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904D3C4CEEA;
	Mon, 23 Jun 2025 22:15:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716925;
	bh=gY0gfT6qWDb7GR8/cxmRFvmd7zoOhZV8QzIcmWD00wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d8xF/j4Qh2SdCHep0LtwtTHvteQ1ebiaY9zkxuZQCnzIGSsgtDoOV7NpKB83SReLN
	 h72PzMF0aarI2L7zT9UPoFDw4xvMEGt5N24YPTsDvt7ChQTLYmhxC9piyDvnbz2sjJ
	 wgxXdScTxdAF5YDOBt3EBdFbZgdfVpHItoXo9on0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.15 569/592] tracing: Do not free "head" on error path of filter_free_subsystem_filters()
Date: Mon, 23 Jun 2025 15:08:47 +0200
Message-ID: <20250623130713.976149735@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 8a157d8a00e815cab4432653cb50c9cedbbb4931 upstream.

The variable "head" is allocated and initialized as a list before
allocating the first "item" for the list. If the allocation of "item"
fails, it frees "head" and then jumps to the label "free_now" which will
process head and free it.

This will cause a UAF of "head", and it doesn't need to free it before
jumping to the "free_now" label as that code will free it.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250610093348.33c5643a@gandalf.local.home
Fixes: a9d0aab5eb33 ("tracing: Fix regression of filter waiting a long time on RCU synchronization")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202506070424.lCiNreTI-lkp@intel.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_filter.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/kernel/trace/trace_events_filter.c
+++ b/kernel/trace/trace_events_filter.c
@@ -1435,10 +1435,8 @@ static void filter_free_subsystem_filter
 	INIT_LIST_HEAD(&head->list);
 
 	item = kmalloc(sizeof(*item), GFP_KERNEL);
-	if (!item) {
-		kfree(head);
+	if (!item)
 		goto free_now;
-	}
 
 	item->filter = filter;
 	list_add_tail(&item->list, &head->list);


