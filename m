Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596A3D52D
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 20:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
	Reply-To:Content-Type:Content-ID:Content-Description;
	bh=TtTbUH5PQh3QevctuMber+EjZGKoMVpZ7Bm0T6SOQ6g=; b=houTJrT5MUluykuM7s1Uc148K3
	GhLI9ASwlgAnteOvFMS4cTsCdKtG82GtTT4Zcr9HncBDiN2PA/JjUo9peW7g1cx2BhR4//0t/yscv
	5IpFo0vcRylXz5s7cE4j0GUn5BKxF1V3uGlaVF0kLGgZuReSbCP/VPJVjuNYboAkpG/PiDxNyDUra
	cVS+I7dVkXOuXr7xnABfgxQLYK8/WfVd3pUiuNrtYXMwDKui183PRS9ebugKbOpGbY3Y5TBFq3kbQ
	ndzN/NkOUhn281UgUQr5UWaEuzp2/EgEHwN9hb5K87XzVbBxcVXtt+E3QheP8aaBbeZpR/TXb+Prl
	oswf6iaA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1pXpoc-003HXQ-HE; Thu, 02 Mar 2023 20:46:14 +0000
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
Subject: [PATCH 3/7] hv: simplify sysctl registration
Date: Thu,  2 Mar 2023 12:46:08 -0800
Message-Id: <20230302204612.782387-4-mcgrof@kernel.org>
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
register_sysctl() can do the directory creation for you so just use
that.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 drivers/hv/vmbus_drv.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index d24dd65b33d4..229353f1e9c2 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1460,15 +1460,6 @@ static struct ctl_table hv_ctl_table[] = {
 	{}
 };
 
-static struct ctl_table hv_root_table[] = {
-	{
-		.procname	= "kernel",
-		.mode		= 0555,
-		.child		= hv_ctl_table
-	},
-	{}
-};
-
 /*
  * vmbus_bus_init -Main vmbus driver initialization routine.
  *
@@ -1547,7 +1538,7 @@ static int vmbus_bus_init(void)
 		 * message recording won't be available in isolated
 		 * guests should the following registration fail.
 		 */
-		hv_ctl_table_hdr = register_sysctl_table(hv_root_table);
+		hv_ctl_table_hdr = register_sysctl("kernel", hv_ctl_table);
 		if (!hv_ctl_table_hdr)
 			pr_err("Hyper-V: sysctl table register error");
 
-- 
2.39.1

