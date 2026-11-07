Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062119;
	b=03iP1w26JMDWvg7vLAVBP+Eq2oIeRCst2b1wY6ABcSwOYFn3kGb+Z7hYJ+w692ITn3ah
	 tDYUA6TLV4e2TkSI3I2PB72qaFPEj1Te/P4voBervYcp0pCjuo/W7hi3xVda3vyhnPM/K
	 lF2IruNQ8zRyz2GyWvE5lCkyOkWnIE0lOe5ZZS8D087x+komui2LP77WSmSNf+k5+VQ76
	 9UBjck0aK+ITVvmlXV5oWmPf4kF+uPXfYbovSYamELvLCaBvuuOszFQCAmfl9esW87UTc
	 6qvJPEcUik+I0TGjNFjWsqIhg/tw1Quz5yxnhfCZLDeBmzMjqZu/kPpf2PIuRUL+Eqw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Vdhboo910tAObMdn7R+AEMDL1vkFkk0HwkOK3IrmceQ=;
	b=D2TzG6RWUOw9zukt5JwTAv12vDJRmkeifo5xV9bejSKNa4ytCO28acUSMxU7S+gU1MLH
	 E4MfArGaPHSpOmct0ZmQmXxk+Kw8b2dKghDVZCV5Qh9XcDbmk5ndNmXT6etjyrpXbvSVR
	 6mjXFeH+VWv/SlPfw2FZIzJn89mJFT58/mQI5sGCWGjGqJqzjjleQ8Xu+nZuhRCckEYV7
	 +QaDGFF0i9NQEbGDYykZ8G7yBY12tIdgF4kkrMLz2CFzhSqvRWfPG4DZsoK3uHDr210HH
	 OCHcMX9E5RR4WPh4NbpxXqnSyV3YRirqou72UogDPj2T0y8/6EKrZZL9ztICNiIGs1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xXMFT+i/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681FE60A6F4B;
	Sat,  7 Nov 2026 14:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xXMFT+i/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1361E1F008A1;
	Sat,  7 Nov 2026 14:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062119;
	bh=Vdhboo910tAObMdn7R+AEMDL1vkFkk0HwkOK3IrmceQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xXMFT+i/KFRELN6MRxrSZps/LDw+7CdfjGeAOlW/9sYQp2/VqiIdiHC2PQNrkyCBA
	 sIopURZhkCMEzAm312Wew7RTcPEqwhk9Y5jKYCS969yh8kuLHF1ZnJ7Sh4a9yQ9QcO
	 In7WJFqJqLv/A5s5/63TnNGmiIZp6eV2ymr8/iYg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1072/1536] mtd: mtdsuper: Fix MTD device reference leak in mtd_get_sb()
Date: Sat,  7 Nov 2026 08:51:28 -0500
Message-ID: <20261107135027.803139493@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit 62ee3da38f41bef83c1cf250f6816a0ee187674b ]

mtd_get_sb() is called with a reference to the MTD device already
taken by the caller.  When sget_dev() fails, the function returns the
error without dropping that reference, so the device is never released
and its refcount never reaches zero.  Every mount attempt on an MTD
device whose superblock cannot be set up leaks a reference.

Restore the put_mtd_device() that the fs_context conversion dropped on
this path.

Fixes: 0f071004109d ("mtd: Provide fs_context-aware mount_mtd() replacement")
Cc: stable@vger.kernel.org
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdsuper.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/mtdsuper.c b/drivers/mtd/mtdsuper.c
index b7e3763c47f0c..22ddeaa7d5221 100644
--- a/drivers/mtd/mtdsuper.c
+++ b/drivers/mtd/mtdsuper.c
@@ -31,8 +31,10 @@ static int mtd_get_sb(struct fs_context *fc,
 	int ret;
 
 	sb = sget_dev(fc, MKDEV(MTD_BLOCK_MAJOR, mtd->index));
-	if (IS_ERR(sb))
+	if (IS_ERR(sb)) {
+		put_mtd_device(mtd);
 		return PTR_ERR(sb);
+	}
 
 	if (sb->s_root) {
 		/* new mountpoint for an already mounted superblock */
-- 
2.53.0



