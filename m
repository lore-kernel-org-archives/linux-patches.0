Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B88A29A2;
	Tue, 30 Jul 2024 15:56:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722354969; cv=none; b=FMHrcPzDT8O7tasZNgEBpb1ERASLVr3zAcefyxXe3nhGi8OtBHg2mY6Q4b7dSY4BI2uCxHUV5POrcFaou9LxZsXq2XyBT7KBgqOWL1jBVP+glu2e1qbmdHOoKLTU4EpXooReirrbCoa1vXlzm4Qsey1b9owZJWWjOmcXmsBPeAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722354969; c=relaxed/simple;
	bh=6bJrMYJOPHqyJJKWiIvzvpKLTKVLKzMt023hVVfVRV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mhinr0d8D/7jJ3UuxsF30I4D7WXJmcWzuEA6tWxOWIFEuYqIQY1KTBt8W7DxSL1BY2t+bUSfjbIVw3mOkxCFwCBEsg2wElg8tecfIMDxAtqImtR1tg7Sm5gvW6rCydhur7LX4RmIJZz9VX2oXHbs8SPP86Lx6pA1aYiWsu7y7ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ve0eYoaH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ve0eYoaH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22D63C4AF0C;
	Tue, 30 Jul 2024 15:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722354969;
	bh=6bJrMYJOPHqyJJKWiIvzvpKLTKVLKzMt023hVVfVRV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ve0eYoaHIJWt8DQF/YQiOc6ckel5X5sIne0eXw5TRzYlvDdRwSYhluOad2QD0EPjW
	 0CzK9P1vkOpU2lsCKYH8aMJ0lwxvEpjcUUJcUmZDcXoVTZTCvFIZovld0YczOux0as
	 C5SACnzHjnCAq7d7cG/RMwF1aFkn0AATDlRWMaEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Song Liu <song@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 006/809] md/raid0: dont free conf on raid0_run failure
Date: Tue, 30 Jul 2024 17:38:02 +0200
Message-ID: <20240730151724.902520899@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 35f20acaa3585f25f8356da0ee6bc143e0256522 ]

The core md code calls the ->free method which already frees conf.

Fixes: 0c031fd37f69 ("md: Move alloc/free acct bioset in to personality")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Song Liu <song@kernel.org>
Link: https://lore.kernel.org/r/20240604172607.3185916-2-hch@lst.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/raid0.c | 21 +++++----------------
 1 file changed, 5 insertions(+), 16 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c5d4aeb68404c..81c01347cd24e 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -365,18 +365,13 @@ static sector_t raid0_size(struct mddev *mddev, sector_t sectors, int raid_disks
 	return array_sectors;
 }
 
-static void free_conf(struct mddev *mddev, struct r0conf *conf)
-{
-	kfree(conf->strip_zone);
-	kfree(conf->devlist);
-	kfree(conf);
-}
-
 static void raid0_free(struct mddev *mddev, void *priv)
 {
 	struct r0conf *conf = priv;
 
-	free_conf(mddev, conf);
+	kfree(conf->strip_zone);
+	kfree(conf->devlist);
+	kfree(conf);
 }
 
 static int raid0_set_limits(struct mddev *mddev)
@@ -415,7 +410,7 @@ static int raid0_run(struct mddev *mddev)
 	if (!mddev_is_dm(mddev)) {
 		ret = raid0_set_limits(mddev);
 		if (ret)
-			goto out_free_conf;
+			return ret;
 	}
 
 	/* calculate array device size */
@@ -427,13 +422,7 @@ static int raid0_run(struct mddev *mddev)
 
 	dump_zones(mddev);
 
-	ret = md_integrity_register(mddev);
-	if (ret)
-		goto out_free_conf;
-	return 0;
-out_free_conf:
-	free_conf(mddev, conf);
-	return ret;
+	return md_integrity_register(mddev);
 }
 
 /*
-- 
2.43.0



