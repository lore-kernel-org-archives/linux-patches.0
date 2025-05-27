Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1DD025A323;
	Tue, 27 May 2025 17:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365728; cv=none; b=b1YamDZdRsfRW2uJMlIXnXUp8SZu3TzeXpKo/0O0oU8MSLU0+ze22LdvbltAtq4TPs+ZffANT+c6liBy+I3beXYvHwNC0o6X01cDtHz4G8BOAWEw5tE5BSqxBrBq2VgZvtqcOT70g5nGaR/C0PpIdv3qTmL531WSqj5q53fUko8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365728; c=relaxed/simple;
	bh=8esODaBkO/PEACmUwnYrkrwlREAhn8fC/073YI26938=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nPcnrGD92JBIb/qIwadbRem/SnWZMRH1dMJYa0bHK3Ydl/ydMFxQbIqMTYxjG2oHGztJij6nVmFNpEEsZhSc7IVqR42ABtjQfMjQ/ODYV292WRJip/lnYvcbLN/sGO28Wlwblyw4xswfXNL9T5UH3dxpXN5Oxu1Id18fT17lXOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kqx0lXOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kqx0lXOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A07C4CEE9;
	Tue, 27 May 2025 17:08:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365727;
	bh=8esODaBkO/PEACmUwnYrkrwlREAhn8fC/073YI26938=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kqx0lXOsc2Fce+fkeerpl+ubvioXmrjvrScEhpBtfqtWBZmc4RSdK311XKvFeNOR1
	 OZjkrckvjdH7fECbiUldVhj0bEQ7RoOG/lfYfdOlFH+J5vtZAhgcEf7HvKvgR10s6c
	 wVsbCnM0twyj8xf6VHAfyKjTDI1yMirp+dAlJmTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 469/626] ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode
Date: Tue, 27 May 2025 18:26:02 +0200
Message-ID: <20250527162504.051705051@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 7d92a38d67e5d937b64b20aa4fd14451ee1772f3 ]

As per codec device specification, 24-bit is allowed in provider mode.
Update the code to reflect that.

Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250203141051.2361323-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/pcm3168a.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/pcm3168a.c b/sound/soc/codecs/pcm3168a.c
index fac0617ab95b6..6cbb8d0535b02 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -493,9 +493,9 @@ static int pcm3168a_hw_params(struct snd_pcm_substream *substream,
 		}
 		break;
 	case 24:
-		if (provider_mode || (format == SND_SOC_DAIFMT_DSP_A) ||
-		    		     (format == SND_SOC_DAIFMT_DSP_B)) {
-			dev_err(component->dev, "24-bit slots not supported in provider mode, or consumer mode using DSP\n");
+		if (!provider_mode && ((format == SND_SOC_DAIFMT_DSP_A) ||
+				       (format == SND_SOC_DAIFMT_DSP_B))) {
+			dev_err(component->dev, "24-bit slots not supported in consumer mode using DSP\n");
 			return -EINVAL;
 		}
 		break;
-- 
2.39.5



