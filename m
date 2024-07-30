Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACC441A6192;
	Tue, 30 Jul 2024 17:05:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359129; cv=none; b=qHWtUdPNEx113romNu0EyvxN+fGHbP+5658tqwj6DTnhstLn6K4ujglnXmnSgRJv3KEbilJEz3u0BYHfLFu420CdWz0q23mSuSpyYTCsmaS0cR5EFJylB1K4NxvTa0zOPt2NnQBSdM+lzsrN/H/lkD4dobZoVlJMKVofXaUGK/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359129; c=relaxed/simple;
	bh=Fx+Mq7pl3sUIwLA12lVQpVPXeAdHhbNJ99pJi3V0IsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qKORA3D6Bd5/8ENPkRhrnn6aAJYp3QNxrUP08vkNYdO/luzZNcJG/7U3jw/UqchfmqSvGpQ4RH6LtbxLN7D7Kgv/9bHHdw4u8fbHM2odFIQS2ldqn4l6hyuqHOXYy4sgiaZKdkoYfyrxrgFMpbBK8SITEOS0uY3HKUXQ4T2Fy04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oCzdo72Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oCzdo72Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36DB9C32782;
	Tue, 30 Jul 2024 17:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359129;
	bh=Fx+Mq7pl3sUIwLA12lVQpVPXeAdHhbNJ99pJi3V0IsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oCzdo72ZM7fsf+cJTrKab7Bs+HERCrkd8z+3HDMkc3pvQfu7Nq/aGMncX5xXcEVv7
	 mjK5EVTV2QkRykulwBja9B2Rham6syrqvW3jyR+W2NJehKVyVyZmpd4kyP4Yj66vlb
	 OfT7fAim/TOh9zNMALEkwv2+DrP9QjbJnnqJTs1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 435/568] ASoC: fsl: fsl_qmc_audio: Check devm_kasprintf() returned value
Date: Tue, 30 Jul 2024 17:49:02 +0200
Message-ID: <20240730151656.872637842@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit e62599902327d27687693f6e5253a5d56583db58 upstream.

devm_kasprintf() can return a NULL pointer on failure but this returned
value is not checked.

Fix this lack and check the returned value.

Fixes: 075c7125b11c ("ASoC: fsl: Add support for QMC audio")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://patch.msgid.link/20240701113038.55144-2-herve.codina@bootlin.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/fsl/fsl_qmc_audio.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/fsl/fsl_qmc_audio.c b/sound/soc/fsl/fsl_qmc_audio.c
index bfaaa451735b..dd90ef16fa97 100644
--- a/sound/soc/fsl/fsl_qmc_audio.c
+++ b/sound/soc/fsl/fsl_qmc_audio.c
@@ -604,6 +604,8 @@ static int qmc_audio_dai_parse(struct qmc_audio *qmc_audio, struct device_node *
 
 	qmc_dai->name = devm_kasprintf(qmc_audio->dev, GFP_KERNEL, "%s.%d",
 				       np->parent->name, qmc_dai->id);
+	if (!qmc_dai->name)
+		return -ENOMEM;
 
 	qmc_dai->qmc_chan = devm_qmc_chan_get_byphandle(qmc_audio->dev, np,
 							"fsl,qmc-chan");
-- 
2.45.2



