Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 305D915CAC
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:52:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A280DC433C1;
	Tue,  8 Nov 2022 13:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915573;
	bh=vgUc982+5um1Sj05/bcj04wJ6GHmCVIA6MCa4/+brT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=luwEoXhUgweNTVzmBdUOcclhZ2j8+CnRwH849O3mlgp0mCtQSLh5RrFmEntaqB9hx
	 R4yD+giJi06QakM7IQ/DC2YLXC4KGJMpL6RwdnoMCURUyJIbuo7h9N8CfYDpQcV8yV
	 8xm7kHLX+46sRQ0oXrGc1IgG01zHvzxXa+Tg0vPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <damien.lemoal@opensource.wdc.com>,
	Sergey Shtylyov <s.shtylyov@omp.ru>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 029/118] ata: pata_legacy: fix pdc20230_set_piomode()
Date: Tue,  8 Nov 2022 14:38:27 +0100
Message-Id: <20221108133341.923573184@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sergey Shtylyov <s.shtylyov@omp.ru>

[ Upstream commit 171a93182eccd6e6835d2c86b40787f9f832efaa ]

Clang gives a warning when compiling pata_legacy.c with 'make W=1' about
the 'rt' local variable in pdc20230_set_piomode() being set but unused.
Quite obviously, there is an outb() call missing to write back the updated
variable. Moreover, checking the docs by Petr Soucek revealed that bitwise
AND should have been done with a negated timing mask and the master/slave
timing masks were swapped while updating...

Fixes: 669a5db411d8 ("[libata] Add a bunch of PATA drivers.")
Reported-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sergey Shtylyov <s.shtylyov@omp.ru>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_legacy.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/ata/pata_legacy.c b/drivers/ata/pata_legacy.c
index d91ba47f2fc4..4405d255e3aa 100644
--- a/drivers/ata/pata_legacy.c
+++ b/drivers/ata/pata_legacy.c
@@ -278,9 +278,10 @@ static void pdc20230_set_piomode(struct ata_port *ap, struct ata_device *adev)
 	outb(inb(0x1F4) & 0x07, 0x1F4);
 
 	rt = inb(0x1F3);
-	rt &= 0x07 << (3 * adev->devno);
+	rt &= ~(0x07 << (3 * !adev->devno));
 	if (pio)
-		rt |= (1 + 3 * pio) << (3 * adev->devno);
+		rt |= (1 + 3 * pio) << (3 * !adev->devno);
+	outb(rt, 0x1F3);
 
 	udelay(100);
 	outb(inb(0x1F2) | 0x01, 0x1F2);
-- 
2.35.1



