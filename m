Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3143ABD9F;
	Mon, 17 Aug 2026 14:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977049; cv=none; b=dhu+Uli4R8kkiZ6ra3pyvLIWgki1Ybd3OyFp++jHtO4rY9bVgVJjwmUVJobzXGQU3fPSu2ewfM/GvfZp5KJwQXNJQc+XkE9nYQSGt+uZlpOVeCz1eyvzDn7zELifemgl8bEUMYbMSHzJXugB7LKT/HotCMv3RNQ6NAYaTQHTWWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977049; c=relaxed/simple;
	bh=Cl9Bztxy5iGPVUVtLqAdEbTHz6X5XGyBVIT+sx3EglE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TTZvufmNxnXZmeXha1n8CGb+s4GCsdQ4B7YCC8lM0z6HGUmmK1oW5O3//FnFJrbfxPbSiqF1sy2D/iOF+c+4LeSJuGFgLka7mqAsHq92S3lh6Dn3A3ZwzJoHZfK7kTVmNbc7Hg2MDG4KNuFPglAV6zK5Y7HMd5wd2wPIbCjNAaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iLcLYtaF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iLcLYtaF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64BA1F000E9;
	Mon, 17 Aug 2026 14:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977048;
	bh=xCrrcj2HlTXNI3Gb+dtOiDea6cxhfgIv2bmtga8v30s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iLcLYtaFMRvdiedoc9C7EUGLD4O5BhpAEva4sK4Z9U+/gK49lcsWtLU71tNLReEO5
	 ibttLfiGkdsvP6LMEV3VAFqlCuUuEMKR5mwfWe8Z7OjrvoLqhLc6Byzu333YdHoKAZ
	 tEnNZqoxlpD205xNRCHhvpiAlVs/V9My7pd4sLJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 5.15 195/456] tracing/probes: Fix potential underflow in LEN_OR_ZERO macro
Date: Mon, 17 Aug 2026 15:29:45 +0200
Message-ID: <20260817132547.742516342@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -896,7 +896,7 @@ int traceprobe_update_arg(struct probe_a
 }
 
 /* When len=0, we just calculate the needed length */
-#define LEN_OR_ZERO (len ? len - pos : 0)
+#define LEN_OR_ZERO (len > pos ? len - pos : 0)
 static int __set_print_fmt(struct trace_probe *tp, char *buf, int len,
 			   enum probe_print_type ptype)
 {


