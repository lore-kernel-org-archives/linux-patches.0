Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15C3812FB03;
	Tue, 14 May 2024 10:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715684061; cv=none; b=ilEV4m+lGj+CgwbN9g9mgV0aG6AclU3ceQeQxmaVmJnw83OmPV3kFggETHlIVdI6dIocLMI8EKX5wjVYOiz0sSrn0UFsMx3yZot2SbIb0OYudDJkCn2YHLkA6DGp1+4bYKj20wm/d5D/H1adj7aI4+pqf6gdb8KOZnjeG7EO5Y8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715684061; c=relaxed/simple;
	bh=nohMFwGU9om1mJSuCwHNDkJZ9tAPCSzy7dqh5mK3E5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9LWc+8w6jPFoyJhMgGVDRZXxEYZuplYfEk0HR2gC9nwPcREFUDEDuTSZ3fSu9UCdXlS4kNzOOtauM+YsyjanLcebaq2cpvLoGgHqVJaxEqsEgo05aRIieeInuo3vPCObmzDrwBG52aWp48+yuDhzAOdG50RXkvsSBUvjRY8iaQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OQPi74jT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OQPi74jT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02E07C2BD10;
	Tue, 14 May 2024 10:54:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715684061;
	bh=nohMFwGU9om1mJSuCwHNDkJZ9tAPCSzy7dqh5mK3E5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OQPi74jT985Km7Bk3TdwV/sf8cevhfy132R6kD7kEshVokUfrlAn8yekGucvbKxsr
	 e+7xiifWvdpv2LsPel+wQVP/yTS4BjBmNb8Mq3aztl5fRSMSwagZwh2gI9rkdK0Z2g
	 MdFK67ukrVV5BV51/37su6WRCPxf226m23ZM5v+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joao Paulo Goncalves <joao.goncalves@toradex.com>,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Jai Luthra <j-luthra@ti.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.8 286/336] ASoC: ti: davinci-mcasp: Fix race condition during probe
Date: Tue, 14 May 2024 12:18:10 +0200
Message-ID: <20240514101049.415702817@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Joao Paulo Goncalves <joao.goncalves@toradex.com>

commit d18ca8635db2f88c17acbdf6412f26d4f6aff414 upstream.

When using davinci-mcasp as CPU DAI with simple-card, there are some
conditions that cause simple-card to finish registering a sound card before
davinci-mcasp finishes registering all sound components. This creates a
non-working sound card from userspace with no problem indication apart
from not being able to play/record audio on a PCM stream. The issue
arises during simultaneous probe execution of both drivers. Specifically,
the simple-card driver, awaiting a CPU DAI, proceeds as soon as
davinci-mcasp registers its DAI. However, this process can lead to the
client mutex lock (client_mutex in soc-core.c) being held or davinci-mcasp
being preempted before PCM DMA registration on davinci-mcasp finishes.
This situation occurs when the probes of both drivers run concurrently.
Below is the code path for this condition. To solve the issue, defer
davinci-mcasp CPU DAI registration to the last step in the audio part of
it. This way, simple-card CPU DAI parsing will be deferred until all
audio components are registered.

Fail Code Path:

simple-card.c: probe starts
simple-card.c: simple_dai_link_of: simple_parse_node(..,cpu,..) returns EPROBE_DEFER, no CPU DAI yet
davinci-mcasp.c: probe starts
davinci-mcasp.c: devm_snd_soc_register_component() register CPU DAI
simple-card.c: probes again, finish CPU DAI parsing and call devm_snd_soc_register_card()
simple-card.c: finish probe
davinci-mcasp.c: *dma_pcm_platform_register() register PCM  DMA
davinci-mcasp.c: probe finish

Cc: stable@vger.kernel.org
Fixes: 9fbd58cf4ab0 ("ASoC: davinci-mcasp: Choose PCM driver based on configured DMA controller")
Signed-off-by: Joao Paulo Goncalves <joao.goncalves@toradex.com>
Acked-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Reviewed-by: Jai Luthra <j-luthra@ti.com>
Link: https://lore.kernel.org/r/20240417184138.1104774-1-jpaulo.silvagoncalves@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/ti/davinci-mcasp.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/sound/soc/ti/davinci-mcasp.c
+++ b/sound/soc/ti/davinci-mcasp.c
@@ -2417,12 +2417,6 @@ static int davinci_mcasp_probe(struct pl
 
 	mcasp_reparent_fck(pdev);
 
-	ret = devm_snd_soc_register_component(&pdev->dev, &davinci_mcasp_component,
-					      &davinci_mcasp_dai[mcasp->op_mode], 1);
-
-	if (ret != 0)
-		goto err;
-
 	ret = davinci_mcasp_get_dma_type(mcasp);
 	switch (ret) {
 	case PCM_EDMA:
@@ -2449,6 +2443,12 @@ static int davinci_mcasp_probe(struct pl
 		goto err;
 	}
 
+	ret = devm_snd_soc_register_component(&pdev->dev, &davinci_mcasp_component,
+					      &davinci_mcasp_dai[mcasp->op_mode], 1);
+
+	if (ret != 0)
+		goto err;
+
 no_audio:
 	ret = davinci_mcasp_init_gpiochip(mcasp);
 	if (ret) {


