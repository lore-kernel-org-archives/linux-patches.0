Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5CCB7A
	for <patches@lists.linux.dev>; Fri, 15 Apr 2022 22:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=bxVj2O1o7LGuwxK5yOR+4h1tW8wZ1StFjb76X3rSON4=; b=fKSuWrCm6xuF4e2mK/cydfZ2/M
	AOwYUVsMSrAdmWo5UrNNcCftgKerHCLBwUfDGOvwh5XlyHvmiTxNkbueKWulSs+RQ7bjqTj9YqlmN
	VshG4TVTffz5jTDMivIQjw/OZBLtfzm9iAHrl7HoBaruRjQsPVgeZvjvi0tc/yB643bN9R264y139
	dfD80J0zOmq2kUiy9gprlZsosoM9p9wKwBDqJMfsqy0nMeSskgnf4Yawe0rA8w/P18L4v3ZJeCob8
	PORbz6wXQoTnVxMfbxBO7G3rA4hT0Sw/9G6r19ZvMbeaTTU6SBI17odF8gTK+zMYtOEo5jazfrPhG
	vuHuV7nw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nfUDW-00BYVL-LO; Fri, 15 Apr 2022 22:15:02 +0000
Date: Fri, 15 Apr 2022 15:15:02 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: zhanglianjie <zhanglianjie@uniontech.com>, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Linux Memory Management List <linux-mm@kvack.org>,
	mcgrof@kernel.org
Subject: [PATCH sysctl-next] mm: fix unused variable kernel warning when
 SYSCTL=n
Message-ID: <YlnuZrhMc7OydWm7@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

When CONFIG_SYSCTL=n the variable dirty_bytes_min which is just used
as a minimum to a proc handler is not used. So just move this under
the ifdef for CONFIG_SYSCTL.

Fixes: aa779e510219 ("mm: move page-writeback sysctls to their own file")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---

Andrew, I can this via sysctl-next if that's OK with you.

 mm/page-writeback.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 438762173a59..4f51d0ac5043 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -89,9 +89,6 @@ static int vm_highmem_is_dirtyable;
  */
 static int vm_dirty_ratio = 20;
 
-/* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
-static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
-
 /*
  * vm_dirty_bytes starts at 0 (disabled) so that it is a function of
  * vm_dirty_ratio * the amount of dirtyable memory
@@ -2077,6 +2074,10 @@ static int page_writeback_cpu_online(unsigned int cpu)
 }
 
 #ifdef CONFIG_SYSCTL
+
+/* this is needed for the proc_doulongvec_minmax of vm_dirty_bytes */
+static const unsigned long dirty_bytes_min = 2 * PAGE_SIZE;
+
 static struct ctl_table vm_page_writeback_sysctls[] = {
 	{
 		.procname   = "dirty_background_ratio",
-- 
2.35.1

