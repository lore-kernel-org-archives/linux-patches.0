Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34E081ACEDA;
	Mon, 23 Jun 2025 21:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750713857; cv=none; b=ltN1mWBIOHETOMlzDxiNx8srsr9P1iuDwlItuH6sIbTTTq9ghVVPbzO1ZHYvZfxJZ3obcWqOr0vtzudbTyp3UxVN/B++t/a4wzUZo9k3fV0PmN5EhNDyZBfVYq+bK9GFWwbifsyDtjrsBK02J+a2LOF6B1e9Wt/VJn23ityHYoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750713857; c=relaxed/simple;
	bh=3FZ2qFlGaUZT5LC9KNPgRN3+YsxHWYsbVfIbsei6Otk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L4nx0JQElHwqfhq6B2xug36iJv4S9xb+QXdgdXsDge+PpFIYW6tRjhv8wfpkPiVU/ZD7sWbfJUri3uo+MbdZ107AiOGV32M/nIvdaFIL3Yz/gz/mHSyrcKIFnhq5fh0uBfsDd2qknPJswQAXjntg25CY9DYOVc3UVwSNN1UdlSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mw0rq4/W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mw0rq4/W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1019C4CEEA;
	Mon, 23 Jun 2025 21:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750713857;
	bh=3FZ2qFlGaUZT5LC9KNPgRN3+YsxHWYsbVfIbsei6Otk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mw0rq4/WWgLGbNIhCmcsxTR58m/q8Z6S2iMDCk/UlaRomEVLYH9j3anv3nIKjdccv
	 iwFTFfAA81aeN5o3kNlKA95rLH/ZKikvGJb4pJFui54bJlxMJJ+RU/qzwgVdzW8+yz
	 dJrFe4Lmvq6ctUVHwFfVbxvWFXC9N4EuKtZihkL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 6.12 087/414] ata: pata_via: Force PIO for ATAPI devices on VT6415/VT6330
Date: Mon, 23 Jun 2025 15:03:44 +0200
Message-ID: <20250623130644.261077874@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tasos Sahanidis <tasos@tasossah.com>

commit d29fc02caad7f94b62d56ee1b01c954f9c961ba7 upstream.

The controller has a hardware bug that can hard hang the system when
doing ATAPI DMAs without any trace of what happened. Depending on the
device attached, it can also prevent the system from booting.

In this case, the system hangs when reading the ATIP from optical media
with cdrecord -vvv -atip on an _NEC DVD_RW ND-4571A 1-01 and an
Optiarc DVD RW AD-7200A 1.06 attached to an ASRock 990FX Extreme 4,
running at UDMA/33.

The issue can be reproduced by running the same command with a cygwin
build of cdrecord on WinXP, although it requires more attempts to cause
it. The hang in that case is also resolved by forcing PIO. It doesn't
appear that VIA has produced any drivers for that OS, thus no known
workaround exists.

HDDs attached to the controller do not suffer from any DMA issues.

Cc: stable@vger.kernel.org
Link: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/916677
Signed-off-by: Tasos Sahanidis <tasos@tasossah.com>
Link: https://lore.kernel.org/r/20250519085508.1398701-1-tasos@tasossah.com
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/pata_via.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/ata/pata_via.c
+++ b/drivers/ata/pata_via.c
@@ -368,7 +368,8 @@ static unsigned int via_mode_filter(stru
 	}
 
 	if (dev->class == ATA_DEV_ATAPI &&
-	    dmi_check_system(no_atapi_dma_dmi_table)) {
+	    (dmi_check_system(no_atapi_dma_dmi_table) ||
+	     config->id == PCI_DEVICE_ID_VIA_6415)) {
 		ata_dev_warn(dev, "controller locks up on ATAPI DMA, forcing PIO\n");
 		mask &= ATA_MASK_PIO;
 	}


