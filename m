Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F7A71F540C;
	Tue, 21 Jan 2025 18:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482889; cv=none; b=abvBRVumkfO91byoPZmX/yFMjbt5fGyDWfy+A+y5qhzNNVTk+T+G4o1Xla5lxkvNL1dwk7hJlSj2OpSFamI6WFLD88dxhp95QX1r9zV+h7SgWOCw1WeArJSjKYMDvT0sfKJi2ej0+H6nVO4ReQ84LZX9Vm/n3jqXizY7cHrCYnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482889; c=relaxed/simple;
	bh=mJ+dX22eAwZUhxAokep3eAm4cwBEqV8UpooUdfxG0QI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xu6ABWUqL/8mglwlTGXbLnMyFDr8Ej0ohre8uV6lfzEqGyXzvoAs+p70aTfBPgFNeHNe7FjQISZs7z2/2WE6yXbTwe4O0bUbPfofimVF0fx3M51MCY6TEEhrBnXyOxRib+bu4RoHlzRQmD9+xwKjjoei+YIkbM8COe3ch79Kjcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SkFz5nsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SkFz5nsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3B1C4CEDF;
	Tue, 21 Jan 2025 18:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482889;
	bh=mJ+dX22eAwZUhxAokep3eAm4cwBEqV8UpooUdfxG0QI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SkFz5nscLn6DI3fUVtdRhvwaIV8iBG2Kef3fJxTOh/diMQ3vUe+7hIAChISz2wiLX
	 qkOodO6MmxhGQqRLJO7nd2VRJ5/LFuNzGln4nJhMTit5Q8Bn4Nh1Nc/ibSmXXUwOtl
	 GMR83GyYzYatJLbp23TljOP6TdkB+ZmE+XkekWyY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>
Subject: [PATCH 5.15 036/127] zram: fix uninitialized ZRAM not releasing backing device
Date: Tue, 21 Jan 2025 18:51:48 +0100
Message-ID: <20250121174531.071973846@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174529.674452028@linuxfoundation.org>
References: <20250121174529.674452028@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit 74363ec674cb172d8856de25776c8f3103f05e2f upstream.

Setting backing device is done before ZRAM initialization.  If we set the
backing device, then remove the ZRAM module without initializing the
device, the backing device reference will be leaked and the device will be
hold forever.

Fix this by always reset the ZRAM fully on rmmod or reset store.

Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
Signed-off-by: Kairui Song <kasong@tencent.com>
Reported-by: Desheng Wu <deshengwu@tencent.com>
Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1150,12 +1150,16 @@ static void zram_meta_free(struct zram *
 	size_t num_pages = disksize >> PAGE_SHIFT;
 	size_t index;
 
+	if (!zram->table)
+		return;
+
 	/* Free all pages that are still in this zram device */
 	for (index = 0; index < num_pages; index++)
 		zram_free_page(zram, index);
 
 	zs_destroy_pool(zram->mem_pool);
 	vfree(zram->table);
+	zram->table = NULL;
 }
 
 static bool zram_meta_alloc(struct zram *zram, u64 disksize)
@@ -1699,11 +1703,6 @@ static void zram_reset_device(struct zra
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(zram->disk->part0, 0);
 


