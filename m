Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C95133C511;
	Fri,  9 Jan 2026 11:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767959996; cv=none; b=YYtMh0KiVpYAhHtHHYCE3zN1RRpFkT0+n+M6W2nzaYjQA20+MdEakyV3suh+uL7IrBeSR+LIUVuc2nSs2tTT1a/RnOIaa/gNQa6NC7Yx+Vcss7QWzX/k3mfW8Kbx51hNeHevRfOYVa8S4N9mPG9Df5DDLcOLBq0H96EROZqN3F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767959996; c=relaxed/simple;
	bh=TUzKQVP9l/YGKIQaoit7Ssprp2+rclJ5aySmn1XFb9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C6fb5nklrRu5NjOsu12+npf7mgieRdlWaevnOG3TpHkwGQV0PV1helgeLhMCmCjXjSUcVEW702u9y3voqXBzHi2ki4vQY0yWB87GWFZGPsy4rvy+pDnQQHbYQ3ccL++7XOkhaDsaLnNcX5us0LSd6WaYbcKxx9grtFGmjT6R2W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QCEU2Zc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QCEU2Zc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FE41C16AAE;
	Fri,  9 Jan 2026 11:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767959995;
	bh=TUzKQVP9l/YGKIQaoit7Ssprp2+rclJ5aySmn1XFb9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCEU2Zc4NYWjHTrMU2tuicT6akoZnshcepSZ9kHBxhTsYHpZHOYpSPkiFcVB3d0WL
	 L5rmkJh3bKcCD/z8NrKH1c67A2vwcGfHElfJluZihjl6tKe/7h1ldusMylS1Sw0VCP
	 u8fr9TtLseKVeSABrbBNMVA6tLbKHUrGcyYzB3Q8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 216/737] ASoC: fsl_xcvr: clear the channel status control memory
Date: Fri,  9 Jan 2026 12:35:55 +0100
Message-ID: <20260109112142.131257488@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 73b97d46dde64fa184d47865d4a532d818c3a007 ]

memset_io() writes memory byte by byte with __raw_writeb() on the arm
platform if the size is word. but XCVR data RAM memory can't be accessed
with byte address, so with memset_io() the channel status control memory
is not really cleared, use writel_relaxed() instead.

Fixes: 28564486866f ("ASoC: fsl_xcvr: Add XCVR ASoC CPU DAI driver")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20251126064509.1900974-1-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 1d7791c7fb4ec..90a0a24c05d84 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1195,7 +1195,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 						bitrev32(val);
 				}
 				/* clear CS control register */
-				memset_io(reg_ctrl, 0, sizeof(val));
+				writel_relaxed(0, reg_ctrl);
 			}
 		} else {
 			regmap_read(xcvr->regmap, FSL_XCVR_RX_CS_DATA_0,
-- 
2.51.0



