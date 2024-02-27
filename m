Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD2B13B2B4;
	Tue, 27 Feb 2024 13:43:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041380; cv=none; b=p08Pu4oAdfQ+GEaUCEOvERIVwGFXRz3UK0t02MxheAMxU0K5BSh1kI5I53efdUheZh27pd2x0OuDpQEmVI1mvqdCQJbZ7d7bSlsM/wXSaFgWCi9VLghNpj4voULGkgjJ1WCqWaEUsn+8+Ha9SGX/LcE8Kj7DNfcLL+/Gt2eyEAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041380; c=relaxed/simple;
	bh=bP8NpHM9o3485cld4Om+VHR+B6iE5zEv2ZUe5BXl7Fo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNltmkmiJSZJtrM4DPsc/q6VvoF6PB+ew01Z9ky+PzJBuyFSUWeyryc/pxz7duAIb5R6GpAqbvymrtVBHDItP2gv2aU9KtOJR8iISegAPflGL+VQGl6w8Ah5/RBM+Pi0tFKHA2sntr0/DxvqTvOqUWBhhdJOfkEba+EKq3ktBwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FfQi6/fs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FfQi6/fs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF81C433C7;
	Tue, 27 Feb 2024 13:42:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041380;
	bh=bP8NpHM9o3485cld4Om+VHR+B6iE5zEv2ZUe5BXl7Fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FfQi6/fs3La5bDjkk8Khr5EKYAKw1HTQ7eI0jevsKV84uzPTJRf9+BiHHyutAFZbj
	 zPQGBIMiDYe33ynmRwoEIwJIscOiI3lJyrY97qUB2buslzJT93bMk6+j4LRNqB/HJN
	 px4bYVxWuSSZeyxFtDKtRiQK23edqlCAb5k2152I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Siddharth Vadapalli <s-vadapalli@ti.com>,
	Simon Horman <horms@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 320/334] net: phy: realtek: Fix rtl8211f_config_init() for RTL8211F(D)(I)-VD-CG PHY
Date: Tue, 27 Feb 2024 14:22:58 +0100
Message-ID: <20240227131641.424978510@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Siddharth Vadapalli <s-vadapalli@ti.com>

[ Upstream commit 3489182b11d35f1944c1245fc9c4867cf622c50f ]

Commit bb726b753f75 ("net: phy: realtek: add support for
RTL8211F(D)(I)-VD-CG") extended support of the driver from the existing
support for RTL8211F(D)(I)-CG PHY to the newer RTL8211F(D)(I)-VD-CG PHY.

While that commit indicated that the RTL8211F_PHYCR2 register is not
supported by the "VD-CG" PHY model and therefore updated the corresponding
section in rtl8211f_config_init() to be invoked conditionally, the call to
"genphy_soft_reset()" was left as-is, when it should have also been invoked
conditionally. This is because the call to "genphy_soft_reset()" was first
introduced by the commit 0a4355c2b7f8 ("net: phy: realtek: add dt property
to disable CLKOUT clock") since the RTL8211F guide indicates that a PHY
reset should be issued after setting bits in the PHYCR2 register.

As the PHYCR2 register is not applicable to the "VD-CG" PHY model, fix the
rtl8211f_config_init() function by invoking "genphy_soft_reset()"
conditionally based on the presence of the "PHYCR2" register.

Fixes: bb726b753f75 ("net: phy: realtek: add support for RTL8211F(D)(I)-VD-CG")
Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240220070007.968762-1-s-vadapalli@ti.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/realtek.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/realtek.c b/drivers/net/phy/realtek.c
index 894172a3e15fe..337899c69738e 100644
--- a/drivers/net/phy/realtek.c
+++ b/drivers/net/phy/realtek.c
@@ -421,9 +421,11 @@ static int rtl8211f_config_init(struct phy_device *phydev)
 				ERR_PTR(ret));
 			return ret;
 		}
+
+		return genphy_soft_reset(phydev);
 	}
 
-	return genphy_soft_reset(phydev);
+	return 0;
 }
 
 static int rtl821x_suspend(struct phy_device *phydev)
-- 
2.43.0



