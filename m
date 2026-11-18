Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027053;
	b=VJ4/aIAyPgV/dDmnC2+wJ3Uju2Ki9pt90NXOdq2xZ7X5GOv79TcEBa+sH0MBR6rm01uW
	 LmsqUbcOH1PsBNri7FywwyS5HAeQYwwD/r9XtZh4sMmhmJY8N0R/dkkBhWSiiO3CLRQjH
	 xK9dC1b/zjsDIAzteJiHLtOSwrYOI/IzV1NG8h8ZoI0d07LNIA2X5u80Zeo+1Z8FyKXZn
	 ezHuy6Vyut8FYx1OEjhe/4DjBw1lBsUW16nsdA1Tm9CAsgiXhPaE9Y9DOnQdJuHZMP+Ce
	 MnNqb6Z2zkVeFSbNIble9VB/EoMfrGuFQLwiV0WWs0pQSyOq8nZ3eNaW6mkbNbrvIcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027053;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=11wybDvJkntvz22r8OgrBvkVnq5CUS+dsT/ao/WaKug=;
	b=4WpO4jL14Bl86nhZ2sdY49ZOPTgIdL8w7DDCmyzBKUWVViSosh5fIjC9KXIS/BM9WvTw
	 Pqm4puTfKujvgkZGmyx01bDwA2VkG/Q0u3RJkRI1xriBidA/pN9tw2vvNaCMTPanTgIkG
	 cRKnBvbAU5Key1NlwZd2UrmRFGlxZ0YT7j3vABd3fHQvpx8UFOkLpeqc6JNqzGcDtLfyK
	 bqURzp5CExn+4CKlT433qaWuAzj3DC5F7+CmiMcMePu6x2A5/5udasNl3B/cbdd7PD80Y
	 f8q4v624PcLTqr7Fpb3P1wEEoKEOwgwC5I6nAnNzSHhAreSMnxI7z3hYiYGFQuYk40A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEd7lQ+9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EC9F606A335;
	Wed, 18 Nov 2026 18:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEd7lQ+9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F0201F000C4;
	Wed, 18 Nov 2026 18:37:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027052;
	bh=11wybDvJkntvz22r8OgrBvkVnq5CUS+dsT/ao/WaKug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEd7lQ+959kwVgAIhHNEo9lC6352AoY4+wEVksWJUSOiHvF2WcFLbozbcyNRU2tV9
	 fHHF2fEmiuZfpbx1aboSXcvCN8OvxqPsh4bBBg/r+ycJzWIHJFIcQ7LqByYT8Ye6RM
	 B3NcFpMz1bAvHZJ23/UNrBbJubE9ybt+UYAPKGK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li RongQing <lirongqing@baidu.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1654/2151] ublk: use global index for reported zones
Date: Wed, 18 Nov 2026 15:56:29 +0100
Message-ID: <20261118150222.095934825@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c0b504c54f331..8db1f9d9272c6 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -436,7 +436,7 @@ static int ublk_report_zones(struct gendisk *disk, sector_t sector,
 			if (!zone->len)
 				break;
 
-			ret = disk_report_zone(disk, zone, i, args);
+			ret = disk_report_zone(disk, zone, done_zones, args);
 			if (ret)
 				goto out;
 
-- 
2.53.0



