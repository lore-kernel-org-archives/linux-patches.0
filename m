Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7714D35C682;
	Tue, 21 Jul 2026 22:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671681; cv=none; b=LeDC/buIHNhLIqxaHmb/ffa97+YuXX0AmsAJl4U/KbYREuT+pQB4gzxi2ihgBf4Grpac1meLtpnJOJWrsX6DZvTW364Z5k7b+HZpL5WEYQdlvXEqECXJLiVCtrTcRvIcJg5/JxvV+pKe6blk2E8bmAsyw04OUpJeNa3h2LgdXC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671681; c=relaxed/simple;
	bh=KYmxCaUHaCv9uDIQATeqH0QG1l08PgKhMrPyhM5fPcY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHy9GpLA3b9uu7G3nwKW1RqUOSOnBAiVQSaVuBLIS0b9QNNOUZf1K9keZdb3fuKTrA5bn/EUomJYVOAb49yHr9xh8Q4xbE5/qN5wF9Wh4no9edazAXE5/r1Qa9Mj40o+1JoKXk/HLviip94gSHu8ryUANKAv6y8JoTzgn8960dw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sWdpwIHK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sWdpwIHK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD0561F000E9;
	Tue, 21 Jul 2026 22:07:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671680;
	bh=IVML/xnNffKro66+hO+eJShaJRQsg5ITHl5SXV4HPW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sWdpwIHKgMuseaqYNZo5GnRB9mBcZCc2qdkc9xJ6rYayR+Eo6cLOHO4EGcsozj5ZK
	 gn7xecOJOnNQBoiqAjLs9rzi56zNdQFtLX9ZLgNLuKHEWsNLwdGV8k/Xw9dcTbD3u7
	 n4c2JVTUYdLhhRw8K+D+0v0nNeu4Lx3kcVUnSoDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 338/843] ASoC: codecs: hdac_hdmi: Validate written enum value
Date: Tue, 21 Jul 2026 17:19:33 +0200
Message-ID: <20260721152413.626366683@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 0b08baeccdcf52fad328ad645f5b4fbee04eea34 ]

hdac_hdmi_set_pin_port_mux() uses the written enum value to index the
texts array before calling snd_soc_dapm_put_enum_double(), which validates
that the value is within the enum item range.

An out-of-range value can therefore make the driver read past the texts
array before the helper rejects the write. Move the lookup after the helper
has accepted the value.

Fixes: 4a3478debf36 ("ASoC: hdac_hdmi: Add jack reporting")
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260609124317.38046-2-sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/hdac_hdmi.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/hdac_hdmi.c b/sound/soc/codecs/hdac_hdmi.c
index bafdaedbee86fa..6a17926fa86928 100644
--- a/sound/soc/codecs/hdac_hdmi.c
+++ b/sound/soc/codecs/hdac_hdmi.c
@@ -906,12 +906,14 @@ static int hdac_hdmi_set_pin_port_mux(struct snd_kcontrol *kcontrol,
 	struct hdac_device *hdev = dev_to_hdac_dev(dapm->dev);
 	struct hdac_hdmi_priv *hdmi = hdev_to_hdmi_priv(hdev);
 	struct hdac_hdmi_pcm *pcm;
-	const char *cvt_name =  e->texts[ucontrol->value.enumerated.item[0]];
+	const char *cvt_name;
 
 	ret = snd_soc_dapm_put_enum_double(kcontrol, ucontrol);
 	if (ret < 0)
 		return ret;
 
+	cvt_name = e->texts[ucontrol->value.enumerated.item[0]];
+
 	if (port == NULL)
 		return -EINVAL;
 
-- 
2.53.0



