Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624230;
	b=wKF1Vbw8JDKJMzst7/Lz1SV2tNcwyWbkK+FKeQjjv4caeZSXGTJ+QeHvhaRjCggEPPXD
	 Nt9hvD1l/mq4Da79Wf9JQ18G2ZF/rJ4Y2QNspuns/+6XXPtiujbaE7lltCZHZy87ZJMWM
	 J0vCLDNw8z4bMwMcbbfJKar/nyLC8ikpl2raxPgcWlVbq1bLhAb3z7iEnpzpaUpaykLQl
	 4DETcpiSECK6JZNZLMy9TjGAxbESlnF4cS76XbeFnMh+4zaNDkOG/8+fnZ/EHOJzfeA08
	 PmM+I0hbSckd3b8SLmBjoFfJAl1XBeuf6fQjkHkEnA3BjgP98O6Dj6zprYRD/AgOWAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624230;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=r7gvARbgR1WJah1Zplssb7CEj8Fqx75eeyFbBZdJbrI=;
	b=bdcNez/m7jvc41+8Jt5n/BJPu85dfKwnbbfrpy0hvz3YvR3RyvIYcntZLKmltLE9KXDa
	 kDf1NihrigTIb0JzhOq61nVk4OHNiOi7Dsq/wdjs6zmn2wGM8YVPI4LnFu0Of9z2JbYt7
	 dF6lBKEEExbAnDahlRUKTNX79vMwyMVltUnSUzL3J9/o9vifmRRWG/Xzdxa5pAET262os
	 +MK+nUhUgQp2cZ4xHVG/5Iypg1gsVJNYyhBcZfHrLVd0hoKrC+OlDa+VZL8wfRXxXCu9I
	 8uNtD4P9HBFo29o96fqGz7CEd+YTnoiQ3sGLYNOxpTsd3KNCwzYRZzP95u2eEoMerZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UB3H7usB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21564606A33E;
	Wed, 25 Nov 2026 16:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UB3H7usB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5381F000C0;
	Wed, 25 Nov 2026 16:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624230;
	bh=r7gvARbgR1WJah1Zplssb7CEj8Fqx75eeyFbBZdJbrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UB3H7usBGvpa1BWo+1s+OEwW5nMTRO71r6hsWO2qemUK/WDNJGS/SLeWf7oh0Av2K
	 0tJeTIbs2lLt3Oa5YF8RXCh7fTkhAmnIjp1PkFNyNQpCf8g4+3vzoATpQdX4gHym49
	 Ov8fj/Ask6oXh3NMA+GILw6AhiPPXLnxFtSWJGSk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Giuseppe Piscitelli <ooonea@gmail.com>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 124/816] ata: libata-core: Check device support before querying power state
Date: Wed, 25 Nov 2026 15:27:52 +0100
Message-ID: <20261125143852.077203177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Giuseppe Piscitelli <ooonea@gmail.com>

[ Upstream commit ec585ac78742527f80495dd8f451dcda7e9e7f59 ]

The standby path queries the power state before checking whether the
device accepts ATA power-management commands. This sends CHECK POWER MODE
to ATAPI devices, including the QEMU DVD-ROM, which rejects it.

Run the existing taskfile initialization and device-class check first,
as the active-power path already does.

Fixes: 9cec467d0502 ("ata: libata-core: Do not call ata_dev_power_set_standby() twice")
Signed-off-by: Giuseppe Piscitelli <ooonea@gmail.com>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Link: https://lore.kernel.org/r/20261026202513.669084-1-ooonea@gmail.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/libata-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index b1947e4e534f6..1424c90f8bead 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -2045,6 +2045,10 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	struct ata_taskfile tf;
 	unsigned int err_mask;
 
+	/* Issue STANDBY IMMEDIATE command only if supported by the device */
+	if (!ata_dev_power_init_tf(dev, &tf, false))
+		return;
+
 	/* If the device is already sleeping or in standby, do nothing. */
 	if ((dev->flags & ATA_DFLAG_SLEEPING) ||
 	    !ata_dev_power_is_active(dev))
@@ -2063,10 +2067,6 @@ void ata_dev_power_set_standby(struct ata_device *dev)
 	    system_entering_hibernation())
 		return;
 
-	/* Issue STANDBY IMMEDIATE command only if supported by the device */
-	if (!ata_dev_power_init_tf(dev, &tf, false))
-		return;
-
 	ata_dev_notice(dev, "Entering standby power mode\n");
 
 	err_mask = ata_exec_internal(dev, &tf, NULL, DMA_NONE, NULL, 0, 0);
-- 
2.53.0



