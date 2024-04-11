Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CFDB79FD;
	Thu, 11 Apr 2024 10:47:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832461; cv=none; b=Z1Gs8YcRrMrY9HDW2CkAHYerLiF/GU6vDWrz6OnvgaGjZHahPwBIEiM5M7yPGIZJspe2WvcJmFsoK4GU8wvjqdHX6/iW2eqqsPbVK/glbYS11sJRTNMk2A8K/GnEKdDu0uwZaSdmks7pIonTe2XOhz2XrmWW91+t7sLrWxTafIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832461; c=relaxed/simple;
	bh=ElV6p2Q/UmnXPHwBAut7ljjteM2QOKOFVAksZay35Nc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I4zv0Cv9SgPPaNCllpOkK69uet6+gCZJa9U2qhfgVkIHoXhMMZGZijJv869OTG8q8pSdIFzjrnquqrOfjNkSO8MEoyPiWbbCtSi9IyI4Iy2bQiXVNUkEeHGP+uR1+4jbLvfLjygG9hM9nPcLGCPFTxST3JiHKgZn0pbvmpOZC7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TDP+1sil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TDP+1sil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E50EC433C7;
	Thu, 11 Apr 2024 10:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832460;
	bh=ElV6p2Q/UmnXPHwBAut7ljjteM2QOKOFVAksZay35Nc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TDP+1sil7lqQp38G05sSihiJ2jGOQ3RsqMjIAgXdoKb90+1zYdJKioO8knpoKU22q
	 UjuRptx3ILce2BZqQX66FNo7Lf6N2ik0X215OdSq3ZZxAjgaT4fcHw85t5XupBGnJ7
	 c+XQYjnH0Cuwg8r2TW02clQk/kPfu5ipLifH2duQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linke li <lilinke99@qq.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 56/83] ring-buffer: use READ_ONCE() to read cpu_buffer->commit_page in concurrent environment
Date: Thu, 11 Apr 2024 11:57:28 +0200
Message-ID: <20240411095414.370576333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095412.671665933@linuxfoundation.org>
References: <20240411095412.671665933@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: linke li <lilinke99@qq.com>

[ Upstream commit f1e30cb6369251c03f63c564006f96a54197dcc4 ]

In function ring_buffer_iter_empty(), cpu_buffer->commit_page is read
while other threads may change it. It may cause the time_stamp that read
in the next line come from a different page. Use READ_ONCE() to avoid
having to reason about compiler optimizations now and in future.

Link: https://lore.kernel.org/linux-trace-kernel/tencent_DFF7D3561A0686B5E8FC079150A02505180A@qq.com

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: linke li <lilinke99@qq.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 431a922e5c89e..d2947de3021a9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4431,7 +4431,7 @@ int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
 	cpu_buffer = iter->cpu_buffer;
 	reader = cpu_buffer->reader_page;
 	head_page = cpu_buffer->head_page;
-	commit_page = cpu_buffer->commit_page;
+	commit_page = READ_ONCE(cpu_buffer->commit_page);
 	commit_ts = commit_page->page->time_stamp;
 
 	/*
-- 
2.43.0



