Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28F6A49218D;
	Tue, 21 Jul 2026 17:34:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655252; cv=none; b=M5IJja3rcQ5zM1nt3qrCb7vMvnzo+WXK8OOWpw8tEww67dNelsYqL472n2SFlvpt3FWoAfuG5nct0ug++33jmd1HOpsR60H+xxr1KgWa4ou9V3MciqI65jOE09RY/uph4SFASFWGhBrqb4hXG2kTp/FSK8PquJny5Dzmd/H6LOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655252; c=relaxed/simple;
	bh=Z7/BCMikCvDz6RqhJJbs5rCN4O0/xuC9CLbiKvwgN/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I5l5uMH+4pI5MSAvmlKNxLVPpSdBqa+iAIOUzNJFVWEkNRtpKqmKSoCfaHNeFf3c67K332VndmPLX/RkzmtDrimbyQM6dPU260bejjXdQSd/933wbT8fho96RWGLL0Ax2dNXBztfMLKWfl/Zjxl1tn4fM2HcO9JHLxyNcvk1OPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NPOtgN53; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NPOtgN53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F6101F000E9;
	Tue, 21 Jul 2026 17:34:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655251;
	bh=qO4FoEDTVGvVFBdAVdNGNJVQgqmIyR/pPTbYPeONsCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NPOtgN53GnaP6PoFw6ywaf1+f9BXS3yxu7HkVF3PlET/8FCcP97ctyCI+Rp0s9wmt
	 I2bkrVDE0W+WG/5TYQRdi12s/zsw7uYNBgjqLKfbTdkiJLFqvZCflPDIzvtjgG5/Q5
	 IUHn4Pb3XFScTLMiSiSa9UrhHp1w5SdPWr9+jTmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 1986/2077] ata: libata-core: Allow capacity transition to zero for locked drives
Date: Tue, 21 Jul 2026 17:27:39 +0200
Message-ID: <20260721152639.553311596@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3992,7 +3992,7 @@ int ata_dev_revalidate(struct ata_device
 
 	/* verify n_sectors hasn't changed */
 	if (dev->class != ATA_DEV_ATA || !n_sectors ||
-	    dev->n_sectors == n_sectors)
+	    dev->n_sectors == n_sectors || ata_id_is_locked(dev->id))
 		return 0;
 
 	/* n_sectors has changed */


