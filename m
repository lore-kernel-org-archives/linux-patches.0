Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692F6200DA;
	Thu, 18 Jan 2024 10:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575552; cv=none; b=GHL5UoDKtteNwOk8drHsG7TYIfbmlTK6SeaXEXL92QtKF9un4SywSzeOT3ixHRHfdoAWET6RLsvR6XBGj/SQ5xZvqM/Yn7VAqRlRafGjDauhp1iAYmFTn+ZBFSM6IEPQLAAZhTUdpeZShMYvw5dw9A2E5PemrXB0jqXTEG6XREc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575552; c=relaxed/simple;
	bh=X/6A3/OjDJe9tcxe1gJrKfp6936xg1zlTGSKNV9JLhk=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Type:
	 Content-Transfer-Encoding; b=cCPM2IqviSf5Q52F2VyxFIaoTbT/h4S136tvtKr2I13wayXd9Nbtvjs2txa2bRc0extSj4x7WSJXsIJmaVSp2JUFJdwnuT8jZbbz2gLViTnJPWg7uXIDHEm/QDVqpHUxd42iO65z1xVUKdhJsiIJQrbCkBBGg8O/4/bXGMbc5f8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avLkx9TM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avLkx9TM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFF6CC433F1;
	Thu, 18 Jan 2024 10:59:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575552;
	bh=X/6A3/OjDJe9tcxe1gJrKfp6936xg1zlTGSKNV9JLhk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=avLkx9TMijsOxceTOHzGosL9ahWuGgC9iYDIYzDPV+j8Xg8GV+b/BoRwJfxxWC609
	 YpZQOllBofFjNp6AZQ5QVXVkC0sKWVQCwIH/D5pMy8nioOF0L70cjT/nhQfAM5ApZe
	 iIr202QiJmboqaOdBwhFyqtOKFW23hShvW9V2YyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kamil Duljas <kamil.duljas@gmail.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 022/100] ASoC: Intel: Skylake: mem leak in skl register function
Date: Thu, 18 Jan 2024 11:48:30 +0100
Message-ID: <20240118104311.879345553@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
References: <20240118104310.892180084@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 7ef004107513..adee4be2dea7 100644
--- a/sound/soc/intel/skylake/skl-pcm.c
+++ b/sound/soc/intel/skylake/skl-pcm.c
@@ -1473,6 +1473,7 @@ int skl_platform_register(struct device *dev)
 		dais = krealloc(skl->dais, sizeof(skl_fe_dai) +
 				sizeof(skl_platform_dai), GFP_KERNEL);
 		if (!dais) {
+			kfree(skl->dais);
 			ret = -ENOMEM;
 			goto err;
 		}
@@ -1485,8 +1486,10 @@ int skl_platform_register(struct device *dev)
 
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



