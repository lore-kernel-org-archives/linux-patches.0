Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2647C40DB22;
	Mon, 17 Aug 2026 14:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976058; cv=none; b=dwJw8/pnz2KjUqSlcFMJaREgDTKpFtbF+qfWgyHUzMDvJPo3H/wV0N+NkWfDUFH9egFzZLODlG3AZS6c4ttEmIyeQe4IJjCfuTJgYPtgvaLclwdxnL0xtxaFoYawVbEFNuyhSYPlk/PdChE+rSgh+hkeP6ooqLVfg8DNbe5bcSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976058; c=relaxed/simple;
	bh=L26hyiYFyqHy6z85Q2hP/RJaKwbuyamMQ2wvThz9wYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TDJVsNgsO2Gh/rYpslShn2lLwOIeInlZJgy0GAzxiClVc/3k2cebnVt3BlxfP5W78tu1Nbr7YwadlMM5lApZIgDN+uXU//yGtJa050m0N1GuIEb720OW4r3MMJ2mVmdJXXW8aEbrElXlcLCrXChA0BiEkdfSmonjPeLk2GmFR24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vOfDpQ2e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vOfDpQ2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8601F000E9;
	Mon, 17 Aug 2026 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976057;
	bh=S/S6sVtuET8lwnCQrGU6pwCtLoYuA39jO8/sP8yf6nQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vOfDpQ2eeE9DYZBelLqcKSkiufYzDwP373LBEkpZ7N7mYBCjCAPQkpDUsXyk4COOq
	 q2zKhUDatZ4e07ylhZ/o28O1G8o3QDaQGFOyuZ2NOxS/03eicaE3m1UyBisVhAv5Q6
	 xttvF2RGpvLw68snPoVSY+lbGumQlpo9dJvF5nh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 235/389] tracing/mmiotrace: Reset dropped_count in mmio_reset_data()
Date: Mon, 17 Aug 2026 15:31:14 +0200
Message-ID: <20260817132548.435257618@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index da2231ac13dfc..e8ae2d92a6787 100644
--- a/kernel/trace/trace_mmiotrace.c
+++ b/kernel/trace/trace_mmiotrace.c
@@ -31,6 +31,7 @@ static void mmio_reset_data(struct trace_array *tr)
 {
 	overrun_detected = false;
 	prev_overruns = 0;
+	atomic_set(&dropped_count, 0);
 
 	tracing_reset_online_cpus(&tr->array_buffer);
 }
-- 
2.53.0



