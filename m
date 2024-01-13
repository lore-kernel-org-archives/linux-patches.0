Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DA701848;
	Sat, 13 Jan 2024 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yRKpiBo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B37C433C7;
	Sat, 13 Jan 2024 10:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705140096;
	bh=unhP22j/IttJyihBACtXRHr5X6e6UTcGpLKoEl1fFic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRKpiBo0GMWngcp9cK9exp1Y1IXBxoMXxwUSnM8UErJZ26UtoVd4Dy3hKW4VrsWT2
	 F4mDmWdrdedpVB8LGc01XP/9k1gI+ix8aKSrGfDesqK80ShpSWVypQB2Y9miy7E+UA
	 1d0iKzQYPMvVK90AitIqFw0md0FoRUhVGpfRWYug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 28/59] ASoC: meson: g12a-toacodec: Validate written enum values
Date: Sat, 13 Jan 2024 10:49:59 +0100
Message-ID: <20240113094210.172870426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
References: <20240113094209.301672391@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Mark Brown <broonie@kernel.org>

[ Upstream commit 3150b70e944ead909260285dfb5707d0bedcf87b ]

When writing to an enum we need to verify that the value written is valid
for the enumeration, the helper function snd_soc_item_enum_to_val() doesn't
do it since it needs to return an unsigned (and in any case we'd need to
check the return value).

Fixes: af2618a2eee8 ("ASoC: meson: g12a: add internal DAC glue driver")
Signed-off-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20240103-meson-enum-val-v1-1-424af7a8fb91@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/meson/g12a-toacodec.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/meson/g12a-toacodec.c b/sound/soc/meson/g12a-toacodec.c
index 1dfee1396843c..10a2ff1ecf33e 100644
--- a/sound/soc/meson/g12a-toacodec.c
+++ b/sound/soc/meson/g12a-toacodec.c
@@ -71,6 +71,9 @@ static int g12a_toacodec_mux_put_enum(struct snd_kcontrol *kcontrol,
 	struct soc_enum *e = (struct soc_enum *)kcontrol->private_value;
 	unsigned int mux, reg;
 
+	if (ucontrol->value.enumerated.item[0] >= e->items)
+		return -EINVAL;
+
 	mux = snd_soc_enum_item_to_val(e, ucontrol->value.enumerated.item[0]);
 	regmap_field_read(priv->field_dat_sel, &reg);
 
-- 
2.43.0



