Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A66331164
	for <patches@lists.linux.dev>; Tue, 15 Feb 2022 02:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=VxT5+TzYaXUngLzkpp0wLjeCZ8njF59V4ZINZ5d0e68=; b=MRXjtI+ud5DO2jHBLU2o4TVrmM
	xeh3JrdrH+eHLul/Hj0BKEIegmmrDwhaCEYsBDJftrFKM6jlfp/QcEOJQBnpd2j7KGc0RSCh200w3
	f3IGkPMW2bdv+kBnapbBx4G3k2u1VARqtVgh8BkypDfzl1M06krk4fd0EY70EvL5DshW2hM2s5Oai
	FZy1YGOQ/b6JBL1I8O6vd7PD9QVJoswDcnmvKUFWbmaOOCIIZYYRZkc0gUxXV/GsEA3cu3pWT9WWq
	02oXXNMqIfpMz7D6Fhm86sg7TjwnEc4pPv+qeS7+5iqhzU/GUqX6HSqh/kRBFk/G3q+vtuNLBoipX
	sM2OoKPA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nJnGX-00HXek-Qc; Tue, 15 Feb 2022 02:08:29 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	keescook@chromium.org,
	yzaikin@google.com,
	nixiaoming@huawei.com,
	ebiederm@xmission.com
Cc: sfr@canb.auug.org.au,
	linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Tong Zhang <ztong0001@gmail.com>
Subject: [PATCH] fs/file_table: fix adding missing kmemleak_not_leak()
Date: Mon, 14 Feb 2022 18:08:28 -0800
Message-Id: <20220215020828.4180911-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.31.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Commit b42bc9a3c511 ("Fix regression due to
"fs: move binfmt_misc sysctl to its own file") fixed
a regression, however it failed to add a kmemleak_not_leak().

Fixes: b42bc9a3c511 ("Fix regression due to "fs: move binfmt_misc sysctl to its own file")
Reported-by: Tong Zhang <ztong0001@gmail.com>
Cc: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

The fix for the regression was applied before we could
say Satoshi Nakamoto, and so it failed to carry the
little tidbit of using kmemleak_not_leak() to avoid the
false positive splat. Fix this.

 fs/file_table.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 4969021fa676..7d2e692b66a9 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -27,6 +27,7 @@
 #include <linux/task_work.h>
 #include <linux/ima.h>
 #include <linux/swap.h>
+#include <linux/kmemleak.h>
 
 #include <linux/atomic.h>
 
@@ -119,8 +120,11 @@ static struct ctl_table fs_stat_sysctls[] = {
 static int __init init_fs_stat_sysctls(void)
 {
 	register_sysctl_init("fs", fs_stat_sysctls);
-	if (IS_ENABLED(CONFIG_BINFMT_MISC))
-		register_sysctl_mount_point("fs/binfmt_misc");
+	if (IS_ENABLED(CONFIG_BINFMT_MISC)) {
+		struct ctl_table_header *hdr;
+		hdr = register_sysctl_mount_point("fs/binfmt_misc");
+		kmemleak_not_leak(hdr);
+	}
 	return 0;
 }
 fs_initcall(init_fs_stat_sysctls);
-- 
2.34.1

