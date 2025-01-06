Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4E5C1DE3AA;
	Mon,  6 Jan 2025 15:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178376; cv=none; b=rDKrJZXRFp31fx8T+/qV2NmP4K8M2vRhqu+aDNldn+en1JKjW+e0pGoSfcNEhCxQ98kuTN96Y/9cTGNxwcHfca3/Pp9wjMBJKj1IUY1h4oXoecaKqRliBDIwZmvOf7F16+ZQCKQBWLz7Ihr8XEf6qmFbKiMjZz87evqLhFU/1hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178376; c=relaxed/simple;
	bh=uNFalZ4QVssxYausFBSWmeBh6Kpw/WaUvSBoXiaBFx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDzYGppv4EbqPag0uPXQmE6mqAO5GLo6p/CcbN6YRj53hqWy8CNCU/Fv0qNwLnJUNeG2aXRmkPJgN/w5Sp8kDmSyhfm7hXCfm/ImwjW82RRgt0iK781w58Kuy8NglHq6vOkMJbRM7dzusShsaHgvf7Sg4JRdjicMDPWDNHcfcU0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KGOXP35b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KGOXP35b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 261C6C4CEE4;
	Mon,  6 Jan 2025 15:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178376;
	bh=uNFalZ4QVssxYausFBSWmeBh6Kpw/WaUvSBoXiaBFx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KGOXP35bZZlr6a/K09puWbRNFCM2roUTk/cXiR/gb5Q9I1VY4AX3E/1l/4+9hPxJ9
	 99c8kDff7LNGlv7b5kOkvAO78aNX+f7IhbtTcTcPy/dYB/m3VVcZV+0hAewekGxLv2
	 zk45Td5V0HPP4EKyGLbW/psqLiCKPURNhGbbBaAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	Desheng Wu <deshengwu@tencent.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 098/138] zram: fix uninitialized ZRAM not releasing backing device
Date: Mon,  6 Jan 2025 16:17:02 +0100
Message-ID: <20250106151136.941319893@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

[ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zram/zram_drv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 8e13586be8c9..05a46fbe0ea9 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1146,12 +1146,16 @@ static void zram_meta_free(struct zram *zram, u64 disksize)
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
@@ -1694,11 +1698,6 @@ static void zram_reset_device(struct zram *zram)
 
 	zram->limit_pages = 0;
 
-	if (!init_done(zram)) {
-		up_write(&zram->init_lock);
-		return;
-	}
-
 	set_capacity_and_notify(zram->disk, 0);
 	part_stat_set_all(&zram->disk->part0, 0);
 
-- 
2.39.5



