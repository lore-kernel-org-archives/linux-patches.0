Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD9CE4E0
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:12:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=KO2HxTUOZzbjQ3y76wpSpZnZj3+bp1GiNAt8DWUNdxU=; b=k6dL7lF5h50jRNr0sP1WQeyO2+
	eYsLqyIE9wANrimmvLh1SLKSaKAQLXJUk1alQIuj4XBGvJRj9uRieruhcs+U6SV+HR+VvPc1UPSuY
	OCc8YZiS6Kb6vpacPRdCb765jGYyQ6mzFufMLIU/iSRNrAp5CXlIIMcmb0RuF4weYhUKE0HejaRS4
	jhrpz+NLg0h7aljcxQP1MoA91eAVuC2Z15E+ZXUHvRkn9mDApq0e9at52A/DmXtjojSQ7Fenv5WEO
	k+NlhBWmlWjDlx6pKRtetpvCU+1DPxNSA7GfdJg2p1cN+xRBYPPZpZa9blNrjwlGC0KgFPyFFinA6
	UUi2v2Bw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1paluB-00GaJN-BZ; Fri, 10 Mar 2023 23:12:07 +0000
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
Subject: [PATCH 5/5] ntfs: simplfy one-level sysctl registration for ntfs_sysctls
Date: Fri, 10 Mar 2023 15:12:06 -0800
Message-Id: <20230310231206.3952808-6-mcgrof@kernel.org>
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

There is no need to declare an extra tables to just create directory,
this can be easily be done with a prefix path with register_sysctl().

Simplify this registration.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/ntfs/sysctl.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/fs/ntfs/sysctl.c b/fs/ntfs/sysctl.c
index a030d00af90c..174fe536a1c0 100644
--- a/fs/ntfs/sysctl.c
+++ b/fs/ntfs/sysctl.c
@@ -31,16 +31,6 @@ static struct ctl_table ntfs_sysctls[] = {
 	{}
 };
 
-/* Define the parent directory /proc/sys/fs. */
-static struct ctl_table sysctls_root[] = {
-	{
-		.procname	= "fs",
-		.mode		= 0555,
-		.child		= ntfs_sysctls
-	},
-	{}
-};
-
 /* Storage for the sysctls header. */
 static struct ctl_table_header *sysctls_root_table;
 
@@ -54,7 +44,7 @@ int ntfs_sysctl(int add)
 {
 	if (add) {
 		BUG_ON(sysctls_root_table);
-		sysctls_root_table = register_sysctl_table(sysctls_root);
+		sysctls_root_table = register_sysctl("fs", ntfs_sysctls);
 		if (!sysctls_root_table)
 			return -ENOMEM;
 	} else {
-- 
2.39.1

