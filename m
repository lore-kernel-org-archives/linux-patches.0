Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E744231846;
	Mon,  2 Jun 2025 14:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873906; cv=none; b=tpHnCkE0zli+gYu6xoHVRR0ImsrMHOK/SeFbosMI7Q2c3NqW+hvvDSizuL2zbMiRswoEaHaDYnNWvlYElfqaaBXqmJz4S1QvOuWKh5ctlfOGUPpyUSGtIL6Oojz8DkHUAHIJ6FsmTGvYU91aiJzSicfu+byLkVWC0w0wgF/TGO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873906; c=relaxed/simple;
	bh=E7N5QtdFH3fhIKKetUoEoRDpy2k0erdGpEjdl15+KRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BMBCdDjoIHGQJvEWV312ZKbxzDlmkCJIFqa51cTycoBfAnCs+NqtT3L+23azYH90X2PU9KTDkdcr06Orc686zwmYihq6EQQPFbSz6S62cPUvTlzNn4K6tXjoZ4i14TNsK6JSoiaz0f9XZEsU+OumEUKwN5Hck1CH15022bGU7vI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HXY1d8xl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HXY1d8xl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAD41C4CEEB;
	Mon,  2 Jun 2025 14:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873906;
	bh=E7N5QtdFH3fhIKKetUoEoRDpy2k0erdGpEjdl15+KRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HXY1d8xlGrge2HPiDmG7Ufx1f+ZexzUZK0Pt23hzZsSEYXMBWErMOoEcC785ROIdz
	 8EIkpIDzLFLE/CViT53BbaKLTqrfqn1Q20x0nBzwPYh2pTW3F3rcv0inZS3V/A1IBm
	 wigc1LnYxJTa6FuEDpAfb1kS2uo9dUTvw6uBIx0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 292/444] ASoC: codecs: pcm3168a: Allow for 24-bit in provider mode
Date: Mon,  2 Jun 2025 15:45:56 +0200
Message-ID: <20250602134352.806909206@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



