Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F9351D558;
	Thu, 11 Apr 2024 10:28:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831328; cv=none; b=jN7APu4i+/ddAvNbNctr8MIy+kE+lLLeJQuXKxEd4himsFheVtJFRnMtCT6j0Q/mS4MAbX+Sv2Y1UbBtfQjwiLRBq7IDXpCCpot8Iap1ySH9goWMjLfwpVC9f1Cgh0Sgr42YOK0KErFyY7c6XDrMaduFE12ncJYuLmTtD+70rGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831328; c=relaxed/simple;
	bh=mlxCh4kAl+T6ViIEnG9y/xm8348jUTMSaQKuOukfoQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkNWp/Er0w+73wu6cGGuCYUuoQcGf9oK+4WjsA7r4QwBsgcw8MeTSE4Gp5c5BBB1x2+h+wTMR8lIqWrOTlJAfwI9Cg/Cx7tbpJJ/aLBf3+32npgYlkizP0AbPLgGmPDnHjEt0FI5nJwunocGbVrpyt2ns0a5T3AwrdCr5583SDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p49Ztb1e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p49Ztb1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC037C433F1;
	Thu, 11 Apr 2024 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831328;
	bh=mlxCh4kAl+T6ViIEnG9y/xm8348jUTMSaQKuOukfoQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p49Ztb1eo4N2sxTSVuB/2UK+1G1cLsE3gQrmuPzN3j1Yp7YHLNg0QywsvwC0Gvm4T
	 Uo3mk28NdPS9YzbiSLC2Cb/ezL7NDN6MajiwIE2ykrGQx3HWfwP0yVjfQCigQGC++h
	 bTdSSneQIvAxE6IlcxSmW/tYXBA4jVwZjudWfEvA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linke li <lilinke99@qq.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 085/114] ring-buffer: use READ_ONCE() to read cpu_buffer->commit_page in concurrent environment
Date: Thu, 11 Apr 2024 11:56:52 +0200
Message-ID: <20240411095419.455672769@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3fedd051f12c0..06249b37d8019 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4436,7 +4436,7 @@ int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
 	cpu_buffer = iter->cpu_buffer;
 	reader = cpu_buffer->reader_page;
 	head_page = cpu_buffer->head_page;
-	commit_page = cpu_buffer->commit_page;
+	commit_page = READ_ONCE(cpu_buffer->commit_page);
 	commit_ts = commit_page->page->time_stamp;
 
 	/*
-- 
2.43.0



