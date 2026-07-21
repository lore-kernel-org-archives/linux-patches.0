Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D4D3B47E5;
	Tue, 21 Jul 2026 20:36:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666184; cv=none; b=bDGyHD4n27sd1A60F5bSIxGehudV9psv3+D9mn614KCPnC6Xb1VegqDWLgmrtTz0yZsTVEQPkMnDOgV5lWHlktH+R6BTzTTHDymkdqDmvDFZ5GJSkAnpj4vQvYVf1jcd4GAmmblvcq5pIM1ydZOZ9hsgOIFREubKsYhTK4oNMx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666184; c=relaxed/simple;
	bh=CfqjFdYrR83mxeXpgaQgXdYRDuzwGQTsdNOcq3Rkxfk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTlNr+faqvzNMewO66pYt1IqUlKWRZuwr9lxRYhKUfjeEoLoeQ4Z/omJt+dJxfiTON/UTs1QcU+7vdd9z2u7Pkvxpkr0HnqItP5M987WsfIvaI078M7hsdqf1cb6cnZyVsUvMapiu3iz0rL8siMhXnJA01BG7a0JJEAAInnkMf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K0CJ6GBn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K0CJ6GBn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66D751F000E9;
	Tue, 21 Jul 2026 20:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666182;
	bh=8MyTRGmF10W1rjmdcnFPUI1DYQg3+OPpm6qfxVrPIRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K0CJ6GBnTyYjs1MNdaoJNgirn4AAeLWzFiFO+1ngKl+O0pUXHgxm7BpaWVmh1NTA9
	 DiH9LSi5Z5qa0pyVARrK7sECBabtAI3//nTI5WrpO6d96Ym4YxeL3yYJKWGc7nzUHK
	 fGA/fvis83x5lOmjgn58p0pdJjxAxgVwlg5zgz9Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0585/1266] ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
Date: Tue, 21 Jul 2026 17:17:02 +0200
Message-ID: <20260721152454.956078266@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit b113a891252c3fa4fab11ec8c2894a22ecaf278c ]

snd_power_ref_and_wait() takes the power refcount and doesn't leave it
no matter whether it returns an error or not.  However, the majority
of callers don't expect but just returns without unreferencing in the
caller side upon errors.

For addressing the potential refcount unbalance, rather correct the
behavior of snd_power_ref_wait() to unreference upon returning an
error.

Note that the problem above is likely negligible; the function returns
an error only when the sound card is being shutdown, hence it doesn't
matter about the power refcount any longer at such a state.

Fixes: e94fdbd7b25d ("ALSA: control: Track in-flight control read/write/tlv accesses")
Reported-by: WenTao Liang <vulab@iscas.ac.cn>
Closes: https://lore.kernel.org/20260612022121.14329-1-vulab@iscas.ac.cn
Link: https://patch.msgid.link/20260614090507.772540-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/init.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/sound/core/init.c b/sound/core/init.c
index 81186af3ac625c..0dc1d25be18404 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1154,7 +1154,7 @@ EXPORT_SYMBOL(snd_card_file_remove);
  * typically around calling control ops.
  *
  * The caller needs to pull down the refcount via snd_power_unref() later
- * no matter whether the error is returned from this function or not.
+ * when this function returns 0.
  *
  * Return: Zero if successful, or a negative error code.
  */
@@ -1167,7 +1167,11 @@ int snd_power_ref_and_wait(struct snd_card *card)
 		       card->shutdown ||
 		       snd_power_get_state(card) == SNDRV_CTL_POWER_D0,
 		       snd_power_unref(card), snd_power_ref(card));
-	return card->shutdown ? -ENODEV : 0;
+	if (card->shutdown) {
+		snd_power_unref(card);
+		return  -ENODEV;
+	}
+	return 0;
 }
 EXPORT_SYMBOL_GPL(snd_power_ref_and_wait);
 
@@ -1184,7 +1188,8 @@ int snd_power_wait(struct snd_card *card)
 	int ret;
 
 	ret = snd_power_ref_and_wait(card);
-	snd_power_unref(card);
+	if (!ret)
+		snd_power_unref(card);
 	return ret;
 }
 EXPORT_SYMBOL(snd_power_wait);
-- 
2.53.0



