Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9CEF3DC4DA;
	Wed, 20 May 2026 18:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300523; cv=none; b=Ty9qvPS+DBviPiYRE7124ERMCbVJJLVpI9NyCINj5OWeVZbfJw3Y+ltpatrdQhIXJIdRvfghi0K5C3qbOVldHAYgf84kRoZaAV3v1fUZtftmfO5oWzHj7Kw6xd+8pOzh1HA3/Vn1/7yy8oj2BTEfKFEGm8Oexy5xxp7tLvC3jcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300523; c=relaxed/simple;
	bh=OwH2UU1dHDXMVTAHJAjRgHytPjY+IMgkdBX9DcrQvaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UUerYHcfb8K/Gh2Ab+VAFXuxxqvh0TFgtc4PgTFaLAMPB5dmzkKVdRYjnEppPqpp5xtG1pp3adpkaX3KrSAYiaJgVRUaBz41hwJ9MgmMhx1ao88pb8KmOTHiWu3kGB0fk35/VOWRzLWB0s5krdXU8Ptj3YqpoqCK8yGP9CidF4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MwHK9uvz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MwHK9uvz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A0191F000E9;
	Wed, 20 May 2026 18:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300522;
	bh=7nIApO0SBkvQ/D9H2iX1qwcsKxs1bFO5BtzoytZ9zsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MwHK9uvz+BiA+E7tl/Km732uhrjWJdBfq983c1LT/Gf6ZcCewAN3jDgB9xvBOGjvB
	 0KX/1vpxVMfGEgIzWrmogC67d7CVAqmss2LJObmtOhwDyUuWx+D6ymbJstKm67mL+s
	 DcCtiU5N+CwZoGvBW0gC17coFg2Ls02mZy9P42/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shengjiu Wang <shengjiu.wang@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 205/666] ASoC: fsl_easrc: Check the variable range in fsl_easrc_iec958_put_bits()
Date: Wed, 20 May 2026 18:16:56 +0200
Message-ID: <20260520162115.650302265@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shengjiu Wang <shengjiu.wang@nxp.com>

[ Upstream commit 00541b86fb578d4949cfdd6aff1f82d43fcf07af ]

Add check of input value's range in fsl_easrc_iec958_put_bits(),
otherwise the wrong value may be written from user space.

Fixes: 955ac624058f ("ASoC: fsl_easrc: Add EASRC ASoC CPU DAI drivers")
Signed-off-by: Shengjiu Wang <shengjiu.wang@nxp.com>
Link: https://patch.msgid.link/20260401094226.2900532-10-shengjiu.wang@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_easrc.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_easrc.c b/sound/soc/fsl/fsl_easrc.c
index 5461a8b44a097..0f8c5210e358e 100644
--- a/sound/soc/fsl/fsl_easrc.c
+++ b/sound/soc/fsl/fsl_easrc.c
@@ -54,6 +54,9 @@ static int fsl_easrc_iec958_put_bits(struct snd_kcontrol *kcontrol,
 	unsigned int regval = ucontrol->value.integer.value[0];
 	int ret;
 
+	if (regval < EASRC_WIDTH_16_BIT || regval > EASRC_WIDTH_24_BIT)
+		return -EINVAL;
+
 	ret = (easrc_priv->bps_iec958[mc->regbase] != regval);
 
 	easrc_priv->bps_iec958[mc->regbase] = regval;
-- 
2.53.0



