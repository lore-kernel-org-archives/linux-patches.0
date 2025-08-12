Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F9D9309DD9;
	Tue, 12 Aug 2025 17:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021555; cv=none; b=DwXfRWGp/OKjrsLNlfEopVXnf84HEC48QsYdkJvg8LfsaJUuI2Q/2mkEyPdK2ixlhj0vRb/775Ji5gYt9eXkGDEwZHmAESZL1/SR2IRwSiUi1cwazo0Q9LgAJJsaciyUXs6YTrXl2X6amge/DBBbGQoAa0WSkYHE0RlaksXLrms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021555; c=relaxed/simple;
	bh=bfKGXnutuVSxoaNVZY+pIKDHj6fwbsaoFledfE2BNCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYr7CvLxRr8LGaKV8HQKoeUEtblzwsFpkE0ikqt8k0Z9/lavn9nz//RZtg4f+R+I7qm6WuYdKdGtgIJPD1egTHbqB+Su3jC39nm+0V56Y8crNjInzmgIsTkwV9+6OR5cIphuKFkDcaj3HrOcxy4MyvMBMxkxYz9OvUUO0qrQ2m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0eEdMDt3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0eEdMDt3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A085C2BC9E;
	Tue, 12 Aug 2025 17:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021555;
	bh=bfKGXnutuVSxoaNVZY+pIKDHj6fwbsaoFledfE2BNCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0eEdMDt3NIrgZHfe5RzJGvCFVKOAxb7nZpzw/8kTewVoMKHMIO1y4ut6RrEtHgb88
	 H2b24sYPd3LRyxtwqyV7IAh3K+Gex3D+GPeu5uBF5q7spcWisReBIV2JKbgjaQdSo9
	 g3yRJScyhX/jIZOTHFohrjBJ+huFLduDqtrZNtKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 123/262] perf tools: Fix use-after-free in help_unknown_cmd()
Date: Tue, 12 Aug 2025 19:28:31 +0200
Message-ID: <20250812172958.344696432@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



