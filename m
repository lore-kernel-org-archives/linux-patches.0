Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B0051D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:08:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E7C7C433C7;
	Tue, 25 Jul 2023 11:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283286;
	bh=sALAg72tNeCuME4pPnoqsdqUoMbldkD4A8ZgNW+V0dI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Olcxq8wXrWVPVdpZsTGrQQQqlfpSAyvVEyi7cz9oy+S0gwc8QJ7xGZhvDoXZYCLw2
	 wLVHBeD5eGWLH3cOOnsaLlvEG5X/RqBtHMkrlGfUIXRRZdT2nVGCwPBIPytE2j918w
	 pd5XrJT8VZsAX87YsMOt/sEtVYXEYavS1gXdPu1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 21/78] ASoC: codecs: wcd938x: fix missing clsh ctrl error handling
Date: Tue, 25 Jul 2023 12:46:12 +0200
Message-ID: <20230725104452.141955186@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

commit ed0dd9205bf69593edb495cb4b086dbae96a3f05 upstream.

Allocation of the clash control structure may fail so add the missing
error handling to avoid dereferencing an error pointer.

Fixes: 8d78602aa87a ("ASoC: codecs: wcd938x: add basic driver")
Cc: stable@vger.kernel.org	# 5.14
Cc: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230705123018.30903-4-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/wcd938x.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -4086,6 +4086,10 @@ static int wcd938x_soc_codec_probe(struc
 						 WCD938X_ID_MASK);
 
 	wcd938x->clsh_info = wcd_clsh_ctrl_alloc(component, WCD938X);
+	if (IS_ERR(wcd938x->clsh_info)) {
+		pm_runtime_put(dev);
+		return PTR_ERR(wcd938x->clsh_info);
+	}
 
 	wcd938x_io_init(wcd938x);
 	/* Set all interrupts as edge triggered */


