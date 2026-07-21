Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46E44471439;
	Tue, 21 Jul 2026 20:02:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784664166; cv=none; b=ZH0oi/a7UJhJT85S+E0c/dDIcXYq5iFJ6X+0fyiMwhba0hePjQS3hDO1ycRntVnrRLR8TH2iIvpTrZ019GvAvn1DsyD2prrM6zT2ZxXAjdoi577QD8xgiLJ3nMIgDXTnNcrBCALbQMFu0YSUJIzkhlqWiRE3PVI+8Flx+nzhVxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784664166; c=relaxed/simple;
	bh=Nw5NuTQ1yjVGxuOUBc2NjtpzON3+5TIopRXoTNCOHQU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nu7CrZ2aK45fUSDsBMKVmOw5kvm9S/e6vioZdfMikqWwz6qyu9yJJxR61aUAhd/MUll4MUMltJ7Gcig9Tc5wGyOHjeIzGBNFeuNoNfvowMApus2vafSZ98vpjQi5ay9r9wDd7i3EMK6OZZmlLOwL8i3JcSJfkHUPPUEggw0NzTU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09lmBuJ4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09lmBuJ4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC7041F000E9;
	Tue, 21 Jul 2026 20:02:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784664165;
	bh=vvwTwzJKihjB6y11V6F6+m79EkEzIfxmKNxUdcxStpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=09lmBuJ4vV3IVFp4r71N3VyeywxecUyG4MdGmYqmOJwzjf0hbxuzLSEH6OrSC9CbZ
	 T8QM9YBQWgDcYdyyN0oY6KDZfnBsouNcEaWepDXpyz+E0FIUiKZ8UNUe1blFJCj/E/
	 eyyNTWgtKUNkJ+hwYxfXl5mYf9+Vb7eDv2IFKLbg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Terrence Adams <tadamsjr@google.com>,
	Damien Le Moal <dlemoal@kernel.org>
Subject: [PATCH 6.12 1096/1276] ata: libata-core: Skip HPA resize for locked drives
Date: Tue, 21 Jul 2026 17:25:39 +0200
Message-ID: <20260721152510.512556296@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


