Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 955EEE4E9
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=N5vx1FBpbc8LlYLlnu7qtqpLSHJPRrla5oNVHVuiKnI=; b=IK/npqdfvhyNAJvSI8r427YlNX
	RSVirLCMWv4Rr8iJyWSYktDBdNXsX1ZR+c6rhA0TmzDEkh3Vcrp/uF0UQJ+utUs5tPGi+F4VP4/rU
	tSdo7bRWz1clO+u+ufJTqZ2YzDinsFuuvFpcigeJ/rU6oLLooGaUqIWgOrdA9XPMxcLBFzUL273aU
	iyqelPcFo9CDdxyxD/7ANzhY92cyIPXjB9mTxx4+ZDErTgZq8xgYjWNpZaI12xLAImgh9S3imGmzk
	0mHwKUcM2B/suuA5MX+v2xKZ6AsD0nHJx/RB10Ka3C+9yGPPsrFJDtJWv7ZI12vaqmPNlCLlUgMzm
	12IlGySA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamQS-00Gj31-5G; Fri, 10 Mar 2023 23:45:28 +0000
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
Subject: [PATCH 4/6] s390: simplify one level sysctl registration for cmm_table
Date: Fri, 10 Mar 2023 15:45:23 -0800
Message-Id: <20230310234525.3986352-5-mcgrof@kernel.org>
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
 arch/s390/mm/cmm.c | 12 +-----------
 1 file changed, 1 insertion(+), 11 deletions(-)

diff --git a/arch/s390/mm/cmm.c b/arch/s390/mm/cmm.c
index 9141ed4c52e9..5300c6867d5e 100644
--- a/arch/s390/mm/cmm.c
+++ b/arch/s390/mm/cmm.c
@@ -335,16 +335,6 @@ static struct ctl_table cmm_table[] = {
 	{ }
 };
 
-static struct ctl_table cmm_dir_table[] = {
-	{
-		.procname	= "vm",
-		.maxlen		= 0,
-		.mode		= 0555,
-		.child		= cmm_table,
-	},
-	{ }
-};
-
 #ifdef CONFIG_CMM_IUCV
 #define SMSG_PREFIX "CMM"
 static void cmm_smsg_target(const char *from, char *msg)
@@ -389,7 +379,7 @@ static int __init cmm_init(void)
 {
 	int rc = -ENOMEM;
 
-	cmm_sysctl_header = register_sysctl_table(cmm_dir_table);
+	cmm_sysctl_header = register_sysctl("vm", cmm_table);
 	if (!cmm_sysctl_header)
 		goto out_sysctl;
 #ifdef CONFIG_CMM_IUCV
-- 
2.39.1

