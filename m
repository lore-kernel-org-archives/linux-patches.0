Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 717B3285C9F;
	Wed, 25 Feb 2026 01:46:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983991; cv=none; b=EwDOFvJIpDSbu0E55C82ngE3H1o7ZoP5G52Hef0+wM6lWE1SgKx+OToF35qFFYcF7Q/IE0eJOw8KiM+QniKJ8lgXmy7G7WEFLbuujMx0JHy91O5u8hjK+fXC0j99ITlGpfzJBPkuV7KCbgWCCPFKRaMIRA/1DN1jdFo6RzXqOiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983991; c=relaxed/simple;
	bh=eOetcmNxe8Lf18pu1a1GPmInKZpzAZ416QvsGS72N/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mntcpdG39Tpj3CH4raZOjv45SjIfDjLMEskrcYWKRhk8+Z1SVPCiAwsaNcOO3PPlRSFMnf0A9M+Z8LeByruX6Kftztd0W4kZbo7+60zG75pJOFyHyXRvV9LkNg5u0TDYV4IkzPGldBGnSyEobpM7lC2anGRvxjJOpl2EThx6PiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ziO/Vsss; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ziO/Vsss"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30B26C116D0;
	Wed, 25 Feb 2026 01:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983991;
	bh=eOetcmNxe8Lf18pu1a1GPmInKZpzAZ416QvsGS72N/U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziO/VsssNOaO2muZMPJkcrGvz5+i6dh2fKrX9dfInGUwbXFX6wWEMQke5aAneBPb0
	 ZOkbA8zLO8xltY9IiwKwrvWbTM/0hNC/KMxe3PlvX27avOAXlNjdo4ouvm352seDE8
	 VElRoIdHlD66MoJZOkmSKxkpMldBUGieMUd3ymAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Benjamin Marzinski <bmarzins@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 246/641] dm: use READ_ONCE in dm_blk_report_zones
Date: Tue, 24 Feb 2026 17:19:32 -0800
Message-ID: <20260225012354.822784778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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
index ba39c8313f32b..f4950b5f766d3 100644
--- a/drivers/md/dm-zone.c
+++ b/drivers/md/dm-zone.c
@@ -56,7 +56,7 @@ int dm_blk_report_zones(struct gendisk *disk, sector_t sector,
 {
 	struct mapped_device *md = disk->private_data;
 	struct dm_table *map;
-	struct dm_table *zone_revalidate_map = md->zone_revalidate_map;
+	struct dm_table *zone_revalidate_map = READ_ONCE(md->zone_revalidate_map);
 	int srcu_idx, ret = -EIO;
 	bool put_table = false;
 
-- 
2.51.0



