Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD713BB9F1;
	Sat, 17 Oct 2026 17:30:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258221; cv=none; b=QuVqWekj0cawJ6NDqDMd9NkDnxskUtS3mWtx5FY9WSJwE/v6m9Yf0WDgRdY7GliogV7G9S01PzupJk3VA9Q0tNw/VDw/HnwmTR8ClKU+uv01MxCjTWgladI/Dq2ymIg6mTtKDBBFbKX2x91Q8zgSilhpiJ1W4BR4PGdYmFtfdIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258221; c=relaxed/simple;
	bh=2OpByieinFlmThCIs/F1zx4gbhswQJfPFrodlJyo7Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=L1pBVla2LdmldaAL7MKlWTKE42SyqWO2XNjGJTXosWCnKezlJiuZSqFDhX8SRQDjLO6q8VHc4hj4B0vdlr9v3mPQfW35MUttKpf4Mo5yi1rz/McFsNyIvmvNSTPUzvx/VAeYS0WyvzUlkKtKOK6ptdx3g4aoBElT2Kov1dtS//M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vihtlqJ5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vihtlqJ5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9373D1F000C4;
	Sat, 17 Oct 2026 17:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258220;
	bh=DvD0zmMXTjNliVJeRNLpHSQIn/dT9CUlBEcL5cCbIWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vihtlqJ5puKt2eszv4cirDczzd/61F+rRkJwNLQIHLbAMJ0VtAlHgQ8D2MWhqwsTw
	 sESq50IH2K9Ptpxl5nMGQJdy5o3N5MGj52yN/6gvX0iUQFRuzqH1Ha7OIpVUz8zArw
	 ohGmvEX/+Twpwf+VmHO5+DoMCg8909OB079vY80o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0813/1674] ASoC: Intel: avs: Do not share the name pointer between components
Date: Sat, 17 Oct 2026 17:51:25 +0200
Message-ID: <20261017160451.992297890@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit 4dee5c1cc439b0d5ef87f741518268ad6a95b23d ]

By sharing 'name' directly, tearing down components may lead to
use-after-free errors. Duplicate the name to avoid that.

At the same time, update the order of operations - since commit
cee28113db17 ("ASoC: dmaengine_pcm: Allow passing component name via
config") the framework does not override component->name if set before
invoking the initializer.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250818104126.526442-4-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/pcm.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 9251c38cf9d12..12e31027d99c2 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -1178,7 +1178,10 @@ int avs_soc_component_register(struct device *dev, const char *name,
 		return ret;
 
 	/* force name change after ASoC is done with its init */
-	acomp->base.name = name;
+	acomp->base.name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!acomp->base.name)
+		return -ENOMEM;
+
 	INIT_LIST_HEAD(&acomp->node);
 
 	return snd_soc_add_component(&acomp->base, cpu_dais, num_cpu_dais);
-- 
2.53.0



