Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91044215774;
	Thu, 12 Dec 2024 15:30:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734017410; cv=none; b=gSnttlX6bod0Yt4mKvOE78bTve05y4VDKTW7BO/2toj0yrhBseTAbg7PKXXxi5yDWLWXprts2sDcuxVHflX3oRX1+C0gka6r8uskCCIqTlPiyRWQImzZiVe352o8vdXBNyJXkAlyzikmLSus9Sv/Z0A6FQubvg7nZbqymwCqfFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734017410; c=relaxed/simple;
	bh=pCZcehmdL2lZufUuxGZOdsz6jk3/vMfqIuWI5ZeK/PI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d5W+A5qQMzwdMJj5sSxJsSGOCf06ddywm863kV4bbJEt0dfiBc5TzAX5tSbzKmx4pABH7XROGm6gvAj26Ef/a0pe8rhNbCMVhEOADMA11aDlnPTsMfKig6kqNherzpo+j2eZct4aw9kNHkE5LLjP9RCkpdAWzMWzNe/X8r/Q538=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vCMAUdsO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vCMAUdsO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3249C4CECE;
	Thu, 12 Dec 2024 15:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734017410;
	bh=pCZcehmdL2lZufUuxGZOdsz6jk3/vMfqIuWI5ZeK/PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vCMAUdsOx+I243F6uJww3S9sRX1wr1dYicXOn2K/yMlGQEY3RJbxjFrH8B3J7H5ns
	 taCQzNBkPyTYQb5PZcOQ647ufCBbzbtjfzixgZZmPWUYu90DIghkE/WAZsUXusUsPp
	 b/AN8xamy4AbVHo+Sth2v6OO+ZWjiPrqVKac2uwU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 460/466] ASoC: Intel: avs: Fix return status of avs_pcm_hw_constraints_init()
Date: Thu, 12 Dec 2024 16:00:29 +0100
Message-ID: <20241212144325.038459060@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

commit a0aae96be5ffc5b456ca07bfe1385b721c20e184 upstream.

Check for return code from avs_pcm_hw_constraints_init() in
avs_dai_fe_startup() only checks if value is different from 0. Currently
function can return positive value, change it to return 0 on success.

Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
I've observed KASAN on our setups and while patch itself is correct
regardless. Problem seems to be caused by recent changes to rates, as
this started happening after recent patchsets and doesn't reproduce with
those reverted
https://lore.kernel.org/linux-sound/20240905-alsa-12-24-128-v1-0-8371948d3921@baylibre.com/
https://lore.kernel.org/linux-sound/20240911135756.24434-1-tiwai@suse.de/
I've tested using Mark tree, where they are both applied and for some
reason snd_pcm_hw_constraint_minmax() started returning positive value,
while previously it returned 0. I'm bit worried if it signals some
potential deeper problem regarding constraints with above changes.

Link: https://patch.msgid.link/20241010112008.545526-1-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/avs/pcm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -509,7 +509,7 @@ static int avs_pcm_hw_constraints_init(s
 			    SNDRV_PCM_HW_PARAM_FORMAT, SNDRV_PCM_HW_PARAM_CHANNELS,
 			    SNDRV_PCM_HW_PARAM_RATE, -1);
 
-	return ret;
+	return 0;
 }
 
 static int avs_dai_fe_startup(struct snd_pcm_substream *substream, struct snd_soc_dai *dai)


