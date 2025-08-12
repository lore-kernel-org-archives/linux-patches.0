Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566A4217F35;
	Tue, 12 Aug 2025 19:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026167; cv=none; b=AbTUoXYcj3C3nNiQvTpB/fo17aUP5w8kNVYwoXjHwtmWx4a4rPJDziZubRyQkQaj53zkhVeU49W9PKP0m38zBlfKr1CgObc1wu/k4V93NUin4oKvzCbXcIqB/mI110aDrqFCzfhYzX0Y3X/5Wuz2aoDGuTbGL70FWprkxKS9e4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026167; c=relaxed/simple;
	bh=w1/pT64DPhz4pTCfeejnwuV5FihiH56IitXIlfxlBI8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdkY7QQieEHNG5b6CK60xiYrC+VPS+ZdiicHO/rWcqPM8h9OWNSAzLWnCdtS+o16DPO9NamckhFCdm8pk38bOU2/fWc9tOUeQmSBrk/YtmzR57EYJmwsmOnrTCP2GmdAUsfBIg4ME4dK0iuR7BT3cvxLhN+CSpZawsDsPcDwQQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Td7pqPTw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Td7pqPTw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABA8DC4CEF0;
	Tue, 12 Aug 2025 19:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026167;
	bh=w1/pT64DPhz4pTCfeejnwuV5FihiH56IitXIlfxlBI8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Td7pqPTwKwhvzRk7MTYzMTvsCeIbigXBXtMCxqcDM7FCytEuL3+VhGeMjpoDLgg6t
	 pJyqtNXBHpQTRZh9DTDPNd2qxrh0vCbX9QF7bnTKg+Oc1mEZ0A9a00rWK34VNtngs5
	 MuuMZIB0YeXhqyH4dYIhiGL2T5WxBC011DFLroTA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 255/480] perf tools: Fix use-after-free in help_unknown_cmd()
Date: Tue, 12 Aug 2025 19:47:43 +0200
Message-ID: <20250812174407.963809610@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 1fdf938168c4d26fa279d4f204768690d1f9c4ae ]

Currently perf aborts when it finds an invalid command.  I guess it
depends on the environment as I have some custom commands in the path.

  $ perf bad-command
  perf: 'bad-command' is not a perf-command. See 'perf --help'.
  Aborted (core dumped)

It's because the exclude_cmds() in libsubcmd has a use-after-free when
it removes some entries.  After copying one to another entry, it keeps
the pointer in the both position.  And the next copy operation will free
the later one but it's the same entry in the previous one.

For example, let's say cmds = { A, B, C, D, E } and excludes = { B, E }.

  ci  cj  ei   cmds-name  excludes
  -----------+--------------------
   0   0   0 |     A         B       :    cmp < 0, ci == cj
   1   1   0 |     B         B       :    cmp == 0
   2   1   1 |     C         E       :    cmp < 0, ci != cj

At this point, it frees cmds->names[1] and cmds->names[1] is assigned to
cmds->names[2].

   3   2   1 |     D         E       :    cmp < 0, ci != cj

Now it frees cmds->names[2] but it's the same as cmds->names[1].  So
accessing cmds->names[1] will be invalid.

This makes the subcmd tests succeed.

  $ perf test subcmd
   69: libsubcmd help tests                                            :
   69.1: Load subcmd names                                             : Ok
   69.2: Uniquify subcmd names                                         : Ok
   69.3: Exclude duplicate subcmd names                                : Ok

Fixes: 4b96679170c6 ("libsubcmd: Avoid SEGV/use-after-free when commands aren't excluded")
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250701201027.1171561-3-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/subcmd/help.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/lib/subcmd/help.c b/tools/lib/subcmd/help.c
index 8561b0f01a24..9ef569492560 100644
--- a/tools/lib/subcmd/help.c
+++ b/tools/lib/subcmd/help.c
@@ -9,6 +9,7 @@
 #include <sys/stat.h>
 #include <unistd.h>
 #include <dirent.h>
+#include <assert.h>
 #include "subcmd-util.h"
 #include "help.h"
 #include "exec-cmd.h"
@@ -82,10 +83,11 @@ void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 				ci++;
 				cj++;
 			} else {
-				zfree(&cmds->names[cj]);
-				cmds->names[cj++] = cmds->names[ci++];
+				cmds->names[cj++] = cmds->names[ci];
+				cmds->names[ci++] = NULL;
 			}
 		} else if (cmp == 0) {
+			zfree(&cmds->names[ci]);
 			ci++;
 			ei++;
 		} else if (cmp > 0) {
@@ -94,12 +96,12 @@ void exclude_cmds(struct cmdnames *cmds, struct cmdnames *excludes)
 	}
 	if (ci != cj) {
 		while (ci < cmds->cnt) {
-			zfree(&cmds->names[cj]);
-			cmds->names[cj++] = cmds->names[ci++];
+			cmds->names[cj++] = cmds->names[ci];
+			cmds->names[ci++] = NULL;
 		}
 	}
 	for (ci = cj; ci < cmds->cnt; ci++)
-		zfree(&cmds->names[ci]);
+		assert(cmds->names[ci] == NULL);
 	cmds->cnt = cj;
 }
 
-- 
2.39.5



