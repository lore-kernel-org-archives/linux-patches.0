Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037EF343D64;
	Tue, 11 Nov 2025 01:12:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823563; cv=none; b=W2jpk9wOdeB0A/w9PFmeP3k5VGtN37JQmfA3f1aonsOFuJOYk9NpyCazkV/kgEoqaHJpAwyC13301d+KwVEvvhc+4SYhSKEKXQZnSJvfTIyhHRb/kqXSeHaiA0bcKqEcPIn1IIYfJx44lWHvCMoAAn+E/1Cyk8gHpC/2BscHqJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823563; c=relaxed/simple;
	bh=qYzDM1KonEN+9embHYg+Cp53a68LxojNzZV78I6OYmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hPL4VTRGhGSkhgoOfuhoKMz/zS2M0UB0rgZdU/OqCAT7vBCi6CouU2MiWNwVbANp+zT7omjHaQ0FO/XJfXbcwtUuGNeu1NC9lP+Dm7oJj35g03n+WNH2U+KTKnYYXSOv/dRA0CrRcdIeDjCpxm2lEJ99hQRUZCDP08xHjHNYhAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KBovI5f9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KBovI5f9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AEA4C116B1;
	Tue, 11 Nov 2025 01:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823562;
	bh=qYzDM1KonEN+9embHYg+Cp53a68LxojNzZV78I6OYmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KBovI5f9k5M6oKEpw8w5aeJqxQcU1BIR770hZzsIHtsdx3KPMZOrK0JZfP2l8XcuS
	 ap1VViRD3S8K9VLYqtbHWdnmsRxc//0QLPqUym1Ayghf6ZIbjfeXRcJXDZqvvlDf5e
	 lWjf49aqbLsknDtdnl+eqKpzjgOwelWWr1omLYs0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 324/849] ASoC: Intel: avs: Do not share the name pointer between components
Date: Tue, 11 Nov 2025 09:38:14 +0900
Message-ID: <20251111004544.252076730@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 0180cf7d5fe15..306c94911a775 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -1393,16 +1393,18 @@ int avs_soc_component_register(struct device *dev, const char *name,
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
2.51.0



