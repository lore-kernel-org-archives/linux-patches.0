Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C59E1B87F2;
	Tue, 12 Aug 2025 18:15:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755022531; cv=none; b=duVemRJTg60ya2cfIaUX/cwqMCN+hbP7To7ii+cAkc8Umhr8IVW0SZGfees1QeaBkevteAXt7I5tVFFMAR1cxsTP/MOL+jHHesfAw0m/StC+EqV3YyG1QCVKA6yOy2ETCzCteh8VhVmTYXklatm8VaMr5zHAj2OGhAepKSevOeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755022531; c=relaxed/simple;
	bh=Kg0mht5U3BlexbwnAAH5rZuu2i2rD+bZCY7hzEM3AK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RnZF8E2q5FJMxmoWl7qYZxs9M/rrePtbvzHYkRBBC4vCdj3Pk+oQhho/XBort6RrxAFYzbeN3HEKIpl1Smah9YMIzwgbNxnVum6ZNojUiPk447kCtxB1dfE49dzR8PC6JyIe+vkWYX+yt+oJRQnRZMhdtN4v0NPMSlNBrjkluus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=znIBLB0b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="znIBLB0b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FD47C4CEF0;
	Tue, 12 Aug 2025 18:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755022531;
	bh=Kg0mht5U3BlexbwnAAH5rZuu2i2rD+bZCY7hzEM3AK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=znIBLB0b0RU2oFtEcnq0ndNLxG+Cwz4oLnI1e37xXE3rby4r0fb/LnZCy9wj+1NIr
	 eEAg71t6ReaQnXjErYyDnUiZ6taJZJeyq0nG94e+xkURcMMJ7E0ziatnZDkCdYpIQ+
	 ZoHeMVxMBnfmIPdGq1jHwZb5OkloHggCnskKX2o8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 175/369] perf tools: Fix use-after-free in help_unknown_cmd()
Date: Tue, 12 Aug 2025 19:27:52 +0200
Message-ID: <20250812173021.360725004@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
References: <20250812173014.736537091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



