Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C68673264FF;
	Tue, 21 Jul 2026 18:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659288; cv=none; b=PQ0MjxF0Ytvzn3FdbDHSPK8gja8xyOUKOGxm2fA03XzUIRvwd3ruVi9C/oMIMEcxqu5qOiMYoAlvRu5W6iQjmIIg6YFDJ9eeJOe2uEkW0EQJ+aUOHhYsGmDlsEBOA8YCQG1VH5WKWdHCfr7DgdvEtLxTaIAqrPMCIdC2uDDnVUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659288; c=relaxed/simple;
	bh=S87usd8+PApMCdK3DkBj/kAeaq9mx5F1lxTrOyzhXNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qb0a3ttxXnSBO5PEO28BgseaXiOpjihxuG3fyBbZhqiERHMIMoxktHkvo41Ln0r5EJcgtVc1wvVUUfhoTDhm5HPY4mTV+VHq/sVrmszpjJDdy4Ar2dnGHjkMk03ffJGwk1PIY1aBmUWKc2qoChLdSqCbWeb9uWA2Unr6za/1Ds8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HcWq9MH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HcWq9MH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DC3A1F000E9;
	Tue, 21 Jul 2026 18:41:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659287;
	bh=B+HaVBqcVb9q8tL65GOCaTd7R3KXPuVzccqqae000oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcWq9MH4M+HAhUSaT3XrvN5xJ48CBEpivbQurk6RRmVki4NnRpLmkf3Keq1+CGI3J
	 sRNVJALoWN3nj3RKiYJJzGPmGPpdDp/St4KcJbKbaAeM9RKR0BCKHolmghQBelUJW4
	 8U0al4zBCNgOOTPsV8i3dvxDyilIiEhkxMtZuGK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.18 1464/1611] ata: libata-core: Skip HPA resize for locked drives
Date: Tue, 21 Jul 2026 17:26:20 +0200
Message-ID: <20260721152548.376444792@linuxfoundation.org>
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

commit 917d0a4b95ea7ba01ed6296fb808f752d5d81107 upstream.

Skip HPA resize in ata_hpa_resize() if the drive is security locked.
If the drive is locked, the command to read the native max address
fails with -EACCES, which currently causes the sticky quirk
ATA_QUIRK_BROKEN_HPA to be set on the device.

Setting this sticky quirk causes subsequent revalidations (after the
drive is unlocked) to bypass HPA checks, preventing the unlocked drive
from exposing its full native capacity without a reboot or device removal.

Cc: stable@vger.kernel.org
Signed-off-by: Terrence Adams <tadamsjr@google.com>
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1324,7 +1324,7 @@ static int ata_hpa_resize(struct ata_dev
 	/* do we need to do it? */
 	if ((dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ZAC) ||
 	    !ata_id_has_lba(dev->id) || !ata_id_hpa_enabled(dev->id) ||
-	    (dev->quirks & ATA_QUIRK_BROKEN_HPA))
+	    (dev->quirks & ATA_QUIRK_BROKEN_HPA) || ata_id_is_locked(dev->id))
 		return 0;
 
 	/* read native max address */


