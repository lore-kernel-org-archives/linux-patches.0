Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 791AC42F709;
	Wed, 30 Sep 2026 19:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795243; cv=none; b=Pif4UuywI/l315m7J8gCWGyVkF4x+8Qk6sIN3q7xkTuo0CHjpre8sJChaFslHFaJqBhpH+wnheOeey0vtwP3NFt0cpCGr4gvDrY6HDxOnMM/DOOGQ9l+1/WEs14awYh4Ijsf2aX0aiMmYZLQGqnuu7noT0KUcCw+QjjYM4kCvuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795243; c=relaxed/simple;
	bh=8qAt8d7U2TOcCLaRyL4DmDzpTOogSHhXOS1KfbmkbPo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFmL5C8nFB0UFc4thw+J0O93UHzbazdvtc8Yxg36mekwCcONKufKhfwsq5FYJ0ZyxOxjjUpRhDsqqXukorDxuREH5hFQI4Cc+IgQJUoVxKsJKuRz79RZrN5z4J33/9OjZJ5MAYQyhgmNm2V0WFq/PJAu6mNP18hNAUM/6yKfKaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GbhL7kqC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GbhL7kqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B381F000FF;
	Wed, 30 Sep 2026 19:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795242;
	bh=2rmhx014ninbOjHuUOS0biuMYFxxPyC9tyqZXDVLK1w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbhL7kqCFPiqx+qj8unWB3XhsIabzBQRVQouo53McztR1J2VCeyM0nn1vmCF1dZ8i
	 udtLFAXzdJ5M55Mcnoc2L+yqxNLqOlU4VPrE2D1tjYWg/9rZH969y/VM5mK3L6obIH
	 JdATNdW101dwp3q7jt4nWhzlidb+QuszM7MLPbLc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Viswajith Murali <viswajithm@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0493/1193] octeontx2-af: mcs: Clear stale X2P calibration state before calibration
Date: Wed, 30 Sep 2026 17:19:37 +0200
Message-ID: <20260930152445.104284156@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Viswajith Murali <viswajithm@marvell.com>

[ Upstream commit 1f29543126dde307e8b5fb6a740c54e59deaa2ff ]

Some firmware versions leave MCSX_MIL_GLOBAL bit 5 set on boot.
If the bit is already set when the driver attempts X2P calibration,
the hardware sees no rising edge and calibration never triggers.
Clear the bit and wait briefly before starting calibration to ensure
a clean rising edge.

Fixes: ca7f49ff8846 ("octeontx2-af: cn10k: Introduce driver for macsec block.")
Signed-off-by: Nitin Shetty J <nshettyj@marvell.com>
Signed-off-by: Viswajith Murali <viswajithm@marvell.com>
Link: https://patch.msgid.link/20260901094318.1395356-1-nshettyj@marvell.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/mcs.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
index a07e0b3d8d000..211c10aa5880f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mcs.c
@@ -1417,6 +1417,16 @@ static int mcs_x2p_calibration(struct mcs *mcs)
 	int i, err = 0;
 	u64 val;
 
+	/* Clear any stale calibration state left by firmware/bootloader.
+	 * Some firmware versions may leave MCSX_MIL_GLOBAL bit 5 set,
+	 * preventing the hardware from detecting the rising edge needed to
+	 * trigger X2P calibration.
+	 */
+	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
+	val &= ~BIT_ULL(5);
+	mcs_reg_write(mcs, MCSX_MIL_GLOBAL, val);
+	usleep_range(100, 200);
+
 	/* set X2P calibration */
 	val = mcs_reg_read(mcs, MCSX_MIL_GLOBAL);
 	val |= BIT_ULL(5);
-- 
2.53.0



