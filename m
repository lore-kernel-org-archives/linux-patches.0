Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308CD3264D6;
	Fri,  7 Aug 2026 15:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116004; cv=none; b=tQKaKZAB0vM5KO1JncqAYcCGoBu78P1glIu7jcFjnoQ63JlIlQTNwU80Ljlm3KUbdpvp81Oj8zUqfw8RzypSZ9U+cP9loZD/c2BIen/xxg30Bt+Zvy1TSQ9yWhPWN+qcSVsq4l+TOM4LMIrEt/8JsnRnS9m3ZcfgZW0PJ6XYIh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116004; c=relaxed/simple;
	bh=k0M1mXrU66AHGkvzZiWEHhfi2WqLssH0hjEGSVpvN28=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5PXHLq3kznIg6sUzqlilHErdl6JyKl/97y2wQBLa5wtrt1wa/FNl4IsSYdyh/LArtt4GHwMhMPvp9QpINRnkvc+e4ZNDKHURk1gaqVTzpbOIoTlvDJtHg6XHTjjdxbugQP8CmVkB87AhwBo4ofgx46M0dmzjyOhLEymyw0x9AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jN28+mAJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jN28+mAJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3C31F00A3A;
	Fri,  7 Aug 2026 15:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116003;
	bh=2F1Y9c5h55z3oKJG3GeIbPBvd2mb+6uHyLwNXUeqMO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jN28+mAJe4Vv/rP6JkRX7l56qOqr//tI2zFtbpRXNL0sEVvzNYe4GyAZ29gYJKhS3
	 UyYp9NtqkN1noM/5LEBAcQy+3mO/GRtOW51sICKm30SJKYJbbp4KK1fOJD5mki30Ng
	 yXP+X/Las0VlYF06NYJHQe0B4iBrn1qy+tVPEIfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 079/261] tracing/mmiotrace: Reset dropped_count in mmio_reset_data()
Date: Fri,  7 Aug 2026 16:37:16 +0200
Message-ID: <20260807143417.089762615@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143415.358597922@linuxfoundation.org>
References: <20260807143415.358597922@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



