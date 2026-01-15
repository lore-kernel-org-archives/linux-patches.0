Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A2642D73B4;
	Thu, 15 Jan 2026 17:20:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497618; cv=none; b=Lt+SkYrn1G1GS7wTmmSoF+5Rz3ynxc9h+xCQmjGsuHq1MfUo1G4m2yDPFRaoJXmQaTyVJqFZEomqGlJ6XJK5nHUccjOdJ3sotT+UfBbeVbtuN+hWhrzi1KQFcJ7J0SYTmTY6pOcVBtyCVXZwVZl+qTDXNb96wwWKJy0T5dYmlc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497618; c=relaxed/simple;
	bh=IuTnLQ1dNNNRpFQrigWgX5tq4plFG4Tvjv898i3wXZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLv6DJ4wnReLI4wPOboGAI7Xfu04eMsoYKKrkzygwMliJ4PIUy3MTqSvorkfirixyMU5ctg2HEwcbU5IOcNROdoO9Wkuh13SRcRxYtaJm7e6WURLtsaPSbx5sXU7K9IaxKl8NPsJUL+N4f5JngGrvIjt0S40Sc2B76WYIjun0AM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nShTAvpr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nShTAvpr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14871C16AAE;
	Thu, 15 Jan 2026 17:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497618;
	bh=IuTnLQ1dNNNRpFQrigWgX5tq4plFG4Tvjv898i3wXZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nShTAvprOCzIi5MbcTPpyi/hCHmZPKytW234DpMI7HqAvZYN0WfLy/ymSnsElkdNp
	 tUG6G4Qpp0LCk/0RYv2nrt2GkwCW5/alRxGEBSTmGLdztO09TGwnLeQGLg9NZvb8ia
	 7ksCepcjE1ySnH1iS4A13dC5xYGlmLG053+CbUmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 145/554] ASoC: fsl_xcvr: clear the channel status control memory
Date: Thu, 15 Jan 2026 17:43:31 +0100
Message-ID: <20260115164251.507490123@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164246.225995385@linuxfoundation.org>
References: <20260115164246.225995385@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 3fee1aa03363b..8065fa5c95e10 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1163,7 +1163,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
 						bitrev32(val);
 				}
 				/* clear CS control register */
-				memset_io(reg_ctrl, 0, sizeof(val));
+				writel_relaxed(0, reg_ctrl);
 			}
 		}
 	}
-- 
2.51.0



