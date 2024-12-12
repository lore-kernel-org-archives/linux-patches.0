Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D55C20A5EE;
	Thu, 12 Dec 2024 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025078; cv=none; b=Kw8aXheLGHXUYH3Cw7ww+iCHpTRba5uug+ZnygVE8y+xigylQ+EtWoQzhF3FQZkt+WgLgXbwRACEFRHqkc2WEhhDguflKrE11Khsyh+54mwowVMlQrNCsjMD04q79MKUL7sD7WxKQ/QdCCeKr1VQbd2oyHngHS053VMXJ6PtIsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025078; c=relaxed/simple;
	bh=x0X75XX+wit+juJuBd+9jf/yQRYKGbuGLL/2gDOWEgU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scHskGdX2r7jBwmk9Sw9rKHqIbMtUH03rpxW/IoX3uppcbeoSc4vYQ35jWduZ3GEMmYWyw3Cxvbhg/17A6mPh3pumdhvt2S0dbxLfNS5q7qUek8zN8RiFahl63EJ0N/ZwwDUzx/yLNaDEt575sG2q+dYj0mfdDjMuZt5YOx57Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MtEV88f+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MtEV88f+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFE3C4CEDD;
	Thu, 12 Dec 2024 17:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025077;
	bh=x0X75XX+wit+juJuBd+9jf/yQRYKGbuGLL/2gDOWEgU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MtEV88f+2uQL/9FzxYvJnKWTEJ1mavdscR3qv2hKV6k++eeK0G3YubNoEEklYRsJc
	 6oqDKkz1+QzpNxQwZoje+IiKrG+2R+SVimRvWkGEAdisgIh0GqW0C1256LZjEo5lwv
	 0shA/C/BOSGcIBdOvJWC31C+eEskuYF6AvKDvxxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyanka Singh <priyanka.singh@nxp.com>,
	Li Yang <leoyang.li@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 041/321] EDAC/fsl_ddr: Fix bad bit shift operations
Date: Thu, 12 Dec 2024 15:59:19 +0100
Message-ID: <20241212144231.618601356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Priyanka Singh <priyanka.singh@nxp.com>

[ Upstream commit 9ec22ac4fe766c6abba845290d5139a3fbe0153b ]

Fix undefined behavior caused by left-shifting a negative value in the
expression:

    cap_high ^ (1 << (bad_data_bit - 32))

The variable bad_data_bit ranges from 0 to 63. When it is less than 32,
bad_data_bit - 32 becomes negative, and left-shifting by a negative
value in C is undefined behavior.

Fix this by combining cap_high and cap_low into a 64-bit variable.

  [ bp: Massage commit message, simplify error bits handling. ]

Fixes: ea2eb9a8b620 ("EDAC, fsl-ddr: Separate FSL DDR driver from MPC85xx")
Signed-off-by: Priyanka Singh <priyanka.singh@nxp.com>
Signed-off-by: Li Yang <leoyang.li@nxp.com>
Signed-off-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/20241016-imx95_edac-v3-3-86ae6fc2756a@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/edac/fsl_ddr_edac.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

diff --git a/drivers/edac/fsl_ddr_edac.c b/drivers/edac/fsl_ddr_edac.c
index 6d8ea226010d2..61e59341a41f9 100644
--- a/drivers/edac/fsl_ddr_edac.c
+++ b/drivers/edac/fsl_ddr_edac.c
@@ -331,21 +331,25 @@ static void fsl_mc_check(struct mem_ctl_info *mci)
 	 * TODO: Add support for 32-bit wide buses
 	 */
 	if ((err_detect & DDR_EDE_SBE) && (bus_width == 64)) {
+		u64 cap = (u64)cap_high << 32 | cap_low;
+		u32 s = syndrome;
+
 		sbe_ecc_decode(cap_high, cap_low, syndrome,
 				&bad_data_bit, &bad_ecc_bit);
 
-		if (bad_data_bit != -1)
-			fsl_mc_printk(mci, KERN_ERR,
-				"Faulty Data bit: %d\n", bad_data_bit);
-		if (bad_ecc_bit != -1)
-			fsl_mc_printk(mci, KERN_ERR,
-				"Faulty ECC bit: %d\n", bad_ecc_bit);
+		if (bad_data_bit >= 0) {
+			fsl_mc_printk(mci, KERN_ERR, "Faulty Data bit: %d\n", bad_data_bit);
+			cap ^= 1ULL << bad_data_bit;
+		}
+
+		if (bad_ecc_bit >= 0) {
+			fsl_mc_printk(mci, KERN_ERR, "Faulty ECC bit: %d\n", bad_ecc_bit);
+			s ^= 1 << bad_ecc_bit;
+		}
 
 		fsl_mc_printk(mci, KERN_ERR,
 			"Expected Data / ECC:\t%#8.8x_%08x / %#2.2x\n",
-			cap_high ^ (1 << (bad_data_bit - 32)),
-			cap_low ^ (1 << bad_data_bit),
-			syndrome ^ (1 << bad_ecc_bit));
+			upper_32_bits(cap), lower_32_bits(cap), s);
 	}
 
 	fsl_mc_printk(mci, KERN_ERR,
-- 
2.43.0



