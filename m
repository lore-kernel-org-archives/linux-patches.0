Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703BB5111A7;
	Wed, 30 Sep 2026 16:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790784526; cv=none; b=cZ4jIqYxE+1LGQRQELtuMaYWR9fOwHV9PULe/MOdp5jz7OEntzsAlef0JMCgnro3kftmtKrKoLY6MdIepkoOl0ywteffc19fI9eCprL2oTFQwAflXNhqlHTK/1fn3oJP+dwuBJBgwoRPFf8Bqo1BDKMgoVGvj2iXKsK6SkMhh90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790784526; c=relaxed/simple;
	bh=Ud/FIlQH8fVPooWEjAWdD8Fr6XbqYCoXJjWq+CP6Yik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BBXq9x/vcqOj6ncUxfbumjOGZ5DsUA3oA+5QchZjnpefmq5KselMPDqAq7AXrKc2RPyTcOueaQJBXoY1wjmejzr/kzOX//IBzyxwLlmQ3ORGqMzoUK1iyeISXXbzhLP2JrbbmOUh/OQ/3XFA5VhQMC6tlpyC+9Y00qxHl9d7TjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u2tLy3f9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u2tLy3f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BCD1F00893;
	Wed, 30 Sep 2026 16:08:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790784521;
	bh=77qYefBNyHvrpcJLJuJiCzq8qAZkDPyqblSSKj7ETUM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u2tLy3f9X1V//RiS9AVLJdiDYJOE2cxncC9rWfLLiuMGsXbkWHiObFMVOvlP6hc36
	 ZecBq1drFZS2SJDOmRx/XaZrzZRc/QBnOKjZM1Cf1YGVDsT3RwkUd1KMHFG0vQFzL7
	 Mh1sJE/XfA3GvWzGzzeKvKonkAKQ1lHYJ0LOWhZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko AI Review <sashiko-bot@kernel.org>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 185/982] ASoC: rockchip: rockchip_pdm: Handle runtime PM resume failures in set_fmt
Date: Wed, 30 Sep 2026 17:15:21 +0200
Message-ID: <20260930152420.791670677@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit ee7b5f7b39332febf917f9ebf212842cc9379815 ]

rockchip_pdm_set_fmt() calls pm_runtime_get_sync() before accessing
hardware registers, but ignores its return value.
If the runtime resume fails, the function continues to perform register
accesses while the device state is undefined.
Replace pm_runtime_get_sync() with pm_runtime_resume_and_get() and
return early on failure to avoid unpowered register accesses.

Reported-by: Sashiko AI Review <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/all/20260522110302.349421F000E9@smtp.kernel.org/
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260602101608.45137-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/rockchip/rockchip_pdm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/rockchip/rockchip_pdm.c b/sound/soc/rockchip/rockchip_pdm.c
index 5b1e47bdc376b..336d0eb0e8b47 100644
--- a/sound/soc/rockchip/rockchip_pdm.c
+++ b/sound/soc/rockchip/rockchip_pdm.c
@@ -322,6 +322,7 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 {
 	struct rk_pdm_dev *pdm = to_info(cpu_dai);
 	unsigned int mask = 0, val = 0;
+	int ret;
 
 	mask = PDM_CKP_MSK;
 	switch (fmt & SND_SOC_DAIFMT_INV_MASK) {
@@ -335,7 +336,10 @@ static int rockchip_pdm_set_fmt(struct snd_soc_dai *cpu_dai,
 		return -EINVAL;
 	}
 
-	pm_runtime_get_sync(cpu_dai->dev);
+	ret = pm_runtime_resume_and_get(cpu_dai->dev);
+	if (ret)
+		return ret;
+
 	regmap_update_bits(pdm->regmap, PDM_CLK_CTRL, mask, val);
 	pm_runtime_put(cpu_dai->dev);
 
-- 
2.53.0



