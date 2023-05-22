Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D071C171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5ED6FC433EF;
	Mon, 22 May 2023 19:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684785240;
	bh=JsB+WBSJEJbYNFzNOj0BBwk0l1WG/zhTTQ+jWG3x6j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AQzUQ/DJDhvTcZuMzSz6WqbDCStH4+aIa4FT0+z15dBL5oXYATR/dJZGLrL87/rVt
	 +xu1fGA9HFyOeyEmT/LeGYw+Kg+7i467ynLBmuc/LHGkQVj5U4IuNdJLpuU0Lmhhy+
	 sseU/mb7/xsdnCSjr67UfKJJiXZ/1eOa+V/+DLFw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ze Gao <zegao@tencent.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.3 357/364] rethook: use preempt_{disable, enable}_notrace in rethook_trampoline_handler
Date: Mon, 22 May 2023 20:11:02 +0100
Message-Id: <20230522190421.699232947@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ze Gao <zegao2021@gmail.com>

commit be243bacfb25f5219f2396d787408e8cf1301dd1 upstream.

This patch replaces preempt_{disable, enable} with its corresponding
notrace version in rethook_trampoline_handler so no worries about stack
recursion or overflow introduced by preempt_count_{add, sub} under
fprobe + rethook context.

Link: https://lore.kernel.org/all/20230517034510.15639-2-zegao@tencent.com/

Fixes: 54ecbe6f1ed5 ("rethook: Add a generic return hook")
Signed-off-by: Ze Gao <zegao@tencent.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/rethook.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/kernel/trace/rethook.c
+++ b/kernel/trace/rethook.c
@@ -288,7 +288,7 @@ unsigned long rethook_trampoline_handler
 	 * These loops must be protected from rethook_free_rcu() because those
 	 * are accessing 'rhn->rethook'.
 	 */
-	preempt_disable();
+	preempt_disable_notrace();
 
 	/*
 	 * Run the handler on the shadow stack. Do not unlink the list here because
@@ -321,7 +321,7 @@ unsigned long rethook_trampoline_handler
 		first = first->next;
 		rethook_recycle(rhn);
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return correct_ret_addr;
 }


