Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2A5049D591;
	Thu, 17 Sep 2026 17:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665713; cv=none; b=SvpF80U44RMFg9/K2g2bUEf4Q0rb5NUzYwvCE4PMpzE+WOTc2HjhYsTikKfh43xwIYhmnNbGFqxP3iKJGlMvgKHTH7BQOTskUGWsB5eBOeycvf9XQfm3fE6grCWRE1mLigyD6551DM7mlZryVO9oY4uHONX0X6aeikVf0LFM7MU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665713; c=relaxed/simple;
	bh=3ffXwhfSdH5LGNpSlJvlbAFRntQ1OXk7CDaNDnOq59U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZrPIvquxkTpDv+kzUKGtEJyz76kfROZxFcXuDKUurvgRslr8/JFrVGdkNoO7RvhUmbBahFFiTNv4yi9wzEWTCQyZARzj+rph2ZAWRKXI2wruHUPmBjjwnzB5SBe4FmRukwJo+4u5OcuG7UnGGtANw0xGo9oc0LCe+8FP9RU0mQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qptqBXla; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qptqBXla"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 065661F000FF;
	Thu, 17 Sep 2026 17:21:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665711;
	bh=4loi11j7ZVKELqQR7exa3BOSOOaoh9vd8o3smNCHgTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qptqBXlaca4LQoyET9jtRLSow9X53i8lZ09kN1JYOXFe3lDkHx4BSlbdqeGMv9BJo
	 aSIHNMAhbHm6885LV9uqTpa2f+H9r93irxUdnBtv4MaGOf2mWGVQeov93t9JU/Ri9/
	 fwNb6jxCj0nKBOVHRTJKvCTEp/zKVlwR0+B+240Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nitin Shetty J <nshettyj@marvell.com>,
	Viswajith Murali <viswajithm@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0795/1250] octeontx2-af: mcs: Clear stale X2P calibration state before calibration
Date: Thu, 17 Sep 2026 16:09:50 +0100
Message-ID: <20260917151613.448133988@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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



