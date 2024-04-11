Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7829F64CC0;
	Thu, 11 Apr 2024 10:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832180; cv=none; b=mNKyeoYhCFfJ/b/oJZi4/VV33F34ADjKkijXQ+7+YPCorXEw72EABdZ7rNmsBam1VKPCB69ChputGtvUqT26faORihUtwiO6o7oQ6GGtyAebFyj+LT5p1VbqtDWjithMgaG7JVvTE44KeI2crUUEzxNjJORbgH3Wri0P+7NTmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832180; c=relaxed/simple;
	bh=y0NaD81Ao5zWOHLEotQ/Ce2Ruhes/QddpD+EbttzVho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IR8oHqKH8+3Yazog1PKg0331PHG7c3n793RKp4JXmEZS/NeJ+WPylCG6Ac4Am/bWNwo3PWRsYINLkCULgRMRsjmsQ99ypGpbXFrT0nHphAKwVVpYH4jxVK/F96ZYVCv6+T/yoQl7wnMDi5r6LrLAhH2oGp74M757L0zWYN8tEIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RXKrZ8ki; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RXKrZ8ki"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00FB1C433F1;
	Thu, 11 Apr 2024 10:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832180;
	bh=y0NaD81Ao5zWOHLEotQ/Ce2Ruhes/QddpD+EbttzVho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RXKrZ8kiC4C9GOrJUW3khX57F9ws7FFcvoVoXFpqtFJKTnMGgNFm21qn6rOZgCzo+
	 5V6tipJ0Il2szHQ013yJgPevyIM0gMnqAui1rwBgj4AD+eA5H4p3xRMkORb/hfrXKy
	 AmszrE95+yilmqyqX8zGcPpmL4dnYIWIuRgHiVuo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 229/294] ata: sata_sx4: fix pdc20621_get_from_dimm() on 64-bit
Date: Thu, 11 Apr 2024 11:56:32 +0200
Message-ID: <20240411095442.479887484@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095435.633465671@linuxfoundation.org>
References: <20240411095435.633465671@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit 52f80bb181a9a1530ade30bc18991900bbb9697f ]

gcc warns about a memcpy() with overlapping pointers because of an
incorrect size calculation:

In file included from include/linux/string.h:369,
                 from drivers/ata/sata_sx4.c:66:
In function 'memcpy_fromio',
    inlined from 'pdc20621_get_from_dimm.constprop' at drivers/ata/sata_sx4.c:962:2:
include/linux/fortify-string.h:97:33: error: '__builtin_memcpy' accessing 4294934464 bytes at offsets 0 and [16, 16400] overlaps 6442385281 bytes at offset -2147450817 [-Werror=restrict]
   97 | #define __underlying_memcpy     __builtin_memcpy
      |                                 ^
include/linux/fortify-string.h:620:9: note: in expansion of macro '__underlying_memcpy'
  620 |         __underlying_##op(p, q, __fortify_size);                        \
      |         ^~~~~~~~~~~~~
include/linux/fortify-string.h:665:26: note: in expansion of macro '__fortify_memcpy_chk'
  665 | #define memcpy(p, q, s)  __fortify_memcpy_chk(p, q, s,                  \
      |                          ^~~~~~~~~~~~~~~~~~~~
include/asm-generic/io.h:1184:9: note: in expansion of macro 'memcpy'
 1184 |         memcpy(buffer, __io_virt(addr), size);
      |         ^~~~~~

The problem here is the overflow of an unsigned 32-bit number to a
negative that gets converted into a signed 'long', keeping a large
positive number.

Replace the complex calculation with a more readable min() variant
that avoids the warning.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/sata_sx4.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/sata_sx4.c b/drivers/ata/sata_sx4.c
index 4c01190a5e370..c95685f693a68 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1004,8 +1004,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 
 	offset -= (idx * window_size);
 	idx++;
-	dist = ((long) (window_size - (offset + size))) >= 0 ? size :
-		(long) (window_size - offset);
+	dist = min(size, window_size - offset);
 	memcpy_fromio(psource, dimm_mmio + offset / 4, dist);
 
 	psource += dist;
@@ -1053,8 +1052,7 @@ static void pdc20621_put_to_dimm(struct ata_host *host, void *psource,
 	readl(mmio + PDC_DIMM_WINDOW_CTLR);
 	offset -= (idx * window_size);
 	idx++;
-	dist = ((long)(s32)(window_size - (offset + size))) >= 0 ? size :
-		(long) (window_size - offset);
+	dist = min(size, window_size - offset);
 	memcpy_toio(dimm_mmio + offset / 4, psource, dist);
 	writel(0x01, mmio + PDC_GENERAL_CTLR);
 	readl(mmio + PDC_GENERAL_CTLR);
-- 
2.43.0



