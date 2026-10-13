Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED644FD786;
	Tue, 13 Oct 2026 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894775; cv=none; b=gQLjp4qfwLji/9yKHPnW0Jak6jp+MbVuC/YGPrSqlC11MR0YK8uwf1vya61g2+Uwv3fqxOdrQbyFOUfjSfM7TmWJ9yIvTfe1xk40EcmdXKV13xG1KOBWMicVeUVZd51QK6cU0QbA8rFVwFb2z+Gq8XLGRKVvjVFZTy8HHAGVVXA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894775; c=relaxed/simple;
	bh=4iH2ncx/I/tYi0B0ydUlWDWFQmoUZ9CIta9pxyBLtCU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d1TRnuF3JdETDvf3cU6n3tYtDPmeOsP4C89MW/VUPwjfDjTS0y4btBCNQ/+aQXuC/i3HfWTHeLHkxvkvDpDezjEra2Ndkrg/MGzeb5ffJzeiPyXKyGdcAXPUlJt/7zrmVidWA5HZLjMJ7t9olReP8uM6f9GgaDsRA1c/5UetswE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XXujAcuY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XXujAcuY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D961F000FF;
	Tue, 13 Oct 2026 12:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894774;
	bh=2aeRgQQJU6VdJ9meAYmdpJO/Vgxyb/8N2xEHa0am1c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XXujAcuYIgFY8L6XInwiWLlG4jobKfCAYzByhkojjOT/MV3LnfyeD2NhNsogwEpFq
	 gTf3GWn1S20AbztyRgfPQPyAElXSEi/OkRwqzJAWdcSaKdlJADYm1gUcQ+u9AOP7kv
	 zDEhmD9Ovr3TeIFn3HwnAzIsDySLVuE7o+BwScVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 053/497] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Tue, 13 Oct 2026 13:33:40 +0200
Message-ID: <20261013112909.145236132@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit e31ae4aeb049983fe3be0cf1e12c8074811a7685 ]

The DRC_THRESH_QR field is bits 7 and 6 of DRC_1, but the control sits on
DRC_0. Its shift and max are right for the field, only the register is
wrong.

Those bits of DRC_0 belong to DRC_STARTUP_GAIN, which "DRC Startup
Volume" claims as bits 10 to 6. So the two controls share bits 7 and 6.
Writing either one moves the other, and the quick release threshold is
never reached at all.

The six fields of DRC_1 tile it exactly, so there is nowhere else the
threshold could live. Point the control at DRC_1.

Found by a sweep for two controls claiming the same bits of one
register. No board with this codec was to hand, the register map is
the driver's own wm8903.h.

Fixes: f1c0a02f32f8 ("ALSA: ASoC: Add WM8903 CODEC driver")
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Assisted-by: Claude:claude-opus-5
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260920135327.3628704-1-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm8903.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm8903.c b/sound/soc/codecs/wm8903.c
index c643b5377d3a1..b2e0f5dd481cc 100644
--- a/sound/soc/codecs/wm8903.c
+++ b/sound/soc/codecs/wm8903.c
@@ -677,7 +677,7 @@ SOC_ENUM("DRC Decay Rate", drc_decay),
 SOC_ENUM("DRC FF Delay", drc_ff_delay),
 SOC_SINGLE("DRC Anticlip Switch", WM8903_DRC_0, 1, 1, 0),
 SOC_SINGLE("DRC QR Switch", WM8903_DRC_0, 2, 1, 0),
-SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_0, 6, 3, 0, drc_tlv_max),
+SOC_SINGLE_TLV("DRC QR Threshold Volume", WM8903_DRC_1, 6, 3, 0, drc_tlv_max),
 SOC_ENUM("DRC QR Decay Rate", drc_qr_decay),
 SOC_SINGLE("DRC Smoothing Switch", WM8903_DRC_0, 3, 1, 0),
 SOC_SINGLE("DRC Smoothing Hysteresis Switch", WM8903_DRC_0, 0, 1, 0),
-- 
2.53.0



