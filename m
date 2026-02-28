Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B249C4A2E14
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300880; cv=none; b=dPkHyhXVpuQVyRc/2RTPZDcHk+8FRjd6QsiRB/RIFQ6YIk1qrBMw0sGM6Ql88vGUi+EkJeE9Bs+oEDkAiNpT5wbt2Yish3TNUqPrjMXEQubrPAWVAMHNMswvUiuBu6gr+vNXAn1bDNhffIlS98F+ICZ+Dc1FEuLQJ1KnbjTplbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300880; c=relaxed/simple;
	bh=RIczDaL9PYQP5+M+OkprKa3ruNJrkZtJ83omwcciUhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ9aqnMIb8SQtsUHLKVANXNDn2y8D/1Orp4akTnf8DH9zp1wLsSoh2Cq+8YCYU4/ApE4lJuwhHcGFavzakl3ThhfrP6D2zgPZJacB/eKMsoQZvMSybSbQnu1TdgkBkOxLQ4ck1F3OEW0pMGm30nOIpdyL9jfzeWIJ2rVneLWC64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LeYj2RNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LeYj2RNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CC5C2BC87;
	Sat, 28 Feb 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300880;
	bh=RIczDaL9PYQP5+M+OkprKa3ruNJrkZtJ83omwcciUhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LeYj2RNkyjEuRq2+bAlCR5flSALqYoeiWvrok7DVgJmC3KV1A4IxqpO+u0R8ptOlS
	 kfO9DYQgaOFCVfem1ih2XqA2f4IDIRkWfZNCwpzjpu0U+EAia67osftcH6ylR10zj1
	 IYK5HZXJz+h6Bpacbnr/p6sy2269eY6/Vf//ZLAuroy0GCQfY6hYv3Cx8PRRQbH83z
	 DeVX5veEH/XvtewoGu9mQ8ZgiGGHXuZ+4DxHZ1INUWoFfh28yiFkj2R6LQK3YXlFjp
	 KOgaQS6fSwjvT08Aqxr5oT/94BBEMog7T5B6mlRjAWbLt+k56/gg9XEAvSVIZWh/5U
	 a5MIlDCzEJscQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sri Jayaramappa <sjayaram@akamai.com>,
	Guilherme Amadio <amadio@gentoo.org>,
	Ian Rogers <irogers@google.com>,
	Joshua Hunt <johunt@akamai.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 006/752] libsubcmd: Fix null intersection case in exclude_cmds()
Date: Sat, 28 Feb 2026 12:35:17 -0500
Message-ID: <20260228174750.1542406-6-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sri Jayaramappa <sjayaram@akamai.com>

[ Upstream commit b6ee9b6e206b288921c14c906eebf4b32fe0c0d8 ]

When there is no exclusion occurring from the cmds list - for example -
cmds contains ["read-vdso32"] and excludes contains ["archive"] - the
main loop completes with ci == cj == 0. In the original code the loop
processing the remaining elements in the list was conditional:

    if (ci != cj) { ...}

So we end up in the assertion loop since ci < cmds->cnt and we
incorrectly try to assert the list elements to be NULL and fail with
the following error

   help.c:104: exclude_cmds: Assertion `cmds->names[ci] == NULL' failed.

Fix this by moving the if (ci != cj) check inside of a broader loop.
If ci != cj, left shift the list elements, as before, and then
unconditionally advance the ci and cj indicies which also covers the
ci == cj case.

Fixes: 1fdf938168c4d26f ("perf tools: Fix use-after-free in help_unknown_cmd()")
Reviewed-by: Guilherme Amadio <amadio@gentoo.org>
Signed-off-by: Sri Jayaramappa <sjayaram@akamai.com>
Tested-by: Guilherme Amadio <amadio@gentoo.org>
Tested-by: Ian Rogers <irogers@google.com>
Cc: Joshua Hunt <johunt@akamai.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20251202213632.2873731-1-sjayaram@akamai.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/help.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/tools/lib/subcmd/help.c b/tools/lib/subcmd/help.c
index ddaeb4eb3e249..db94aa685b73b 100644
--- a/tools/lib/subcmd/help.c
+++ b/tools/lib/subcmd/help.c
@@ -97,11 +97,13 @@ void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 			ei++;
 		}
 	}
-	if (ci != cj) {
-		while (ci < cmds->cnt) {
-			cmds->names[cj++] = cmds->names[ci];
-			cmds->names[ci++] = NULL;
+	while (ci < cmds->cnt) {
+		if (ci != cj) {
+			cmds->names[cj] = cmds->names[ci];
+			cmds->names[ci] = NULL;
 		}
+		ci++;
+		cj++;
 	}
 	for (ci = cj; ci < cmds->cnt; ci++)
 		assert(cmds->names[ci] == NULL);
-- 
2.51.0

