Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55F0B403EB9;
	Tue, 21 Jul 2026 17:33:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655223; cv=none; b=Jyft1RiMPTBfHdB+9i9f6Iow0PIN1kt+JWeXCra9yuSWm3XWDO9Uae5oNhswAzOhzLKu4ZfyqXmU3Z+T0MMAl3PTL59+U+Q/6G7GDPG68SMMpqcKyC7TiMwk+8ntwJNka57gTQwYoAyYAR682egqEH7gChcgV1Za5vk095bNzEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655223; c=relaxed/simple;
	bh=lZIffXaYEzZkPrdtZ2SS23hT/uhgDCn6SM302WLlm04=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h7/GxYUcr3krb8/NSh27trh5a2T0Ur87HsbSPWC2PqmVYVMP34cgNDZuRxpCakY0aljc5zZltbKWQTzDn6rR6Jyuz4uv5qfY07y0aWeaqMXAvicr64eCBbyGfi/2i1vCos4A0baLWaQ4bLo/7ViDS3nbusymDXIddsBUpVuSXrQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l8KhtjJJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l8KhtjJJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7F3A1F000E9;
	Tue, 21 Jul 2026 17:33:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655222;
	bh=9XtF6+jFcbXBlGUu1CtYnV5gNSoGbn2a+8vBReulb2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l8KhtjJJc1u6MdE7Q6SdfBZlD6yR7H09ZuQDpR7L1XrM5JG5aBMCW84BExFujIGcI
	 KF8V/o2XU0eFV7W2rGdtQmLiKSlVZuT3kQf9gQNEvApNn1VVenzQ8te0hUvTeiwi29
	 IxwO2gQl9oyv5n9Q45oC0zGiroY/MSV619TJ8M8U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 7.1 1985/2077] ata: libata-core: Skip HPA resize for locked drives
Date: Tue, 21 Jul 2026 17:27:38 +0200
Message-ID: <20260721152639.529519459@linuxfoundation.org>
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
@@ -1338,7 +1338,7 @@ static int ata_hpa_resize(struct ata_dev
 	/* do we need to do it? */
 	if ((dev->class != ATA_DEV_ATA && dev->class != ATA_DEV_ZAC) ||
 	    !ata_id_has_lba(dev->id) || !ata_id_hpa_enabled(dev->id) ||
-	    (dev->quirks & ATA_QUIRK_BROKEN_HPA))
+	    (dev->quirks & ATA_QUIRK_BROKEN_HPA) || ata_id_is_locked(dev->id))
 		return 0;
 
 	/* read native max address */


