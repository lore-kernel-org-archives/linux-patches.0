Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5EFE4EC
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=LMz951lH+GTlXBdT5Z97YwiBE8EmQ72In88ZwOJtlek=; b=OflQ0N4/CEo1p1GvnhPn14bpjg
	vmz+hv+Jy3oouD/nIf1Vs6OZVTZLHssU2qrv5wXv26MXvSDxbzSf/ixlaGq9di1FLc3Tt+NaldRzl
	gVkepqTIr+4FuiUK0XdHT/UeYiYo8Xp7YYrDphAe04rmoUut+n/Iv0DkWyLbvTbzbM7EwE2raaTmg
	3dD+DLd3lGYlD8qCF+wZi0zvK7gWAapuOSVbXih5eWvfZ/3xzZwVEzDLXlMO7Z2JZaY6eGW15pOaR
	CN27Hg3mEWxeTKsLrPi17eAX6fCPSZuiDaBT18bXXVPZtUwwUtLkxbZeNKuOONRADTL4BZLYiluq3
	ag/IEb0Q==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamQS-00Gj2v-1v; Fri, 10 Mar 2023 23:45:28 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: hca@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	sudipm.mukherjee@gmail.com
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 2/6] s390: simplify one-level syctl registration for s390dbf_table
Date: Fri, 10 Mar 2023 15:45:21 -0800
Message-Id: <20230310234525.3986352-3-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230310234525.3986352-1-mcgrof@kernel.org>
References: <20230310234525.3986352-1-mcgrof@kernel.org>
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
 arch/s390/kernel/debug.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/s390/kernel/debug.c b/arch/s390/kernel/debug.c
index b376f0377a2c..221c865785c2 100644
--- a/arch/s390/kernel/debug.c
+++ b/arch/s390/kernel/debug.c
@@ -981,16 +981,6 @@ static struct ctl_table s390dbf_table[] = {
 	{ }
 };
 
-static struct ctl_table s390dbf_dir_table[] = {
-	{
-		.procname	= "s390dbf",
-		.maxlen		= 0,
-		.mode		= S_IRUGO | S_IXUGO,
-		.child		= s390dbf_table,
-	},
-	{ }
-};
-
 static struct ctl_table_header *s390dbf_sysctl_header;
 
 /**
@@ -1574,7 +1564,7 @@ static int debug_sprintf_format_fn(debug_info_t *id, struct debug_view *view,
  */
 static int __init debug_init(void)
 {
-	s390dbf_sysctl_header = register_sysctl_table(s390dbf_dir_table);
+	s390dbf_sysctl_header = register_sysctl("s390dbf", s390dbf_table);
 	mutex_lock(&debug_mutex);
 	debug_debugfs_root_entry = debugfs_create_dir(DEBUG_DIR_ROOT, NULL);
 	initialized = 1;
-- 
2.39.1

