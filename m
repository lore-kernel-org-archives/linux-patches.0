Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 707831D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:00:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E14FEC433C7;
	Tue, 25 Jul 2023 11:00:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282832;
	bh=tw+DjXXLppjdV7VzR4ztWLAsfVm72/NGBJggAufUS40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=08YQxg9wD8fe2/NtVbs8c4RN1CgjQvmXEUswx/DR+4nUe/XdHyPA/3iJfU2+e2Eq5
	 eVSeFK1j+FTFXlSrqBD6pDJNJOBBB6ipxwm/W4Ewiwq1IoFg3b+HMEk+ecVOHUOBfv
	 xzzUnDVjSR8jBltQexVnWg78aMG5F/cg4C18OFIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.1 043/183] ASoC: qdsp6: audioreach: fix topology probe deferral
Date: Tue, 25 Jul 2023 12:44:31 +0200
Message-ID: <20230725104509.497284609@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit 46ec420573cefa1fc98025e7e6841bdafd6f1e20 upstream.

Propagate errors when failing to load the topology component so that
probe deferrals can be handled.

Fixes: 36ad9bf1d93d ("ASoC: qdsp6: audioreach: add topology support")
Cc: stable@vger.kernel.org      # 5.17
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230705123018.30903-3-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/qcom/qdsp6/topology.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/sound/soc/qcom/qdsp6/topology.c
+++ b/sound/soc/qcom/qdsp6/topology.c
@@ -1100,8 +1100,8 @@ int audioreach_tplg_init(struct snd_soc_
 
 	ret = snd_soc_tplg_component_load(component, &audioreach_tplg_ops, fw);
 	if (ret < 0) {
-		dev_err(dev, "tplg component load failed%d\n", ret);
-		ret = -EINVAL;
+		if (ret != -EPROBE_DEFER)
+			dev_err(dev, "tplg component load failed: %d\n", ret);
 	}
 
 	release_firmware(fw);


