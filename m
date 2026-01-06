Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC76F37C0ED;
	Tue,  6 Jan 2026 18:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722409; cv=none; b=kTzAdNmUUzFCTZYIKM1ufrn9TSugGNsO2Md83ve0ZS/LELl8qLUMOScJlP/26JvQmHXmpbR5Tv0CnRI3VqZqbEpl14WDrTUWm7+Dh6faB0pvy7y9D3mhk2vpMBJZcNXXJNw72K+67JtHS74nKGbRhrz8d8T+tCvMMgNw/VOPw8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722409; c=relaxed/simple;
	bh=jhrRqkE79vArfRMplbw3IlwnAdC7C+bvuqq1ueJnaQI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdBN0zmM3dJG04ur1llxwh0sD1gOUxgTrXVdoXmgOpGJbzt6hgfPktz9v5CbxDHWN0s0h/FRBdze0wKS7FC76OfGTONEDkMs31bQ46+q5QKsdbLBnwKMJ/8M2dj/BwThKtnEY1HPmuh0auqkxLWL85o6Lcmja5BBx3IPLPg/CS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a6Cz2Htj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a6Cz2Htj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C010C116C6;
	Tue,  6 Jan 2026 18:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722408;
	bh=jhrRqkE79vArfRMplbw3IlwnAdC7C+bvuqq1ueJnaQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a6Cz2Htjtigh4SKwmIg4cRcZ4DHeH5XIDirYt6cn/6H1zJ8FSrIEoHtT84puV7MDk
	 J6NlN4oH/tk0BT0S40ou6KK4mI8XO3yjudhr5s+sg258YoHcfAtTv6/Er+lKeM99MZ
	 hRZ/La1hOJLhL5QsJXLVVujzirI3JaCXqdhmN95E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.18 255/312] net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration
Date: Tue,  6 Jan 2026 18:05:29 +0100
Message-ID: <20260106170557.073478686@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 1e5a541420b8c6d87d88eb50b6b978cdeafee1c9 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/mediatek/mtk-ge-soc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/mediatek/mtk-ge-soc.c
+++ b/drivers/net/phy/mediatek/mtk-ge-soc.c
@@ -1167,9 +1167,9 @@ static int mt798x_phy_calibration(struct
 	}
 
 	buf = (u32 *)nvmem_cell_read(cell, &len);
+	nvmem_cell_put(cell);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
-	nvmem_cell_put(cell);
 
 	if (!buf[0] || !buf[1] || !buf[2] || !buf[3] || len < 4 * sizeof(u32)) {
 		phydev_err(phydev, "invalid efuse data\n");


