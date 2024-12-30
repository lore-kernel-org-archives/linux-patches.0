Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBD0E15E8B;
	Mon, 30 Dec 2024 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573881; cv=none; b=l6EmTES8mb9Efj5clvXv244clcxNuzNTXqNuQjD6noP90cKCQVNCjTuzr4YHVrMAc+Mef/KIIMhH+4ybDmdr8v6yyMjUnkMy06BTvTP0W0jrbQkGY9SoykAfQ5HYU6j7L7Dndke+SWBX+zPEcqeR2TUqgSiPyw9Itkz6Vh6zbss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573881; c=relaxed/simple;
	bh=o2sqwsynM/ZRWMIiZHc2J2a1fUOIEF7jSG+28e6VH14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=auGjhjC92G/RIEKMo8xdTS4x6Ww9ujlb9UiMD33p/btV7kwTje79wuLwGO4G1PLPQkkPZL0CmqUUOiU5y6E70QG0an05FNDix16Z19wnhn3v42nMcsV5I1eekvxO41R/gRdaR0E7HGFXpwiHW6+ulfKBBXbomfrDrzvOzzBF3eU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8IqbMcy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8IqbMcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A32EC4CED0;
	Mon, 30 Dec 2024 15:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573881;
	bh=o2sqwsynM/ZRWMIiZHc2J2a1fUOIEF7jSG+28e6VH14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q8IqbMcyqNA9zWrZ2ZeeGrl1VCMq5lhGxk0HPOpHHpLtg80H++6+gT9Z6d/EEQ1m9
	 xvt8cXVnlojH0FTYO9RqzPwiOxVNnwsBY7ffVRniaJn+AFTWof2h4teqp/bQP2YIvh
	 pTaSrPUbg6ZeYXjbq27MSmKbpMpHreZmndOSrzwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 31/86] tracing/kprobe: Make trace_kprobes module callback called after jump_label update
Date: Mon, 30 Dec 2024 16:42:39 +0100
Message-ID: <20241230154212.905414299@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 94cb09d44115..508c10414a93 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -702,7 +702,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 
 static struct notifier_block trace_kprobe_module_nb = {
 	.notifier_call = trace_kprobe_module_callback,
-	.priority = 1	/* Invoked after kprobe module callback */
+	.priority = 2	/* Invoked after kprobe and jump_label module callback */
 };
 
 static int count_symbols(void *data, unsigned long unused)
-- 
2.39.5



