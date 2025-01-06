Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C2C13BC39;
	Mon,  6 Jan 2025 15:53:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178829; cv=none; b=nG6QdHXR607z14DAw+/2HMAVJDe1RgliK9j57NC+pEXxRJGWBFtuvLC8yuQeKYVF40HFxG+nFXznD2KKAm1DsXEEzmx7ICvuSmxxzrZpq8haFSnq3PAPN6lFb/hSWY7mUDqWfzHyp53KamOghneUubpa/cutqjqsP5Wcdn7+oJY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178829; c=relaxed/simple;
	bh=MXmxjrHouHGoRboskVtMa3rBryGwsE26kCLEnSW5y/k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A3gJ0h/GqwAPioxflI4cyujLAFbGw/yG8IRXBaWpW/zVUucas/nG05D7O7HKI5WKJEIrXOSrEzL7DNWf73WiNEY/z1DIpG433FA6t9rTvH212WbkFguS9uLivsVyH4BID65kpCIyUWVyqheaWgzIMPGWkzIv/ya2YItB2AoRW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kiTtTAnB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kiTtTAnB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24E7AC4CED2;
	Mon,  6 Jan 2025 15:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178829;
	bh=MXmxjrHouHGoRboskVtMa3rBryGwsE26kCLEnSW5y/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kiTtTAnBSKuLEZZu5FJQdqOge7S5UxFRnTuI5HUWCT24fHanUrwtkKo8HDZG0VCW0
	 uEljVdOLXcFlgeTQaUJ5JUUAkkkuo16MEikgml3lWwh/MWLm4XWws8q99bNNi6WHhW
	 T7J22xTRGRgaM++6SsIO2MyaQFtnZr97ANYOR0K8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 075/168] tracing/kprobe: Make trace_kprobes module callback called after jump_label update
Date: Mon,  6 Jan 2025 16:16:23 +0100
Message-ID: <20250106151141.299494589@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
References: <20250106151138.451846855@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index baaaf9bc05f2..3a1c54c9918b 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -705,7 +705,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 
 static struct notifier_block trace_kprobe_module_nb = {
 	.notifier_call = trace_kprobe_module_callback,
-	.priority = 1	/* Invoked after kprobe module callback */
+	.priority = 2	/* Invoked after kprobe and jump_label module callback */
 };
 
 struct count_symbols_struct {
-- 
2.39.5



