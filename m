Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53D7C1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VGJIUwgG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C721DC433C8;
	Wed,  4 Oct 2023 18:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443628;
	bh=0VYi4uXk1YJ9Cn+ouYKkprl+D/3t4NUsaWj/O/yCdC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VGJIUwgG6ZWy52WkrzQ9tcRE8gd6nt9kudJM+1WP76oQHqawbKhIvcWoCXGL0fuAK
	 48laLrA6/2MdFg5sdHw40VyAViiGTn6AHlBPSrctdvaOF3YdGqfv/haDrBF5b0UrIX
	 /+AwPkunVTi1mx1oSWevhpTGz/xP3OBPSNWDvpo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: =?UTF-8?q?=5BPATCH=206=2E1=20185/259=5D=20=3D=3FUTF-8=3Fq=3Fmemblock=3D20tests=3A=3D20fix=3D20warning=3D20=3DE2=3D80=3D98struct=3D20s=3F=3D=20=3D=3FUTF-8=3Fq=3Feq=3D5Ffile=3DE2=3D80=3D99=3D20declared=3D20inside=3D20parameter=3D20list=3F=3D?=
Date: Wed,  4 Oct 2023 19:55:58 +0200
Message-ID: <20231004175225.790417253@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mike Rapoport (IBM) <rppt@kernel.org>

[ Upstream commit 55122e0130e51eb71f5ec62d10525db0468f28e8 ]

Building memblock tests produces the following warning:

cc -I. -I../../include -Wall -O2 -fsanitize=address -fsanitize=undefined -D CONFIG_PHYS_ADDR_T_64BIT   -c -o main.o main.c
In file included from tests/common.h:9,
                 from tests/basic_api.h:5,
                 from main.c:2:
./linux/memblock.h:601:50: warning: ‘struct seq_file’ declared inside parameter list will not be visible outside of this definition or declaration
  601 | static inline void memtest_report_meminfo(struct seq_file *m) { }
      |                                                  ^~~~~~~~

Add declaration of 'struct seq_file' to tools/include/linux/seq_file.h
to fix it.

Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/linux/seq_file.h           | 2 ++
 tools/testing/memblock/tests/basic_api.c | 2 +-
 tools/testing/memblock/tests/common.h    | 1 +
 3 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/include/linux/seq_file.h b/tools/include/linux/seq_file.h
index 102fd9217f1f9..f6bc226af0c1d 100644
--- a/tools/include/linux/seq_file.h
+++ b/tools/include/linux/seq_file.h
@@ -1,4 +1,6 @@
 #ifndef _TOOLS_INCLUDE_LINUX_SEQ_FILE_H
 #define _TOOLS_INCLUDE_LINUX_SEQ_FILE_H
 
+struct seq_file;
+
 #endif /* _TOOLS_INCLUDE_LINUX_SEQ_FILE_H */
diff --git a/tools/testing/memblock/tests/basic_api.c b/tools/testing/memblock/tests/basic_api.c
index a13a57ba0815f..7ce628e31a431 100644
--- a/tools/testing/memblock/tests/basic_api.c
+++ b/tools/testing/memblock/tests/basic_api.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0-or-later
+#include "basic_api.h"
 #include <string.h>
 #include <linux/memblock.h>
-#include "basic_api.h"
 
 #define EXPECTED_MEMBLOCK_REGIONS			128
 #define FUNC_ADD					"memblock_add"
diff --git a/tools/testing/memblock/tests/common.h b/tools/testing/memblock/tests/common.h
index d6bbbe63bfc36..4c33ce04c0645 100644
--- a/tools/testing/memblock/tests/common.h
+++ b/tools/testing/memblock/tests/common.h
@@ -5,6 +5,7 @@
 #include <stdlib.h>
 #include <assert.h>
 #include <linux/types.h>
+#include <linux/seq_file.h>
 #include <linux/memblock.h>
 #include <linux/sizes.h>
 #include <linux/printk.h>
-- 
2.40.1



