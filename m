Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBC4D2D592D;
	Fri,  9 Oct 2026 14:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555442; cv=none; b=LiEdXdEKVMN58P2m3PIevh3/KjPKsWc8lZ2Fg2enfHc6SqfPhFQaYTMdLseng9vXRjtwXYPm6ZJAGII03rS5Sl9shj7L7GHwf/Vbx5Wtm6LypMg7+KlCqHgUkKKMj5I5U0a98aEMe12UVTFz1H4cK4i4/Lrj7XmDjWeZVY4Av+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555442; c=relaxed/simple;
	bh=u7EwxiSRxX6rFyDnA45iOJMBIgIF1/Z6NE8X+opxnd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hJnRhVBe7su0PPU5ejEL0hlTo6IjpUZo2bLl51casxk2EPuTG+1JTWiuMxeJsKzmSG3D3UYp05NQ3yZ3COYG5GecMYH57MmSB2F7oriZHTUyjF8Xc2zAtEtriXLV40jWj/aSccylF467DUUyBT1JQAOUTtaaxmdn+9wRlV5HUEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TaSgw6Rk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TaSgw6Rk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5BEA1F000FF;
	Fri,  9 Oct 2026 14:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555438;
	bh=jSvTx4CPcv20NJLR+2f4xkLaZaMbE4KPeM6FXu1xMVU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TaSgw6RkfxPBj/5/xoRMfefcyv+xEmRky22elNU9ZvItqMifrd5hU4IKrczkjrSxM
	 q3t4ei/T2FRbNAmHIbVFVIculR19sTwIT7EsjKCV5gsLAF5y/PaEMm5NoJsGN0waEa
	 i15rXV56WDFZmMye/F+/4hIZL+bWDqFoJD2FiqMU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 057/403] iio: dac: rohm-bd79703: Do not allow writing SCALE
Date: Fri,  9 Oct 2026 16:06:58 +0200
Message-ID: <20261009140953.435449438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

[ Upstream commit 55671fbc3d12ae1f381842433567fcb7ff96a298 ]

The BD79703 has adds IIO_CHAN_INFO_SCALE in the info_mask_shared_by_type
so users can read the scale, which depends on the used reference
voltage. This, however, enables users to try writing the scale as well.
This isn't really supported but the bd79703_write_raw() does not check
the mask, and if written scale values pass the validation, the driver
will proceed writing the DAC value when users writes the scale.

Prevent the unsupported scale setting and return an error.

Fixes: af6aca656a85 ("iio: dac: Support ROHM BD79703 DAC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/dac/rohm-bd79703.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iio/dac/rohm-bd79703.c b/drivers/iio/dac/rohm-bd79703.c
index e91090e4a66d9..68e66e7286d86 100644
--- a/drivers/iio/dac/rohm-bd79703.c
+++ b/drivers/iio/dac/rohm-bd79703.c
@@ -73,6 +73,9 @@ static int bd79703_write_raw(struct iio_dev *idev,
 {
 	struct bd79703_data *data = iio_priv(idev);
 
+	if (mask != IIO_CHAN_INFO_RAW)
+		return -EINVAL;
+
 	if (val < 0 || val >= 1 << BD79703_DAC_BITS)
 		return -EINVAL;
 
-- 
2.53.0



