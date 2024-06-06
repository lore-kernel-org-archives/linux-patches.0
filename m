Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B946196434;
	Thu,  6 Jun 2024 14:08:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717682896; cv=none; b=uSR9otMXhbByl6l51znfnf/xhgDjH5Nq1j2gzpMa40K+JAtd64ewY3detGG2DUKxkRB/jZAcizA93it5roQ/J266/Qx4SCbIh4DWvK75MLqXV4ga8046rIvjlJIv+EgShmsdAAugopD9kqCDDFObclLgPA5/dpNNRklegmUW8sM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717682896; c=relaxed/simple;
	bh=EFHXELxFA5IGFZSz3j8MECwXArUmFYluL2JJdwgZsPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTR/yKjMSFLbWPLrKFUX9TgVo7icEU/j88YOlVkH8zgYomB8JHgJ2Cyjlm1trFyE1cUEV3kbwnBdaSIX/pBv1PQBdhODlS6qiy/qHxSg89KO2dttiZftolEAB/PU6ndYsl/XrMNekhlGI5OBPIO3gjfXM9Z3LNstoFBBelmswqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hR1ag1Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hR1ag1Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44353C4AF0F;
	Thu,  6 Jun 2024 14:08:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717682896;
	bh=EFHXELxFA5IGFZSz3j8MECwXArUmFYluL2JJdwgZsPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hR1ag1Q+5szpC2zmBpbTBYSrsz6mYbUFBqYswl3omxN5c6nc7aS79r/VLuRGLif2n
	 hlGQt1Q4r3Zhh4Ur3k+JKm5vNeJlLJg8bUGMrNcfH1LTHjiv1P27d1KwWU5q05Y8X+
	 qxqqJXArcfHkwEV0NPtOKmITlZ+hh3DZoDmybdB4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Ian Rogers <irogers@google.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 004/374] perf probe: Add missing libgen.h header needed for using basename()
Date: Thu,  6 Jun 2024 15:59:43 +0200
Message-ID: <20240606131651.857956588@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 581037151910126a7934e369e4b6ac70eda9a703 ]

This prototype is obtained indirectly, by luck, from some other header
in probe-event.c in most systems, but recently exploded on alpine:edge:

   8    13.39 alpine:edge                   : FAIL gcc version 13.2.1 20240309 (Alpine 13.2.1_git20240309)
    util/probe-event.c: In function 'convert_exec_to_group':
    util/probe-event.c:225:16: error: implicit declaration of function 'basename' [-Werror=implicit-function-declaration]
      225 |         ptr1 = basename(exec_copy);
          |                ^~~~~~~~
    util/probe-event.c:225:14: error: assignment to 'char *' from 'int' makes pointer from integer without a cast [-Werror=int-conversion]
      225 |         ptr1 = basename(exec_copy);
          |              ^
    cc1: all warnings being treated as errors
    make[3]: *** [/git/perf-6.8.0/tools/build/Makefile.build:158: util] Error 2

Fix it by adding the libgen.h header where basename() is prototyped.

Fixes: fb7345bbf7fad9bf ("perf probe: Support basic dwarf-based operations on uprobe events")
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/lkml/
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 2a0ad9ecf0a20..5c12459e9765f 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -11,6 +11,7 @@
 #include <sys/stat.h>
 #include <fcntl.h>
 #include <errno.h>
+#include <libgen.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <stdlib.h>
-- 
2.43.0



