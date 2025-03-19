Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E905F214A9E;
	Wed, 19 Mar 2025 14:37:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395070; cv=none; b=jXJSUJFCGZ6SBevwOpLhUVfQ3ojnkadhShwyN+FCA5cN34HIemdrmTBvz8OpKsUE5L4fLKJQBv/+9j/jJOMZQYFYwy0QXNwAVt2FkAVEdF2Uqcg7aYAl1qYV2Rrwr98Uii/fm3QAUlXmGVVOloTVPwXsy8HQeRM7ur5Nft67qoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395070; c=relaxed/simple;
	bh=wPDXHV2kcXRpWgMdDHC63YcXS9xxRCVMXsyRhcmo3Qw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aao3Sa++ss+6voML2m5dd+bvoiTbezaSKHkxqDoIdIYOBWAoPqBhTYwbRlx3fiGuJq/B6XG4FPD5v+vvk7MornX68Sd3tu6UqSOb9RzjQsEY1QzXCvOCLi8P2YIRKOsQ911L7wKmDmStpXZ1p4d224qhlx2Ka9R+4S6VJ1J9cQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ts2BTMxI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ts2BTMxI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63FD5C4CEE4;
	Wed, 19 Mar 2025 14:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395069;
	bh=wPDXHV2kcXRpWgMdDHC63YcXS9xxRCVMXsyRhcmo3Qw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ts2BTMxIpb9o5nkr6WgKh2nEvKlCifMdfYvARsPpXaNfml24aVxRwVfus4YjG5W4O
	 XNqGa5gg9uoRml8mx3wA50f43Drc5hNgJuK1yD2CRkQLCKm4aexuCq21qqAHdbOkDc
	 xfZM5xegXcOjggTQOJQwfMqUggqoqqlEch9TLsNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Daniel Baluta <daniel.baluta@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 106/231] ASoC: simple-card-utils.c: add missing dlc->of_node
Date: Wed, 19 Mar 2025 07:29:59 -0700
Message-ID: <20250319143029.456657195@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

[ Upstream commit dabbd325b25edb5cdd99c94391817202dd54b651 ]

commit 90de551c1bf ("ASoC: simple-card-utils.c: enable multi Component
support") added muiti Component support, but was missing to add
dlc->of_node. Because of it, Sound device list will indicates strange
name if it was DPCM connection and driver supports dai->driver->dai_args,
like below

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.(null).rsnd-dai.0 (*) []
	...                                     ^^^^^^

It will be fixed by this patch

	> aplay -l
	card X: sndulcbmix [xxxx], device 0: fe.sound@ec500000.rsnd-dai.0 (*) []
	...                                     ^^^^^^^^^^^^^^

Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Reviewed-by: Daniel Baluta <daniel.baluta@nxp.com>
Link: https://patch.msgid.link/87ikpp2rtb.wl-kuninori.morimoto.gx@renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/generic/simple-card-utils.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/generic/simple-card-utils.c b/sound/soc/generic/simple-card-utils.c
index fedae7f6f70cc..975ffd2cad292 100644
--- a/sound/soc/generic/simple-card-utils.c
+++ b/sound/soc/generic/simple-card-utils.c
@@ -1097,6 +1097,7 @@ int graph_util_parse_dai(struct device *dev, struct device_node *ep,
 	args.np = ep;
 	dai = snd_soc_get_dai_via_args(&args);
 	if (dai) {
+		dlc->of_node  = node;
 		dlc->dai_name = snd_soc_dai_name_get(dai);
 		dlc->dai_args = snd_soc_copy_dai_args(dev, &args);
 		if (!dlc->dai_args)
-- 
2.39.5



