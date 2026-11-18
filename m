Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026490;
	b=qjukoqC0Cr4GPkWTnPvsvlu1n/EkDhpnsaP9Dm/NGWWlXho539BgDWaqG94ozo8js0YT
	 BjhyStR5YM17C9RSzDjMM4ZosDBZ5GM5Nkj3dZMqMYLvoJVcUXU6oon/1FoDxCvqA9dwy
	 tZUiCloyYhBXFdFL7xyfCHYHeBl/UHjg+Olo0xSoPXa6taEnss2pgcT4MvrpHVDTVEEou
	 5uLS25aTU8mzsOvWCPE4yMSSllHUvolsP9JiP3fEicCaCg5KOMn1rbnh4A2LYLgbQ7zj2
	 uCh+hq1qWiraINlkedY8S9eRLHetYtUlAmPDiGBozYi2Le4FXnvYXtqvITxUCmMCRjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026490;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RIp3ADI6aFqpSflXbILSweiz6a8SHfiTwb5sZj+00ZA=;
	b=m/E/z6/cKgf4AZW+hLnMEZPOeTM1w1ciTnIOsXz9guqcZApj/pP4P/zg8F3ZJWTInSMn
	 W61rkZjkYfSs5tI3Hmy7HzBLHg1s9lIIKU0XMEUqZir5i/SaGEPYDiywnom5JN7RKvKjI
	 HfxZjHKXTQqhKXGm0urjJbeiL7azI5+XYHp88HYFRepeDv2tVFlZuOMROYtCroc8XlccM
	 bn9PJGXzKoGvTghAMYoT2VhLQCV+ioLpBoTNSc3VzmYg4xAZWXSKlhOGnUPTXaeHVUkuW
	 SzuHtS0ZB/MFMkt4Sdt2wBM7HUMUfXRQdj/mtaut+6I4GcFKXzawX/so/XDzdWIOtmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyZIgixT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF73D606A320;
	Wed, 18 Nov 2026 18:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tyZIgixT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253AF1F000C5;
	Wed, 18 Nov 2026 18:28:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026490;
	bh=RIp3ADI6aFqpSflXbILSweiz6a8SHfiTwb5sZj+00ZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tyZIgixTgSOy4RUKIfz1BOwaZ8IptqWQ4/BdFR+xWjRLdX/9+IXDBWku+zcQrlZA0
	 s60LprXApcXokHD2T9qAhDs87alNUqMt1zhjSLegxOrVtay+25vKezfBfdyTWadbcY
	 gs5zia1ppMzTVbMnhz5swP2LtqscvIxMFlZYOzPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1453/2151] ASoC: atmel: atmel-pcm-pdc: Fix atmel_pcm_close() being skipped on rollback
Date: Wed, 18 Nov 2026 15:53:08 +0100
Message-ID: <20261118150214.844767967@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 50aaca643038774b6779c911c4f96bc7e0d607e9 ]

snd_pcm_hw_constraint_integer() may return 1, which is then returned
from atmel_pcm_open(). ASoC only marks the component as opened
when .open() returns 0, so .close() can be skipped on rollback.

Return 0 explicitly on success.

Fixes: 92dfa6198623 ("ASoC: atmel-pcm: split into two file")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261008103831.542533-10-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/atmel/atmel-pcm-pdc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/atmel/atmel-pcm-pdc.c b/sound/soc/atmel/atmel-pcm-pdc.c
index 7db8df85c54f3..ea834d3fd8c3a 100644
--- a/sound/soc/atmel/atmel-pcm-pdc.c
+++ b/sound/soc/atmel/atmel-pcm-pdc.c
@@ -295,6 +295,8 @@ static int atmel_pcm_open(struct snd_soc_component *component,
 	}
 	runtime->private_data = prtd;
 
+	return 0;
+
  out:
 	return ret;
 }
-- 
2.53.0



