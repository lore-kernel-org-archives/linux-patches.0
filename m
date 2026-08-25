Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0AC62ED154;
	Tue, 25 Aug 2026 13:41:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665275; cv=none; b=PGRD7l/fBHobSEXox5tntPodpSTuOqNE2O2cyn9Rpt//BJkry0o2Zol+cszJ6czI4cTqWZDx26lWIrJOrS0IwTjNpQHR1E1sj08xfRfkcygJkA0wyySLkaeMDTz/HmP5ee2cn9L7kAbtMFI4QkQaPj5RJ2oqYnasgla2dTGTIQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665275; c=relaxed/simple;
	bh=yD31dKvIfhQ2WPSOXVEM4AXfOa7kNAhgQcoBgSR0+gc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IRW9adsA2X+7tltTaD5MklmD3PNx7IonfCzz+g8MXh5TZvxPXy799TkkqhWP472LsmeXg2DcdadUHKL+d+ReFywBmFMlgpIiiFQI0kH7YIMef9RmBE/uRQGlul+FYs5E4ZKUqnSMMiMdJP55qG95FML40vk1RrDaPQfCAnVu1/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m3VdRSZu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m3VdRSZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187FF1F000E9;
	Tue, 25 Aug 2026 13:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665273;
	bh=TJlrWUn3Fn1PL/KyvAjAjwiuEiyTVAQoOPqMhYT9pBc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m3VdRSZuSsqk9ja6bHX5VfD2sb+2hfA22UePSk3V4RfhtVEHVvfO5X3g1HrGILxHm
	 VotCW+5D+WpzM3qbJXsqsNYyAvBiodthYOCbM/4ErGxK0k9uewo0KLZ7GDhp+wpwge
	 2j9pdl1uD23NVF94wAr/lk6nCnMxnt0pCajhndVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Dawid=20Wro=CC=81bel?= <me@dawidwrobel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 64/94] ASoC: codecs: lpass-tx-macro: Fix enum kcontrol accesses
Date: Tue, 25 Aug 2026 15:26:00 +0200
Message-ID: <20260825132544.406380231@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dawid Wróbel <me@dawidwrobel.com>

[ Upstream commit 1ba381759e45d5d0442452cfa5c42e836191a568 ]

The "DEC0 MODE" to "DEC7 MODE" controls are enumerated, but
tx_macro_dec_mode_get() and tx_macro_dec_mode_put() access their
value through ucontrol->value.integer.value[0] (a long) instead of
ucontrol->value.enumerated.item[0] (an unsigned int).

This same pattern was fixed in the sibling drivers by
commit bcfe5f76cc40 ("ASoC: codecs: rx-macro: fix accessing array
out of bounds for enum type") and
commit 0ea5eff7c606 ("ASoC: codecs: va-macro: fix accessing array
out of bounds for enum type"), but tx-macro was missed.

On 64-bit kernels built with CONFIG_SND_CTL_DEBUG, the elem value
sanity check catches the 4 bytes written past the enumerated item
and every read of these controls fails with -EINVAL:

  snd-sm8250 sound: control 2:0:0:DEC0 MODE:0: access overflow

Fixes: c39667ddcfc5 ("ASoC: codecs: lpass-tx-macro: add support for lpass tx macro")
Assisted-by: Claude:claude-fable-5
Cc: stable@vger.kernel.org
Signed-off-by: Dawid Wróbel <me@dawidwrobel.com>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@oss.qualcomm.com>
Link: https://patch.msgid.link/20260730-worktree-lpass-tx-macro-enum-fix-v2-1-6d091c736116@dawidwrobel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ kept `snd_soc_kcontrol_component()` context line instead of upstream's renamed `snd_kcontrol_chip()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/lpass-tx-macro.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/lpass-tx-macro.c
+++ b/sound/soc/codecs/lpass-tx-macro.c
@@ -1075,7 +1075,7 @@ static int tx_macro_dec_mode_get(struct
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 
-	ucontrol->value.integer.value[0] = tx->dec_mode[path];
+	ucontrol->value.enumerated.item[0] = tx->dec_mode[path];
 
 	return 0;
 }
@@ -1084,7 +1084,7 @@ static int tx_macro_dec_mode_put(struct
 				 struct snd_ctl_elem_value *ucontrol)
 {
 	struct snd_soc_component *component = snd_soc_kcontrol_component(kcontrol);
-	int value = ucontrol->value.integer.value[0];
+	int value = ucontrol->value.enumerated.item[0];
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	int path = e->shift_l;
 	struct tx_macro *tx = snd_soc_component_get_drvdata(component);


