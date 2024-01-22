Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86DC91487C0;
	Tue, 23 Jan 2024 01:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972068; cv=none; b=YGGTLSM/H/+2eOkBP6Q1bPWOiVwJnNYUrbXg5HcmruQ6FFH/fvDsF96tt08CaKxyo4O6Kx3zgDYk8zf8fju4FVBDcUjdF4KSvzLdAmluCN74/Yc5T62imQLtD/rNFQjXAqX1Vojwj+RgG/4fnWWevxt5tSTAajowFErkzIa6k9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972068; c=relaxed/simple;
	bh=bGBRij4Ntwr3uHqdpOZe12BM50xJELoX1uvv1AwyInQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aMtaof87Oq3jvQONWwmZpyQzh5ByWr3snLqB5gfq9RyeeVljjOg1W3IT+lhgw+xDDWDPW3z9vxZN8xyeY+fPPC8+wxcFWdP4MMSV5zbsw5KLlYYlYt4rP129Wbf70jWa6OVHNHsr+xDidH+wbTwQx4fdAjNPul9JIhZpgXhb/1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kg1We5ac; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kg1We5ac"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DEF3C43390;
	Tue, 23 Jan 2024 01:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972068;
	bh=bGBRij4Ntwr3uHqdpOZe12BM50xJELoX1uvv1AwyInQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kg1We5acGawNciREKht2CYUIPT3XZT3VLnbTIf56Li2paD86aa8Ors4ERoHtsxdBE
	 2+DIzDAiRiCrS7BJToqxhYbWGBUl/w5bJubk53L4dGrVLKCu/1kB+tQf+HMm/QhR3T
	 J/+NH/p4MwUzKmycJenQzF5zbS55tSJZNW9ydxpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 012/374] ASoC: Intel: Skylake: mem leak in skl register function
Date: Mon, 22 Jan 2024 15:54:28 -0800
Message-ID: <20240122235745.054280793@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kamil Duljas <kamil.duljas@gmail.com>

[ Upstream commit f8ba14b780273fd290ddf7ee0d7d7decb44cc365 ]

skl_platform_register() uses krealloc. When krealloc is fail,
then previous memory is not freed. The leak is also when soc
component registration failed.

Signed-off-by: Kamil Duljas <kamil.duljas@gmail.com>
Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20231116224112.2209-2-kamil.duljas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/skylake/skl-pcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/skylake/skl-pcm.c b/sound/soc/intel/skylake/skl-pcm.c
index 0d08b0269a66..af5af5be42f6 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1467,6 +1467,7 @@ int skl_platform_register(struct device *dev)
 		dais = krealloc(skl->dais, sizeof(skl_fe_dai) +
 				sizeof(skl_platform_dai), GFP_KERNEL);
 		if (!dais) {
+			kfree(skl->dais);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -1479,8 +1480,10 @@ int skl_platform_register(struct device *dev)
 
 	ret = devm_snd_soc_register_component(dev, &skl_component,
 					 skl->dais, num_dais);
-	if (ret)
+	if (ret) {
+		kfree(skl->dais);
 		dev_err(dev, "soc component registration failed %d\n", ret);
+	}
 err:
 	return ret;
 }
-- 
2.43.0



