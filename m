Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FC143B495;
	Mon, 17 Aug 2026 15:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979482; cv=none; b=hu454S5WxSr+R4/sJXrZw7KCO2YLgaiU9zvonCfvlarxgN+t3d36usOPzxQ1gbo3aziInlp4knaOHlfwG+oRwrhojXNHOTjGM1qUKfG3WiWHIYj5TJamKy8frC5qM6J5g0nm/5DYtzlZhiES8HRkPlyktr9s9gxpr/dyjOsA/TA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979482; c=relaxed/simple;
	bh=w+Gu4FxogkPqtdJLI9j5kVHZCBDbbrr0EPZoOij5M9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzNs2XFBSckATCINshAiq6Lph1MJpOhxpDIqODnjowoNi6eKddLX3xhxhHGWmyrxyigNvVRL+adO1wTUK9rhQptk/pq+k36farC3sqDQ4BKUUU0VsN5FHaYb6II2C0FWOefNb421I+VtWz/vYt523hf6urwVDxAmUV7tWrZ2HGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p3JJ6xai; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p3JJ6xai"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4A61F000E9;
	Mon, 17 Aug 2026 15:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786979481;
	bh=Nwxbf+wGt9LKyI+7VfqmrAjom7fO2etCtCEmVUU4Cw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=p3JJ6xaiy73N+eHWykTP5fwK2HFd6JtjobuVw+C9ksiwiU/eMWLPFJyWBnYzM0aPk
	 bDxwMGBKPhjOV9cmIcqa375bmqgI74HmfJ3l4ERK/o48pmCkuvvGXylW73b1dHcH4E
	 BLQI4Q0XbpfcsZl6LidZhQPma4i8LBIMcyEgI5Ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 6.1 242/609] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Mon, 17 Aug 2026 15:28:58 +0200
Message-ID: <20260817132552.175931463@linuxfoundation.org>
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
@@ -900,7 +900,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   enum probe_print_type ptype)
 {


