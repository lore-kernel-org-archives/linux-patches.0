Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C548446C00;
	Thu, 30 Jul 2026 16:09:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427793; cv=none; b=quXC32LaydxvNAm84HiKBvcB95LSp3XWTrTngmw+Do0kHqLAXlXmTHas35xeNtaMiRKDd4VCB/ovvS2xbDk+6b2HXe7U6cpX5pW9IUpTW0Lk/7Ls6bPdC16kgjFeAPXN397NM1yoR6CS9t4b6EZjhkVeIjEaKzhlnhYRandBeNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427793; c=relaxed/simple;
	bh=dtuyO8HIO95+F2wIP009vER8DzJpwB/I2jXXh14pESY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WUEGZd8vMkIEDpHd4ZivF2PdCyCBGYgP4HFNjiOC9xRJfMYp90NO22T69ylzXNWumM8bllg5c2FyiJvosVos4Iz7wqzGNbQC6BJrgGp3oYqBg2i/l5mjHOR57WRQw90Ibi9HqCsGk0zNMb1ohqImsXY2bBa3zFOpjEYQAwiNz6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGZ5G71x; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGZ5G71x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9710C1F000E9;
	Thu, 30 Jul 2026 16:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427792;
	bh=nGtoodlQTLfXYJMR+xeME1ROYtJZN5WnJPn1dSFkEeU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yGZ5G71xIeXjtVVuhrU1qizDDtMwm+tPjr5tr3Aod52lWpJDRYufBvPPYbvlKo1Xb
	 4tNX0XRYhbjOjIP6Dt9bC5M7H1+caESGcT2VkoMkkOYrgv8KV5xJ3oytrjpOZzaYbA
	 wTpPtRAmmI1w1sDaBcpuKNW3veEWKZaIAZx+qqtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.6 295/484] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Thu, 30 Jul 2026 16:13:12 +0200
Message-ID: <20260730141429.902887357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

commit 8ce20bfba48902e1382187cd1a852f7cf3a1e739 upstream.

In __set_print_fmt(), LEN_OR_ZERO is defined as (len ? len - pos : 0).
If len is non-zero but smaller than pos, len - pos evaluates to a negative
integer. When passed as a size argument to snprintf(), this negative value
is cast to a large unsigned size_t, bypassing buffer size limits.

Ensure len > pos before subtracting to avoid integer underflow.

Link: https://lore.kernel.org/all/178454234934.290363.15247317871499514139.stgit@devnote2/

Fixes: 5bf652aaf46c ("tracing/probes: Integrate duplicate set_print_fmt()")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_probe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -1779,7 +1779,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   enum probe_print_type ptype)
 {


