Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A93D529
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=vfrPqlpwv8UtDJtEckddNe/7V4TGRdI///FWzG6Y790=; b=1CcCUGLBcs0TG5syyZ+Ce28wnZ
	TxulkQAu2Jm0WRJA6sb0GzobJ5R2x0XtLkbJm7zUd+adTEbOuyDoBktLQaR6+NEjbd3hP800Zv4ab
	CP94tMtVo225TVDQQpPfR4eKirU6KAgyGAv7UhKUNv+tsNT8dKsrw7xAeorlwpNtCx/ojqVajYfJ8
	TyL5KCOZWwicnmes7WAvAKy3iK6h57YsUSyGiVJDO7nGE50XaEzfpHPHXTpGghPM2rtIyQHyCvtPl
	lFxB/iKwkZSDU6fgE+Job9uIOTovRK96UQqV0J9jEUh9JHRAQp8aC/33h166ouZa/n2rgQvbbVdx6
	eEuIbxjQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpoc-003HXM-Ao; Thu, 02 Mar 2023 20:46:14 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	jejb@linux.ibm.com,
	martin.petersen@oracle.com,
	minyard@acm.org,
	kys@microsoft.com,
	haiyangz@microsoft.com,
	wei.liu@kernel.org,
	decui@microsoft.com,
	song@kernel.org,
	robinmholt@gmail.com,
	steve.wahl@hpe.com,
	mike.travis@hpe.com,
	arnd@arndb.de,
	gregkh@linuxfoundation.org,
	jirislaby@kernel.org,
	jgross@suse.com,
	sstabellini@kernel.org,
	oleksandr_tyshchenko@epam.com,
	xen-devel@lists.xenproject.org
Cc: j.granados@samsung.com,
	zhangpeng362@huawei.com,
	tangmeng@uniontech.com,
	willy@infradead.org,
	nixiaoming@huawei.com,
	sujiaxun@uniontech.com,
	patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	apparmor@lists.ubuntu.com,
	linux-raid@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	linux-hyperv@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 1/7] scsi: simplify sysctl registration with register_sysctl()
Date: Thu,  2 Mar 2023 12:46:06 -0800
Message-Id: <20230302204612.782387-2-mcgrof@kernel.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20230302204612.782387-1-mcgrof@kernel.org>
References: <20230302204612.782387-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

register_sysctl_table() is a deprecated compatibility wrapper.
register_sysctl() can do the directory creation for you so just use that.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/scsi/scsi_sysctl.c | 16 +---------------
 1 file changed, 1 insertion(+), 15 deletions(-)

diff --git a/drivers/scsi/scsi_sysctl.c b/drivers/scsi/scsi_sysctl.c
index 7259704a7f52..7f0914ea168f 100644
--- a/drivers/scsi/scsi_sysctl.c
+++ b/drivers/scsi/scsi_sysctl.c
@@ -21,25 +21,11 @@ static struct ctl_table scsi_table[] = {
 	{ }
 };
 
-static struct ctl_table scsi_dir_table[] = {
-	{ .procname	= "scsi",
-	  .mode		= 0555,
-	  .child	= scsi_table },
-	{ }
-};
-
-static struct ctl_table scsi_root_table[] = {
-	{ .procname	= "dev",
-	  .mode		= 0555,
-	  .child	= scsi_dir_table },
-	{ }
-};
-
 static struct ctl_table_header *scsi_table_header;
 
 int __init scsi_init_sysctl(void)
 {
-	scsi_table_header = register_sysctl_table(scsi_root_table);
+	scsi_table_header = register_sysctl("dev/scsi", scsi_table);
 	if (!scsi_table_header)
 		return -ENOMEM;
 	return 0;
-- 
2.39.1

