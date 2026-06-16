Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DB974508E4;
	Tue, 16 Jun 2026 16:41:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781628118; cv=none; b=C2fhCgFmWAsTeZ8q0KnRl2/fo/nFA+myZblbLpHNpDMln0Qa129xgUX8MBuK5kYDTFiq8xoDceoESiHDd0l8zFzLSPGSeSmNdzJX2yam+fo2lnX6ofNSoP1THUNQPRVw9AxxNQZGsAiVDUtOoCECKmEmXxiQwteCg0yjzs2IJbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781628118; c=relaxed/simple;
	bh=LpAx6SNZuNLsOMOmIs77ZRY2TXETXPDfZpUzqcOY0ik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nGj868ssCse61++ZWB3/mqELYIh7zmU2k/nYqt5JgfWlxc7V79pOqBwjM+FtcFX1vfGdG4Us6wyPh5y/py1NL8xcwLzWO5uzrrf8ORWH8Hw7E13zjxsxsjHDqiyG5lcWVnRQocImija5tB/9d46PJYGXQg/6go/wl7WByMt7IEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wzwSh40h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wzwSh40h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F2E61F000E9;
	Tue, 16 Jun 2026 16:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781628117;
	bh=nkR3NkxVb4TnqNgjBzAXCayNm5LVQ8DG3A696lVBo4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzwSh40he54RxM7I3cciX3GhAZTOHb+X87kcf9eD9hyFVtiGQ67OLUAx1LgRXrsFK
	 TPVDBq06GVxPYxMGGMVo2L0nx/4bO+hUNwLsbPu6cK+Z07tyzvySB1pXPQNcBRBge7
	 /ItWrObRb1M/f7DdPiFxVfLWrF7psf1zKvHlsDRE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/452] ASoC: codecs: simple-mux: Fix enum control bounds check
Date: Tue, 16 Jun 2026 20:24:21 +0530
Message-ID: <20260616145119.719050660@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index bf67de12d20b7f..02ccaa4c9a0804 100644
--- a/sound/soc/codecs/simple-mux.c
+++ b/sound/soc/codecs/simple-mux.c
@@ -40,7 +40,7 @@ static int simple_mux_control_put(struct snd_kcontrol *kcontrol,
 	struct snd_soc_component *c = snd_soc_dapm_to_component(dapm);
 	struct simple_mux *priv = snd_soc_component_get_drvdata(c);
 
-	if (ucontrol->value.enumerated.item[0] > e->items)
+	if (ucontrol->value.enumerated.item[0] >= e->items)
 		return -EINVAL;
 
 	if (priv->mux == ucontrol->value.enumerated.item[0])
-- 
2.53.0



