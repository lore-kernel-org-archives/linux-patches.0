Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 760C8280CE0;
	Wed, 23 Apr 2025 14:50:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419829; cv=none; b=BfloI8/VOVgV2JhBylPWTVOImyzvr0wflRkO8RI7asGa8ajvv6k98+8R6L0KOTAiuPmB30J1iURKMcG3ahUYbwIxz1wS1KZAMMaZeilLa6vsnbg/Rx8ykwiujsoI7naNY7EQ2h/+wUg1+Lej66wUk09OR4bNr5Q4rRvCAER7NB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419829; c=relaxed/simple;
	bh=KAR+DyQbVlZ4ipOs8idwH/vENfu+12D1xxnNheKMwLs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kVCWIRHJ3NK2NHtwUYxLp8ZjStyXzJjWKs7ReyoQhZx26fyyKQbZi8X62uJGKQ+owuHQictQJE/81nZ1AsxT9Z2ozxGjuexhpfcemGvXD1RxlRC4gRlJ1Om8dhSpXUdgO7CG2eCqYK9gkVD4ZmkA4xTh8io3Ghw15bUm0m4BHi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PQV7V+ci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PQV7V+ci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA65DC4CEE2;
	Wed, 23 Apr 2025 14:50:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419829;
	bh=KAR+DyQbVlZ4ipOs8idwH/vENfu+12D1xxnNheKMwLs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PQV7V+cik5hX5QXwl2fJpBKr5z8UUE49SDQxgbXuu/sRuBnGKLTzC9dU/6hIOar0Y
	 SavkBSwo91PVqnjrQHR2KIQd5iuH3TLzOPv4dVycQgEwaThIdG7cb5G4BxzaVL2HLO
	 sD7KeSfTjCuTRWZ5LY5x7MILimqSzc6wXXwbCO1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 012/241] ASoC: Intel: avs: Fix null-ptr-deref in avs_component_probe()
Date: Wed, 23 Apr 2025 16:41:16 +0200
Message-ID: <20250423142621.023774380@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 4bfbcb5a5ae8a..f7dd17849e97b 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -927,7 +927,8 @@ static int avs_component_probe(struct snd_soc_component *component)
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



