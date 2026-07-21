Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 911E944AB68;
	Tue, 21 Jul 2026 21:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669180; cv=none; b=EovPluiiL031oZwKIlx8Ki4uxAj/bzNM4yzGr6y84iZ5+CleUssUHkGPx2rlLAikYYh/qQoMu5AsG8Cl9/kHiFIR+Zp47rmHs81M/fpIO3kPMBRf6I1dFEVJbOp3Eie+6S/e/6JtA24Mjh9mGdzK8b9D12jI5mlbdf93eb2Cosg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669180; c=relaxed/simple;
	bh=zftQSJoc+p/Bv/WK253Gtw/XZ2k4OaSmgb2jFblYvL0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PG9ys84l+8FzOnxX38m62E+KxnhFQs/yaYLw7DyG0wM7yyLozwSunRw9HEBIeoMZI2VMiCzqRjE/uqjGl7V9RF3wPStbYBieMXdZRcenTsPcBilVrGGu85fh5utgcp4idLc6w2aaVEz2AOgIQ9Sq4uOENv+5ocUB5zXCpOCWrNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLTrw6Pq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLTrw6Pq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02DD21F000E9;
	Tue, 21 Jul 2026 21:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669179;
	bh=sfLenDWSteaj8dAyXrd3ku9xyPk651oGAIXjGOdSgcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PLTrw6PqM9qDguSzBnVkifXf9J6cQz9Dfz74B+GaqTOYYtsORGtcLmVTqkWe60Jwc
	 iqOe0JIeks00ZZO9sGvigZQVu6QuKLC+1LX/Xns/7ZP9BRgUjYnqLDQX17sp3khYB1
	 tF0R02TNq4+Nw6tq1Qe6fwP5XieBeLgHTcEejcco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	WenTao Liang <vulab@iscas.ac.cn>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0456/1067] ALSA: core: Fix unintuitive behavior of snd_power_ref_and_wait()
Date: Tue, 21 Jul 2026 17:17:37 +0200
Message-ID: <20260721152434.817551309@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
index f142e73e2e3fd0..4b95d885a7dcf2 100644
--- a/sound/core/init.c
+++ b/sound/core/init.c
@@ -1161,7 +1161,7 @@ EXPORT_SYMBOL(snd_card_file_remove);
  * typically around calling control ops.
  *
  * The caller needs to pull down the refcount via snd_power_unref() later
- * no matter whether the error is returned from this function or not.
+ * when this function returns 0.
  *
  * Return: Zero if successful, or a negative error code.
  */
@@ -1174,7 +1174,11 @@ int snd_power_ref_and_wait(struct snd_card *card)
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
 
@@ -1191,7 +1195,8 @@ int snd_power_wait(struct snd_card *card)
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



