Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAFE5E4EB
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:45:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=6RSbXeOyJXMcC096K906LGWK1pufxQXw88aIMgb//hY=; b=oPkUxijQji7nsAPM9NoPoMym+I
	AR65R3ylE5x03QCPirCr2PlHYS0RXVk6IA586IZCoN+CVwZyxHSPlfGIRAOj/TNyFpl67NiQB0txS
	dNinDi5REGeIrrg5VGBGMjJzr6z9eF1AmBa7IFYBe5tcWeTT1u2eu7mHZsx9QBht1S6dYvGp60Lij
	y5NMIxZAhBUSZlsUAT58b4NtLvGew+LNFw6z8eEPaI+yo1xxDFjfA08xuqBhHueLjj9y4A1VV/AqF
	RktygUAbAEOmsDduIfaJl+JYHG2UDxfI25po7gm08BHdl3sZJ03wZ0inOuzaNEmxwVhVv0zZ8FAix
	EUc9SXIA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pamQS-00Gj35-95; Fri, 10 Mar 2023 23:45:28 +0000
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
Subject: [PATCH 6/6] s390: simplify dynamic sysctl registration for appldata_register_ops
Date: Fri, 10 Mar 2023 15:45:25 -0800
Message-Id: <20230310234525.3986352-7-mcgrof@kernel.org>
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

The routine appldata_register_ops() allocates a sysctl table
with 4 entries. The firsts one,   ops->ctl_table[0] is the parent directory
with an empty entry following it, ops->ctl_table[1]. The next entry is
for the the ops->name and that is ops->ctl_table[2]. It needs an empty
entry following that, and that is ops->ctl_table[3]. And so hence the
kcalloc(4, sizeof(struct ctl_table), GFP_KERNEL).

We can simplify this considerably since sysctl_register("foo", table)
can create the parent directory for us if it does not exist. So we
can just remove the first two entries and move back the ops->name to
the first entry, and just use kcalloc(2, ...).

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 arch/s390/appldata/appldata_base.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/arch/s390/appldata/appldata_base.c b/arch/s390/appldata/appldata_base.c
index c593f2228083..a60c1e093039 100644
--- a/arch/s390/appldata/appldata_base.c
+++ b/arch/s390/appldata/appldata_base.c
@@ -351,7 +351,8 @@ int appldata_register_ops(struct appldata_ops *ops)
 	if (ops->size > APPLDATA_MAX_REC_SIZE)
 		return -EINVAL;
 
-	ops->ctl_table = kcalloc(4, sizeof(struct ctl_table), GFP_KERNEL);
+	/* The last entry must be an empty one */
+	ops->ctl_table = kcalloc(2, sizeof(struct ctl_table), GFP_KERNEL);
 	if (!ops->ctl_table)
 		return -ENOMEM;
 
@@ -359,17 +360,12 @@ int appldata_register_ops(struct appldata_ops *ops)
 	list_add(&ops->list, &appldata_ops_list);
 	mutex_unlock(&appldata_ops_mutex);
 
-	ops->ctl_table[0].procname = appldata_proc_name;
-	ops->ctl_table[0].maxlen   = 0;
-	ops->ctl_table[0].mode     = S_IRUGO | S_IXUGO;
-	ops->ctl_table[0].child    = &ops->ctl_table[2];
+	ops->ctl_table[0].procname = ops->name;
+	ops->ctl_table[0].mode     = S_IRUGO | S_IWUSR;
+	ops->ctl_table[0].proc_handler = appldata_generic_handler;
+	ops->ctl_table[0].data = ops;
 
-	ops->ctl_table[2].procname = ops->name;
-	ops->ctl_table[2].mode     = S_IRUGO | S_IWUSR;
-	ops->ctl_table[2].proc_handler = appldata_generic_handler;
-	ops->ctl_table[2].data = ops;
-
-	ops->sysctl_header = register_sysctl_table(ops->ctl_table);
+	ops->sysctl_header = register_sysctl(appldata_proc_name, ops->ctl_table);
 	if (!ops->sysctl_header)
 		goto out;
 	return 0;
-- 
2.39.1

