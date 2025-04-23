Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C81528A1DB;
	Wed, 23 Apr 2025 15:25:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421944; cv=none; b=gXgpyIUHe4yG6O3QOwbazbk1xGBNI1HGMGDUY9ruYs6EgCTpKACpTeVACQRda4Tx9fhxTqq05ehySvJ7bDlj2RQitl4It0UbaBe24TfmiMICTBsNmW0AejhbeTUXLMDBFOF/6x/YkR0VAmgYTXvecMrUBDHB9HLvLmaVR5smpko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421944; c=relaxed/simple;
	bh=Ouxh4cMHs0C1tW4b6Aes6ISNRfpqKSkYIUNlo4Q3R3k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ub4xY0aAv+4HYmN2OiLkbDSBPl5keUiiZofM3swBmCfI86Q4Ff8K25oQhZuz/BJK7AaEGiUd9tUUVtndPAtjZA3S/xFdaheptP1esxWIvn6rkIJX37O8SCVo18lQ/SbwGgOuUao7vNFh1Y8MeUvsPuK1TQPvRfFrE7JZvo1mlOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PLA9/Mnf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PLA9/Mnf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951E6C4CEE2;
	Wed, 23 Apr 2025 15:25:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421941;
	bh=Ouxh4cMHs0C1tW4b6Aes6ISNRfpqKSkYIUNlo4Q3R3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PLA9/Mnfh0CLWV5rUHAjovUoj8CQ+z1h5gILXkMQ3H1nsvvt3u4oEswMpLrUbQSBX
	 u94E6MmkxzlERJwHRe1yf85M990eMBhdzzZ7aKtS9sspKKaSIcADwwIE+MWHQT/ERn
	 p5OGYSA6vXA18iex0PH+sjd1Otwyg/NATg+FB5uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 249/393] ASoC: Intel: avs: Fix null-ptr-deref in avs_component_probe()
Date: Wed, 23 Apr 2025 16:42:25 +0200
Message-ID: <20250423142653.660335593@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

[ Upstream commit 95f723cf141b95e3b3a5b92cf2ea98a863fe7275 ]

devm_kasprintf() returns NULL when memory allocation fails. Currently,
avs_component_probe() does not check for this case, which results in a
NULL pointer dereference.

Fixes: 739c031110da ("ASoC: Intel: avs: Provide support for fallback topology")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Reviewed-by: Ethan Carter Edwards <ethan@ethancedwards.com>
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Link: https://patch.msgid.link/20250402141411.44972-1-bsdhenrymartin@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index bb1e77ac78e04..781019685b941 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -808,7 +808,8 @@ static int avs_component_probe(struct snd_soc_component *component)
 		else
 			mach->tplg_filename = devm_kasprintf(adev->dev, GFP_KERNEL,
 							     "hda-generic-tplg.bin");
-
+		if (!mach->tplg_filename)
+			return -ENOMEM;
 		filename = kasprintf(GFP_KERNEL, "%s/%s", component->driver->topology_name_prefix,
 				     mach->tplg_filename);
 		if (!filename)
-- 
2.39.5



