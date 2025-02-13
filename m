Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DFD13C816;
	Thu, 13 Feb 2025 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739461016; cv=none; b=ofcCX8s+Hoi9UC+b0ETPLWEXDhjKtlp9snqG+nhHoV3qHF2fnXIb7R/pzVCBsB/UCb879+ywU1FvIdxwlYtKduw79gR6FEyxi+q4d0nnoQl6pfTmAdbF6ILYEBl62AVPS4MImMw4eWwrpgKznGeli1C2xGK0TnTebOD94I28ERY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739461016; c=relaxed/simple;
	bh=3xAjUWUqvHsG0SNBqsulmKMWG5vkA1Ak8uFs1ikwVDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cdJICBgAxqV+cFy2Gf2UQFOygWjusXSo4L+PJp/E++j2iJpjyxADo63oGYkEy3UOw58/TWshNJ54d/+ul9hZW+JPPqm+dLE00l1U7KMv1v4hkif49TWB4l3NHaKOHjsdZn3l2QrIYbjS7D/T8VkrI0lk19e1Cv3fFyr0nqwUwKo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p9e+5s10; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p9e+5s10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3421DC4CED1;
	Thu, 13 Feb 2025 15:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739461015;
	bh=3xAjUWUqvHsG0SNBqsulmKMWG5vkA1Ak8uFs1ikwVDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p9e+5s10FyzomqCsCZ6WxfF2biyhOm5rclZeo5gHamcuGRLo6wAUMKWAzM9KSrDmf
	 4rZxImkURnhgVMxHVkOZ49SWjzSO83TwiwoAGi+ojCI94uklRK0pCNSFJLLZfZfxSt
	 qauurCjDIYIin3C+jbmpB4YASWeSqPj3s96jIqRs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milos Reljin <milos_reljin@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 246/273] net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset
Date: Thu, 13 Feb 2025 15:30:18 +0100
Message-ID: <20250213142417.155798384@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1302,6 +1302,8 @@ static int nxp_c45_soft_reset(struct phy
 	if (ret)
 		return ret;
 
+	usleep_range(2000, 2050);
+
 	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
 					 VEND1_DEVICE_CONTROL, ret,
 					 !(ret & DEVICE_CONTROL_RESET), 20000,


