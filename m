Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2467B15492
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJSHaqkH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 927E7C433CB;
	Mon, 23 Oct 2023 11:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060226;
	bh=aT92nxBTcUtelMFZSpeaDQxwWNS3vvYy9d+RKVMeMGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bJSHaqkHiQ/DZF6O5TJYzUnbZXtNkVviHopbHYwQUwdxiuzwtzg0D+wdK2fDU0K3H
	 smBuCicGQGHh0BjTlcR1fxkcrtIDbAnbs83t6p++wgJVj7WzmPUPKFIzAFzNU26Bsk
	 FeGKA4ejF3t9MtjTtq2BDohNBcNPeuiH3lPBhX3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Hannes Reinecke <hare@suse.de>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 100/196] ata: libata-core: Fix compilation warning in ata_dev_config_ncq()
Date: Mon, 23 Oct 2023 12:56:05 +0200
Message-ID: <20231023104831.365757348@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

[ Upstream commit ed518d9ba980dc0d27c7d1dea1e627ba001d1977 ]

The 24 bytes length allocated to the ncq_desc string in
ata_dev_config_lba() for ata_dev_config_ncq() to use is too short,
causing the following gcc compilation warnings when compiling with W=1:

drivers/ata/libata-core.c: In function ‘ata_dev_configure’:
drivers/ata/libata-core.c:2378:56: warning: ‘%d’ directive output may be truncated writing between 1 and 2 bytes into a region of size between 1 and 11 [-Wformat-truncation=]
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                                                        ^~
In function ‘ata_dev_config_ncq’,
    inlined from ‘ata_dev_config_lba’ at drivers/ata/libata-core.c:2649:8,
    inlined from ‘ata_dev_configure’ at drivers/ata/libata-core.c:2952:9:
drivers/ata/libata-core.c:2378:41: note: directive argument in the range [1, 32]
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                                         ^~~~~~~~~~~~~~~~~~~~~
drivers/ata/libata-core.c:2378:17: note: ‘snprintf’ output between 16 and 31 bytes into a destination of size 24
 2378 |                 snprintf(desc, desc_sz, "NCQ (depth %d/%d)%s", hdepth,
      |                 ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2379 |                         ddepth, aa_desc);
      |                         ~~~~~~~~~~~~~~~~

Avoid these warnings and the potential truncation by changing the size
of the ncq_desc string to 32 characters.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index fbc231a3f7951..fa2fc1953fc26 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2456,7 +2456,7 @@ static int ata_dev_config_lba(struct ata_device *dev)
 {
 	const u16 *id = dev->id;
 	const char *lba_desc;
-	char ncq_desc[24];
+	char ncq_desc[32];
 	int ret;
 
 	dev->flags |= ATA_DFLAG_LBA;
-- 
2.40.1



