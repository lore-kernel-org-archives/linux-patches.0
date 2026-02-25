Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98918DB2A;
	Wed, 25 Feb 2026 01:33:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983180; cv=none; b=hU18W/Z+HpXarXkOBFxeeEKr0B5sfQqXYiDlDOzFDJFSRaSTrkhIYa2Pz9LzT803Eb74gzRog4L39aHK+JPljFG4GazZ8dpVwGIxcP4UMYZh4IT2DS+LSoWEvWmy2AkSgAdm2KftX4tyDPWFrgTAmMGixIPKKmIEGzOWYu/A05I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983180; c=relaxed/simple;
	bh=AWPce8JNEg3WRlIS4+Dd8KXUJ1vxX/lLDZuFvM1SuIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CE5flf9nO2WQ8Drr5/ZT5l1qkyGDt07XJNxNLBnMDf/uqyEYb4d1TE/3oZmBWV6cwpBsx57cIAGfV2p8VYB3aDN0eH92tFg54bS6IzdhA5/rFmvG7qxsvm4ZCK63poKMSu8495iSc8Zl/DH4o01ZGuttX+dp7qfvwFEN6T4F8bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vrDM7gk6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vrDM7gk6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77FFBC116D0;
	Wed, 25 Feb 2026 01:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983180;
	bh=AWPce8JNEg3WRlIS4+Dd8KXUJ1vxX/lLDZuFvM1SuIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vrDM7gk6QqwriC89TIpyBfM+SkiBeHgmnePnPbEM3YtFgc8uLjSUNXIrQ6YUVGYqx
	 jVaJVfSqAJju3UwYPg5CFaMnTxQhcVUBbjiAK5LC0fJPEC4S2+HaZblru734dqTkqq
	 NfH17XZlEW+NP6aqQMJ+Yv0AaVDT0h4rom6U5KUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 331/781] dm: use READ_ONCE in dm_blk_report_zones
Date: Tue, 24 Feb 2026 17:17:20 -0800
Message-ID: <20260225012407.821098412@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

[ Upstream commit e9f5a55b70ae6187ab64ef2d1232ae2738e31d1f ]

The functon dm_blk_report_zones reads md->zone_revalidate_map, however it
may change while the function is running. Use READ_ONCE.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 37f53a2c60d0 ("dm: fix dm_blk_report_zones")
Reviewed-by: Benjamin Marzinski <bmarzins@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-zone.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-zone.c b/drivers/md/dm-zone.c
index bc4e45862a220..f29acf64429a7 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -50,7 +50,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	struct dm_table *zone_revalidate_map = READ_ONCE(md->zone_revalidate_map);
 	int srcu_idx, ret = -EIO;
 	bool put_table = false;
 
-- 
2.51.0



