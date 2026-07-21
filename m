Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C1B5471267;
	Tue, 21 Jul 2026 18:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658014; cv=none; b=Tcbhnh1zSvLcYXEGW9P6jKpjElbw7ckDHq48sbXUeHaM2kY1NMjecf29WUOcvt+R6VKkYAGzyoWix34deiPRyLgJGCiIBb96s6tpsVlxVBxaWALTq634KFPzQWPbq0cFuXyY6J/WS8+9JogyVpuSJtepUtm4N+XOJRbMzTvIU18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658014; c=relaxed/simple;
	bh=saeos3WL6ibHPIYVjT4y26xcxavqSHkMouORvOLP1mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V+ufD/KXMFbM+YtwiG6ygCTXuDiPoU4bHFFP8qL3SXMVlMejSF9brzBFsl3z8eS4Fvfla3ZI7b1PMJBjUmM6D4WrSRyf2cRcL3DThYJMgrCBFsnBsewRkGiXP8v5We2xsZv0I/ALx5GVJOapFDZfSj4P5HU12xLbZmevDewQBJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tfKjjZk8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tfKjjZk8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8331F000E9;
	Tue, 21 Jul 2026 18:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658013;
	bh=DsPcp/w4OjZSOmZolAbAjIgaXzWpl+y8LXIaI4VRsUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tfKjjZk8Fv3wHtKAUB0TtWvZCyQlIg/LxChZ4TCiC5jNMOHkUZvzJM6pKNS4Te/me
	 /h2CVdKNS2mGrF+muthT4qriQ+QSfVxFirEf/tk7aJm2P2PKv+GfgWEJ3qwptItd9I
	 CXATH004PEO5F6Zf5WYtEuGkncdLckBJEO+RpOZU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0984/1611] tracing/probes: Make the $ prefix mandatory for comm access
Date: Tue, 21 Jul 2026 17:18:20 +0200
Message-ID: <20260721152537.525743117@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

[ Upstream commit a369299c3f785cf556bbef2de2db0aa2d294c4c9 ]

Since $comm or $COMM are not event field but special fetcharg
variables to access current->comm, It should not be accessed
without '$' prefix even with typecast.

Link: https://lore.kernel.org/all/178231209724.732967.12049805699091810641.stgit@devnote2/

Fixes: 69efd863a785 ("tracing/eprobes: Allow use of BTF names to dereference pointers")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_probe.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_probe.c b/kernel/trace/trace_probe.c
index 2a080eda8df38f..a7a73eb6f011e6 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -341,10 +341,6 @@ static int parse_trace_event(char *arg, struct fetch_insn *code,
 	ret = parse_trace_event_arg(arg, code, ctx);
 	if (!ret)
 		return 0;
-	if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
-		code->op = FETCH_OP_COMM;
-		return 0;
-	}
 	return -EINVAL;
 }
 
@@ -1073,8 +1069,14 @@ static int parse_probe_vars(char *orig_arg, const struct fetch_type *t,
 	int len;
 
 	if (ctx->flags & TPARG_FL_TEVENT) {
-		if (parse_trace_event(arg, code, ctx) < 0)
+		if (parse_trace_event(arg, code, ctx) < 0) {
+			/* 'comm' should be checked after field parsing. */
+			if (strcmp(arg, "comm") == 0 || strcmp(arg, "COMM") == 0) {
+				code->op = FETCH_OP_COMM;
+				return 0;
+			}
 			goto inval;
+		}
 		return 0;
 	}
 
-- 
2.53.0



