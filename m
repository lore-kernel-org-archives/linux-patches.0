Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 047E7350A0D;
	Tue, 21 Oct 2025 20:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761077415; cv=none; b=sKqZB/0kq+t091s/ea6wZW5r1jo+8wrnQU0i1NBQSxaMDp6NwOAk+MmFakjq09G4+ZOm7U0MldcmZe6LNzuouEOIXnPYhBKv+60slHcCr/DEWu7tyGKHoM1ba53tml7iHGiCHLaqYT4xtZus8+k0XxUn9PPkCqCW0z1Vd3YBB1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761077415; c=relaxed/simple;
	bh=5VDA7uYH340JmvJ8aPZ9Y5OlAf/czBSbPSFl2WpV+LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Eqhp7e7bsa+dll+Ek7KyqRbduEKsD7KNJgVT5rAJd9cGxBMwQdAvXkYmcLaOLinZeuymcuPtpNeeW2dWhtbzjin5v8icenXsx3wjTCg0Wi2GdAY9xLkShe9ex3E5JlspJdDggQpbiIJw232q24F9FfI75oWlFttoht1iJifb8jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zrKHAUlU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zrKHAUlU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E667C4CEF1;
	Tue, 21 Oct 2025 20:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761077414;
	bh=5VDA7uYH340JmvJ8aPZ9Y5OlAf/czBSbPSFl2WpV+LY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zrKHAUlUVZeRP+Hd9izbVo4TyyWZnpJS9JykQwR81d5uPXO/KKkgXKw8D/Dfb8lWw
	 NigsRdVfjUjuiBmhepsHdwJNLWykoEbEp0SL9c44ga71tkEVsYWQ+AgDA3OZwixdjn
	 ER3APkov6x8yUF55Rn3QgFiBYveJ/5fC6dh398AU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Ciocaltea <cristian.ciocaltea@collabora.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 099/159] ASoC: nau8821: Generalize helper to clear IRQ status
Date: Tue, 21 Oct 2025 21:51:16 +0200
Message-ID: <20251021195045.565569335@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195043.182511864@linuxfoundation.org>
References: <20251021195043.182511864@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>

[ Upstream commit 9273aa85b35cc02d0953a1ba3b7bd694e5a2c10e ]

Instead of adding yet another utility function for dealing with the
interrupt clearing register, generalize nau8821_int_status_clear_all()
by renaming it to nau8821_irq_status_clear(), whilst introducing a
second parameter to allow restricting the operation scope to a single
interrupt instead of the whole range of active IRQs.

While at it, also fix a spelling typo in the comment block.

Note this is mainly a prerequisite for subsequent patches aiming to
address some deficiencies in the implementation of the interrupt
handler.  Thus the presence of the Fixes tag below is intentional, to
facilitate backporting.

Fixes: aab1ad11d69f ("ASoC: nau8821: new driver")
Signed-off-by: Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
Link: https://patch.msgid.link/20251003-nau8821-jdet-fixes-v1-2-f7b0e2543f09@collabora.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/nau8821.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/nau8821.c b/sound/soc/codecs/nau8821.c
index fed5d51fa5c3b..cefce97893123 100644
--- a/sound/soc/codecs/nau8821.c
+++ b/sound/soc/codecs/nau8821.c
@@ -1021,12 +1021,17 @@ static bool nau8821_is_jack_inserted(struct regmap *regmap)
 	return active_high == is_high;
 }
 
-static void nau8821_int_status_clear_all(struct regmap *regmap)
+static void nau8821_irq_status_clear(struct regmap *regmap, int active_irq)
 {
-	int active_irq, clear_irq, i;
+	int clear_irq, i;
 
-	/* Reset the intrruption status from rightmost bit if the corres-
-	 * ponding irq event occurs.
+	if (active_irq) {
+		regmap_write(regmap, NAU8821_R11_INT_CLR_KEY_STATUS, active_irq);
+		return;
+	}
+
+	/* Reset the interruption status from rightmost bit if the
+	 * corresponding irq event occurs.
 	 */
 	regmap_read(regmap, NAU8821_R10_IRQ_STATUS, &active_irq);
 	for (i = 0; i < NAU8821_REG_DATA_LEN; i++) {
@@ -1053,7 +1058,7 @@ static void nau8821_eject_jack(struct nau8821 *nau8821)
 	snd_soc_dapm_sync(dapm);
 
 	/* Clear all interruption status */
-	nau8821_int_status_clear_all(regmap);
+	nau8821_irq_status_clear(regmap, 0);
 
 	/* Enable the insertion interruption, disable the ejection inter-
 	 * ruption, and then bypass de-bounce circuit.
@@ -1522,7 +1527,7 @@ static int nau8821_resume_setup(struct nau8821 *nau8821)
 	nau8821_configure_sysclk(nau8821, NAU8821_CLK_DIS, 0);
 	if (nau8821->irq) {
 		/* Clear all interruption status */
-		nau8821_int_status_clear_all(regmap);
+		nau8821_irq_status_clear(regmap, 0);
 
 		/* Enable both insertion and ejection interruptions, and then
 		 * bypass de-bounce circuit.
-- 
2.51.0



