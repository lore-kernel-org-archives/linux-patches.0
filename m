Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEBA814A085;
	Tue, 23 Jan 2024 01:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972097; cv=none; b=GpG/mfJenHqAOez1qAjsvPgaZ9vgkuu+a7nXJn0Bn0htN2fUTGqOUpVzYcVQwd/R63AJ12OLrrqqLkuvM62eRuJwhweW4pkTBQxSFhgA02LE5OeVPwlZPZ7cP2N+VRx8pjgpamDZmgBJk8aSxI/so9AGTwBEWQe7zrzp/SSz8Ss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972097; c=relaxed/simple;
	bh=jLX/ITKIZpub7DXccc6VLYPpHtkDpH2o02iygJTIXTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j1H54qYdTjbXuv81qsn3w54BxFEWq6SZhFznHA7IcnBVrqTB6Yu9zwPmIuJIyu+Gp9IAQZnrHLPSLAVfZlGkATr0oDD0N1q5S9UdTiMyyY4e2jOOJQCOx483UiPA6wjhgyV1UMr0nHLPiWpF+gO7i34FH9v3f3QmtRSda5Q3fO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vaRugg1a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vaRugg1a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88B26C43390;
	Tue, 23 Jan 2024 01:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972097;
	bh=jLX/ITKIZpub7DXccc6VLYPpHtkDpH2o02iygJTIXTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vaRugg1adAu1FyoEPBLScuQrmay3IJddLc2+gZfFT4fYDi8ZJhU/rqbCVu5z3ul+f
	 tT3C0TEsmi2TvOPrXgdk8UpBV0nmwlcHYzu8KpFj2yc3SDugRzb4MLU3VA7GX6pWmz
	 FaYvFvIbUMecyYpAikq4JgUPs1NTIh8cyQB9zguo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 036/374] ring-buffer: Do not record in NMI if the arch does not support cmpxchg in NMI
Date: Mon, 22 Jan 2024 15:54:52 -0800
Message-ID: <20240122235745.895235753@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 712292308af2265cd9b126aedfa987f10f452a33 ]

As the ring buffer recording requires cmpxchg() to work, if the
architecture does not support cmpxchg in NMI, then do not do any recording
within an NMI.

Link: https://lore.kernel.org/linux-trace-kernel/20231213175403.6fc18540@gandalf.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 65a728b89574..374cfba6c306 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -3603,6 +3603,12 @@ rb_reserve_next_event(struct trace_buffer *buffer,
 	int nr_loops = 0;
 	int add_ts_default;
 
+	/* ring buffer does cmpxchg, make sure it is safe in NMI context */
+	if (!IS_ENABLED(CONFIG_ARCH_HAVE_NMI_SAFE_CMPXCHG) &&
+	    (unlikely(in_nmi()))) {
+		return NULL;
+	}
+
 	rb_start_commit(cpu_buffer);
 	/* The commit page can not change after this */
 
-- 
2.43.0



