Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6871917C2;
	Tue, 10 Sep 2024 10:37:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964639; cv=none; b=KtyeCXaOSdHGgRh3gam/Z7e4xnLOmK3bUvJIgCUDNmAvJ2gP1JS6TyXP8kYMb4pN1ng0xbJ9fvOc8BBD8qU2egr3RM4Gm2nIZ1H2nzNqVs1TlWnD2wVy17uCfKEI2/3E0hJfToJUnQ/M7Ky7P122RCEr44E0jCJQcf21E+5QILo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964639; c=relaxed/simple;
	bh=1Gqgr5pthuoCKDPJ9e15enyqyxCRXnVN0AbxQCmKEC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvboqyWNAYofZh20SDWHKdGjbHaXULr9TFlFrveQNgsb7pHgKiR6fZb/saayW4SnvlfnWAQnC0gXR1O/87aiQj95NkMu9XITw737Vec47xq+4KJFA/OskzzWA4AEe8LfQpjhxoxiDKnulyIoNPaphUZSopU0KCXtP76L7ULeCeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1HvKLJZc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1HvKLJZc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BABC4CEC3;
	Tue, 10 Sep 2024 10:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964638;
	bh=1Gqgr5pthuoCKDPJ9e15enyqyxCRXnVN0AbxQCmKEC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1HvKLJZc+Qz6d6IAwItty+VaocGbh8da25lRJwjYRi4qU5M0GLUKtn2LVfWJr/zKy
	 oFO6c2G3y8M9o5cmObExYB7XoAU9lJxv40cZnPMXeKq78Y5j37WPYnANYJVCeikNFh
	 0xFe2ZNfeJw2298nNzsSLtvwL7JEyaK3U1xPaf54=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen-Yu Tsai <wenst@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 251/269] ASoc: SOF: topology: Clear SOF link platform name upon unload
Date: Tue, 10 Sep 2024 11:33:58 +0200
Message-ID: <20240910092616.759369397@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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
index 7133ec13322b..cf1e63daad86 100644
--- a/sound/soc/sof/topology.c
+++ b/sound/soc/sof/topology.c
@@ -2040,6 +2040,8 @@ static int sof_link_unload(struct snd_soc_component *scomp, struct snd_soc_dobj
 	if (!slink)
 		return 0;
 
+	slink->link->platforms->name = NULL;
+
 	kfree(slink->tuples);
 	list_del(&slink->list);
 	kfree(slink->hw_configs);
-- 
2.43.0



