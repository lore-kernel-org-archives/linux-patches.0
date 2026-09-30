Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA0C64F402F;
	Wed, 30 Sep 2026 16:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784012; cv=none; b=BTeujK9G+AaDzUmtOwnyheMccaiJo3/0emDh6NV8GExG81Wqe7SHvMUbk/Ngql9Ow9o23m9Rp3wPUO5dSUcWo4rjBmPHu7vu+i4MzHuc9ues/2z+W0fo6C8E1Ehpj1fXO0JP0xnZRCNycHv0nq/HREDHY0+36KxenyDYsinZDbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784012; c=relaxed/simple;
	bh=toZH6PuK+britBm9LaDXqmMa3dXkgaCymllgwdOC9yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GPV6dQnX8SazkjJsKLVD8JYzkwlOZnNUtdt7keDSW/va2Rz4hXon07UZCd/V4mr4AREyWkXzEtWYIWKevZaSdai8+NZHPehjgdlV4/IxvBbx6pt2ZHYNnBHhsc4PBMjOaafPJ09Abo5fHlgAJ1sjIr302uYLdzpHbfarZCkLoQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dsET+EtH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dsET+EtH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4625F1F00898;
	Wed, 30 Sep 2026 16:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784008;
	bh=veRsqi3QHi6MspCcUnavWRvGuUFfR7neJf+9uxJ8wXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dsET+EtHmM/f1vOTAzDRGiv72IQYu1mXiHrbQC4T+if1OoiCND/IrbxIpdiOq34hC
	 fpOJz0LGjhVxDo5uTLvyKEhT0mzjTQzfX9M7RSXUk0OBCxMOXy6J0jHOtKfKo4eRlf
	 nN/iDj/9HUppkZoOP5/CO1x0/5wGgVi36g9t+z6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 5.10 593/595] lan78xx: Enable Auto Speed and Auto Duplex configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:28:06 +0200
Message-ID: <20260930152400.493704646@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
User-Agent: quilt/0.69
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 799f532de13601f91ecb9cc6169d45d6e6933b0f upstream.

Enabled ASD/ADD configuration for LAN7801 in the absence of EEPROM.
After the lite reset these contents go back to defaults where ASD/
ADD is disabled. The check is already available for LAN7800.

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-3-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2839,8 +2839,11 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	/* LAN7801 only has RGMII mode */
-	if (dev->chipid == ID_REV_CHIP_ID_7801_)
+	if (dev->chipid == ID_REV_CHIP_ID_7801_) {
 		buf &= ~MAC_CR_GMII_EN_;
+		/* Enable Auto Duplex and Auto speed */
+		buf |= MAC_CR_AUTO_DUPLEX_ | MAC_CR_AUTO_SPEED_;
+	}
 
 	if (dev->chipid == ID_REV_CHIP_ID_7800_ ||
 	    dev->chipid == ID_REV_CHIP_ID_7850_) {


