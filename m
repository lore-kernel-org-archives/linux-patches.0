Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E7295678C2;
	Wed,  9 Sep 2026 14:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964848; cv=none; b=Bg+1OqXLvwzTisvDdXS7P8sZdEJG7ueP1WBvqeYXX6f3ZKZ9B18iqbxR8aOmO2pPreDUrCs/qD2S/8TmYvsdpRzsITiwnR6+lFtGdE0l4z2ZOGs8x957RLuNp0tdj/Yhp1G1O2YTTThe9kOyg/27nNRslMYTkUJiFF2FjliN4qQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964848; c=relaxed/simple;
	bh=85LPX7Y7v5mEwqhAr+SDaZ0vIFLL2QPBgUuDrQTqvzc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=usdwK5Afdmy6NMMnKcqOT5Z9eSDfMn7g8MA5u9aYoxJl0/nOWgcQzQ9hLy8QMQ+RHDoIxlEnDXQ4JjwaJt54BzQ1BS8WVqXVoZo+vCrCqNcT0H88CnboMJqbVB1AUiltF4+7897l43YwnGg98cPOk5oOaxFD/opOc/m1G15VCLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fHhQ7zC6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fHhQ7zC6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 787071F00A3D;
	Wed,  9 Sep 2026 14:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964847;
	bh=DgyaQXKW8x7fUrmCBQk1Jb+Fl73jp7OyyssObm6ZcRY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fHhQ7zC6gn9Tktigcqwgm3om0s0QGcagieQU4vIfdtN5XNtxzmVA/RbZhl8Y4I2iS
	 8Tng6bW5YnkztW4wYNnNDJf714+1hvSh8r8OT+tGxyouQZiJ95SPEZIt4B+vyLAb6b
	 +45pJ5+zhJtZ/OTeQ/TJCbZdXs/kpG9QEZoz/iNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Brian Geffon <bgeffon@google.com>,
	Minchan Kim <minchan@google.com>,
	Richard Chang <richardycc@google.com>,
	Yuwen Chen <ywen.chen@foxmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 557/583] zram: read slot block idx under slot lock
Date: Wed,  9 Sep 2026 15:44:02 +0200
Message-ID: <20260909134256.991107080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sergey Senozhatsky <senozhatsky@chromium.org>

[ Upstream commit 1b1a4e4d6797a57fefa40569fc920ce573bbf75b ]

Read slot's block id under slot-lock.  We release the slot-lock for bdev
read so, technically, slot still can get freed in the meantime, but at
least we will read bdev block (page) that holds previous know slot data,
not from slot->handle bdev block, which can be anything at that point.

Link: https://lkml.kernel.org/r/20251122074029.3948921-7-senozhatsky@chromium.org
Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Brian Geffon <bgeffon@google.com>
Cc: Minchan Kim <minchan@google.com>
Cc: Richard Chang <richardycc@google.com>
Cc: Yuwen Chen <ywen.chen@foxmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: dde75313eed0 ("zram: set default primary compressor in zram_destroy_comps()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zram/zram_drv.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -1734,14 +1734,14 @@ static int zram_read_page(struct zram *z
 		ret = zram_read_from_zspool(zram, page, index);
 		zram_slot_unlock(zram, index);
 	} else {
+		unsigned long blk_idx = zram_get_handle(zram, index);
+
 		/*
 		 * The slot should be unlocked before reading from the backing
 		 * device.
 		 */
 		zram_slot_unlock(zram, index);
-
-		ret = read_from_bdev(zram, page, zram_get_handle(zram, index),
-				     parent);
+		ret = read_from_bdev(zram, page, blk_idx, parent);
 	}
 
 	/* Should NEVER happen. Return bio error if it does. */


