Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 227711F937;
	Thu, 13 Jun 2024 12:35:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718282150; cv=none; b=avKERusUv/azJePLk1c50Wpl4gnf+LnKvccBZMM+ktJS8JLtnXgmfj0D5lwWtKD6TOOAqHwZb9+Y7QaMvsb1+MWjw0iM30iM39UxpEC+ZjvIEr5M9mpIitbCVwSlvR5y5Fug43sD31XVIlFyOWhukz14yEPiN0+avqlgqq52kJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718282150; c=relaxed/simple;
	bh=BeUiFD8BKdLQNsKGEUBb/1XSve5BvZrrWY5ODBcT9uI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QypkXZNs1bM8E4AzXqRgRJmvhwW8uKRsSz29aaOz4v4aUGACgAtvQvzubC5xTlH/OW/MxjtmiHDWKp3CVJc8ERlkrYlv2Z39U4VqhDzDVojyvHh1pIi3Ivm0RJkp7SwV9fC2OigUWZQZoA9gZExURJlCZs4fDd0Kmj8TDExw3KY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GqI47u5V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GqI47u5V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DCEDC2BBFC;
	Thu, 13 Jun 2024 12:35:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718282150;
	bh=BeUiFD8BKdLQNsKGEUBb/1XSve5BvZrrWY5ODBcT9uI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GqI47u5VvTfv3J1+dbSM5yHlufvgS9MkKON4KNH8HbTZCaHt8FLhUuoubcZ9L6OUI
	 ZyLzm6XKKHfe4Lebte0InS9KlZyQWktvP5dCGLqVJ/IQv64o3gnbWwzTexYg8RXAIZ
	 6Dc7yrEuIX5e/c4o2ohKDaH4saJKv7tkzemZPdl8=
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
Subject: [PATCH 5.15 178/402] perf probe: Add missing libgen.h header needed for using basename()
Date: Thu, 13 Jun 2024 13:32:15 +0200
Message-ID: <20240613113309.093046045@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113302.116811394@linuxfoundation.org>
References: <20240613113302.116811394@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 68844c48f688a..454a7e2325d87 100644
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



