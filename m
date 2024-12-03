Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8264B1F76AD;
	Tue,  3 Dec 2024 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242204; cv=none; b=ZHQdHZULDd4Z2vbLbvvwuazsgA922J7R7UrRUnJ29vPCGepL9FDF3rQqGbjlLHNg/eh2Gpt0SrEP7tutN3gBlGDWj1Nh0GZJxR/1RmUXoME26f6mxEw90WffYPnKIOPQZLo1vSwmexZrueOlz+clOV/w7+pA20tV3aT6/jsDPB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242204; c=relaxed/simple;
	bh=7mfXtonGRubR5iWSXS6l5ZRZugY5DcyBV0NAw2IeICE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=agW2Llegij2z17F3OHtOGN9eWNE2con1Ww/bCsUyZldgkg6ra01VMyZux66uhpzyfo5Z4MkhlQxNp1D9eol7Nopb6xZ67n+SpzkiqgbgZozZp7Vbth8dXDt2ddg/RkAqq4W3QgAm1ZNwF7mRE6jFh65vu80BEzaGsIsuLjjqy0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qp2a6upL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qp2a6upL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5C0AC4CED8;
	Tue,  3 Dec 2024 16:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242204;
	bh=7mfXtonGRubR5iWSXS6l5ZRZugY5DcyBV0NAw2IeICE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qp2a6upLXsppOJSq+xVSNiZddNo1mSyezSzqFS1HPAMinzy0kjX4dnvBf2rJdM/UX
	 NfQ8WvvSdPZx0rpJ8Bl61VN5hmw8C5gNMYCOzHmwdoL79ZjIAeV2XadEaU5+F1jnKh
	 o1kNTTx9KFyQCmkz/bONvCSftOIXzRegnqThau9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 637/826] ASoC: da7213: Populate max_register to regmap_config
Date: Tue,  3 Dec 2024 15:46:04 +0100
Message-ID: <20241203144808.600183718@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>

commit 9d4f9f6a7bb1afbde57d08c98f2db4ff019ee19d upstream.

On the Renesas RZ/G3S SMARC Carrier II board having a DA7212 codec (using
da7213 driver) connected to one SSIF-2 available on the Renesas RZ/G3S SoC
it has been discovered that using the runtime PM API for suspend/resume
(as will be proposed in the following commits) leads to the codec not
being propertly initialized after resume. This is because w/o
max_register populated to regmap_config the regcache_rbtree_sync()
breaks on base_reg > max condition and the regcache_sync_block() call is
skipped.

Fixes: ef5c2eba2412 ("ASoC: codecs: Add da7213 codec")
Cc: stable@vger.kernel.org
Signed-off-by: Claudiu Beznea <claudiu.beznea.uj@bp.renesas.com>
Link: https://patch.msgid.link/20241106081826.1211088-23-claudiu.beznea.uj@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/da7213.c |    1 +
 1 file changed, 1 insertion(+)

--- a/sound/soc/codecs/da7213.c
+++ b/sound/soc/codecs/da7213.c
@@ -2136,6 +2136,7 @@ static const struct regmap_config da7213
 	.reg_bits = 8,
 	.val_bits = 8,
 
+	.max_register = DA7213_TONE_GEN_OFF_PER,
 	.reg_defaults = da7213_reg_defaults,
 	.num_reg_defaults = ARRAY_SIZE(da7213_reg_defaults),
 	.volatile_reg = da7213_volatile_register,


