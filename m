Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022283;
	b=ZQAcBhp2zfMbyD4E8Lw4Wzcy+jFvUxMHp98ycLEakGfaCNJlAaOj3S+jHSUilGrpnw/M
	 U9DePPBAB93kmLztAxZtzgrwk7qpRBXXXcD40Cq+cwT6PQxWwxE9pcs1u7pLqa+dCSiYJ
	 rNF48hiSUnCAAXSO6lir8qr4YEjiQX+2qGyPiqgk8Sf1IbJJGgtf/jzuO0NoU6ODZJC7W
	 i2N74Cm2Zu5ZEeTsyXjNZZw1P73Nbol3uQuwkLSxnJhnldyaAwumi40X7SVnJIilOvIfN
	 lJ5y8SrD0oDDCt75Hb5lWeAjrirlUEQJ8AO39zqHMtJQw3da+d6RP84m6CrJ4Tgruvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022283;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aB8svDvy4796GZktCXDc62jEEr7Uf1CDhmUVj3QvLJE=;
	b=45Uej0LwAQexikRFuGjr2+jK+WeNyW0/e9u41Jt+9Qkqs922uZt9mw9omLtFvi6DC4Ul
	 Ya456zgUF8YtVN6Syqjj1DzpK+4ih6rmQ6C/NbqiuuW6S8+qP5EeYC5Gx5V3E7dvioqZz
	 KGB2HhX8l5ziabqZl/vrRJ+2a46jQiGiX9r4pIq5W1RsxqPXyOgINEfFn6Qvu/65p9IoS
	 e6X4Dy/rxT++S/7wVjmF/WnMHyK+8e1wBjk1yB/u4hwa/iA+Ylah3kd+0HDq4GMaUTNI5
	 TDrfal5IFY0QHZAaXALkv9kwcS9HLLdh74V3XSrIFQjTG+YXehTFISk2lzwZgiY825g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nm4f6KlM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 817E2606A320;
	Wed, 18 Nov 2026 17:18:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nm4f6KlM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0BE1F000C4;
	Wed, 18 Nov 2026 17:18:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022283;
	bh=aB8svDvy4796GZktCXDc62jEEr7Uf1CDhmUVj3QvLJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nm4f6KlMyVX3Y0Ju33UVzC4Nee2C0U6LcCRpIgzXNFBH9USayjOZnCFugA1o6ZSUZ
	 KdbJpwx8potnfKSETW/F/J5mCYj8PZSxthhVHyIZp1gTvxflvPHTyHF/BK6xzPbBbR
	 jx/Q3ks0c+tDF1gYGC88eZaco5ohfmgQPX96w9vM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2607/2651] zloop: fput file after failed zone init
Date: Wed, 18 Nov 2026 16:04:07 +0100
Message-ID: <20261118150418.111768706@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit 134ffb0755626c91af82fc7debc8b6f75f1f777e ]

Clean up after failure in zloop_init_zone, as the caller only cleans up
the zones before the current one.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Signed-off-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/20261029150353.2503201-4-hch@lst.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/zloop.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/block/zloop.c b/drivers/block/zloop.c
index 0f37fb373a051..d41c0d54ae4e5 100644
--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -1125,7 +1125,7 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 	if (zlo->block_size) {
 		ret = zloop_get_block_size(zlo, zone);
 		if (ret)
-			return ret;
+			goto out_fput;
 	}
 
 	if (zone_no < zlo->nr_conv_zones) {
@@ -1140,14 +1140,14 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		ret = vfs_getattr(&zone->file->f_path, &stat, STATX_SIZE, 0);
 		if (ret < 0) {
 			pr_err("Failed to get zone %u file stat\n", zone_no);
-			return ret;
+			goto out_fput;
 		}
 		file_sectors = stat.size >> SECTOR_SHIFT;
 
 		if (restore && file_sectors != zlo->zone_size) {
 			pr_err("Invalid conventional zone %u file size (%llu sectors != %llu)\n",
 			       zone_no, file_sectors, zlo->zone_capacity);
-			return ret;
+			goto out_fput;
 		}
 
 		ret = vfs_truncate(&zone->file->f_path,
@@ -1155,15 +1155,21 @@ static int zloop_init_zone(struct zloop_device *zlo, struct zloop_options *opts,
 		if (ret < 0) {
 			pr_err("Failed to truncate zone %u file (err=%d)\n",
 			       zone_no, ret);
-			return ret;
+			goto out_fput;
 		}
 	} else {
 		/* Sequential zone file. */
 		mutex_lock(&zone->lock);
 		ret = zloop_update_seq_zone(zlo, zone_no);
 		mutex_unlock(&zone->lock);
+		if (ret)
+			goto out_fput;
 	}
 
+	return 0;
+
+out_fput:
+	fput(zone->file);
 	return ret;
 }
 
-- 
2.53.0



