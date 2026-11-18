Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060742;
	b=JXtmFW3YczNQTkxO5i6goMeGJkQxztNs0yN3vtrbd+qyla9zfMxh1HQ+04QiB3upuAqI
	 9sIbymDd3NvH9j5yKnuj28ukC7WhKH3Ip3KTN44Vmb5xzGBa/H2d1TgMkROZIkhW89T9I
	 839YKexu5c786Ht3bKclaOMomS+fwARGWwvasbYg7dXc5k1/IRT8H8mmmdCAHzDOaTZBx
	 Rt3fk5y+X7CGbe1Q+BOxYyJRpD8droKPAsc0KD99UlpnkU6QQuDM+G+I0moqL6lJMvck5
	 ziwOrxrDWzndepHfnEQvhcvdCuv94mhDVvpqTEOHlgjBd0cKV9e+oVIoTWenXZNbEdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060742;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X2ep0UHew+ROeaXEUHtcn8/imc9yDLXUmHon64R6MLE=;
	b=mVQRNP3HJVDafLkqvu1LRV95A8iaTbXPQZYX3vXSX3Q5Da8R4zD+I4lXoJXUwjhPk82b
	 CXN59UTc5Tq1QVEIX+RUiuS2+2hVGYxDGgAapVQKrNT2tNlt7vC4+843D3ozBGo/B8P7n
	 zxhLivcqXyZpFeLVsYQCcTyNL+I3jkkGrojhtXOUNfIM54V4jCA4pfG7e/5VAq/RPgJEB
	 ZZjRfwWSQ8KgIbmrP/ECY7gkDj1zTQH0l3uoIr7e3i2An7AIeiOsDmXV2cYI0w9wu4F16
	 1uLjUzdcK3IFXESYSnCT1bsguHjuTV4Q52E42/1LZthQ5x3tcMV80DHVRnd27vCqwEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCqUAc8n;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475CC606A32A;
	Thu, 19 Nov 2026 03:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pCqUAc8n
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D4641F000C4;
	Thu, 19 Nov 2026 03:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060742;
	bh=X2ep0UHew+ROeaXEUHtcn8/imc9yDLXUmHon64R6MLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pCqUAc8nYwJ7ni21fxVWv6vke6p/HPhX7FMs1sHmU57mDdSJBq+MLCr48F+RYEL7x
	 MhnkZc8RDiXp0xiRaSZyfQFncTGnnc+qKsIrqnJWH1z9sulM0c/miGs5LdTDPm0r85
	 H8dsRe1+7Iw6PRDrxqr5W3pBCX4ZfXxgmcISgk5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Chamberlain <mcgrof@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1308/1848] swim: simplify using blk_cleanup_disk() on swim_remove()
Date: Wed, 18 Nov 2026 15:55:46 +0100
Message-ID: <20261118150014.233124755@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit b76a30c254d987b4ae7d47415081121d4c0a7423 ]

We can simplify swim_remove() by using one call instead of two,
just as other drivers do. Use that pattern.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Link: https://lore.kernel.org/r/20210927220302.1073499-8-mcgrof@kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 994a778d9665 ("swim: Configure parameter memory")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/swim.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/block/swim.c b/drivers/block/swim.c
index 0fa87c9c6206c..34a63fda9c9f1 100644
--- a/drivers/block/swim.c
+++ b/drivers/block/swim.c
@@ -940,9 +940,8 @@ static int swim_remove(struct platform_device *dev)
 
 	for (drive = 0; drive < swd->floppy_count; drive++) {
 		del_gendisk(swd->unit[drive].disk);
-		blk_cleanup_queue(swd->unit[drive].disk->queue);
+		blk_cleanup_disk(swd->unit[drive].disk);
 		blk_mq_free_tag_set(&swd->unit[drive].tag_set);
-		put_disk(swd->unit[drive].disk);
 	}
 
 	unregister_blkdev(FLOPPY_MAJOR, "fd");
-- 
2.53.0



