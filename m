Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C600E2F32
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=BmPt7zwNeFbqQAIaOUhCWsgY6IQL642oNKGF33J3xkI=; b=SXT/D5OFkE2YKFFmqJdPxzQmYX
	2aSY4e1ePRtmHrcRwHXP3b4+mklneKzkiSDIQwshC5V5Tn3acCVrE/8oYwJ9VioMh973Q61sqCJXK
	AcEWZoqJ808wwBUvWdTjxL09MkKLbCHuf3IrPnqz4jbg9vM4se6BrXmD4biWl8i9o3RiN+sAFGIOd
	zcAxwpQqBBw8gpvp3PwirBTIoh3Pmi0zf3rfxjyU8xT/hHsLWvQD0+3P9eQzuT1d+p/l1vy+BuL14
	6qNO1SoB7tut6hRAvGNdn1wRFjad2iZOV/BIr3Mmz61s94Em61CMrgwn7tYOh++vDnpeOoYpLg3h/
	ItGDm4IQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paluB-00GaJJ-92; Fri, 10 Mar 2023 23:12:07 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: dhowells@redhat.com,
	linux-cachefs@redhat.com,
	jack@suse.com,
	jaharkes@cs.cmu.edu,
	coda@cs.cmu.edu,
	codalist@coda.cs.cmu.edu,
	anton@tuxera.com,
	linux-ntfs-dev@lists.sourceforge.net
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 3/5] quota: simplify two-level sysctl registration for fs_dqstats_table
Date: Fri, 10 Mar 2023 15:12:04 -0800
Message-Id: <20230310231206.3952808-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310231206.3952808-1-mcgrof@kernel.org>
References: <20230310231206.3952808-1-mcgrof@kernel.org>
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
 fs/quota/dquot.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
index a6357f728034..90cb70c82012 100644
--- a/fs/quota/dquot.c
+++ b/fs/quota/dquot.c
@@ -2948,24 +2948,6 @@ static struct ctl_table fs_dqstats_table[] = {
 	{ },
 };
 
-static struct ctl_table fs_table[] = {
-	{
-		.procname	= "quota",
-		.mode		= 0555,
-		.child		= fs_dqstats_table,
-	},
-	{ },
-};
-
-static struct ctl_table sys_table[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= fs_table,
-	},
-	{ },
-};
-
 static int __init dquot_init(void)
 {
 	int i, ret;
@@ -2973,7 +2955,7 @@ static int __init dquot_init(void)
 
 	printk(KERN_NOTICE "VFS: Disk quotas %s\n", __DQUOT_VERSION__);
 
-	register_sysctl_table(sys_table);
+	register_sysctl("fs/quota", fs_dqstats_table);
 
 	dquot_cachep = kmem_cache_create("dquot",
 			sizeof(struct dquot), sizeof(unsigned long) * 4,
-- 
2.39.1

