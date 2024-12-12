Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC7B217F46;
	Thu, 12 Dec 2024 15:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018925; cv=none; b=or2bMWbTDVqoJ2ZK8tHdIS+Zln3BkIc6fl7Th+M1nLC1cLmS3PFLtYCcPjdqifbAvC8k3G+ryMpjOOcnZI2fgJCjtpGucsE0JQZ9GFLvycHesMlF8URAa43g7P+93Smuph9flyGkoJwL32RXlno9z2jI6gFARXEdIlvLbTvjnGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018925; c=relaxed/simple;
	bh=4g1iH6HbPNvzxLSLDBm5IJpzlOMZ88ghpOkP+DkkP4w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDTx7snpjIVDUMMLmvVsBOe1/kbHdKmq28r5zoEbVckI3cHJAPQOTJYMiuTPwrvs+g3zKk3lBGB1xnZ+qhRcFhtuRppoNeblSDJyXOb13n5fAMcyks7CAxRMG4wGChrOtf/OO+AUbj/1d1xHqyZZGhujvsMTVNxO+Yo5GRJ9e5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=stDOIZ2v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="stDOIZ2v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28EB7C4CECE;
	Thu, 12 Dec 2024 15:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018925;
	bh=4g1iH6HbPNvzxLSLDBm5IJpzlOMZ88ghpOkP+DkkP4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=stDOIZ2vaTKcOEIAXDKpCJOULhT5qEkQGAj3MpsTqsAhoijEmbs+cB7z2KluM04Bu
	 xc3Sh6As61/fDfPEr8Og2vMZmlL6QxItyaUbbZGtVS29kqscffS6VPLcG6X3WvmrRA
	 8bNhC0riRwj6JAdRCI2S0gP1qVbvQkXQb+AP7sY8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Priyanka Singh <priyanka.singh@nxp.com>,
	Li Yang <leoyang.li@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 072/772] EDAC/fsl_ddr: Fix bad bit shift operations
Date: Thu, 12 Dec 2024 15:50:17 +0100
Message-ID: <20241212144352.905862800@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ac2102b257062..2fea9569927b2 100644
--- a/drivers/edac/fsl_ddr_edac.c
+++ b/drivers/edac/fsl_ddr_edac.c
@@ -329,21 +329,25 @@ static void fsl_mc_check(struct mem_ctl_info *mci)
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



