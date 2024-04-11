Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2291E48E;
	Thu, 11 Apr 2024 10:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832668; cv=none; b=SGPbwePzOWSTnC/+zvwBGuacNSwbN4Dk7Mie0dZHrkFSzZaO1aUGwMKuHm9A1vdHibosfwUxGH/O3ev1eYWOn0FF6Mswu/8RdphPDa3NXn/TJI55Gsvpheh/gbSaja3KF5LUJTunR/VThXeKL/bxMMaP2ZIooV4r6MuM0CUFWkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832668; c=relaxed/simple;
	bh=QHiegyv2VvfBzQFv/Atfq3tcs2BBLGSEUVzMSvxs5nw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r3n+K8OxAF9VaxKWGB8bZvGcUFMIDQPwfzEAe3BR109awwz6GUOgRp6qISjq1BDVrx32kwvAYR75YdojAhjei+hkB8aAo4SHZmAMf1hi5YXOlQw8MOz6f3EiWWa9EI0siTQozYW/DeJThbBUw8ocRNb5k1kf4T9aiEKs45M5cDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vbM1atnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vbM1atnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F04AC433F1;
	Thu, 11 Apr 2024 10:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832667;
	bh=QHiegyv2VvfBzQFv/Atfq3tcs2BBLGSEUVzMSvxs5nw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vbM1atnHVS58HGluxwsuoueDMdE8lvhGL2ukviVLSOPxWOhw6cOSeTY3IWAQ8a+5h
	 TuCBMo168Je9Ve9Y9HsHFCqorg6TmEroEb+K7o/zKPtqLKvYmokWvXD5vUiGdbiH+r
	 WgaEXImRMJoA22DNPezLLdMsVW0ZWR6A4r+tXpNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 42/57] ASoC: soc-core.c: Skip dummy codec when adding platforms
Date: Thu, 11 Apr 2024 11:57:50 +0200
Message-ID: <20240411095409.263878303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 23fb6bc2696119391ec3a92ccaffe50e567c515e ]

When pcm_runtime is adding platform components it will scan all
registered components. In case of DPCM FE/BE some DAI links will
configure dummy platform. However both dummy codec and dummy platform
are using "snd-soc-dummy" as component->name. Dummy codec should be
skipped when adding platforms otherwise there'll be overflow and UBSAN
complains.

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://msgid.link/r/20240305065606.3778642-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index a5b3ee69fb886..1c4d8b96f77b1 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1042,6 +1042,9 @@ int snd_soc_add_pcm_runtime(struct snd_soc_card *card,
 			if (!snd_soc_is_matching_component(platform, component))
 				continue;
 
+			if (snd_soc_component_is_dummy(component) && component->num_dai)
+				continue;
+
 			snd_soc_rtd_add_component(rtd, component);
 		}
 	}
-- 
2.43.0



