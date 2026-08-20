Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361AD37EFFE;
	Thu, 20 Aug 2026 15:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238873; cv=none; b=HEqjmYGUHwfNPyEtCjTVc+774XYc1NOL2MwgAgCR5fCWPzchRY+0eZog0HgYweN9lTTAyo7/XyVbFmw1AM4SxXwvf3zjawHPEGwIhWm1C1xDopJNlyS/eSJ6H/a4JuD+Db5LiGIL9lIcFAjghGY+iUdJOwj4Va5NSIXr3pcTs5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238873; c=relaxed/simple;
	bh=EGDqx2DCTj50r4/Yf31eLgQ21xcoXtZm8taujmBs2Xo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IS+SHFw/2PO2Ats7PNN0YZxN5hadHMHq/JC2T3fQqjTzR+Gcz4XhHtg0fShy9bl8HStLX4xAMDBD4AboDfnpQi7wtUTTwG6NJBLRRY+j32HOOb0uDMXMOWZDxBbGz8abf0UJy64XY46t+rukZ/qxbqlpsITmLD+sgraJfuu80vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ar5r5rT7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ar5r5rT7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C9E1F000E9;
	Thu, 20 Aug 2026 15:14:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238872;
	bh=T+lqMRxVW7dqDRnNZLSYyUN23WinxuEh9tmjlQC3QME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ar5r5rT7uq0L3o9gC1fvL0ZoftW4kYJkJpLwVVfnqN2+UudtzhuzoRFuG08FR4f7h
	 I+EIYZtZhqTWoT6VwvbghLmHlBewKr7tu72CT4mYFKuLuBq9L+Law1DNRlqP2Xk8Fr
	 bXVMElIZET/An1KfrbKwfdnGY8aPt+u6LDNA5IOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.18 069/217] pmdomains: mediatek: Avoid setting RTFFs CLK_DIS before NRESTORE
Date: Thu, 20 Aug 2026 16:53:57 +0200
Message-ID: <20260820145239.697587783@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145237.531699751@linuxfoundation.org>
References: <20260820145237.531699751@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

commit cbb0140379de69fa46526672f3003f128f0b4e2e upstream.

For the PCIE_PHY (also called PEXTP_PHY) type of RTFF hardware,
there is special handling setting CLK_DIS before performing the
NRESTORE sequence for resetting the RTFF and start sequencing
from a clean state.

That special handling, though, poses an issue in case the machine
specific bootchain (bootloader in particular) ends up booting the
kernel with both PCIe MAC and PHY enabled (not just power domains)
as doing so will partially corrupt the PCIe MAC/PHY registers in
an unpredictable manner, producing either an initialization fail
in the PCI-Express drivers, or even a hard lockup!

Resolve this by simply removing the special handling: in this case
the bootchain, or remote processors, setting is getting honored by
the later check for PWR_RTFF_SAVE_FLAG presence in the RTFF ctl
register.

Fixes: 9d02c94342b3 ("pmdomain: mediatek: Add support for RTFF Hardware in MT8196/MT6991")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/mediatek/mtk-pm-domains.c |    8 --------
 1 file changed, 8 deletions(-)

--- a/drivers/pmdomain/mediatek/mtk-pm-domains.c
+++ b/drivers/pmdomain/mediatek/mtk-pm-domains.c
@@ -266,16 +266,8 @@ static int scpsys_ctl_pwrseq_on(struct s
 	if (ret < 0)
 		return ret;
 
-	if (pd->data->rtff_type == SCPSYS_RTFF_TYPE_PCIE_PHY)
-		regmap_set_bits(scpsys->base, pd->data->ctl_offs, PWR_RTFF_CLK_DIS);
-
 	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_CLK_DIS_BIT);
 	regmap_clear_bits(scpsys->base, pd->data->ctl_offs, PWR_ISO_BIT);
-
-	/* Wait for RTFF HW to sync buck isolation state if this is PCIe PHY RTFF */
-	if (pd->data->rtff_type == SCPSYS_RTFF_TYPE_PCIE_PHY)
-		udelay(5);
-
 	regmap_set_bits(scpsys->base, pd->data->ctl_offs, PWR_RST_B_BIT);
 
 	/*


