Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 406851448EF;
	Thu, 11 Apr 2024 10:11:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712830316; cv=none; b=iQktCteMkSHOqQ+jVRFGR5wFafHRd/VwYb9hK9JN1xoVEohOjoA7MNgFRCheQUOyHEaBPcSN7qy1KTSivrTgdF1RWwgPK5sAQOJRCgQKeeKWZPvLoqWJ5E9GfzddPqVxBzjKtJqGL9SQmN28Tvjx5O3cRMyjNZCfTHT5o4c9J8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712830316; c=relaxed/simple;
	bh=wv8zhXZMHAVv+IxkH/M5sRjGtUAG7tsmR80jYUqKdIw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HlibU5djrF6OoepzpwTRKvBOtUs8m1eVH9GqtSWZiJmDwQADObfNO0kjutf7jfoN2znpCoq6YQJPmGlvjRH90BIgY2xm5DVZPyVPJoN4nONmm3UnD5JOwPrg2SIlC5c66yzQIU3xi1+0KPzqXxg1LodRI3knVODK3YBPl77e2C0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CWCfWjWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CWCfWjWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80374C433C7;
	Thu, 11 Apr 2024 10:11:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712830316;
	bh=wv8zhXZMHAVv+IxkH/M5sRjGtUAG7tsmR80jYUqKdIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CWCfWjWFSVF384bTD3UODI18vj2xTAfh8BU7jyvUMDW0XKwbYb1C+4aq82gCv09Ye
	 LFrt8ug96Y8DsLvhYYosgMVniiebMXLgO2asjs0aqD0mElyijlyAxI+OyHoOZ1DBO5
	 LMvGbkqJdQ4UyFrOqW2hVxptFoiW5BzrcDROHnLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	linke li <lilinke99@qq.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 107/143] ring-buffer: use READ_ONCE() to read cpu_buffer->commit_page in concurrent environment
Date: Thu, 11 Apr 2024 11:56:15 +0200
Message-ID: <20240411095424.127625051@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095420.903937140@linuxfoundation.org>
References: <20240411095420.903937140@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 43060a7ae15e7..2ad234366d21c 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -4395,7 +4395,7 @@ int ring_buffer_iter_empty(struct ring_buffer_iter *iter)
 	cpu_buffer = iter->cpu_buffer;
 	reader = cpu_buffer->reader_page;
 	head_page = cpu_buffer->head_page;
-	commit_page = cpu_buffer->commit_page;
+	commit_page = READ_ONCE(cpu_buffer->commit_page);
 	commit_ts = commit_page->page->time_stamp;
 
 	/*
-- 
2.43.0



