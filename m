Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC3C22DFF3;
	Mon, 10 Mar 2025 17:58:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741629527; cv=none; b=uVDgOIgLBAdXp7BbgoSLcgDsVuyBmxDchGWapJI1Vn6Ka4bZAAfxfYOkH0hxKbNdKDsoXqGUqbOkq/ND3gHvCfDB6fVBWQgs2xeUiYFFAxxHhMdC8WzxEQEitqxczsbRdBifq2hde8H0MJZrzXDVsFPkqcWT8HJjy++b6iBKH+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741629527; c=relaxed/simple;
	bh=d2obqB14xG8FVd2oODS030nZnBuR/cDDNIHN38a/Uzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C2HvUm2I/QSnDmmjYNufxdN6lEctLyCwrVvpHEE3ILdPQHz8hlu7Ib75UQMKLm4JzRU8QzBUWbNbCBmDkZhLBn/ouSc1+i0mptIdiYdhF9Nr8TMaPojpmMz6YhqCmJGmbt0tEACT0SU2zeQ/Puhkd1zxU1ScKg0bi1SnYbgu3kc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UN1QiEel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UN1QiEel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6564BC4CEE5;
	Mon, 10 Mar 2025 17:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741629527;
	bh=d2obqB14xG8FVd2oODS030nZnBuR/cDDNIHN38a/Uzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UN1QiEelkRfRabIAkVesvo275NcfG3rGnamXzPpeLcu6HQRjABH9PelDd2qs/7PWY
	 kbmOZD45MycSf17Lmn1ksE9bdLt0nvX0EhWlFsVcJ2VJUucR+zF/ijb8xgfa/vp6Is
	 OodsoqqN9KPXJ2EYGW1P8LonOfcr6DAucZXmi4cg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milos Reljin <milos_reljin@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 326/620] net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset
Date: Mon, 10 Mar 2025 18:02:52 +0100
Message-ID: <20250310170558.474931694@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milos Reljin <milos_reljin@outlook.com>

commit bd1bbab717608757cccbbe08b0d46e6c3ed0ced5 upstream.

In application note (AN13663) for TJA1120, on page 30, there's a figure
with average PHY startup timing values following software reset.
The time it takes for SMI to become operational after software reset
ranges roughly from 500 us to 1500 us.

This commit adds 2000 us delay after MDIO write which triggers software
reset. Without this delay, soft_reset function returns an error and
prevents successful PHY init.

Cc: stable@vger.kernel.org
Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")
Signed-off-by: Milos Reljin <milos_reljin@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/AM8P250MB0124D258E5A71041AF2CC322E1E32@AM8P250MB0124.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -717,6 +717,8 @@ static int nxp_c45_soft_reset(struct phy
 	if (ret)
 		return ret;
 
+	usleep_range(2000, 2050);
+
 	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
 					 VEND1_DEVICE_CONTROL, ret,
 					 !(ret & DEVICE_CONTROL_RESET), 20000,


