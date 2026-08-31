Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51976486B89;
	Mon, 31 Aug 2026 14:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788185000; cv=none; b=Uhoh8I8+nq+QChqzQo79lskbUx+Adh4A7KcMFqrplAORJf7CKOvFNwEHFM/iV1c4r1K9oAP0pqD3a9Wqrg8UEpsndbYaMP6EZ/2H0Osf97TzSCgAcWlqOBg49RUssaDR3Iyjzi6cIv6sH8m8LqFSVKDqsyeF0jY72Tw4b+IwYqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788185000; c=relaxed/simple;
	bh=0Qjy5gTNUiO8AcxpCK+XMPrtFBS3nn11exPkZ7X8V/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UApvB7frjznNwuW6skmFj65op0a+ow15hB6pyh8Ceiqjk8H6zx5uxTjSpNGt6RyVb2yk3Ho4UsqrB72U+cVOkvJd7jCehlSR4ND/eTfWy9JnOjbdZCvK8+Jsp4drbkm7y7Z4lacHGfEw0OqPc/krY7Ze1VY8SMb3S5RTsqpdOxU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bTNjN1BO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bTNjN1BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 652E51F000E9;
	Mon, 31 Aug 2026 14:03:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184998;
	bh=eruFH5evuIafNvG7vYOcETMzteiKv1L7D1+4euqncow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTNjN1BOE4c90Ut75fgU1TEFFq0UNl866XuveNridSDQkv+htluBUDfD00q+mxoPw
	 nHWkMcPmV45vdD9w4aVatvsqlmmuhx8bq5UY/uGzzVUeC/1Ed0jw9u9Tm3uhoz5RcS
	 C4s5U75/okJb+3MbehPcJ2C31VZiMNsRoBx2/UlQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 19/69] ASoC: tegra: Fix Master Volume Control
Date: Mon, 31 Aug 2026 15:34:52 +0200
Message-ID: <20260831133359.417115793@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133358.601894154@linuxfoundation.org>
References: <20260831133358.601894154@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jon Hunter <jonathanh@nvidia.com>

[ Upstream commit f9fd804aa0a36f15a35ca070ec4c52650876cc29 ]

Commit 3ed2b549b39f ("ALSA: pcm: fix wait_time calculations") corrected
the PCM wait_time calculations and in doing so reduced the calculated
wait_time. This exposed an issue with the Tegra Master Volume Control
(MVC) device where the reduced wait_time caused the MVC to fail. For now
fix this by setting the default wait_time for Tegra to be 500ms.

Fixes: 3ed2b549b39f ("ALSA: pcm: fix wait_time calculations")
Signed-off-by: Jon Hunter <jonathanh@nvidia.com>
Link: https://lore.kernel.org/r/20230613093453.13927-1-jonathanh@nvidia.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/tegra/tegra_pcm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/tegra/tegra_pcm.c b/sound/soc/tegra/tegra_pcm.c
index ef1e74d952369..e5a2091090cdf 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -111,6 +111,9 @@ int tegra_pcm_open(struct snd_soc_component *component,
 		return ret;
 	}
 
+	/* Set wait time to 500ms by default */
+	substream->wait_time = 500;
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tegra_pcm_open);
-- 
2.53.0



