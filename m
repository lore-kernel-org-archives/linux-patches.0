Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841273EC2CD;
	Mon, 17 Aug 2026 15:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979863; cv=none; b=he0MTeX0Pr1HUb+rtYYHlCyiIVtO3wGPTCBUrTcfq9N6M/Uo/dI6qav0E5GhUXQt2jUAB2L1vwrxBCgfdFkNb01x40PRNg47QhSU5gYIByq3wF5VCPAUoVQ24ZPY3Twk1XoZKHF+0FjGYYzyJPi4ALbBf2v1c2r2DULyGTckv7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979863; c=relaxed/simple;
	bh=4ANxgUP5yTwCbJ0D0o3xfSt/SfbNwhDODS5nv7E4UkA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jHcpt+yUPoFKrkg/AuIAlUE5bpVC4YOAq1OiS5HXV5KbNxCRemlp1BqrDGeM2PaL0YqydlEc6NF35l1YxJiXAOqaHUd8X3WUuLkDZfU6brbzGypxhmU5PVDSdArSUBkqjHdMYegMQHKQpE/BSPp4KUz3gF9cItykAPEtJygMhy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vijr/Ln/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vijr/Ln/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F0481F000E9;
	Mon, 17 Aug 2026 15:17:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979862;
	bh=AriELPOZLoGtoqVEdxFIf9QmE/P1QtyPjNUDdvO41vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vijr/Ln/KFk90MPYWqi6sc2G8oLHMEvvCvlcW/gjPD6T/HfLYwNbIJfiytfRqj2UP
	 v+UVDbt7uouw51XGB1Du9YrJNcCpMTm5qri1388Q0IML6GnZGXnuUODiWykLGInww3
	 226O0adeaZ0iSB6BIe0kdFOtSC6dDGpGxQq6ZK6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 374/609] tracing/mmiotrace: Reset dropped_count in mmio_reset_data()
Date: Mon, 17 Aug 2026 15:31:10 +0200
Message-ID: <20260817132556.793355875@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit c786d2bdf1f3964deee192ad942dee2a741c1e2c ]

mmio_reset_data() is called during tracer initialization, reset, and
start. While it resets overrun_detected and prev_overruns, it neglects
to reset dropped_count. Consequently, dropped event counts from prior
tracing sessions persist in dropped_count and corrupt overrun reports
in subsequent runs.

Fix this by explicitly calling atomic_set(&dropped_count, 0) in
mmio_reset_data().

Link: https://patch.msgid.link/178524299122.56416.16277704230639425172.stgit@devnote2
Fixes: 173ed24ee2d6 ("mmiotrace: count events lost due to not recording")
Assisted-by: Antigravity:gemini-3.6-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_mmiotrace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace_mmiotrace.c b/kernel/trace/trace_mmiotrace.c
index 4d9e5c830dbe1..c523ce5aa4958 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -29,6 +29,7 @@ static void mmio_reset_data(struct trace_array *tr)
 {
 	overrun_detected = false;
 	prev_overruns = 0;
+	atomic_set(&dropped_count, 0);
 
 	tracing_reset_online_cpus(&tr->array_buffer);
 }
-- 
2.53.0



