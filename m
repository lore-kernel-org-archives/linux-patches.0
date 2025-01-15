Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD4151E98E3;
	Wed, 15 Jan 2025 10:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938288; cv=none; b=HmDbLOeHfhohRBL8zYI75tROLYqW9d04m9288Rgu/VLqqBYrKFQ7lB7zqPIL2nreHWubNvSIKXLW3PFNmMsxL/YEaHV1KMFDgJUsfNbdUDajdd28AvQpPMkvsGflw/YOAFmacBbywJafRuqJfSsoJWsVwBWXXpvTrWmcQ7a/V7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938288; c=relaxed/simple;
	bh=XePNtQGldHFHSRI9OCY6lQsTV1257TxC2KcdWSuQc5c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O04qh+NLEm6eMkRy11wL9DSjRrRf16OYeDYV7160tKLGC37cgRo+7J9binhlY/YXhIT1fIpKY3AmynzExuxTHOfODAZ0PU8E2INZyUClXOo8imtnj0NehYQ/V+Rxln0ou2UVNKml3e1hrkD0vQUZ//lvogAnj6eqOaUPjAEsSBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xmk/6aqw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xmk/6aqw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDEF3C4CEDF;
	Wed, 15 Jan 2025 10:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938288;
	bh=XePNtQGldHFHSRI9OCY6lQsTV1257TxC2KcdWSuQc5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xmk/6aqwuU4aMI4uEq/1SgTD0l0LnKGk26ysIYd7M8grvaG1R7GTCASMnDT/5F0fg
	 XP7RexWA4RCwsh0fP3dT1+F0LzNszAdQj6yju7Uo2+oNZciNw/yzQL/qO/yTVloBcw
	 j9xYTLQtXnGngm8GziO7Q5GFKMWyMW+fqUtNfYJo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Rengarajan S <rengarajan.s@microchip.com>
Subject: [PATCH 6.12 139/189] misc: microchip: pci1xxxx: Resolve return code mismatch during GPIO set config
Date: Wed, 15 Jan 2025 11:37:15 +0100
Message-ID: <20250115103611.977222449@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

From: Rengarajan S <rengarajan.s@microchip.com>

commit c7a5378a0f707686de3ddb489f1653c523bb7dcc upstream.

Driver returns -EOPNOTSUPPORTED on unsupported parameters case in set
config. Upper level driver checks for -ENOTSUPP. Because of the return
code mismatch, the ioctls from userspace fail. Resolve the issue by
passing -ENOTSUPP during unsupported case.

Fixes: 7d3e4d807df2 ("misc: microchip: pci1xxxx: load gpio driver for the gpio controller auxiliary device enumerated by the auxiliary bus driver.")
Cc: stable <stable@kernel.org>
Signed-off-by: Rengarajan S <rengarajan.s@microchip.com>
Link: https://lore.kernel.org/r/20241205133626.1483499-3-rengarajan.s@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
+++ b/drivers/misc/mchp_pci1xxxx/mchp_pci1xxxx_gpio.c
@@ -148,7 +148,7 @@ static int pci1xxxx_gpio_set_config(stru
 		pci1xxx_assign_bit(priv->reg_base, OPENDRAIN_OFFSET(offset), (offset % 32), true);
 		break;
 	default:
-		ret = -EOPNOTSUPP;
+		ret = -ENOTSUPP;
 		break;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);


