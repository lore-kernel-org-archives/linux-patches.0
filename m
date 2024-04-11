Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A84D1D558;
	Thu, 11 Apr 2024 10:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712831363; cv=none; b=KUyWW5L+d7ZFe2heRbKftmVY61e2oOfgBYNRY26UNFSNEqdAx9KnqIe/31KcPTYhcAzK8rpHxokBbJ8djpsxl6Dzt/WH2gV1agaLLqkwDl7gKySZ7Dl5Xy9c05+Th1R/9RHISZqvvAQrgk43DgvVVd025OTsRF3+/H978c7VoQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712831363; c=relaxed/simple;
	bh=fnmbNURjj3Hdi+dD2Y2nD97DMc+wGjQ5l8/39dlB92U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RJ/7OZpovfU7pBcF6fmdqnRAQliU9CtUpBwR5jBQtPhuitBofpf6/Ii8kBAkInQBHGepWvOxmO+x5ByagftehvGpweYJqtR8KGkynffonAK063nTN4c0wx+GIDiJxgAms4trWMzYrjyDX8xwt+d48kV1bOIvMjC90xheHMmIW5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTOekaTi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTOekaTi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDF2DC43390;
	Thu, 11 Apr 2024 10:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712831363;
	bh=fnmbNURjj3Hdi+dD2Y2nD97DMc+wGjQ5l8/39dlB92U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KTOekaTiesdTpj/e1aI+S+PDpAt2e+pkgxWXrHviG249nw+qqk3K3Wcv/BL8K+JBs
	 9YiiFI8icrIccLJwD4QykKLDSMGEL16wPgj0kZBp2E1RVL5Z9I88IbiPSBQF3R5Mob
	 +x2I85hwd/PtLo/Wjh51CYgP1npjM7AphG+V8tmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Wang <zhipeng.wang_1@nxp.com>,
	Chancel Liu <chancel.liu@nxp.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 096/114] ASoC: soc-core.c: Skip dummy codec when adding platforms
Date: Thu, 11 Apr 2024 11:57:03 +0200
Message-ID: <20240411095419.788856813@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
References: <20240411095416.853744210@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chancel Liu <chancel.liu@nxp.com>

[ Upstream commit 23fb6bc2696119391ec3a92ccaffe50e567c515e ]

When pcm_runtime is adding platform components it will scan all
registered components. In case of DPCM FE/BE some DAI links will
configure dummy platform. However both dummy codec and dummy platform
are using "snd-soc-dummy" as component->name. Dummy codec should be
skipped when adding platforms otherwise there'll be overflow and UBSAN
complains.

Reported-by: Zhipeng Wang <zhipeng.wang_1@nxp.com>
Signed-off-by: Chancel Liu <chancel.liu@nxp.com>
Link: https://msgid.link/r/20240305065606.3778642-1-chancel.liu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/soc-core.c b/sound/soc/soc-core.c
index 9de98c01d8151..e65fe3a7c3e42 100644
--- a/sound/soc/soc-core.c
+++ b/sound/soc/soc-core.c
@@ -1105,6 +1105,9 @@ static int snd_soc_add_pcm_runtime(struct snd_soc_card *card,
 			if (!snd_soc_is_matching_component(platform, component))
 				continue;
 
+			if (snd_soc_component_is_dummy(component) && component->num_dai)
+				continue;
+
 			snd_soc_rtd_add_component(rtd, component);
 		}
 	}
-- 
2.43.0



