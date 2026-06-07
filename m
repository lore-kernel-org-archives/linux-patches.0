Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A22302E2DDD;
	Sun,  7 Jun 2026 10:11:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827098; cv=none; b=FZNGPS+D7Mqbyl2PEvTY4mSvQAp6SKaFDJlA6NbyBTSWQ2bK5R9GRTDJVfo0FGqqvaahC9OGkFEu+PzyxOLPy/FhuVW0pyWACk3GOm6S8+25v/cCI+0xHOvT8bQnsETbOfTvmitNd+WOukaJSDHfei+RlPirOy1qpbdnPAdoT1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827098; c=relaxed/simple;
	bh=ZysLHZEAFQIs1V9stxUEVhQFfxEV0sNPTuCe5aOflNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NwC6la/HcGpLJ5c66hBbVfWYrYNHUgKCq3TkOfhrzQ3IMji9GKLFdvCBx73YPRnfNUIiuiirv9NlxHzh/GDT8PujvlD+gK+DyuenLPAScmc+mCT/B45wueGwdy2KRegSRztJfNaIBAAWbvbkgxXUw2IjjD4GUforXSFooJlLu70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uy9Tg9OQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uy9Tg9OQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919621F00893;
	Sun,  7 Jun 2026 10:11:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827096;
	bh=BTA3ayOCUI5CvHT1Wu4aEAXEfMdrmTo26xokmgbvU/E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uy9Tg9OQn+qgdpI3rFdCsw938jojulK4kahp1e1dTpjPpONpj4WwifmJ96He1ggP1
	 dHjBBirZ+4F9vlmtCIjn/VuzV/E+k79bxMjh5Azr/Jcm9to9xntF2IQQqfu+d0P+UJ
	 x2O6KVGzVpUIA1Yjz1XrROqxo778tw+xtrC1VnsE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 062/332] ASoC: codecs: simple-mux: Fix enum control bounds check
Date: Sun,  7 Jun 2026 11:57:11 +0200
Message-ID: <20260607095730.408997341@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit f63ad68e18d774a5d15cd7e405ead63f6b322679 ]

simple_mux_control_put() rejects values greater than e->items, but
enum control values are zero based. For the two-entry mux used by this
driver, valid values are 0 and 1, so value 2 must be rejected as well.

Accepting e->items can store an invalid mux state, pass it to the GPIO
setter, and pass it on to the DAPM mux update path where it is used as
an index into the enum text array.

Use the same >= e->items check used by the ASoC enum helpers.

Fixes: 342fbb7578d1 ("ASoC: add simple-mux")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260527-asoc-simple-mux-enum-bounds-v1-1-3f805b9fc671@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/simple-mux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/simple-mux.c b/sound/soc/codecs/simple-mux.c
index 069555f35f7359..c2f906a3f074ce 100644
--- a/sound/soc/codecs/simple-mux.c
+++ b/sound/soc/codecs/simple-mux.c
@@ -51,7 +51,7 @@ static int simple_mux_control_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *c = snd_soc_dapm_to_component(dapm);
 	struct simple_mux *priv = snd_soc_component_get_drvdata(c);
 
-	if (ucontrol->value.enumerated.item[0] > e->items)
+	if (ucontrol->value.enumerated.item[0] >= e->items)
 		return -EINVAL;
 
 	if (priv->mux == ucontrol->value.enumerated.item[0])
-- 
2.53.0



