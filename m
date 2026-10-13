Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 814614D7D30;
	Tue, 13 Oct 2026 12:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892878; cv=none; b=KveDcZk6+fB9R7vMjbyy8C/mvrFfn7yTUl3tRU2QRvKxcdDAaD7qCgHNdKrjtGKs3noOHbi0ozaaquO6m16jxEjYgTo/XfhfVBAJNnxqulumhME13XqYUqupdr2iQaEnI8rgIZ6cPQm8U4cKmhJjz6IyrlpYWQw+ePzHKDIwP+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892878; c=relaxed/simple;
	bh=XPX2XGhuipqJxit3cJHjqcV+gnl/GJl7cD6Dp9QsZUw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKxcReUkisKYKDcTh1m07h/gmQhdBH93ZgOZ5MjgZ1TpjPcwXu1PBCASX19/E2dpqqVN4IR/pZn3GfcMG/kyS2Onlax9yInBlS25gja7rADc8p4ohR7roxVMKzyg42X1TxnEy/g9fdsBcNJ0IVFVuveuyt8V8wG7DKYLk7GjEqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JbeJK/20; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JbeJK/20"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2B9A1F000FF;
	Tue, 13 Oct 2026 12:01:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892877;
	bh=FER243vGVZJS6o2mwmfqLnA95WdjSpTnnVmueVxoSa4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JbeJK/20KbyXLL4KdVDi9I4dT9VmTw6Ugx4AubYtNTdKJpax4JAtDrqQzPGyaR8mH
	 a16K2N8VzRFJiUDn4CHy/cpaVY2YTXa9Bkxh2KfvqrKfr/Qse1P+lhQ961+SmzkubX
	 pPv3TXhjn9MfrECY/K6qLm9aLqwn8tjs+gkA1iFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Huang <huanglu@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.18 038/621] wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()
Date: Tue, 13 Oct 2026 13:30:33 +0200
Message-ID: <20261013112921.768922308@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

From: Lu Huang <huanglu@kylinos.cn>

commit 52f6a065e0810c739a5dabd33a58047f08100f50 upstream.

When the eFuse block covering MT7976C_EFUSE_OFFSET is invalid,
mt7996_mcu_get_eeprom() returns -EINVAL without writing buf, but
mt7996_variant_fem_init() tolerates -EINVAL and keeps running, so
buf[idx] == 0xc reads uninitialized stack memory.  A stale 0x0c byte
misclassifies a 0x7976 aDie as 7976C, selects MT7996_FEM_INT and the
wrong default EEPROM, overriding valid calibration data.  Only consult
the eFuse byte when the read succeeded; with an invalid eFuse, fall
back to the three explicit aDie version checks.

Fixes: e8cb33ad546a ("wifi: mt76: mt7996: add support for more variants")
Cc: stable@vger.kernel.org
Signed-off-by: Lu Huang <huanglu@kylinos.cn>
Link: https://patch.msgid.link/20260930085435.1424493-1-huanglu@kylinos.cn
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -1178,7 +1178,7 @@ static int mt7996_variant_fem_init(struc
 	adie_ver = u32_get_bits(regval, MT_ADIE_VERSION_MASK);
 	idx = MT7976C_EFUSE_OFFSET % MT7996_EEPROM_BLOCK_SIZE;
 	is_7976c = adie_ver == 0x8a10 || adie_ver == 0x8b00 ||
-		   adie_ver == 0x8c10 || buf[idx] == 0xc;
+		   adie_ver == 0x8c10 || (!ret && buf[idx] == 0xc);
 
 	adie_id = u32_get_bits(regval, MT_ADIE_CHIP_ID_MASK);
 	if (adie_id == 0x7975 || adie_id == 0x7979 ||


