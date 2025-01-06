Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4E0282F5;
	Mon,  6 Jan 2025 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179160; cv=none; b=njfdTQepxdJhwwcurSPJ+0CuII9y0WBfit6pg4O41fcByT51M/9znTpA9ODecuG9duM8BkvZNmNcjBU6i0OMZwnCKfdZF8ZOPOvYeA/DcVkQgz9IsMcEQ430fjJ9fBKKRZR01K2ja3H1CqHZf+IZhf1qfmkzmTPlQZTOWYvCCDk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179160; c=relaxed/simple;
	bh=HzJrOGO7SSi8SJQ20OuxS2v6x1yNn+TjTH2N9Ey8ZCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iNmjZyQKBx7XuA7kMyeooIRDO8krfDe4RR87GwmTkWuKJZP49g0b4h9I6EnAhXYxvaNsFrufEy+iQYf8Ky3rZzTKt3k770hvB5bagqPcoOGWNa+WSn9O4tfevYOtpyc/0IslJqck04cof7HBR6LLl+ViGhh5/ip7aV+zzcAQ6Cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mEl+gxtt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mEl+gxtt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 736E2C4CED2;
	Mon,  6 Jan 2025 15:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179159;
	bh=HzJrOGO7SSi8SJQ20OuxS2v6x1yNn+TjTH2N9Ey8ZCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mEl+gxtt5NEPwcvbnEyxwSny7FpEpyQdTwmeSy97Qr+vNmojiiXUkaP30nxYbomhO
	 2bbIs5QcPchd1tFoTgeXc0fDxz0e3mRcsuRgOpZcJPnSv8CZYwY9SlWFvzFk3Oe9//
	 +9WXagoD6e7YFUwLJqEkVnYKDqKZ87HoB4N2cKgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 44/93] tracing/kprobe: Make trace_kprobes module callback called after jump_label update
Date: Mon,  6 Jan 2025 16:17:20 +0100
Message-ID: <20250106151130.364099423@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit d685d55dfc86b1a4bdcec77c3c1f8a83f181264e ]

Make sure the trace_kprobe's module notifer callback function is called
after jump_label's callback is called. Since the trace_kprobe's callback
eventually checks jump_label address during registering new kprobe on
the loading module, jump_label must be updated before this registration
happens.

Link: https://lore.kernel.org/all/173387585556.995044.3157941002975446119.stgit@devnote2/

Fixes: 614243181050 ("tracing/kprobes: Support module init function probing")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index c966638fb62c..56d22752a52e 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -703,7 +703,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 
 static struct notifier_block trace_kprobe_module_nb = {
 	.notifier_call = trace_kprobe_module_callback,
-	.priority = 1	/* Invoked after kprobe module callback */
+	.priority = 2	/* Invoked after kprobe and jump_label module callback */
 };
 
 /* Convert certain expected symbols into '_' when generating event names */
-- 
2.39.5



