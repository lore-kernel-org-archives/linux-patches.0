Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A95C146010;
	Thu, 11 Apr 2024 10:04:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829894; cv=none; b=ng2/GnjCCM9nw5PNIjyJU8DFp06KMvWPTZ/gwm/L4B7XWYtY0zFNp8SSudJG5dubUN5fq+LJfJqJeta42jw18gArXGCkbG30CbFxpl7xJY3MLdzf2+PV6mcngrevjEvskQHZYL/gNbdl76UrdICV8gd9MDBHnMKFJNX/D3oalL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829894; c=relaxed/simple;
	bh=QZCYQLdkDpsmmUS06EKe9Mw7sNRi6GxqTQ+Iq9HV3Z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtZUD3l3TvH9YcIFSvbhdlzqOqDKimju6P5YUuHYI2lAQm2PlXqWOw57EPateg+erk6xfzE8Ur33KFQHUqxeEXYaBpPrb7xNgnqI4QCLM3h/Z7iAmxx+VLn+OK37MSGhJEkmQnO5vkzHNHChOxOh3pwxBBv/j8mnUzTW1kU3ybQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qThrIlcJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qThrIlcJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F253C433C7;
	Thu, 11 Apr 2024 10:04:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829893;
	bh=QZCYQLdkDpsmmUS06EKe9Mw7sNRi6GxqTQ+Iq9HV3Z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qThrIlcJXwDtNLSlOZ+Wky6xNRejjZL+wXroro/loK19Br8Rs2orN8Fm6VeuDFxXN
	 7jdKs4GDa1e1pKApv4YLXmpaC5+ilj3byacAFO9DOirVbAxNtVrAzlROnN69EH5o7w
	 Ymr/QSmmHqWCTmaqKyZPqeglEqevEih/KYvlQCKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Damien Le Moal <dlemoal@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 141/175] ata: sata_sx4: fix pdc20621_get_from_dimm() on 64-bit
Date: Thu, 11 Apr 2024 11:56:04 +0200
Message-ID: <20240411095423.809851979@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 0d742457925ec..f217ac8e17b15 100644
--- a/drivers/ata/sata_sx4.c
+++ b/drivers/ata/sata_sx4.c
@@ -1020,8 +1020,7 @@ static void pdc20621_get_from_dimm(struct ata_host *host, void *psource,
 
 	offset -= (idx * window_size);
 	idx++;
-	dist = ((long) (window_size - (offset + size))) >= 0 ? size :
-		(long) (window_size - offset);
+	dist = min(size, window_size - offset);
 	memcpy_fromio(psource, dimm_mmio + offset / 4, dist);
 
 	psource += dist;
@@ -1069,8 +1068,7 @@ static void pdc20621_put_to_dimm(struct ata_host *host, void *psource,
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



