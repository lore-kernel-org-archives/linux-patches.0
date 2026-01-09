Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA883328EA;
	Fri,  9 Jan 2026 12:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767961848; cv=none; b=MUNH/WxO/+Zu5nTSoVwgdgBFrL6w/P0fgRUFsy/mL3hA0td04Lcmg+PuPIVdIw5b2olGv+MPbC/REwmTin0Ti0rVomR+cH6Nt7gS0Rqn186+ykx0hEclwEi5L7C7XrvMw/bOQm9/DPL0j2h3DnnR3d1wkOadSOpVnhFmcqKVVx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767961848; c=relaxed/simple;
	bh=SGAO9+6nox7464YTlHJsmKYzZVXMyfuITORA5Owy0Js=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uy+bGcK6oO11j1sw9AFkUl60sB4xOY6KxXqXOaf2JfN3NE73y89I04aOr7wOt92ZuMja8qsyfgArsR6o2IUaKgysluHR/uXuakN1nFn86T6YtmZu9uQjWS7p5BqsVgwlBZL6TQfsI5t4WZFPIVzne2d6r2rxtceTyMVPZnMQRbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqoXgk0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqoXgk0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AAB2C4CEF1;
	Fri,  9 Jan 2026 12:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767961848;
	bh=SGAO9+6nox7464YTlHJsmKYzZVXMyfuITORA5Owy0Js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqoXgk0Gs0psoWPggltEqy//2Rq4uJCASNRHmjUM/iAlsW/nZc7bQjlYtN2tXQFOa
	 d1RLTFc10IrOSvG8KFDTALqIOtA16C1tKzH9nSMjg8EIs9FI4dfp9lLlqx6+WbPP8L
	 1NfsSTL1tyJJ+2iE7TvL+uscVfP99NhRfXYIAkjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 157/634] ASoC: fsl_xcvr: clear the channel status control memory
Date: Fri,  9 Jan 2026 12:37:15 +0100
Message-ID: <20260109112123.358871280@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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
index 8f8ff0ff9765a..9093f3e6e1962 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -1164,7 +1164,7 @@ static irqreturn_t irq0_isr(int irq, void *devid)
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



