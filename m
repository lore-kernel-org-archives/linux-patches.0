Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26121DA81
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=eet2vNHP9SJyRytQAXeN8dV9MlcbH4NW2iBs2IrmZDA=; b=D0P+yBFRbDD6Jw9Y3fJhnTPsrq
	l88RCpE421CMXqcRp/zu8zhyDXD+kJD0SPKKMr5xdj+r+PBL4rWOKzpmL4ADiku7It8+dicSWA+bw
	5nSv3/FhwMiiZ8Qs3BCO6P8jWlSmByf6ebJTBPwM8+cdpQH34xs5/HsfavYDfFD5FCTCdYMvpHvb9
	ouAorx54GfC33pUF+eihyGd+4yFtUGNGOEJQMv6wZ44zglX7yyWeEPuJsBiZHS2ax8cVE0U6BJ5pf
	LZXiMI6IuRVZdUi5aHTL0FzKAnkhTIRa0NDDo0ybW8KUsYg13a1d12EQ91jREbJATq+Z2UUTZ7Tv9
	9M0tob/w==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1palkh-00GZGm-Vp; Fri, 10 Mar 2023 23:02:20 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: djwong@kernel.org
Cc: linux-xfs@vger.kernel.org,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH] xfs: simplify two-level sysctl registration for xfs_table
Date: Fri, 10 Mar 2023 15:02:19 -0800
Message-Id: <20230310230219.3948819-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

There is no need to declare two tables to just create directories,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

This is not clear to some so I've updated the docs for the sysctl
registration here:

https://lore.kernel.org/all/20230310223947.3917711-1-mcgrof@kernel.org/T/#u     

 fs/xfs/xfs_sysctl.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/xfs/xfs_sysctl.c b/fs/xfs/xfs_sysctl.c
index 546a6cd96729..fade33735393 100644
--- a/fs/xfs/xfs_sysctl.c
+++ b/fs/xfs/xfs_sysctl.c
@@ -210,28 +210,10 @@ static struct ctl_table xfs_table[] = {
 	{}
 };
 
-static struct ctl_table xfs_dir_table[] = {
-	{
-		.procname	= "xfs",
-		.mode		= 0555,
-		.child		= xfs_table
-	},
-	{}
-};
-
-static struct ctl_table xfs_root_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= xfs_dir_table
-	},
-	{}
-};
-
 int
 xfs_sysctl_register(void)
 {
-	xfs_table_header = register_sysctl_table(xfs_root_table);
+	xfs_table_header = register_sysctl("fs/xfs", xfs_table);
 	if (!xfs_table_header)
 		return -ENOMEM;
 	return 0;
-- 
2.39.1

