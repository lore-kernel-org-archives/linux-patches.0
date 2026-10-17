Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C809D28E0F;
	Sat, 17 Oct 2026 16:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792254677; cv=none; b=biSlQZL3xPtbOAapN5Pm2gHA7PsR20+g5gIMabjGUKdJGzua4ft7IO+m+J/77/OmrFuo7ASEmz6l45uleeeMCUya1w3FwP29G20e83PLa8ET/RHtf+B6J2q3pjb4/S8AXqSyPA8M87ty0A425tdMeGvDaGLbc2M2QOFEEjCImus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792254677; c=relaxed/simple;
	bh=S1MnD54ksHrVuuNp8RTUN1VPDOutTUNmH6rdv6yEc0g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UmsosDLMCkiWNuinGVJWK+5x1IlKmq7y1Yk8IgoNETPu/xr7pc76IRgu8Zz4MXHUejsGakYAzfRlrbGlPcC4JPD+aK5ULDwb7xNric+plURMpXI6ckCa2LNnEa9aH38+rK3K5VEFzYTatYCl4i12R1XVTlGzXR/9bvIDRkPl2i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AoBrT+9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AoBrT+9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFE4A1F000C4;
	Sat, 17 Oct 2026 16:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792254676;
	bh=j7S/HIfn5+VPAyCWd3w7H+18j6P3zFMWjoE75CWeZ0s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AoBrT+9P9VAdxd/BrOIy1lM3Uttdq27PPjpas3Z6fhJMGs40zvCYlJcmvtBawKHwp
	 yBAUv8znpeNoQkzh5rg+iVuljG8GDGVUZfWDGFuH7yUJnFJXmLWswT4jttiGZHlD/c
	 zYWsPqfpSbgs79Eb2Wlse9sf+U0/Q+m+ahrM7X6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 526/869] tracing/probes: Remove WARN_ON_ONCE from parse_btf_arg
Date: Sat, 17 Oct 2026 17:56:07 +0200
Message-ID: <20261017160050.599293344@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit 251a8fe1b9aedccd298b77bc28426d564c5a923f ]

Sashiko found that user can cause this WARN_ON_ONCE() easily
with adding a kprobe event based on a raw address with BTF
parameter.

Since this is not an unexpected condition, remove the
WARN_ON_ONCE().

Link: https://lore.kernel.org/all/178177265367.2059927.13789953014706792126.stgit@mhiramat.tok.corp.google.com/

Link: https://sashiko.dev/#/patchset/178165816303.269421.7302603996990753309.stgit%40devnote2

Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: b576e09701c7 ("tracing/probes: Support function parameters if BTF is available")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 9c6ca26ffb927..95201c0daa8f0 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -622,7 +622,7 @@ static int parse_btf_arg(char *varname,
 	int i, is_ptr, ret;
 	u32 tid;
 
-	if (WARN_ON_ONCE(!ctx->funcname))
+	if (!ctx->funcname)
 		return -EINVAL;
 
 	is_ptr = split_next_field(varname, &field, ctx);
-- 
2.53.0



