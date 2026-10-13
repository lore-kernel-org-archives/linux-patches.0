Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3575F3B1EE7;
	Tue, 13 Oct 2026 11:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892154; cv=none; b=pdGUuGntxrl9KzsJBWer6gQDzP8mOJQ6MOt5eGwSheGrolTX35wSg8usMRbeiYV16qopeqwQWDpx6zRubMTrYZiQbLGKGyqf9rpX6KNehSsyJYWBFfceezo/7YmSPNc9/QQdy4fikyIo4rTQT9Hkv86ker6R7YkC1OvDNNUVtMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892154; c=relaxed/simple;
	bh=e8dgn+U8usVs8YsHkULT/XjaK3P2GXlTp4FYqwVYN30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qxegWdH1NitYZgPPJCbVZl18P4iO8Pq1YVTC/iVK8la7ySLWXZTyPoWBmEqVKGA8MyVK+03fOYnD2n/semfyflToMK8SNJRQBxgNbFXDRcoFMGJlnt80YwKjpJ67sy811OO3Iime0/YhR1rSG6Zt6RkfFGXz/fcDQGFqQsgr7F4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EI/o3Ihm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EI/o3Ihm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D3DE1F000FF;
	Tue, 13 Oct 2026 11:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892153;
	bh=OWsWN3kUAMlgL/XwASgLn7dUl3CAW9jc1/Rk8qtcvDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EI/o3IhmG7S/KGh9fR+U/SMwMcHdR9PKMTJLrKjz2nFx8hazRnTruNX7XsqO7swxB
	 Zurf2ceZRWteNf6fk9BiAykx2XkcyjI9rPCLVTlfqvl7GzUX7xOzJoTsACSgEoF6hi
	 jXEQJ+nL+4wjQrHbuAjFV82I8m0nd64hDAJiZD0Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Huang <huanglu@kylinos.cn>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 7.2 033/281] wifi: mt76: mt7996: fix uninitialized buf read in mt7996_variant_fem_init()
Date: Tue, 13 Oct 2026 13:35:49 +0200
Message-ID: <20261013112855.857565248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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
@@ -1237,7 +1237,7 @@ static int mt7996_variant_fem_init(struc
 	adie_ver = u32_get_bits(regval, MT_ADIE_VERSION_MASK);
 	idx = MT7976C_EFUSE_OFFSET % MT7996_EEPROM_BLOCK_SIZE;
 	is_7976c = adie_ver == 0x8a10 || adie_ver == 0x8b00 ||
-		   adie_ver == 0x8c10 || buf[idx] == 0xc;
+		   adie_ver == 0x8c10 || (!ret && buf[idx] == 0xc);
 
 	adie_id = u32_get_bits(regval, MT_ADIE_CHIP_ID_MASK);
 	if (adie_id == 0x7975 || adie_id == 0x7979 ||


