Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D94315786;
	Tue, 16 Dec 2025 11:29:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884586; cv=none; b=NtkVV2TxYyh6hZEJpFdQuJMad0EgpdC29INeTrztAl5DZXqx6BgxBSfIoy4rCEUDtgYTRw/UUhJgalBEJjk2cCSpc2BMujto2upagkIddc2WGYFDReP6tIadAw73B2Hl5FPg/SDkAScmPbMsdQAeTQQmCutyq8OeMNA6DSZ3KSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884586; c=relaxed/simple;
	bh=XZ8bpWJoJO+LyrLR2wlvrNDJhX3Nedk/hPyUpD8I7T0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=quAOqSukrRLyK5FcvNn0S0X2qRicz/Dkuf5SX5R8fBCYezVLIJWnP6dzwJ2OK7IbsdN9i2DkHwPa+NiYlpgxP38MoP9LAHmyQC4dl9bWCgEjedMo5EeYqYIB7nXyJAhc0kAhLKEekKcRYGK24JE1X0n5/YSJ7SrN/INSh1Feotk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L9xbIoRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L9xbIoRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52542C4CEF5;
	Tue, 16 Dec 2025 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884585;
	bh=XZ8bpWJoJO+LyrLR2wlvrNDJhX3Nedk/hPyUpD8I7T0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L9xbIoRKyJYdhzD3rnB1y24SmNq1x8Jx9NK7XH7QJ6EDHpt8hjrTNDHE4HK6lGP//
	 Bo9ZbufZo1ed6SfvPXdAWaB4ehDzifC+mxCW6HeWlDRYzRnUOunpWrg5VFGZfo8MA+
	 Re9mSYyUkLSi7654A/kfShObm6AOEaZFtnHRhYC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 237/354] ASoC: fsl_xcvr: clear the channel status control memory
Date: Tue, 16 Dec 2025 12:13:24 +0100
Message-ID: <20251216111329.501673624@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 0a67987c316e8..656a4d619cdf1 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1237,7 +1237,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
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



