Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDBE296BD2;
	Fri,  7 Aug 2026 15:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115201; cv=none; b=dKdZe4FMBrQJ2SNZl+miB65fglmSYdKmivrGX3aZfBaxsOyV4yBkQvjVxDeuOkMKTJckWVEqY8piKoqt4cD3ScthR61W8M+ffkc0RfUe9yTomxcka/1eQEhP0Q5B/kVwVSXQ8zguBDVl4eUDW+IRnYR2W42tOGLsKOsKLJDlzOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115201; c=relaxed/simple;
	bh=YDNyy8W5HrbjPuFJH1sbVeBsLA/k5uPtvAZytwYknXg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BSfk9caauPmFLS94i5VtJyaCZsLlkSW+F0tTo3AlrH76dKM2k7M4jWvBcpn+KH64L/6hw4Zl8kwuS2+SGXealg/nWizXrnvabS+8kMWN8faLOqBKZGau5zf4Q95BcPLKcaGREi8y9z1xR5xGopqXpykSwXVCuxt70vRPC2UQq3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VkL6272w; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VkL6272w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAB861F000E9;
	Fri,  7 Aug 2026 15:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115200;
	bh=8xqGGV4K3EVxmnokwWEnIb0yhaqw8LMwKBPck6Flfxw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VkL6272wJsoFnhwq7DIS1dDMZRa84zk+iEayZBiVM5ldK60IJ0rAReLCoDiAR6Pjq
	 vi+g2M54ww+XIKG1RPNuckb9B+WkU7iVcE0Z+e9SPnbcWjgEeNc4Ed0AdY1CCh2YDu
	 AzWE5Os6DUJF3LhwHrtg86jPhS9/k8iTprDDMmNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 139/396] tracing/mmiotrace: Reset dropped_count in mmio_reset_data()
Date: Fri,  7 Aug 2026 16:34:59 +0200
Message-ID: <20260807143427.308095794@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index dc8a1eafbe574..e16b15d7c84aa 100644
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



