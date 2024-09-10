Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 198F017BEAE;
	Tue, 10 Sep 2024 09:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962328; cv=none; b=RGDcVtj0IOm4bjGOYj1NzWz3LYCR32i0EHpcULx76KvluXm5mofaEmxxateDfiUCLaO5oz6ba0H+l8NpRltd+JNudE/h4FM8daKY4I59q0wae0USYUnrf99SNjW/0hRekP08A+qRWBbKKnJE5B0nqvpRkXpBEPTZwmusQwjoqiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962328; c=relaxed/simple;
	bh=G0/UpizbvaQ+aP+TdUrzJxdypmsLLW/dpXL7sYxRqKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N8KXoMjzdloqHLHeaf8pmg8Kmcdymqk3zkuOXsLn2KbdQayifNCW6h6RwZyvoFm7wmM5g4T/QGj+dife12+nNlfu2IyUzcdINrIRVLkid4gewi08OOgT9saWplceUsiuS7Ple+u2KC+UX137/FOdgZOIABMEVD3NIc/zD4VoGfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XmB54qW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XmB54qW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DDCEC4CEC3;
	Tue, 10 Sep 2024 09:58:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962327;
	bh=G0/UpizbvaQ+aP+TdUrzJxdypmsLLW/dpXL7sYxRqKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XmB54qWGapDQ/r2Uyh756bheGq8Q0/1kqIc6cgC8GMEAc2HLmifmryVtDBe2wxKD
	 ODetBV3K882LcKcWwPFnavGCttvwAFuJkA/hop8WVddyE4L92nMPY2cqX34aEZB8/A
	 vRQ+ahFWIYmDSMxnqMm1jyP/efQTYCUamakIRV5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 346/375] ASoc: SOF: topology: Clear SOF link platform name upon unload
Date: Tue, 10 Sep 2024 11:32:23 +0200
Message-ID: <20240910092634.210389816@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit e0be875c5bf03a9676a6bfed9e0f1766922a7dbd ]

The SOF topology loading function sets the device name for the platform
component link. This should be unset when unloading the topology,
otherwise a machine driver unbind/bind or reprobe would complain about
an invalid component as having both its component name and of_node set:

    mt8186_mt6366 sound: ASoC: Both Component name/of_node are set for AFE_SOF_DL1
    mt8186_mt6366 sound: error -EINVAL: Cannot register card
    mt8186_mt6366 sound: probe with driver mt8186_mt6366 failed with error -22

This happens with machine drivers that set the of_node separately.

Clear the SOF link platform name in the topology unload callback.

Fixes: 311ce4fe7637 ("ASoC: SOF: Add support for loading topologies")
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Link: https://patch.msgid.link/20240821041006.2618855-1-wenst@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
index da182314aa87..ebbd99e34143 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2050,6 +2050,8 @@ static int sof_link_unload(struct snd_soc_component *scomp, struct snd_soc_dobj
 	if (!slink)
 		return 0;
 
+	slink->link->platforms->name = NULL;
+
 	kfree(slink->tuples);
 	list_del(&slink->list);
 	kfree(slink->hw_configs);
-- 
2.43.0



