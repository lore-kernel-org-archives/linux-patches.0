Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCE082F12AE;
	Tue, 16 Jun 2026 18:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781633135; cv=none; b=fN9lBZrvHLoEf0FO6+ey1xr54tOspl0s6bZVyYzpAvyjKt/3m06u3mEl3gbK+VFHzhabwopZkVFG6c2IrcR55VIExj2hXKlZ+ICPxay7aSbQoJN0qdaUwDc4IlJcfilCXE9ger+weNMTNaVdixeRE/JTG35Q5r11maUBn/cEeH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781633135; c=relaxed/simple;
	bh=k5pYwIKblx6vAOFRmrDR0is7khTWn9/z/hfqfzPcrwg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pK1hoWzPWjX9Xkj/DFxoL0HhCtJRR02G6ZQSs92Bzrh+UxzAwRaz1lTLSFCHfQ8o2DR0PMLAVFhw82Et5WM6Jv3qMAoZDbPKNBilCMNTbA6LEJaaJNWWGsoL4mMrHz669pt50dqPij2VPZse/Oneox49h7ezypiE9cP8TgLfzCY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VCkWF44Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VCkWF44Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21F621F000E9;
	Tue, 16 Jun 2026 18:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781633134;
	bh=wdCEMCkwMTcpJsM5uDr7Sp1BWRgPaEOhE1JvHEpVlAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VCkWF44YgskG+wT1+3KBOx4qkAIbaRmpbDM6zRidS/A0FLcv3r+jUq8fdVHIuvcl1
	 yY2/jnzLg8OwHs/5Qwk+HZ3ZhxEGIxnvf57WJEsD2yqFNseNLGQvNJe2f6T/cEgPt8
	 4UWmNWCS7mbYvKYADJ45GNDd9Iou1CduxYucEM1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 025/411] ASoC: codecs: simple-mux: Fix enum control bounds check
Date: Tue, 16 Jun 2026 20:24:23 +0530
Message-ID: <20260616145101.701828711@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145100.376842714@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e0a09dadfa7cf0..344bc61b9dc26a 100644
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



