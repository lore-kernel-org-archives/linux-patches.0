Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208E7E4DF
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=PETkYU+yLAOC06k0Jk3717NirimTBUEacXQYVPLCx+k=; b=VuJ8QGzTljjnxQAGTBwmlAEbe4
	bxAsS6bspO0fL4OaZie/KXBnbWapTbnJXc6LV/+7yTRzHhmUKQovBJZsp+VYqSV/PayedCRTgfzwf
	WjDC1d0tO1XIm1nlU0ENvlWetX6rGWXRfQHvAOT4Rn0ssnfQvK7V8nO5klGVRAXpwYtvSECLLkhai
	ipA2YmL0x0DIUrgga0kgVI8DwfyjYJxHX2k8ZMF3VU/7H28uw9+80U98Rpt5r8snEIoVto6oo2xKc
	AniA2x7rixepUZv2B6NdYhcZtkZ7ZRYKVI9eJs0JI776K30jtZz7gaLnp63QBJ2VAruHaQDKA+fyC
	GRvYYNhA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1palhD-00GYlX-6T; Fri, 10 Mar 2023 22:58:43 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: chuck.lever@oracle.com,
	jlayton@kernel.org,
	trond.myklebust@hammerspace.com,
	anna@kernel.org,
	linux-nfs@vger.kernel.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 3/3] nfs: simplify two-level sysctl registration for nfs_cb_sysctls
Date: Fri, 10 Mar 2023 14:58:42 -0800
Message-Id: <20230310225842.3946871-4-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310225842.3946871-1-mcgrof@kernel.org>
References: <20230310225842.3946871-1-mcgrof@kernel.org>
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
 fs/nfs/sysctl.c | 20 +-------------------
 1 file changed, 1 insertion(+), 19 deletions(-)

diff --git a/fs/nfs/sysctl.c b/fs/nfs/sysctl.c
index 7aea195ddb35..f39e2089bc4c 100644
--- a/fs/nfs/sysctl.c
+++ b/fs/nfs/sysctl.c
@@ -32,27 +32,9 @@ static struct ctl_table nfs_cb_sysctls[] = {
 	{ }
 };
 
-static struct ctl_table nfs_cb_sysctl_dir[] = {
-	{
-		.procname = "nfs",
-		.mode = 0555,
-		.child = nfs_cb_sysctls,
-	},
-	{ }
-};
-
-static struct ctl_table nfs_cb_sysctl_root[] = {
-	{
-		.procname = "fs",
-		.mode = 0555,
-		.child = nfs_cb_sysctl_dir,
-	},
-	{ }
-};
-
 int nfs_register_sysctl(void)
 {
-	nfs_callback_sysctl_table = register_sysctl_table(nfs_cb_sysctl_root);
+	nfs_callback_sysctl_table = register_sysctl("fs/nfs", nfs_cb_sysctls);
 	if (nfs_callback_sysctl_table == NULL)
 		return -ENOMEM;
 	return 0;
-- 
2.39.1

