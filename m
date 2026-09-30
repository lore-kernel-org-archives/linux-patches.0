Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAE8C51C060;
	Wed, 30 Sep 2026 18:25:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792727; cv=none; b=OD9XJGjDWkLOx3ZfOIY0X72AQkTNs4t4lHkRfFLwxhrKdVKtAo1d97E9LVyIfiXjWGnr1NQrQzmxwJYBGEOXeMixtvELluIWNM4rsXojfK6g8WVuo5oGfeWrER9pyUKNtO1tYuTtZMFkjeye+f9XvIymZ0Xa96YQFbWXGsm95zY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792727; c=relaxed/simple;
	bh=+LgiVbH9PrnsD9eel1eg1P2Le94/KkNqRKKy6PzZmzg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qTwRqJJB124xS1DdNd/YWXN8DZMVErsISIKxhfIMV+wWVzdlT36RK5aS3Hr0PpS02ZqhlBF3o3YdekyaOrAOKk9GdD+Y34BzzbWkmKqWG7wLKNbsHhGVLG86bHCEsP++K1FQwFDJoixKiSF8jrLsZbg+KyEIueWAxedYlPLjScg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DPMpejKm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DPMpejKm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 241FB1F000FF;
	Wed, 30 Sep 2026 18:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792726;
	bh=AJi7yUnS4PSdn8ZVEJ8dZRm+7C6GvTzvmdlpSdJWx54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DPMpejKmEyzMzlXzT0NVX5Sn9FKoArG5vQNC3DA7gLU5bbK5MMQUcIvh2RzKIRdxF
	 ODDfThunUS9t7EQ8atG7xFwZHH2glzPIZr77dMXVrLQbcPvy91dy7wOUU+6NH70qut
	 7a5kiuNn0D27ceuO7VGmv5suc0AiIezWgcYe5IdM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	=?UTF-8?q?Minh=20Ti=E1=BA=BFn=20Nguy=E1=BB=85n?= <zizuzacker@gmail.com>
Subject: [PATCH 5.15 750/752] lan78xx: Enable 125 MHz CLK configuration for LAN7801 if NO EEPROM is detected
Date: Wed, 30 Sep 2026 17:30:20 +0200
Message-ID: <20260930152414.445137548@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rengarajan S <rengarajan.s@microchip.com>

commit 5160b129f65fc6e1a4aa282d44f824e12aa800ee upstream.

The 125MHz and 25MHz clock configurations are enabled in the initialization
regardless of EEPROM (125MHz is needed for RGMII 1000Mbps operation). After
a lite reset (lan78xx_reset), these contents go back to defaults(all 0, so
no 125MHz or 25MHz clock).

Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20240529140256.1849764-2-rengarajan.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Cc: Minh Tiến Nguyễn <zizuzacker@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/usb/lan78xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -2804,6 +2804,8 @@ static int lan78xx_reset(struct lan78xx_
 		return ret;
 
 	buf |= HW_CFG_MEF_;
+	buf |= HW_CFG_CLK125_EN_;
+	buf |= HW_CFG_REFCLK25_EN_;
 
 	ret = lan78xx_write_reg(dev, HW_CFG, buf);
 	if (ret < 0)


