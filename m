Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9476A6FC9
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:46:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2948C433C7;
	Sun, 17 Sep 2023 19:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694980011;
	bh=XDFDxLm7EzVJ9QXdjFO+R2i3u5qiTT3+MZw3Z2Ayxos=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YEqG83jsN2wS6qSGF5YO0kifzYxjnD9iKuQzY3h/L6GYojRPSs7zyO8XnHY6+52cZ
	 nl32RiObn4WpgOC/u5fuhWeelUXDTYhjMlqdbcCmFwf18tkMEiKlofHMg+U7bP/FE4
	 UeP6nHdjKGmuIt/hUnoQVnpgNt2ZYUyCH8ROAieA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xie XiuQi <xiexiuqi@huawei.com>,
	Ian Rogers <irogers@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 064/285] tools/mm: fix undefined reference to pthread_once
Date: Sun, 17 Sep 2023 21:11:04 +0200
Message-ID: <20230917191053.923872590@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
References: <20230917191051.639202302@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xie XiuQi <xiexiuqi@huawei.com>

[ Upstream commit 7f33105cdd59a99d068d3d147723a865d10e2260 ]

Commit 97d5f2e9ee12 ("tools api fs: More thread safety for global
filesystem variables") introduces pthread_once, so the libpthread
should be added at link time, or we'll meet the following compile
error when 'make -C tools/mm':

  gcc -Wall -Wextra -I../lib/ -o page-types page-types.c ../lib/api/libapi.a
  ~/linux/tools/lib/api/fs/fs.c:146: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:147: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:148: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:149: undefined reference to `pthread_once'
  ~/linux/tools/lib/api/fs/fs.c:150: undefined reference to `pthread_once'
  /usr/bin/ld: ../lib/api/libapi.a(libapi-in.o):~/linux/tools/lib/api/fs/fs.c:151:
  more undefined references to `pthread_once' follow
  collect2: error: ld returned 1 exit status
  make: *** [Makefile:22: page-types] Error 1

Link: https://lkml.kernel.org/r/20230831034205.2376653-1-xiexiuqi@huaweicloud.com
Fixes: 97d5f2e9ee12 ("tools api fs: More thread safety for global filesystem variables")
Signed-off-by: Xie XiuQi <xiexiuqi@huawei.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Matthew Wilcox <willy@infradead.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/mm/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/mm/Makefile b/tools/mm/Makefile
index 6c1da51f4177c..1c5606cc33346 100644
--- a/tools/mm/Makefile
+++ b/tools/mm/Makefile
@@ -8,8 +8,8 @@ TARGETS=page-types slabinfo page_owner_sort
 LIB_DIR = ../lib/api
 LIBS = $(LIB_DIR)/libapi.a
 
-CFLAGS += -Wall -Wextra -I../lib/
-LDFLAGS += $(LIBS)
+CFLAGS += -Wall -Wextra -I../lib/ -pthread
+LDFLAGS += $(LIBS) -pthread
 
 all: $(TARGETS)
 
-- 
2.40.1



