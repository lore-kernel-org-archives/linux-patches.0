Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE96747DD4F;
	Mon, 31 Aug 2026 13:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184774; cv=none; b=BXCik+bPT7GRV3IC45PVJRFvB5fb3qXy1v41vZWSJPMtLGS40472StJzy3viG6f2OkQjUYeZsFclW0LS7zT3MDwzkpx0pCJ8xnmS7ug4E2wWYSAgiCjou/pbsIzAUgTQlMIRutwqwdaiLEvC0hEeXm4M+JwvKS7StebtpJjO63A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184774; c=relaxed/simple;
	bh=TKR9RoCUYNyoxbzUbxuB/A4AT+vbC5L/3uQ/IYoDGlI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NaqVGpUE55QoddU/6uOtgccIcwLLOt/NAsc6iPuSX0C3laABMm/0EbM7ouNQSQR9ddGW/wQD0EUH0jQp7INFGgUTMTLaCHwxHQPNJbCerElfOM8L7JyiRbYUKHheQb7JG6qnKfVHGjLvWCNtc3pRT7MqFpHFJYidfle3g2N6P8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f8wobYii; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f8wobYii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2571F000E9;
	Mon, 31 Aug 2026 13:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184773;
	bh=C30mQbacuv4oW+evibx0iJ8mPE9zVcYgZk5Tc64C75E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f8wobYiimYkzcZwDcfp3qMmguUABCW67hhxjoFmKHak+wTCNjE/SvdhCTagvEWNMu
	 ZoE1KSSkwRjze/jHrwPTOE3rtdxcqj/ZTB6u67LBICFbki92AE5XI7kiCgriW7BZAG
	 6TEi03pW9I4Bs1SbuZ6C5ewtpaqpPaYzNjt2SbjQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jon Hunter <jonathanh@nvidia.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 34/92] ASoC: tegra: Fix Master Volume Control
Date: Mon, 31 Aug 2026 15:34:32 +0200
Message-ID: <20260831133401.474375091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.482388899@linuxfoundation.org>
References: <20260831133359.482388899@linuxfoundation.org>
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
index 468c8e77de217..0b69cebc9a33c 100644
--- a/sound/soc/tegra/tegra_pcm.c
+++ b/sound/soc/tegra/tegra_pcm.c
@@ -117,6 +117,9 @@ int tegra_pcm_open(struct snd_soc_component *component,
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



