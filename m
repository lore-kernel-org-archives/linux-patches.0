Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CE2B352019;
	Thu, 20 Aug 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238254; cv=none; b=ciDU80AJy8DPvH5rqLs2oY3fUIQaDaXnz888DIM2VlD+kXAIIq1Mn3wLqlIyPmSyM5cn8tYOgfOk2+95duejug7DByZ0kcomZuDz2eqTkdywR9SLw+uNrcnDXT3Q1REvDj6D7e8Snu12Pneocf6MtO8WPZbQ070M2WpZdCMHJbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238254; c=relaxed/simple;
	bh=MgqVRbD5L9iN01f139BL2+ps4CO8bFarI4LKi5mxotA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FPqcyra4ylMTSoxCa+Edb9olzpf2B1gKI8NLQqgJqFUcD76FgkBmLPlwc8yUlrlU+bqWNqhAldExOL3pG26kF7f5UvCSexuVrzQ6mWskwr+bZZdFQtcaderUldZImZWWX5Vv4I1YM28zUWYlHt7JT/pcisl1Erxtv6NHrsdz2t8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WVzu7zme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WVzu7zme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039531F000E9;
	Thu, 20 Aug 2026 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787238253;
	bh=rbPjgo5lOgnZpBmbsYv0gEkrT+bc78q/R/jXWeHzpDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WVzu7zmeisojTuihfgJ3uLq9pXSI94VlxAlj13/9fC7kjMBl58n8eJ05I5xtWt4AS
	 MPW+UKhCO+JmWcJKOanuaZ88QSy8YsokQYnWh8gkDeLp7iaw/UxJYX2QO4AbQHOSbU
	 Zle2p0jWaI0qAdFH7Bt52u4xoTC8PWai9wAZKdrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 7.1 083/228] pmdomains: mediatek: Avoid setting RTFFs CLK_DIS before NRESTORE
Date: Thu, 20 Aug 2026 16:53:45 +0200
Message-ID: <20260820145247.171515364@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145244.450574346@linuxfoundation.org>
References: <20260820145244.450574346@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -486,16 +486,8 @@ static int scpsys_ctl_pwrseq_on(struct s
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


