Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020725;
	b=AEKY2hlMt1eHqL8Ug59zLZe8hF6Xr84uR8I01LUKdebWmBafQ2ZHxyPTO0PRIRwkUMkO
	 o6u3TA8s9/8VFKhEf2cwpwhJ48KQWjNpDMz4x8xgp6TCxEdKY9hoVvar73mnJWJmHxXWl
	 6vTZ+BRWUDccmUsLNjONW2GgSUILVyx2Fa7+NiWBNillCW68DFT6Yyiknco3qzxygmTn0
	 KU4DgtL1Pnlklzeegmm5IcFzQ2wmCOtfupiOppgJe0KA/SEeihJQZf1pr71rEmeXkdPN2
	 O25LQL3JgLgsof7dDHhcUublM/nvU4+epJsT41a4kNYjWaA1TAg+2QDINexQdI6RoTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020725;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sNa4kaP2pfmu6V1otGqMWFG//U8+Jgo3RF3hXZ08flE=;
	b=KJMRi6nXKksOfGoQrOxwH7ER/kqKaUWTDs4EcFIsNUD9Ll8wW7oqKq5hGcGd69mURQoV
	 BXww/OhE6sC8xA/LV0QUxDJ9w0n3PTxCi0zU9y01Tsn8yeoO9iJDu34UK9TnZNGoKg9md
	 0eceIGBlMFRqVwmy/9jj9s4dccNPXTn3kHIG3J/6dL2dgCPQhDfeetgZvFmyRW4Uq+G4t
	 fq7pL+v+qPg+7SfkezrG8HHBmGKtEcU+TxwfyTMbNFnkJMO+qXc164JA8u0EPKpN0tvN1
	 jbQZLdzkSDrM1FtX2FTzr2wtYQXRD4BvoXnulYtbYvzse06s/6k1tZoB334KuNZVndQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujF8PjrV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3F4E60A2629;
	Wed, 18 Nov 2026 16:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ujF8PjrV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC3AE1F000C6;
	Wed, 18 Nov 2026 16:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020725;
	bh=sNa4kaP2pfmu6V1otGqMWFG//U8+Jgo3RF3hXZ08flE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ujF8PjrVFwaGUrtAZIYLHhIlLGp5uwbWUF86t0rwTe2r1MHGyTrRiU1GJ9hujTOMy
	 voOtzs58DO72+ITK/ncLWrK8dFnp3uxYr51LgQceIxqV4LqUg1Kf0Sd7uHGTo/uxOS
	 BCjUKZXjW0uFMWiBNWfn4VP1b+555WGxNYCckqos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2014/2651] ublk: use global index for reported zones
Date: Wed, 18 Nov 2026 15:54:14 +0100
Message-ID: <20261118150358.751822831@linuxfoundation.org>
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

From: Li RongQing <lirongqing@baidu.com>

[ Upstream commit 80897c7e5ae5c56f37a2eb004328edcb4da7cdd1 ]

ublk_report_zones() may split a zone report into multiple requests when
the number of zones exceeds the temporary buffer capacity. The index
passed to disk_report_zone() must refer to the zone position in the
whole report, rather than the position within the current request.

Currently, the per-request loop index is used as the callback index,
causing each chunk after the first one to restart from zero. This can
make userspace callbacks receive duplicate zone indices and may result
in blk_revalidate_disk_zones() updating incorrect entries in its zone
state array.

Use the number of zones already reported as the base index for each
request so that zone indices remain continuous across all chunks.

Fixes: 29802d7ca33b ("ublk: enable zoned storage support")
Signed-off-by: Li RongQing <lirongqing@baidu.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Tested-by: Ming Lei <tom.leiming@gmail.com>
Signed-off-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261011063555.1142277-13-tom.leiming@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index d806c6104c74d..cc4e72fd5d4df 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -696,7 +696,7 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 			if (!zone->len)
 				break;
 
-			ret = disk_report_zone(disk, zone, i, args);
+			ret = disk_report_zone(disk, zone, done_zones, args);
 			if (ret)
 				goto out;
 
-- 
2.53.0



