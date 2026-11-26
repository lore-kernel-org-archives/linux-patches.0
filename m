Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704927;
	b=ZOcd1nhnu6J+FVN4vrpm6pabpwmWKD183iuM5OIJCeecovr4ytt6A5ZF4E7lBAnn2/9I
	 cOR/RiZyPghWi9xoCfP4BjCoivT8VCWUG3R7iOu5IGUZTkvZi0r7XP4jhi1zUUnn93bh3
	 HM9LpJOTPlS2izteYkd8ojAwDdw3RBSWRkdUAt5FeO1BjE7RAzJ46wA3btnDrMdPoG8Io
	 FecVFpO8rbnLbJ7B+1W1s/Ip5VupC4Vm/5yV+abCHasp3uz8xUCQQoZOnLAVIkFtuDvxd
	 RncWCR0VFUEUJyZXFjwuN8lNw6OW8vGKKaWDybOMxl9rwgh3BUNnYucvtgvtrJCl18g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704927;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=p4I3RxJ+aJ81IRdk+1JjUhcyTNKv0yr08V9tAIvovec=;
	b=S0v4KPjLPATW0s24j5FJx7Z4yPWJlqBaVgulOjwv0A2p1kl5fW2GIfIB04rMrv0XQiJT
	 EdcnP2WClNfBomj6MSzaLGsa7//q8iINh0a2cxVCRuZGZANJWe2LqNshniWNA8JlzZvJI
	 A0ra9RFII0ukwgT9K5ABYUIVKj/nANRBljKYBgKvhnVTEIjmjCVWgacEmF4xw26ZnAQPa
	 MRDiPLWI/iyWzydW0+M2Wtnlu7yOP6WPt59nRyfGbAUz2FBj1wfzsmJBxkpuHl4Hhmd+0
	 4pxWI6R3BWyH+rpBUv9Cy4Y9AjzTBIRTcovmMpvlSqO928GB6689mQaYnWXxgKSZ1Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="osN/W8D3";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B949F606A31C;
	Thu, 26 Nov 2026 14:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osN/W8D3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A74501F000C0;
	Thu, 26 Nov 2026 14:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704927;
	bh=p4I3RxJ+aJ81IRdk+1JjUhcyTNKv0yr08V9tAIvovec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osN/W8D31BJBuDdv5zk0kF4J2jUSodb3dTcrN9rYKaLaks8JxOElasMy3v3WIW/WQ
	 hio2voBiF9XnWxLbDm6o2AKLOtxchOnKV7/DeaNYQgYjkb/7uEsDGLcSQDMMGhT6+2
	 408eqH1KYcEw7Rbkkj5nS5f24SXjo04C/hvuys+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 023/319] scsi: aic7xxx: Fix REQUEST SENSE allocation length on big-endian hosts
Date: Thu, 26 Nov 2026 15:36:31 +0100
Message-ID: <20261126144007.264045853@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 9a2690eb4bbea8d7fbc3dfe478fca75fe956abb4 ]

The REQUEST SENSE length was taken from sg->len after the AHC_DMA_LAST_SEG
flag was or-ed in and the value converted to little-endian, so the 8-bit
field is 0x80 on big-endian hosts and the target is asked for 128 bytes
into a 32-byte buffer. Use the buffer size, as aic79xx does. On an SGI O2
with a Fujitsu MAX3147NC, the sense data of its CHECK CONDITIONs during
probe was lost.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Link: https://patch.msgid.link/20261013094253.2956-1-kaloz@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/aic7xxx/aic7xxx_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aic7xxx/aic7xxx_core.c b/drivers/scsi/aic7xxx/aic7xxx_core.c
index d747d0b72a13a..989e8c9bda4ac 100644
--- a/drivers/scsi/aic7xxx/aic7xxx_core.c
+++ b/drivers/scsi/aic7xxx/aic7xxx_core.c
@@ -1097,7 +1097,7 @@ ahc_handle_seqint(struct ahc_softc *ahc, u_int intstat)
 				sc->byte2 = SCB_GET_LUN(scb) << 5;
 			sc->unused[0] = 0;
 			sc->unused[1] = 0;
-			sc->length = sg->len;
+			sc->length = ahc_get_sense_bufsize(ahc, scb);
 			sc->control = 0;
 
 			/*
-- 
2.53.0



