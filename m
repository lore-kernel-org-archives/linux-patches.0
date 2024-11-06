Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296062003A7;
	Wed,  6 Nov 2024 12:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896776; cv=none; b=irYNqjgE9rzQrU1npPbjN0MrYOGnF8Aa+x0jcc7FMO1PslI6w9KAxM2uD583V8PiH4ei1MUieuJdyzvEAmYhcJgn9t7ykDMac2mk/WsNBaY5/Id4Q7syI5SlCPbsH9EWKYoNlQQMrFNmbXZXDoYufNwXMfejE6KdEQYreOrjkj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896776; c=relaxed/simple;
	bh=pPwbi+3vQwHZlx4sBTkIR6bTV2MJCdefvwUrrbGwEHg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gcjO7xT7C6+wBibaFjiGDvnQpor7gEolirsvvbk7W8dp82jrspY7zHWZlRW9Dde3Pwa4n9q1fxrDa8i2e6Ij4FtjCeQaHWPkFIb8G+2gIAhSDlANdj9kqUMFxpmI5YXCJQD1l3L9QEV7SSf4+q6myIY6LH8VHy2SqkgPdRBU5zk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bz2wbR+A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bz2wbR+A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A429CC4CED3;
	Wed,  6 Nov 2024 12:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896776;
	bh=pPwbi+3vQwHZlx4sBTkIR6bTV2MJCdefvwUrrbGwEHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bz2wbR+ALUgOmLizKqSSHzH6s9g6eMnqU9v5uTr4mdwnMJXRfSpM9AJxIwjXM64eU
	 S5UihWCbqKQj+ZAgq74oxyV3I3Ay9bOZsntXlZu8MhN400mFvcYhy27rBrgle7+iT0
	 rKa9a3dDc8gMuvdHw5uRdi3gB3zSnh7EWsS67J6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 032/110] tracing: Consider the NULL character when validating the event length
Date: Wed,  6 Nov 2024 13:03:58 +0100
Message-ID: <20241106120304.076721504@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120303.135636370@linuxfoundation.org>
References: <20241106120303.135636370@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 0b6e2e22cb23105fcb171ab92f0f7516c69c8471 ]

strlen() returns a string length excluding the null byte. If the string
length equals to the maximum buffer length, the buffer will have no
space for the NULL terminating character.

This commit checks this condition and returns failure for it.

Link: https://lore.kernel.org/all/20241007144724.920954-1-leo.yan@arm.com/

Fixes: dec65d79fd26 ("tracing/probe: Check event name length correctly")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 073abbe3866b4..1893fe5460acb 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -256,7 +256,7 @@ int traceprobe_parse_event_name(const char **pevent, const char **pgroup,
 	if (len == 0) {
 		trace_probe_log_err(offset, NO_EVENT_NAME);
 		return -EINVAL;
-	} else if (len > MAX_EVENT_NAME_LEN) {
+	} else if (len >= MAX_EVENT_NAME_LEN) {
 		trace_probe_log_err(offset, EVENT_TOO_LONG);
 		return -EINVAL;
 	}
-- 
2.43.0



