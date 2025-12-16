Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D7434F24E;
	Tue, 16 Dec 2025 11:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765886182; cv=none; b=NqrwHgq1UQsWzSsR80Jh7YjYpT01twvPXISxVKhqIvj2JKYJxQfl5oF0fNjXhfFAoKCTXFB4bCSue0kuzlqjERzqdOvQg2j1sj6EnEG/bun+ZD+e2o9TxPpErS2gdtM1OBCH74Q22iRO6yfz85gYdu+GKhPWmmm6GcYAoszYcfc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765886182; c=relaxed/simple;
	bh=KCZZIpj1cpievKEQ8SYALa+QNsqFRaMyZ5RiXT0k3Kk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N3kXG2hxl6SP9DfU1ydCBOANRgnZP8fRcl2R8I72S0UrE5RLf8XTHXyDr5Yk3dmLzZk0bNDvUrvTqU3WEqrqVN1hxBV4vCcTD/inYkvleZS5E5rh24/zU06WvdoERSAmXanjGSUYX7xzoP1ci6t7kOGeYqSRLqTLD4h4O1Kc6Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pHB4ccIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pHB4ccIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44634C4CEF1;
	Tue, 16 Dec 2025 11:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765886182;
	bh=KCZZIpj1cpievKEQ8SYALa+QNsqFRaMyZ5RiXT0k3Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pHB4ccIs3t0DIrls/F0kHIJdyQCo+bB1tesF1nNGLV5cdWJzT8etJOH3OxW3A3dgH
	 BPYi5vaolgPbfHcljB+7HzDcKqhXfGs7jy0b2wabTG7U9jXIBKt5bSJXRsIoX1gRM6
	 Ih9GJaJFwBimNT8FjOr81JNN7Dk1xgXMU1HHHu8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 363/507] ASoC: fsl_xcvr: clear the channel status control memory
Date: Tue, 16 Dec 2025 12:13:24 +0100
Message-ID: <20251216111358.609990491@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 5d804860f7d8c..58db4906a01d5 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1421,7 +1421,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
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



