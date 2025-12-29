Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 300FB33469A;
	Mon, 29 Dec 2025 16:32:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025974; cv=none; b=cKjcIO/THsKTof2I9pMqnRZVk2bK9zzCJJazVcwjfpasRN0UqRT0k1GoMYe3ZyR/DBIE8Lh0yH/viPIem/9BG5oZsJSonkG8Y60THsO49Pxs825XoW4S7uLuUaN7WWGs+bgQOBrTH7Bm6CBs09k6iSZxKnKtACthjfKqLEMoCV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025974; c=relaxed/simple;
	bh=vTBBFer4f25clrpiGUI71dEYBc3OLEGAUl7NK+4c5Ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dWOmzedcpGf6Svti5KfX2RitYaBJPUUhntvxbWjT8UONi6Bl6xtV64xm2A1oKStea39Ui9beq+P9OlhnIIoYL75AY69YiK6H3X79wM9lGWJtCPg64Vaef2l4NzmF1717A+snHuK5Fa7YGY2XTh09rkzVZ08o374D6lHNL4oxG10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbwuALnS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbwuALnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A5AC4CEF7;
	Mon, 29 Dec 2025 16:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025973;
	bh=vTBBFer4f25clrpiGUI71dEYBc3OLEGAUl7NK+4c5Ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mbwuALnS3R2CNYgxUWivhgicZPXTTK63/bgbr90LkRT7DdoUek4eS5owMZyk7p1M+
	 WCiVBCz0nBQZuyStWJ5UmK2CNVJIOcZR94TgepBmZ6uf42fu6AiMqlSO8VIrc6N2VU
	 kEp9eOkHh/utFg+ebQRKyTTsOA6W+VvMIxRS0/mg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 402/430] zloop: make the write pointer of full zones invalid
Date: Mon, 29 Dec 2025 17:13:24 +0100
Message-ID: <20251229160739.107802438@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Damien Le Moal <dlemoal@kernel.org>

commit 866d65745b635927c3d1343ab67e6fd4a99d116d upstream.

The write pointer of zones that are in the full condition is always
invalid. Reflect that fact by setting the write pointer of full zones
to ULLONG_MAX.

Fixes: eb0570c7df23 ("block: new zoned loop block device driver")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/zloop.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/block/zloop.c
+++ b/drivers/block/zloop.c
@@ -177,7 +177,7 @@ static int zloop_update_seq_zone(struct
 		zone->wp = zone->start;
 	} else if (file_sectors == zlo->zone_capacity) {
 		zone->cond = BLK_ZONE_COND_FULL;
-		zone->wp = zone->start + zlo->zone_size;
+		zone->wp = ULLONG_MAX;
 	} else {
 		zone->cond = BLK_ZONE_COND_CLOSED;
 		zone->wp = zone->start + file_sectors;
@@ -326,7 +326,7 @@ static int zloop_finish_zone(struct zloo
 	}
 
 	zone->cond = BLK_ZONE_COND_FULL;
-	zone->wp = zone->start + zlo->zone_size;
+	zone->wp = ULLONG_MAX;
 	clear_bit(ZLOOP_ZONE_SEQ_ERROR, &zone->flags);
 
  unlock:
@@ -437,8 +437,10 @@ static void zloop_rw(struct zloop_cmd *c
 		 * copmpletes.
 		 */
 		zone->wp += nr_sectors;
-		if (zone->wp == zone_end)
+		if (zone->wp == zone_end) {
 			zone->cond = BLK_ZONE_COND_FULL;
+			zone->wp = ULLONG_MAX;
+		}
 	}
 
 	rq_for_each_bvec(tmp, rq, rq_iter)


