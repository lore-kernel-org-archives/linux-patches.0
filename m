Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF7C339B30;
	Fri,  9 Jan 2026 11:44:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959098; cv=none; b=C5namkJOkwZhy1k/d6C/maAoZu/m+E/rkPg2vsbtIdiGlL4PMHS9K74riJ6pHwS5U1iNTaYfALXRoMNZBl9rtAMzUCLJaMzQqFh3ow1gKPegK5ck/FgXaN/5msKgmYtYNoBMZwrfZI66IwSXRvFrYWGbJJPN0Y1S/rM0J2DwuzQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959098; c=relaxed/simple;
	bh=4IrgLY7HDkQy6WZ4fXdjLmoN2q8Nr18LVclOopC/eA4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UfQTUVdxgidAyQDKtdXzv8k2NqHAOa4GriXKG3smrL1An8Yx0hhatcLO9uNGFhPSZQpIJzjLQTC89AQe+FgjC1RrjIr1MoiMI+1vV6dYXWIl+qWMuBgbicxsg5XUwJb3C2AWfhroFsphaFlZwzrzmbWsFNwbhmY/alAbvNQ1y9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iQVHEzKc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iQVHEzKc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA62C4CEF1;
	Fri,  9 Jan 2026 11:44:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959096;
	bh=4IrgLY7HDkQy6WZ4fXdjLmoN2q8Nr18LVclOopC/eA4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iQVHEzKcifwuMK71DRYTKwPf36bdoH/kL/u+85V4N67gKwTeH3pRHLMhHYPrSK1xN
	 6GxWqlc4JPP0YXHWLibCjmqLByPZs0+zlYqWJ5CNfM7lkvK0yAoy1n0Tqq/uisEy7b
	 9E2rgfcu4fJKOIpW0q4QgI/gG9Hg4LWO2tR+mDS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 07/16] net: phy: mediatek: fix nvmem cell reference leak in mt798x_phy_calibration
Date: Fri,  9 Jan 2026 12:43:48 +0100
Message-ID: <20260109111951.699301528@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
References: <20260109111951.415522519@linuxfoundation.org>
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


