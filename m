Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98472E4EA
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=H5HqYRjESHY8xUnMrM+cMVopzwc1JUtrK5M1N6TB7H4=; b=Rb2ENORkOAXfh2XoBReOuS75Tk
	QqougMDviCgYgMy+K8gXsHJzMfAjPBP7p9aqASPSUV7bZqiRvrmjXrA3FnPk+e+c/xr4wFRIsB/bA
	j8j7O3tzwutLtXlFCED7jR5LAMiWEo8vD7BzCH7CYvQPjMZVWEynP7TtwIcvWh7IJZTAXigSDdTeJ
	FvX6Xca2XQ/MZEOdQ2HIofICvCWJrvY5GC8ECdH52BnqXyBtjnb3Or+a5MacnTO0NUwHoXKgq2Zaq
	SzHxI9n1Rt3jYzr+Gw6pebhK9sTPr/hf15Xhl3Dw/YbihBpStQ9m29aDqpAc1mu2MeU8jE+qzB8vR
	5scFTiOg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamQS-00Gj2z-3K; Fri, 10 Mar 2023 23:45:28 +0000
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
Subject: [PATCH 3/6] s390: simplify one-level sysctl registration for appldata_table
Date: Fri, 10 Mar 2023 15:45:22 -0800
Message-Id: <20230310234525.3986352-4-mcgrof@kernel.org>
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
 arch/s390/appldata/appldata_base.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index c0fd29133f27..c593f2228083 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -66,16 +66,6 @@ static struct ctl_table appldata_table[] = {
 	{ },
 };
 
-static struct ctl_table appldata_dir_table[] = {
-	{
-		.procname	= appldata_proc_name,
-		.maxlen		= 0,
-		.mode		= S_IRUGO | S_IXUGO,
-		.child		= appldata_table,
-	},
-	{ },
-};
-
 /*
  * Timer
  */
@@ -422,7 +412,7 @@ static int __init appldata_init(void)
 	appldata_wq = alloc_ordered_workqueue("appldata", 0);
 	if (!appldata_wq)
 		return -ENOMEM;
-	appldata_sysctl_header = register_sysctl_table(appldata_dir_table);
+	appldata_sysctl_header = register_sysctl(appldata_proc_name, appldata_table);
 	return 0;
 }
 
-- 
2.39.1

