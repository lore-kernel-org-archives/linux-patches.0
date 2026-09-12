Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFAA361960;
	Sat, 12 Sep 2026 08:15:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200943; cv=none; b=HESdllRHa7BMBEpyB0/8e/JEPOhHOQ9OaVXTJA2ESE6JKxsq9dIJO11cB57PF5Q3+FyyZNROXrZZkCoumcP1O85DeRM4H7rTSt5CEdKGRdyXqoN6OlCSIDouw7Fkb5yp8HLJRcifSolFNb6QEok4iS5a/6CMRbmqz+NAWjJw6OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200943; c=relaxed/simple;
	bh=SgF3pM1mAr4qkhOYvRxc5uCKaBTqioxznCReq3eYiH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vhg7eVYIQkzvYWSgeIc4/U53Qh122TvWhpr1ffP739rORQGB3dEMsCrPn1Mrna7BJrDy4vM64Sfifd79rqT93y3oJtiZ76CtPne1CzelsHQstPEEiAIAaEeFXGkm2P7IMQSrehl0/uPGom3YMXTjzy6MRLcT+TIrmKbDWWhlfug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBWY/dFU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBWY/dFU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B38D11F000FF;
	Sat, 12 Sep 2026 08:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200942;
	bh=g1wnKGOokOxQFGEnvkgO6MOFy+8WZKmsjuKw2kvdO5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBWY/dFUa94Mikuzni/n7asisFT/zsXPnqI5DhhcZb0KygtWetSKsmvn2ec0uOfX+
	 LWjn4zq4slu3qJlivcJThpQbCjLZ3L0i2YDSjRdhMDVQBqls0+RHq2Jgvc3Ev/a5Wb
	 NKoqPGgBKYQunJsoAztNLkQNP93CQBzNfVrqlyi0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0894/1815] wifi: mt76: fix out-of-bounds access in mmio copy helpers
Date: Sat, 12 Sep 2026 08:44:04 +0200
Message-ID: <20260912065709.907277581@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 6689b4a65e88d7b019e687fa9d6943ca070f3e43 ]

mt76_mmio_write_copy() and mt76_mmio_read_copy() iterate up to
ALIGN(len, 4), so a length that is not a multiple of four reads past the
source buffer (write_copy) or writes past the destination (read_copy).
Copy the aligned body in the loop and handle the remaining tail through a
4-byte bounce buffer, keeping the register access width unchanged.

Fixes: 2df00805f7db ("wifi: mt76: mmio_*_copy fix byte order and alignment")
Link: https://patch.msgid.link/20260724124813.3961474-3-nbd@nbd.name
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mmio.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mmio.c b/drivers/net/wireless/mediatek/mt76/mmio.c
index 05d74cd7248e9..73d47608bf428 100644
--- a/drivers/net/wireless/mediatek/mt76/mmio.c
+++ b/drivers/net/wireless/mediatek/mt76/mmio.c
@@ -35,9 +35,16 @@ static void mt76_mmio_write_copy(struct mt76_dev *dev, u32 offset,
 {
 	int i;
 
-	for (i = 0; i < ALIGN(len, 4); i += 4)
+	for (i = 0; i + 4 <= len; i += 4)
 		writel(get_unaligned_le32(data + i),
 		       dev->mmio.regs + offset + i);
+
+	if (i < len) {
+		u8 tmp[4] = {};
+
+		memcpy(tmp, data + i, len - i);
+		writel(get_unaligned_le32(tmp), dev->mmio.regs + offset + i);
+	}
 }
 
 static void mt76_mmio_read_copy(struct mt76_dev *dev, u32 offset,
@@ -45,9 +52,16 @@ static void mt76_mmio_read_copy(struct mt76_dev *dev, u32 offset,
 {
 	int i;
 
-	for (i = 0; i < ALIGN(len, 4); i += 4)
+	for (i = 0; i + 4 <= len; i += 4)
 		put_unaligned_le32(readl(dev->mmio.regs + offset + i),
 				   data + i);
+
+	if (i < len) {
+		u8 tmp[4];
+
+		put_unaligned_le32(readl(dev->mmio.regs + offset + i), tmp);
+		memcpy(data + i, tmp, len - i);
+	}
 }
 
 static int mt76_mmio_wr_rp(struct mt76_dev *dev, u32 base,
-- 
2.53.0



