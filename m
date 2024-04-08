Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0465A128372;
	Mon,  8 Apr 2024 13:36:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712583390; cv=none; b=I9KYh0SFG0yfrx+2dxEWAIL1R9+E6lLQ09OKdkvGUncalV8XqTieOvloNPzSC6JallO3vZv8508TP/VdbRaG6ImIM63tlylgs18IYZTsxiabl6sVOR2ZC6TwpmSKk8O29jvmQ9ZnJnJL9q3sPHhAXPliqY7lxmh1HIVReG4Tx0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712583390; c=relaxed/simple;
	bh=du+Srk0KS5XSprjg4t3Z2MfgdWpqKKbD7LGAGiyrPVY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fu1p5r8SiEVedchiZERQE2wP8BpbtVCSN9fjSeMyqidXmP+zPR6tnrOmT8gq+ZAF8ostZZmZYNcqCXt/Exqv692+s8Rb8KAwnHkF7y49WfCIMupGT8/k5SHWZiwW6GkkX3ExWa6zuOuDYKiPqyGqXv0etwaOZjWtZrPip5ezR/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cpA015cv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cpA015cv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F06C433C7;
	Mon,  8 Apr 2024 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712583389;
	bh=du+Srk0KS5XSprjg4t3Z2MfgdWpqKKbD7LGAGiyrPVY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cpA015cvf9cgZaNGQonzujn6/lrQOWat6AMfB7n/FY9BgyFsO2SUfAfGAucl716Gu
	 862bcT5Jsn9dL8ETtvvIMX/NF0vPGnP8USw2rQNQMbKkymwtjw1dqzo1YBd0EZC/tN
	 BHw5TgZ6LSBfmOmmbz43gO130pssp35KoKqmz1C0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 174/273] ata: sata_sx4: fix pdc20621_get_from_dimm() on 64-bit
Date: Mon,  8 Apr 2024 14:57:29 +0200
Message-ID: <20240408125314.663373020@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125309.280181634@linuxfoundation.org>
References: <20240408125309.280181634@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index b51d7a9d0d90c..a482741eb181f 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -957,8 +957,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 
 	offset -= (idx * window_size);
 	idx++;
-	dist = ((long) (window_size - (offset + size))) >= 0 ? size :
-		(long) (window_size - offset);
+	dist = min(size, window_size - offset);
 	memcpy_fromio(psource, dimm_mmio + offset / 4, dist);
 
 	psource += dist;
@@ -1005,8 +1004,7 @@ static void pdc20621_put_to_dimm(struct ata_host *host, void *psource,
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



