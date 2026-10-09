Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D38B3D8912;
	Fri,  9 Oct 2026 14:23:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555829; cv=none; b=Rr/jZsYhe8vUGSubx1VJcPggYuv8UYE6KKad0jxoYDAItFzgCWpDE1ExXlm03IgjoS4794PAhi+hNkyfzPXOywpF9MeCNa4qqqiZ5m3UJbNV5lKh394dXuBsZ69lGBmJcexXweyC4t2gDg+uwHziqas7D3lYOVGVkCtt7O/ZcBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555829; c=relaxed/simple;
	bh=BLWweNAgRtBAKWaHjjNlPjtRzDxyxIMR7vqtvbj85Ko=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IbD+XvZB7hbFGsDOm+fyNsIcsLSzq6wEm1zzBwyBHA+KnRvUICF0ZEOKw6PQkJyQUhVpcqNJ+0Vn+j+6Fp+aE/v/CpI7yezHoBfN+1djOP8iVv1e6YYRt3aj406z3Kgs8dZPxv/5Mdu5Xapxm+pJCbWhytviHVrvV6rZqeEmFlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hv2+RSNP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hv2+RSNP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB941F000FF;
	Fri,  9 Oct 2026 14:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555828;
	bh=wYbyoYisKw5JZsCR3OUflKfJ8B+BHyEuK76zlWqzhI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hv2+RSNPOboZJkkrlJeMbKa9+bicW53nIV7lmReYQlvWH6Mghj+oMJ2E/MZ7CBmM2
	 9lTCQc+LTxKYadcvz6eBbMRdEsSyc0zcY559fLV1XIouFt95Tj+QhOPj++sCj0VJWI
	 Xa8bEQkDzvJrqz2jdyx0t0taPw6wl7zHmVJenDys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 076/428] ASoC: wm8903: Move the DRC QR threshold to the register that holds it
Date: Fri,  9 Oct 2026 16:06:53 +0200
Message-ID: <20261009140947.834765535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 320d7737699d9..585f0185c0d3b 100644
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



