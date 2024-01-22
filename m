Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56D6860EC7;
	Tue, 23 Jan 2024 00:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970752; cv=none; b=C2etZ/VKQL7b6szRB/b2uhfjwsr7cSMzTBlxKR1S3su4Jm9ro/SFCmaK5z8rF3zsDmkL+xO9H265nt/+x0hEj4jeygunnNtBSQl14/HBbxBVT1BrBAPVGFlSchSU2exiL9A7npbPeW6KHn5wnCmpgVhyGZGX4ta001lTriuqQaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970752; c=relaxed/simple;
	bh=f0gexUZLGEersWFHd/9GD+McCt0b1Ul1LYzbdCYJ24c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SJhhgeoXjpMz/4AtNUR2tRbis2yXPVChSnL3c7uGYWge/LeCY3xWaa8hjPNxK9ABBX5Af9bvC/pyR2Bu7vMgY8ueUTdwtcGrxvAmS665jR54DFmS5DkczZmEahnpjqgOVwAo/I8qNBm39aYI0bVUIxxWhVfBUUWIKeylYe22BME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AAtUTNTY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AAtUTNTY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC756C433F1;
	Tue, 23 Jan 2024 00:45:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970752;
	bh=f0gexUZLGEersWFHd/9GD+McCt0b1Ul1LYzbdCYJ24c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AAtUTNTYioGIJ91DfPD1d94MTsOJPjvJGnOQWx+6HHdrwnF4DCqnlGW9zQ8iOq4xd
	 MACX3YcXVsekmBBc0FTPVEdf/sUMZYakEa1Pmen1QWv4MkqfCzEVLY4bU8g2vao+Pv
	 wszULzF+9+0AOQZtrgIgiOUz9ou0zVIcJ7WBIwUk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 011/286] ASoC: Intel: Skylake: mem leak in skl register function
Date: Mon, 22 Jan 2024 15:55:17 -0800
Message-ID: <20240122235732.449596600@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c7e76111f68b..935c871abdaa 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1477,6 +1477,7 @@ int skl_platform_register(struct device *dev)
 		dais = krealloc(skl->dais, sizeof(skl_fe_dai) +
 				sizeof(skl_platform_dai), GFP_KERNEL);
 		if (!dais) {
+			kfree(skl->dais);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -1489,8 +1490,10 @@ int skl_platform_register(struct device *dev)
 
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



