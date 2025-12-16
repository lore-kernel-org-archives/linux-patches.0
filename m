Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BC5F315786;
	Tue, 16 Dec 2025 11:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886310; cv=none; b=mJzo0hvAvQkr48Dx9GKYaBkkWaeTwRpzyh7jS010i29igEJavv42ez56aY0E3o2d2ibUM5GtKyTZolVGlyi1rlaHzjvStnAHfr3zVvhmi8kS5JXfi6QXgnkIfjVDe/MkZ+N4UGD15eOogfAE7LSIDxbVsSWDKwTGFWzxnD/HhFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886310; c=relaxed/simple;
	bh=NeDPqkM85q1JhMpKYGttHBoUYwrcOhccW7UbieIasPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mgbPq1S0vPTZJvaWk2sM92LUJpw3aXdA1og3fOZDcWqwro+6wCx3VQokY1KD9PrnKue+3j2aEPbbrELYCBn1JuXNVyYN21nlhZ2Cvs42rjWKisTDvCYKFUw0lAxs/OxgQtnGWuu8k25EbMkQfVoF0v+t5WlDeBbt/EBRPc7H6ho=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShNn/N26; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShNn/N26"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A150CC4CEF1;
	Tue, 16 Dec 2025 11:58:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886310;
	bh=NeDPqkM85q1JhMpKYGttHBoUYwrcOhccW7UbieIasPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShNn/N26CRF86f5cj5mQhteFQdQP9pv5MmMGUlFCNMPP3AEEZaL6JowexIFhENUVW
	 ETKZcQed5nApHsFknm09io6uaPltg8eds4DDCGkH46EsMr8YbTlIw734GA1KTh6x1Z
	 IcMFHO5pbHzkE84Fgpj4oF1d4NqapzMjImyLX+hY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Marko <robimarko@gmail.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 400/507] net: phy: aquantia: check for NVMEM deferral
Date: Tue, 16 Dec 2025 12:14:01 +0100
Message-ID: <20251216111359.944614621@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robert Marko <robimarko@gmail.com>

[ Upstream commit a6c121a2432eee2c4ebceb1483ccd4a50a52983d ]

Currently, if NVMEM provider is probed later than Aquantia, loading the
firmware will fail with -EINVAL.

To fix this, simply check for -EPROBE_DEFER when NVMEM is attempted and
return it.

Fixes: e93984ebc1c8 ("net: phy: aquantia: add firmware load support")
Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20251127114514.460924-1-robimarko@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/aquantia/aquantia_firmware.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/phy/aquantia/aquantia_firmware.c b/drivers/net/phy/aquantia/aquantia_firmware.c
index bbbcc9736b00e..569256152689f 100644
--- a/drivers/net/phy/aquantia/aquantia_firmware.c
+++ b/drivers/net/phy/aquantia/aquantia_firmware.c
@@ -369,7 +369,7 @@ int aqr_firmware_load(struct phy_device *phydev)
 		 * assume that, and load a new image.
 		 */
 		ret = aqr_firmware_load_nvmem(phydev);
-		if (!ret)
+		if (ret == -EPROBE_DEFER || !ret)
 			return ret;
 
 		ret = aqr_firmware_load_fs(phydev);
-- 
2.51.0



