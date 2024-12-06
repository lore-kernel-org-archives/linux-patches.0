Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6BC1474AF;
	Fri,  6 Dec 2024 14:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496716; cv=none; b=GoWQ3foSFcHbd+74cxBznwYrpVnohr2PL7QpXJRnKV6xW9dvM1rmEe74UDPgYH0e37Cr3oCIufk6BqpG87Kbhp0OZEVJghai2THz06Ke+bICuUYu1LS4rvEMmq8bvDIDNi9Z7CxOwtfUS5ltNRlv8esGYJzCgZcpLMVFi7fRD0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496716; c=relaxed/simple;
	bh=HJAkS7PnpjdkQu3/zVQlx/Z10T2lcOujL9WhJfMgfiU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lwv//eIY89aNnFfPIQtxBfutWcLNyd9ocxcfWzOlO15FJBiF6iFtgm4VtrI9vbFKvkk6gAUJ5PydHEUV1A+kvQzqGJsW9WfxoTOfLmEDvTFtBd4dky/sw3W7Xr2mY79dQb2PgW08wsCy3VRP7h+iEF7dWRtZyP3dyI+3bQPri4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ba7ff1ga; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ba7ff1ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CA18C4CEE0;
	Fri,  6 Dec 2024 14:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496715;
	bh=HJAkS7PnpjdkQu3/zVQlx/Z10T2lcOujL9WhJfMgfiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ba7ff1gaYKOgyAuC6IZFc07R+6R/zReaJBBRPmMHnKkTGQtDL5LbnBqp5HWt4zlYz
	 DMsGgZPdLMbLGuY7BxnXaWARonfhUcru3Z0BPOzbBe1LUnVmSruHeWRx5tIAZYqEXf
	 lHG6jRSqZoz0Zqi/rRTUyZHtsYk5R8S1OETXACBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyanka Singh <priyanka.singh@nxp.com>,
	Li Yang <leoyang.li@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/676] EDAC/fsl_ddr: Fix bad bit shift operations
Date: Fri,  6 Dec 2024 15:28:23 +0100
Message-ID: <20241206143656.645049053@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index b81757555a8a9..7809427c2dbeb 100644
--- a/drivers/edac/fsl_ddr_edac.c
+++ b/drivers/edac/fsl_ddr_edac.c
@@ -328,21 +328,25 @@ static void fsl_mc_check(struct mem_ctl_info *mci)
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



