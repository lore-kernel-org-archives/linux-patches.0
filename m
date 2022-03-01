Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7E617E4
	for <patches@lists.linux.dev>; Tue,  1 Mar 2022 04:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=Wvaf2rS4XOIPWWBrYZGKk5K6I6KgN+6dn1ljHlk2zPs=; b=SVQP0McGFuu5OufwsHA4flHsxD
	0kXXn8LxZXj2d23U0sUGGTCIw+hfPbFi69d56eYCqYWXYSfBWrvimU/Y4TpsU8p6KF6YNYFS2bDLS
	M8kdZBlZ0dLmUFi2U0pglwn3tx7klxSygvVfb1hKQSHXzx33n4PIrDgtDHe82jM9+TrXM3BthJgMe
	HXS4YR4ztraAKWoGeXhX2RwKWqVjqgMb9H7gWacp5G5B7XdkCvFiN5APnvnz6CS7rLkGQ7FBso73U
	kXvnIJ13uCimrYomvS5GdzD3kmQ9jKmefT5tgjhLDaOf3AmwY2XXCP+ItVAkIxg1ktCen3BydUwRw
	+FhknsDA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nOty2-00Eqwn-5p; Tue, 01 Mar 2022 04:18:30 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-kernel@vger.kernel.org
Cc: patches@lists.linux.dev,
	Randy Dunlap <rdunlap@infradead.org>,
	Igor Zhbanov <i.zhbanov@omprussia.ru>,
	Feng Tang <feng.tang@intel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>
Subject: [PATCH] driver core: dd: fix return value of __setup handler
Date: Mon, 28 Feb 2022 20:18:29 -0800
Message-Id: <20220301041829.15137-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When "driver_async_probe=nulltty" is used on the kernel boot command line,
it causes an Unknown parameter message and the string is added to init's
environment strings, polluting them.

  Unknown kernel command line parameters "BOOT_IMAGE=/boot/bzImage-517rc6
  driver_async_probe=nulltty", will be passed to user space.

 Run /sbin/init as init process
   with arguments:
     /sbin/init
   with environment:
     HOME=/
     TERM=linux
     BOOT_IMAGE=/boot/bzImage-517rc6
     driver_async_probe=nulltty

Change the return value of the __setup function to 1 to indicate
that the __setup option has been handled.

Fixes: 1ea61b68d0f8 ("async: Add cmdline option to specify drivers to be async probed")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Reported-by: Igor Zhbanov <i.zhbanov@omprussia.ru>
Link: lore.kernel.org/r/64644a2f-4a20-bab3-1e15-3b2cdd0defe3@omprussia.ru
Cc: Feng Tang <feng.tang@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Rafael J. Wysocki" <rafael@kernel.org>
---
 drivers/base/dd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20220228.orig/drivers/base/dd.c
+++ linux-next-20220228/drivers/base/dd.c
@@ -810,7 +810,7 @@ static int __init save_async_options(cha
 		pr_warn("Too long list of driver names for 'driver_async_probe'!\n");
 
 	strlcpy(async_probe_drv_names, buf, ASYNC_DRV_NAMES_MAX_LEN);
-	return 0;
+	return 1;
 }
 __setup("driver_async_probe=", save_async_options);
 
