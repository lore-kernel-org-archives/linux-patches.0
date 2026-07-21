Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0EE395266;
	Tue, 21 Jul 2026 18:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659904; cv=none; b=IECu+XiAd7EIDsBKmxfilzUL36NJb5Zv/wQi90VR9ihPahiVBiPVnLsLpGEuPPeOduWIfSjlG3WM4HMRxe2q9KfvZEDQJMmIv7Zn9eJMbYUB87nW8VnkCsaJxYYmZxusoc1ttd6o5JdH0SKhfALZ9h8PxRZLVL/aiuvB5RFeuv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659904; c=relaxed/simple;
	bh=nI2QRdrYYzPGNHru0Pmkf+9ELZ+y9THLC6iqDxYc4io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DpnPvvg2OpZ3L2Ju8kmpMOopdyuWpLJxrd1D+iA/k8EwCTXnv9QvUE1T4WzVgapEV2RIRu6FXCugdkUMQYuPqDDAhKzg6PvnA7k6cPfFEI7yyc72/9fgrSX2IN98JFYyFJDSBJo3vy8ohcWC8kdsO/mnPCnk4G9ZZW85R5KuLoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o+ZSAyee; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o+ZSAyee"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D51F000E9;
	Tue, 21 Jul 2026 18:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659903;
	bh=q1t2FOHN173Ut6c/qCtVZ9Wt8jgRuADgJXMwrqa+68Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o+ZSAyeeg/6liKfGN3z6lkezWCR/TKOUU/bAOUHPkSMrlLLSmbY08sjsmhKRuTmWX
	 Q26Xj67zvaVvCQJ/bYlZCpXHsFSjWehWwyFMz8V469F4OUAITRRXE8NDcmil95AThE
	 IjiDAq5auVQn1tDmaon7ym1anEWJonywCsCy94HA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0775/2077] ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
Date: Tue, 21 Jul 2026 17:07:28 +0200
Message-ID: <20260721152611.075380867@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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
index 0c316189e94769..9bff101af6478f 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1139,7 +1139,7 @@ EXPORT_SYMBOL(snd_card_file_remove);
  * typically around calling control ops.
  *
  * The caller needs to pull down the refcount via snd_power_unref() later
- * no matter whether the error is returned from this function or not.
+ * when this function returns 0.
  *
  * Return: Zero if successful, or a negative error code.
  */
@@ -1152,7 +1152,11 @@ int snd_power_ref_and_wait(struct snd_card *card)
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
 
@@ -1169,7 +1173,8 @@ int snd_power_wait(struct snd_card *card)
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



