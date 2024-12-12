Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428DC215F48;
	Thu, 12 Dec 2024 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016063; cv=none; b=uh2YXQCDNywYNtoQUjPNGcLeRdWco4jrvUoi1LpaISJKXDmprGMNoZImqNhcb8/6LGZnDQPVlaufjbBN2IP7kF9649WiAXFq2uVvz45DJ0mlBzRKpKJlntA8KfHPmn1wk7CXia9pH5iLz5kDqLpf8mpxiplX/uBignLWVDcNG/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016063; c=relaxed/simple;
	bh=9GUn0Ep9iFlcd5KD2A9K0lCOwWLft3z4Ldem36n3w3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q7GoCs4tG2kZpwnMP9kgIyzOdX6rnM2QqmnUNCvJCMI8tihi9yHKWKFXtGkNzhe9dkmeWfCxBL49UP1e3epiIFBd+r/Mx4PLEvxGYBQWtdw++6ZJ+jVud+nxZqfkjRpitJv6cQ/m+psTnfejyah1yMK2wLIual+Q3H3UROeY4rY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vt1FjZ6a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vt1FjZ6a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A211C4CECE;
	Thu, 12 Dec 2024 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016063;
	bh=9GUn0Ep9iFlcd5KD2A9K0lCOwWLft3z4Ldem36n3w3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vt1FjZ6a+29xoKGclPfpMMKJGyNevv5NVoKQf0OhQfnGk7WHQ5qn0QWyV8WXGstPs
	 Yrg3wJuKFZE2uNI0WIgyPMIbkJrjhlGBseVy/cJ79o7pfh3zVxByaEDPirKQRBBSxt
	 axaMFAFbBRQQDhf09EgT8ES8kbsbjtlnf2fhZzao=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 094/466] ASoC: SOF: ipc3-topology: fix resource leaks in sof_ipc3_widget_setup_comp_dai()
Date: Thu, 12 Dec 2024 15:54:23 +0100
Message-ID: <20241212144310.528658948@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 6d544ea21d367cbd9746ae882e67a839391a6594 ]

These error paths should free comp_dai before returning.

Fixes: 909dadf21aae ("ASoC: SOF: topology: Make DAI widget parsing IPC agnostic")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/67d185cf-d139-4f8c-970a-dbf0542246a8@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/ipc3-topology.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/sound/soc/sof/ipc3-topology.c b/sound/soc/sof/ipc3-topology.c
index c2fce554a674b..e98b53b67d12b 100644
--- a/sound/soc/sof/ipc3-topology.c
+++ b/sound/soc/sof/ipc3-topology.c
@@ -1588,14 +1588,14 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 	ret = sof_update_ipc_object(scomp, comp_dai, SOF_DAI_TOKENS, swidget->tuples,
 				    swidget->num_tuples, sizeof(*comp_dai), 1);
 	if (ret < 0)
-		goto free;
+		goto free_comp;
 
 	/* update comp_tokens */
 	ret = sof_update_ipc_object(scomp, &comp_dai->config, SOF_COMP_TOKENS,
 				    swidget->tuples, swidget->num_tuples,
 				    sizeof(comp_dai->config), 1);
 	if (ret < 0)
-		goto free;
+		goto free_comp;
 
 	/* Subtract the base to match the FW dai index. */
 	if (comp_dai->type == SOF_DAI_INTEL_ALH) {
@@ -1603,7 +1603,8 @@ static int sof_ipc3_widget_setup_comp_dai(struct snd_sof_widget *swidget)
 			dev_err(sdev->dev,
 				"Invalid ALH dai index %d, only Pin numbers >= %d can be used\n",
 				comp_dai->dai_index, INTEL_ALH_DAI_INDEX_BASE);
-			return -EINVAL;
+			ret = -EINVAL;
+			goto free_comp;
 		}
 		comp_dai->dai_index -= INTEL_ALH_DAI_INDEX_BASE;
 	}
-- 
2.43.0



