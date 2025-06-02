Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2DB230BEF;
	Mon,  2 Jun 2025 15:15:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877302; cv=none; b=lw29XdNTD7yQ/yVUtyHgxtbsGLUI1i5g6ZTu72Ce/JVOlFYQP765dljLHwYIdFDu1DeZhMuIq/PPJ2idB7Z6AcKaxCdnpr0o7ZTfZ6Zw+jBIiwkiMPEmpDauWGxt4gwKJVrNZ0mKdSQFn35ijqAiFzzWA1o2kVq88JgXTeQMV2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877302; c=relaxed/simple;
	bh=tfdSYgE0R2zIbxngj4KBpGeMelKp6tlJbsjb00xBC3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fxGsiYoTjI9hNbTf7wpshhyoAMEM/zeXzrYhLBWT5z/jXPkhdXJtKMKRntexsoDk6DDNS0a6qdaIoLPy8I662tyU2a2hQM8sAS9tPXTatVqaEk4+55a8gzmX960t3SaLbmTa1JlpxfrB4RAzYfq8gUHPjNS/uphbnm6yGQxOsBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w5f8yZZS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w5f8yZZS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91B43C4CEEB;
	Mon,  2 Jun 2025 15:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877302;
	bh=tfdSYgE0R2zIbxngj4KBpGeMelKp6tlJbsjb00xBC3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w5f8yZZSj7CtC+gFqz5BHMWKHYHm34O3a5vLmpdj7nEwFp1xSm1eHFu0IX9N/pI2e
	 brD927pOcg468bvmDi2P5HstJ6QBNCctYMy6N0ckggJ86Qx0Yo5NachkApEumWcOA/
	 /VwokC8CaYhtFnYCuw4VeeTm60AthJewSfgnFZ7E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 207/325] ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode
Date: Mon,  2 Jun 2025 15:48:03 +0200
Message-ID: <20250602134328.201367611@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 9d6431338fb71..329549936bd5c 100644
--- a/sound/soc/codecs/pcm3168a.c
+++ b/sound/soc/codecs/pcm3168a.c
@@ -494,9 +494,9 @@ static int pcm3168a_hw_params(struct snd_pcm_substream *substream,
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



