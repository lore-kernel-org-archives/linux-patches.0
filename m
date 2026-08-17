Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 815CF3EC82D;
	Mon, 17 Aug 2026 14:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975923; cv=none; b=twLryJ3MuHh8KJktuD2+1u4bA7yfradbH0n867Hoh/S0DBvjgT7zryFZzhpweRlojyoORFqeNCl2xiSi838n93fSX4IBA8iUOpTtndIvLSMJCK4tXPAhdeK+pdShhSaLVZfo/cAfsMUlkRLi1V/U/RNk70Ro7vYp/GKKY/QhOdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975923; c=relaxed/simple;
	bh=hFs23pvMZ4TtLbY6I3BYZvUUtLVrgMBrdd2DoXt3zUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DoSreLoZcT+wI0Y8ukNIt+oQWls6kmcdP578SRBC/s2JbmjIo3bsmerM6CliKF24XrIYI/g3YnX5hNMJ9NmW7QTYf4ltGDa7dfM7oD9E2JfT3XnmsCG58gpcKdXJw+MSeqTBcyyXSSLJZo2vLuAFayqXLiMNe5bBObKfQYYoiz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DIjZYvjl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DIjZYvjl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C771F000E9;
	Mon, 17 Aug 2026 14:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975922;
	bh=2YZTdf8CtrdZxVHTef7WudwJ9vnktLhryrxI7ymPVUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DIjZYvjlbcyqCySIiBZWngaoaTAy64XP+YuUhNOQdNz4S1dbsBL99FUYdkavrnCjR
	 kBZmUTurXNMZZjIALjkvQn1ID7bsTl6MLYIEbtludwVXlLWpleD9MIrBoqBMUj58hr
	 v87VZwzDdYpidETexRPi/JNibu7PL6wBeezp8Ev0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.10 155/389] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Mon, 17 Aug 2026 15:29:54 +0200
Message-ID: <20260817132545.231048821@linuxfoundation.org>
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
@@ -842,7 +842,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   bool is_return)
 {


