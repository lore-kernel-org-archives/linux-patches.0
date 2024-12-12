Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFE7223E60;
	Thu, 12 Dec 2024 15:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018640; cv=none; b=SvSfG2Ie1aXjE3n+lIph/3ALE3BTi+waANQyDe7oWQ1u9dIx6A9ikdeDH3xc+3B1cMUTRYF/Rz19VwGvvSup+qq/G0OnVT5D+6cLkWBkM+uCogGtF7CaKf1e4SbKbMQkTRZI/djAEG7eFMPwsX39aXbYGu4HoEgTZ0j+zCZCQEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018640; c=relaxed/simple;
	bh=0tUHNEknCgRhvL0YPGz6vlKpXdl0em0XfGjfBd8yf10=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mjX8rk2uRFlOIdeBJoHevBwIUg3wE101Su6+pF+nH5/jX4laHfDXzNtfMi1n+iRyMm1Ujqx8kazPh4bCZSEfVbs1uQLkUVF83QyMCu0FFAuP1xNMt17qqMurBLdwizKOfHmsT/wdk4npKYFxfW0NjzvYILDo0pikHuxpczfKhpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SMBtM0Xu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SMBtM0Xu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40565C4CECE;
	Thu, 12 Dec 2024 15:50:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018639;
	bh=0tUHNEknCgRhvL0YPGz6vlKpXdl0em0XfGjfBd8yf10=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SMBtM0XurF9dXOQ5uaXiALxk/a6i9jWvNEdEoWzi0YaHDzO5eN7iZewntif1KlFHC
	 Kmuc5wx1cQyeMhUyeHGVNHukjhoCB/6QNTS547Y/WPeriegv8BYr4Dk3pF0c1jKEfv
	 SKZVydu7YI3fFxn/Zzl5G46DQMKF+Ww05mFf2Vww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 347/356] ASoC: Intel: avs: Fix return status of avs_pcm_hw_constraints_init()
Date: Thu, 12 Dec 2024 16:01:06 +0100
Message-ID: <20241212144258.276928665@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -424,7 +424,7 @@ static int avs_dai_hda_be_trigger(struct
 		break;
 	}
 
-	return ret;
+	return 0;
 }
 
 static const struct snd_soc_dai_ops avs_dai_hda_be_ops = {


