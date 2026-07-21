Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E57A23D1CCA;
	Tue, 21 Jul 2026 17:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653506; cv=none; b=MyymU53wOMIHawqA0n2K4Xza0NKlv5/IzMdmNpbJ7xJASd0X2JZ/x6hACwZyc0+aaejEPS58VWxjftidJyEePys9MJoZJAZk7i9Mr6nxcBk2RFPt1CB1EZsD2Qk5/UfBWjxXd4ZzuLXkuZdNEx4PQsCqSzjkfdDHI9RDsNnGCFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653506; c=relaxed/simple;
	bh=lpzPB9AIv8+ph4NVeyILiAVfc0cMDH02W+mVxgCF8e0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mFebTx800JsYQ9ae/X684nazbuy9ZWutE984fOoGlEyBx7c9A127GRAFr96wFOrwbAEYp6nYnV3Uup6XcEm18KONhjVHZaPCrnC1lQJVWPMdQzd2qZQK18bu7ZBMjoMFK3kgUayvjuxZdEYjLpzyEfuP6/xoPJYk1uZL4YX3YTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mmexjiIE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mmexjiIE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE5B1F000E9;
	Tue, 21 Jul 2026 17:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653504;
	bh=r4qjksQJtGOs5tJXP/N1eRKX1QL9ahNZtah0UvZxxrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mmexjiIEZdMyuwkr2TQGmdUjKuGTKWZYdeWfFORbafEze1L90cXBbC7dsdHnL+TfJ
	 bJkB87WakRyXzwonU47l6UIyyx23JkkM/EAtiy/ce/1dBN+JBrv0Uw/dH5Yqc195m/
	 5DaaxMeLMFWOElKe3jzjrQQ0w9ro/8d/cF+G4Ysc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1353/2077] tracing/probes: Make the $ prefix mandatory for comm access
Date: Tue, 21 Jul 2026 17:17:06 +0200
Message-ID: <20260721152624.731102511@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 0b1277f03dfcb5..3f928ed35180bd 100644
--- a/kernel/trace/trace_probe.c
+++ b/kernel/trace/trace_probe.c
@@ -342,10 +342,6 @@ static int parse_trace_event(char *arg, struct fetch_insn *code,
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



