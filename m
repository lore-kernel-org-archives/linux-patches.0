Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932A72550D3;
	Mon, 23 Jun 2025 13:34:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685654; cv=none; b=kMQc9bhyLDCFx5p/W5FhFdCw85GGRhmcwUYLOea3V2IjN1tzX5k2lb0G5Bs1yY61CXWacDB6rNB0BUwLA+u3B4bIDddS5ZXevshjN+UGd85T2rXplDiCrFiYHl+3u9ae5f5MMNLVAqgkInqO6OZ+1+uHBuvaJ9/PgPzyefkCy6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685654; c=relaxed/simple;
	bh=zgI3tEJzyMhFfbCPg0SFMj8wcr2R1CRzwxXrtp3jM4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eydr7TGj+DMliAciuwqJBDSxw4Nrf8+rNgX1a6y8qYlGeDuWsIeinDQBWF4gigczaZWo429sqPeyokvjUNbMXrJNb7n1kWS/LuLmmAe+ESggv8qJW6X+GmyeYDBhsx3wlgYaVul5t1w5gBmvkeNaXeKb5K4lcdZvIrrxafpCq04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jihywH/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jihywH/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBB0BC4CEF1;
	Mon, 23 Jun 2025 13:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685654;
	bh=zgI3tEJzyMhFfbCPg0SFMj8wcr2R1CRzwxXrtp3jM4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jihywH/l0JidRBcdH1HUdk8UOOT4L7X4h/TE4CqI8HPnxnDz9aMhREKtxpvA5TWS
	 HVgB4MexX8ANd4CWLVGxWYX2+fmokbjtg43fmGw19tb9I9rKaGQ8mN33eRgHN0h7Tl
	 mXngTFyscWDrpnB37PIh8yBE7BM8EUC1mUwagLJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tasos Sahanidis <tasos@tasossah.com>,
	Niklas Cassel <cassel@kernel.org>
Subject: [PATCH 5.4 110/222] ata: pata_via: Force PIO for ATAPI devices on VT6415/VT6330
Date: Mon, 23 Jun 2025 15:07:25 +0200
Message-ID: <20250623130615.417424433@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
@@ -368,7 +368,8 @@ static unsigned long via_mode_filter(str
 	}
 
 	if (dev->class == ATA_DEV_ATAPI &&
-	    dmi_check_system(no_atapi_dma_dmi_table)) {
+	    (dmi_check_system(no_atapi_dma_dmi_table) ||
+	     config->id == PCI_DEVICE_ID_VIA_6415)) {
 		ata_dev_warn(dev, "controller locks up on ATAPI DMA, forcing PIO\n");
 		mask &= ATA_MASK_PIO;
 	}


