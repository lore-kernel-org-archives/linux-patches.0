Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17BA8838
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 22:58:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IhZZbKD1WKnq6M386c99sK7smpr0/fPnG05q4GVFpm8=; b=bLVTVRbRNqMlWICtQ+JBfb3zge
	UyUY7WJRD6BRaa4ns/utecRHd7Ssm/+VA/CVmAqtN+k2ndIx8YaDV/M73Vj64SWE3i1TU2CkEsarK
	woVn9zjciNL1TN8NAkaoRmTzxhC/vOYmAKEYswupLSFNksk1iJZX05MN8cB2IpSQuB0AYlL5Q6QYY
	epch0/yi6YgA1wS7M/+bYD8ZHpgNXFl3LaqvLiA6HgCzI9PlEhnlg8To/YDdpJGN8GHqInLGwyJ3P
	CL2HpL07q0ZKFxbaQe1LxATGZU96atFeBweJa7pPRVPcrQ2T90Xw5mV7FXPn2gOBBcivsof3kzdTL
	T28og8Sw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1palhD-00GYlV-5F; Fri, 10 Mar 2023 22:58:43 +0000
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
Subject: [PATCH 2/3] nfs: simplify two-level sysctl registration for nfs4_cb_sysctls
Date: Fri, 10 Mar 2023 14:58:41 -0800
Message-Id: <20230310225842.3946871-3-mcgrof@kernel.org>
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
 fs/nfs/nfs4sysctl.c | 21 ++-------------------
 1 file changed, 2 insertions(+), 19 deletions(-)

diff --git a/fs/nfs/nfs4sysctl.c b/fs/nfs/nfs4sysctl.c
index c394e4447100..e776200e9a11 100644
--- a/fs/nfs/nfs4sysctl.c
+++ b/fs/nfs/nfs4sysctl.c
@@ -37,27 +37,10 @@ static struct ctl_table nfs4_cb_sysctls[] = {
 	{ }
 };
 
-static struct ctl_table nfs4_cb_sysctl_dir[] = {
-	{
-		.procname = "nfs",
-		.mode = 0555,
-		.child = nfs4_cb_sysctls,
-	},
-	{ }
-};
-
-static struct ctl_table nfs4_cb_sysctl_root[] = {
-	{
-		.procname = "fs",
-		.mode = 0555,
-		.child = nfs4_cb_sysctl_dir,
-	},
-	{ }
-};
-
 int nfs4_register_sysctl(void)
 {
-	nfs4_callback_sysctl_table = register_sysctl_table(nfs4_cb_sysctl_root);
+	nfs4_callback_sysctl_table = register_sysctl("fs/nfs",
+						     nfs4_cb_sysctls);
 	if (nfs4_callback_sysctl_table == NULL)
 		return -ENOMEM;
 	return 0;
-- 
2.39.1

