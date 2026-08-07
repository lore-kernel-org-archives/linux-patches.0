Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B1835677E;
	Fri,  7 Aug 2026 15:33:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116818; cv=none; b=tcZRjMPAKeC6a0YpR4qZ8eazvz/6h8ibPpBGgHo+sotJHX+/1poyVOdlxOwoQ2ARzl2yUMhGyziaJIGtEnfK0Cgi5EJeHUwTtApHn3azxqb8lSrSWZ1La9PAd4vGk2siNtKcZcsgNjsGZJtiVnJJi+hKFs3mMCKy+7PhuKJg0Mc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116818; c=relaxed/simple;
	bh=b4OjDE0DcN1vthGUIUrbgwYUb3lRgNwurThHtp/Vq9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qM5D50dl0NCyga0CsGaHtw3qqdwviIXJyuQ4orzLNqh4oIWWszhKH02EKFL386adajYz5kCUpVjV3hEq8UxwpBoNHBiYSMmaYf7YkxT1BVPv/+iVuzF8yHbVihmQo9doUogwfbuzAmYHT5F7Sefzj6bWqNzfgpfcrt7i4HMudHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWvTvpu1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWvTvpu1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D1E51F000E9;
	Fri,  7 Aug 2026 15:33:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786116817;
	bh=o8fzS4V7JXyervj4xTexhyTSu9shMRlPVbZwXhlAJu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWvTvpu1ADX2zp3JYoSh3MDQdz7U6y1K8EVKoVA526d697gxAuFiBtQi2WKPlbpop
	 BpSvUU2GvwvGt9pChJq9J8n2I5hbJW6MkdcMEJ1gwOzf5/U/4uoNOGSD2smzwafupt
	 fs2s3xxQQJMGElzWI340ZNy0WVagqxW6pTHrEb9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Surendra Singh Chouhan <kr494167@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 100/438] ASoC: sophgo: return 1 on volume change in cv1800b_adc_volume_set()
Date: Fri,  7 Aug 2026 16:34:56 +0200
Message-ID: <20260807143430.122286298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Surendra Singh Chouhan <kr494167@gmail.com>

[ Upstream commit f47064c970d3e920a27435454c02df310695f6e1 ]

cv1800b_adc_volume_set() serves as the .put callback for the "Internal
I2S Capture Volume" control.

ALSA mixer control callbacks must return 1 when the register value is
modified, 0 if unchanged, or a negative error code on failure. Returning
0 unconditionally causes ALSA core to assume the value was unchanged,
suppressing SNDRV_CTL_EVENT_MASK_VALUE change notifications to userspace
sound servers (e.g. PipeWire/PulseAudio).

Fix this by comparing the new register value with the existing register
value. If unchanged, return 0; otherwise, write the updated value and
return 1.

Fixes: 4cf8752a03e6 ("ASoC: sophgo: add CV1800B internal ADC codec driver")
Signed-off-by: Surendra Singh Chouhan <kr494167@gmail.com>
Link: https://patch.msgid.link/20260727053804.25599-1-kr494167@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sophgo/cv1800b-sound-adc.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/sound/soc/sophgo/cv1800b-sound-adc.c b/sound/soc/sophgo/cv1800b-sound-adc.c
index b66761156b993..bd93e261bdd1d 100644
--- a/sound/soc/sophgo/cv1800b-sound-adc.c
+++ b/sound/soc/sophgo/cv1800b-sound-adc.c
@@ -251,16 +251,22 @@ static int cv1800b_adc_volume_set(struct snd_kcontrol *kcontrol,
 
 	u32 v_left = clamp_t(u32, ucontrol->value.integer.value[0], 0, 24);
 	u32 v_right = clamp_t(u32, ucontrol->value.integer.value[1], 0, 24);
-	u32 val;
+	u32 val, old_val;
 
 	val = readl(priv->regs + CV1800B_RXADC_ANA0);
+	old_val = val;
+
 	val = u32_replace_bits(val, cv1800b_gains[v_left],
 			       REG_COMB_LEFT_VOLUME);
 	val = u32_replace_bits(val, cv1800b_gains[v_right],
 			       REG_COMB_RIGHT_VOLUME);
+
+	if (val == old_val)
+		return 0;
+
 	writel(val, priv->regs + CV1800B_RXADC_ANA0);
 
-	return 0;
+	return 1;
 }
 
 static DECLARE_TLV_DB_SCALE(cv1800b_volume_tlv, 0, 200, 0);
-- 
2.53.0



