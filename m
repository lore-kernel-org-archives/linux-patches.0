Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD9C35A92E;
	Fri,  9 Jan 2026 12:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961174; cv=none; b=Vuv9r3/0Gx7onf50SAdGQcjOoy4P01o1NIg0Ap3QnKzXmJF7paeYNDuVIQ9qDn9+VEJUE64UqPZvtN0Qlr3h9NDA9Ky4OuYWRETdeoztRiTK2d7Ns6kIQxnv1li8Yl8/FHHlw/gMnr0QG6sixzqQ0nVO7A5GicSlzADPGp8yrqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961174; c=relaxed/simple;
	bh=EN1a5kzJOscm1ojHBQM8pt9VykWtUvYQ4DuZcKuQne8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bBXT9YKb/aWuNgQFwFNihMP2iwulZ1L3uhhnOA8G9Mu34FYshWrqiGPWfOMa76foxpv+SujH8l5vJSDKvT4s4Djugim39UgUzhzVf9TyUcLhzIVJZO24ycUGe/AjHf5xHOf+bdpHT1iTR4MqzryIkGXRX57zhzSkaHnDEeYcLP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gR9sjvfp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gR9sjvfp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BA3C4CEF1;
	Fri,  9 Jan 2026 12:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961173;
	bh=EN1a5kzJOscm1ojHBQM8pt9VykWtUvYQ4DuZcKuQne8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gR9sjvfp8RzJLGPD1SLpi55P+3+i5CJ8i2YY0I9CBFqXDnJXnXP+TC/BXjoIMPjBf
	 oKF3cEyEa8yn5fniIMncdsnsdB8K+XEGW1AuHIgNKTYCmA9KxDYfQVmdAcouhcmA0P
	 t1INliCaEZvnUgNvTZLzHaiTt09+AtWFqnlrCFDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 660/737] net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration
Date: Fri,  9 Jan 2026 12:43:19 +0100
Message-ID: <20260109112158.857291520@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1e5a541420b8c6d87d88eb50b6b978cdeafee1c9 ]

When nvmem_cell_read() fails in mt798x_phy_calibration(), the function
returns without calling nvmem_cell_put(), leaking the cell reference.

Move nvmem_cell_put() right after nvmem_cell_read() to ensure the cell
reference is always released regardless of the read result.

Found via static analysis and code review.

Fixes: 98c485eaf509 ("net: phy: add driver for MediaTek SoC built-in GE PHYs")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20251211081313.2368460-1-linmq006@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek-ge-soc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/mediatek-ge-soc.c
+++ b/drivers/net/phy/mediatek-ge-soc.c
@@ -1082,9 +1082,9 @@ static int mt798x_phy_calibration(struct
 	}
 
 	buf = (u32 *)nvmem_cell_read(cell, &len);
+	nvmem_cell_put(cell);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
-	nvmem_cell_put(cell);
 
 	if (!buf[0] || !buf[1] || !buf[2] || !buf[3] || len < 4 * sizeof(u32)) {
 		phydev_err(phydev, "invalid efuse data\n");


