Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BDD0355F49;
	Sat, 17 Oct 2026 16:11:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792253505; cv=none; b=Z8QPJ+8Bpin1YQ3fAOEsCvlaT5YcPiBc4EcESfZnMiwr1JB+UAb6LRAH/oJPW86swk8KeHnRwtNP1GswYXXxXmytJK3mLCJe4St3m0XOHhRJwvaxNgduR0bsYFPkCZq8aRFmEJgarTxPe5rd6AdxHj8muPKJdcFVSVIO7f63n70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792253505; c=relaxed/simple;
	bh=p3s8Y0JNqX/L7RO4hGDwqsEDf6HRDqmZVwkpiEnerdQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MdJ13U7szbaEDIFoQprpzGFQLEKtyHmpNIxAMc5HrItgKj4BzcRI1a5i3HHTTBUHDXRj6HaYml+RkkMuTgm/Sh70Ax0eXKiu9gGcClBCU476g5NhtiQNqSPtCHibZLyLKCLZ4Yclbn6seB/ZwndX5AqAqheT+3sJfxFa1W2tMRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GrXI+Mmj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GrXI+Mmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B32BD1F000C4;
	Sat, 17 Oct 2026 16:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792253504;
	bh=lskfRhShBDY6fWHk4hlvoaEAkLB8nZeT+WD+zHug9Ec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GrXI+Mmji4gAN9aKRWVHddCwD5XCDRZi5H1XmP9yC9+X3gM5yBPgCFPw7Gba9Xwgr
	 79eOEuhRiYmFWocygZqElVUnDCI9ZE0kZdEuk2g1LUx+0qz6ZFq2QISIVS8DTDt8IH
	 a/wu8456fuQ5cZfvddCMof1UI5HWMGCw83H1FJzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 139/869] ASoC: Intel: avs: Do not share the name pointer between components
Date: Sat, 17 Oct 2026 17:49:40 +0200
Message-ID: <20261017160040.608109991@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 sound/soc/intel/avs/pcm.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/sound/soc/intel/avs/pcm.c b/sound/soc/intel/avs/pcm.c
index 8889fa7ddd908..81fe4f0218c1a 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -1304,16 +1304,18 @@ int avs_soc_component_register(struct device *dev, const char *name,
 	if (!acomp)
 		return -ENOMEM;
 
-	ret = snd_soc_component_initialize(&acomp->base, drv, dev);
-	if (ret < 0)
-		return ret;
+	acomp->base.name = devm_kstrdup(dev, name, GFP_KERNEL);
+	if (!acomp->base.name)
+		return -ENOMEM;
 
-	/* force name change after ASoC is done with its init */
-	acomp->base.name = name;
 	INIT_LIST_HEAD(&acomp->node);
 
 	drv->use_dai_pcm_id = !obsolete_card_names;
 
+	ret = snd_soc_component_initialize(&acomp->base, drv, dev);
+	if (ret < 0)
+		return ret;
+
 	return snd_soc_add_component(&acomp->base, cpu_dais, num_cpu_dais);
 }
 
-- 
2.53.0



