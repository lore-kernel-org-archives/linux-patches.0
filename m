Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9336013A27C;
	Tue, 23 Jan 2024 00:02:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968129; cv=none; b=Ig4K7fgyRpn+Eva+De9vGrvCio5HAmNp3TlP/uJTW4sf9FW7z8kPfkthpugMCP0n9XJpamfnK7XtP9QdLQOqTPVGcC4b7PUZYkP32Ss4pGUIXVmjAUdkmzWtlPbVmjvkmS3P8HVsb6zV9RT5hyZiM+qHX55N+xLMS7CvfDIp3dk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968129; c=relaxed/simple;
	bh=0i0P8BXc1L3jwCpxgv6GfbRKSswJ11UGBLMlSGd4AVk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K/KXPtfMGseXvkKy3L0ZU1DjT7CrvfskzTWBFa9fO98+ah4wfyDmhTrI+48u74NY4VUgq/9v3IYT2zlIeR+1LZFhhis6CcwcO034LKuZCTQ6kex4WVVd1wXq4LaI3K6CRoSMo/5qUiJtK6dk9qVm3leDMCnFHlXKoDiWOE5sy3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RpYgLeeY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RpYgLeeY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD301C433C7;
	Tue, 23 Jan 2024 00:02:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968129;
	bh=0i0P8BXc1L3jwCpxgv6GfbRKSswJ11UGBLMlSGd4AVk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RpYgLeeYdxOaVmr4GwnAtnI449+VsXi+UOTEVV0auBEuj1EEgfZeBMNDw9hmkOaFP
	 cj+oojvhSlhOyVdyOV7t2pzWUo6GGI2PV6hXRWLM/uKde48DioalpZNNNjdbsD2R4m
	 rdwRwGaOu/J+vx0QW/Wvz5IDWXhQl0LycSRhG4l0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 002/148] ASoC: Intel: Skylake: mem leak in skl register function
Date: Mon, 22 Jan 2024 15:55:58 -0800
Message-ID: <20240122235712.539495426@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6b2c8c6e7a00..5195e012dc6d 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1450,6 +1450,7 @@ int skl_platform_register(struct device *dev)
 		dais = krealloc(skl->dais, sizeof(skl_fe_dai) +
 				sizeof(skl_platform_dai), GFP_KERNEL);
 		if (!dais) {
+			kfree(skl->dais);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -1462,8 +1463,10 @@ int skl_platform_register(struct device *dev)
 
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



