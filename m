Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B021D1474CC;
	Tue, 21 Jul 2026 18:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659291; cv=none; b=YGOsfJXPInHpktuJaFPQI0aZvLtwzCkApRmpzwP38gKybhXjMRn68OH2LoZbhBJXxt65lcNPrCLpZZTRMX0JM+rfHKoL3phIYYwKMMQuUQ9qFKiP/9gcQGodbkxWLTlIdBOPwe5AHWU48CRteQEwMukMBGClchzrJeqcJRNqg/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659291; c=relaxed/simple;
	bh=SRZ855emzKyUIaw4mzyjQ6vEJcrEFShkCHw2hohABnw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TnLberbxqfAFBQsH0JxgPxVqgpKRHmvhYt9IvXGfX7kq0Tcv7/VAb9Q/7shfskYLTSS6Z15GSd3UZr22YwRdBHT7tyiLWW7Kk8Z3q0eXfTfYnz+e+oO/5obxrsCFy7Ltzp8Lf6VzERI+j4O373dZV2tmdoODXgYzjtw1u+Td0ls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SVAPZROt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SVAPZROt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB60A1F000E9;
	Tue, 21 Jul 2026 18:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659290;
	bh=Piz3+5YdX7MiLAZ1KNABldxTaBVn+gncSGq/JYhEs8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SVAPZROtKUwXeCX5ncd/9Hkq1hX1itY2qsHAFFSqePX3bIalD8Av7iCO1+ee/gkrN
	 jjUUXRqSu43CHSOX1/ohuiNpYFbXg4z8RIu1fckySnzMldgi4j7vuNgUAhBTd+oDYd
	 0/25dDg8QWa0XpPCjES8O9dRY3aO0B3mwRQhkIUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.18 1465/1611] ata: libata-core: Allow capacity transition to zero for locked drives
Date: Tue, 21 Jul 2026 17:26:21 +0200
Message-ID: <20260721152548.398214116@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: TJ Adams <tadamsjr@google.com>

commit 793bf193b18e9bff6c4280268bbffd16a5b533e5 upstream.

Commit 91842ed844a0 ("ata: libata-core: Set capacity to zero for a
security locked drive") introduced setting the device capacity (n_sectors)
to zero in ata_dev_configure() if the drive is security locked.

However, during runtime revalidation, ata_dev_revalidate() compares the
new capacity (now 0) with the old capacity (>0) and detects a mismatch.
Since it does not consider the locked status, it returns -ENODEV.

This revalidation failure can occur when doing a reset of the PHY (e.g.
hard reset) for a controller that has I/Os in flight. The timed out
I/Os trigger the SCSI Error Handling (EH) path, which in turn invokes
libata device revalidation. If the drive is locked at runtime (e.g.
it lost power during reset and relocked), revalidation sees the capacity
transition to zero and fails, eventually disabling the device.

Fix this by allowing the capacity transition to zero in
ata_dev_revalidate() if the drive is reported as security locked by
ata_id_is_locked().

Fixes: 91842ed844a0 ("ata: libata-core: Set capacity to zero for a security locked drive")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.5-flash
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -3963,7 +3963,7 @@ int ata_dev_revalidate(struct ata_device
 
 	/* verify n_sectors hasn't changed */
 	if (dev->class != ATA_DEV_ATA || !n_sectors ||
-	    dev->n_sectors == n_sectors)
+	    dev->n_sectors == n_sectors || ata_id_is_locked(dev->id))
 		return 0;
 
 	/* n_sectors has changed */


