Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 120C4288CBD;
	Wed, 23 Apr 2025 15:06:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420775; cv=none; b=aonQByjgi7OxQiT2kGbRpkKHFJpvvkCgZXMpNEwFIZGcNShGCGkwAOMU69OlBd168T6h+20/EEG6pGDNVXbfsw5kgJV8iHAOoVg41gWByEVFeOgTXo5zjFjjLCbcdNM39W6Fpr/fIJNu0vmQ2z5ZPLAuwcoGfngfgh8qARFLl20=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420775; c=relaxed/simple;
	bh=ru1NkOPg1aGUnF/DCE8DU4yFcbe/kXxbASca1luvRMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uc01kI+sQfDv77B3depspJGhALyPiHElegS4O6lzQwDC99S6dCLM5CIYSC3ahDx0vdHidntn/EIOIapOWs0WnKIeJkb1PLGStt/2BSb3EfKGUGUNnlZ7Cv0txmiG+yR9KHkqEnKwXtW9HPDDEt970Pd5ROwG9mcw/gB/fhHO1EA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JPDfpiSI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JPDfpiSI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CAFC4CEE3;
	Wed, 23 Apr 2025 15:06:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420774;
	bh=ru1NkOPg1aGUnF/DCE8DU4yFcbe/kXxbASca1luvRMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JPDfpiSI6zW/NGLEjELgrz/g1sybknygazgqMFBnezMF5Zj5l7MzBaBpMngXUtvry
	 TvR/I7v0aD7rt7WsztRPTCDcFSkzCxZ7cVAs3P/khurYGPCdrfFfCcpPyHMmt0lpIQ
	 jPkFWB4Y5fiAoK8ZrHsaOrJzYmxTnLpbRkJz0eWI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 111/393] tracing: probe-events: Add comments about entry data storing code
Date: Wed, 23 Apr 2025 16:40:07 +0200
Message-ID: <20250423142647.951415441@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

[ Upstream commit bb9c6020f4c3a07a90dc36826cb5fbe83f09efd5 ]

Add comments about entry data storing code to __store_entry_arg() and
traceprobe_get_entry_data_size(). These are a bit complicated because of
building the entry data storing code and scanning it.

This just add comments, no behavior change.

Link: https://lore.kernel.org/all/174061715004.501424.333819546601401102.stgit@devnote2/

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Closes: https://lore.kernel.org/all/20250226102223.586d7119@gandalf.local.home/
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 8c73156a7eb94..606190239c877 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -769,6 +769,10 @@ static int check_prepare_btf_string_fetch(char *typename,
 
 #ifdef CONFIG_HAVE_FUNCTION_ARG_ACCESS_API
 
+/*
+ * Add the entry code to store the 'argnum'th parameter and return the offset
+ * in the entry data buffer where the data will be stored.
+ */
 static int __store_entry_arg(struct trace_probe *tp, int argnum)
 {
 	struct probe_entry_arg *earg = tp->entry_arg;
@@ -792,6 +796,20 @@ static int __store_entry_arg(struct trace_probe *tp, int argnum)
 		tp->entry_arg = earg;
 	}
 
+	/*
+	 * The entry code array is repeating the pair of
+	 * [FETCH_OP_ARG(argnum)][FETCH_OP_ST_EDATA(offset of entry data buffer)]
+	 * and the rest of entries are filled with [FETCH_OP_END].
+	 *
+	 * To reduce the redundant function parameter fetching, we scan the entry
+	 * code array to find the FETCH_OP_ARG which already fetches the 'argnum'
+	 * parameter. If it doesn't match, update 'offset' to find the last
+	 * offset.
+	 * If we find the FETCH_OP_END without matching FETCH_OP_ARG entry, we
+	 * will save the entry with FETCH_OP_ARG and FETCH_OP_ST_EDATA, and
+	 * return data offset so that caller can find the data offset in the entry
+	 * data buffer.
+	 */
 	offset = 0;
 	for (i = 0; i < earg->size - 1; i++) {
 		switch (earg->code[i].op) {
@@ -825,6 +843,16 @@ int traceprobe_get_entry_data_size(struct trace_probe *tp)
 	if (!earg)
 		return 0;
 
+	/*
+	 * earg->code[] array has an operation sequence which is run in
+	 * the entry handler.
+	 * The sequence stopped by FETCH_OP_END and each data stored in
+	 * the entry data buffer by FETCH_OP_ST_EDATA. The FETCH_OP_ST_EDATA
+	 * stores the data at the data buffer + its offset, and all data are
+	 * "unsigned long" size. The offset must be increased when a data is
+	 * stored. Thus we need to find the last FETCH_OP_ST_EDATA in the
+	 * code array.
+	 */
 	for (i = 0; i < earg->size; i++) {
 		switch (earg->code[i].op) {
 		case FETCH_OP_END:
-- 
2.39.5



