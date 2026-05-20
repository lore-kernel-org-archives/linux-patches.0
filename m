Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4F829D26E;
	Wed, 20 May 2026 17:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298552; cv=none; b=YagD+uIk2YPo7wSk9tPvbLYZU+crFEUdGoZcjh9KTl5V8YwQujG9LnF8223a+Q6B7R118sudKN07Ry51Pt4wwOe9Ri5JIU8WE3y23qn1rivi9BdSAYYe/SD+OM6tTgfU0IEWeH3h/wPQsEQaeXwOgKflLB+X8JCnbEd9JgGYxks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298552; c=relaxed/simple;
	bh=wiDSfII5W+JzbM1vQw1IMtbe0tB5WhVh2oPMPgLL/Pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GKigwO6t4QvrXf+Hk6RLtONxAXfpnLPFJLXt6cNvCcG/nvNxa6h9mbgGi6wbBZ8lwIa+fJY5jrLOTntmp2JGGgsZZ4Z0rXFKe/SqCh8qGGZBPVxDTeZXJVHH7HG2D/o6nmN+8yYpyWn5SpYict6tolmKlt/otF0B1eM3RTmB3eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N8G38Ic3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N8G38Ic3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C4BF1F000E9;
	Wed, 20 May 2026 17:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298549;
	bh=sJzSBO7fXUCkRRmPYGIETvHzIqEifgtpLLml7kKp8Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=N8G38Ic3V20FMWRxkYcAFg0QiU1pSmmjeo9vJInOFzn/IhZXgkjaNpqOnBOPr2IKd
	 jSRdtjwDjTu+nGBSlnF8w2UYCLafyWuTHDFOTo8zJITeiJZ9ZSLVNq7wt7QJZRHdSG
	 9/qbteuH0zIhl+7KOylAfgMYLoBtMdR29EFc42Pc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Zanussi <zanussi@kernel.org>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 454/957] tracing: Rebuild full_name on each hist_field_name() call
Date: Wed, 20 May 2026 18:15:37 +0200
Message-ID: <20260520162144.367988606@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 5ec1d1e97de134beed3a5b08235a60fc1c51af96 ]

hist_field_name() uses a static MAX_FILTER_STR_VAL buffer for fully
qualified variable-reference names, but it currently appends into that
buffer with strcat() without rebuilding it first. As a result, repeated
calls append a new "system.event.field" name onto the previous one,
which can eventually run past the end of full_name.

Build the name with snprintf() on each call and return NULL if the fully
qualified name does not fit in MAX_FILTER_STR_VAL.

Link: https://patch.msgid.link/20260401112224.85582-1-pengpeng@iscas.ac.cn
Fixes: 067fe038e70f ("tracing: Add variable reference handling to hist triggers")
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Tested-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 2a0726e1bc97f..cb9e067138683 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -1355,12 +1355,14 @@ static const char *hist_field_name(struct hist_field *field,
 		 field->flags & HIST_FIELD_FL_VAR_REF) {
 		if (field->system) {
 			static char full_name[MAX_FILTER_STR_VAL];
+			int len;
+
+			len = snprintf(full_name, sizeof(full_name), "%s.%s.%s",
+				       field->system, field->event_name,
+				       field->name);
+			if (len >= sizeof(full_name))
+				return NULL;
 
-			strcat(full_name, field->system);
-			strcat(full_name, ".");
-			strcat(full_name, field->event_name);
-			strcat(full_name, ".");
-			strcat(full_name, field->name);
 			field_name = full_name;
 		} else
 			field_name = field->name;
-- 
2.53.0



