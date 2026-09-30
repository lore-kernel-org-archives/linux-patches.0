Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43CFA3769FB;
	Wed, 30 Sep 2026 16:19:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785167; cv=none; b=oyde+ZrC1Igrv8rIpsB3fE/xK5KkM6FCFy4+/k5+VXhmL5dCWTMowA77KeCoT6IC5h/QNm7NI6fwS/JHg4S0E06AqxfEYd8Fxfs3OK3xMHn+RWlvHSKefMnjbBCvihEfP7RDfbhO3DcBFr98hV1dZKcxdbN/RWDqpKa9Q+//M1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785167; c=relaxed/simple;
	bh=BqV6lfmEyCtj0evxiuyQ2lc8zJNN/0w9dAgqXR1qgic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V75OPItrrpAHPsH8ReJRfs5ILyy9prHLA4QfwOvF+NlqBaLyxWl/0ajc81N+Ntr5xnNmezmEAZmDs+hX5EMN0G3HGT4cKAWZ74hrmTEwWPJXmWqwtdtICUZKdxRUC9uTmlmzmm2cvpS2LvhaFe1actNYUbS7Fe4Zz4tU0cH+XIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBMWCGuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBMWCGuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11241F00893;
	Wed, 30 Sep 2026 16:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785161;
	bh=Z/tN8N2P+iJaHqLXZEMyXGZ2Cnu1PSaaPJv15OYKSnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eBMWCGuSra/ICWmeagZ/svbLmpMPG4THLWS5eLL+LLVPKd+3+DXf52Opew7d0C1SA
	 TewD+8HpqI1FidN9XGPQliBBqVnTsLK2tT1ETk26/h9yQAMlhbaIm4Db+jK5+RrZaH
	 Jx01fLxmdr0+uwwbC3dL2YYQQauMDQLQKfx3KV1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Viswajith Murali <viswajithm@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 412/982] octeontx2-af: mcs: Clear stale X2P calibration state before calibration
Date: Wed, 30 Sep 2026 17:19:08 +0200
Message-ID: <20260930152425.656984389@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



