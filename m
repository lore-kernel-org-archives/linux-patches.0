Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF1B938C415;
	Sat, 12 Sep 2026 15:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789225836; cv=none; b=EiAZAKNXACOFwNCnSEV7DQelcAnkSXOvpai03IlvCp1ddJd3ZDk7UhtWwy6SToJcFDXaYUQnDPUhzIWx0W0A8Rh5PfkkuAml9zxds/Rg0NOelbjhFl3SkpP64ZY9EFR6yTiPxBrCaHI0eloaaiNC8FOQP7jmNrO9dPS7KMV5HO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789225836; c=relaxed/simple;
	bh=oXuJfc7E8/+yLajLC7dsQVaPqiFpRHbhwVIf4V48+4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmvvxBo9jwJii3fNDypn5T9LuF441xFjiRBWV0iucOyhsds6pH7Kjx5B1Xbou/K2gkI2tnusHGaEsBo3VLVOSMP4qjjA7TmmS6pN+GlvqThYleviaurQU4dO2x/tnMBY/St9g0UuVaYAIVY9Qz9UuAoqY+HOMMr1sB+pcUiVY9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TB/jQrh3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TB/jQrh3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC961F00893;
	Sat, 12 Sep 2026 15:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789225831;
	bh=kKS5PWYULFaGe+42ExlS1h4OvnyBJTL9AuyEFfDWII0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TB/jQrh3g6DWWPf/sol6kDLcZc8gItcyUSu752B+pdi94qsH4hIC/tQFgMI7mxLPL
	 4I415j8pMWP5D29NUv5MBYCyiJGk2mIMvcVyHObgk+kVhKNglHs256Bktaspe4iSH2
	 z8k8uIsCYfA2YfY+sKczn8t5sPrXH6AVrkHysSBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1235/1424] null_blk: free global tag_set on init error path
Date: Sat, 12 Sep 2026 09:01:07 +0200
Message-ID: <20260912065634.939197755@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 5a1c5ff3a49ba93a1fd0b70537e7a0164071760d ]

If shared_tags is enabled, null_setup_tagset() allocates the global tag_set
via null_init_global_tag_set(). If device creation later fails, err_dev
destroys the default devices and calls unregister_blkdev(), but never frees
the global tag_set. Since module init failed, null_exit() is never invoked,
so the global tag_set's tags and maps are permanently leaked.

Free the global tag_set in err_dev, matching null_exit() which does
if (tag_set.ops) blk_mq_free_tag_set(&tag_set).

Fixes: 82f402fefa50 ("null_blk: add support for shared tags")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-5-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index bec087daae9cd..80f6f7a7a7583 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2351,6 +2351,8 @@ static int __init null_init(void)
 		null_destroy_dev(nullb);
 	}
 	unregister_blkdev(null_major, "nullb");
+	if (tag_set.ops)
+		blk_mq_free_tag_set(&tag_set);
 	return ret;
 }
 
-- 
2.53.0



