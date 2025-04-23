Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D898E280A50;
	Wed, 23 Apr 2025 14:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419686; cv=none; b=i13zVpix9RY7lCN0hxwn/c+/KbOCeIlZYUWajX5DoWTt7kIGdxq91dpILwC+Ow99yMfPp6BsjjdXh8MXCArodtXMrDa/l4iduVpDABxl+mUAmVnG4yF7xnaKfdpho7QQMB0khGEobL1U7RrDwGlFbpBfHij2HULACnIC3rLWE7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419686; c=relaxed/simple;
	bh=D4aSliOL+n0yJSM+Bl6du42Pz5CsVaR7pBu0zm0omcc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YL+P+qCLw4O4bp4VGpk7jQH+1wSAMiu5QbLBoajDX8pvUBxz8ZzrORhu4qnaOG0oHQ6MyUY9PrLMC30alVN1cTKq2Q2843IYlJO8EjR6+vfb+tJnH/mBWKUGUAKyiOvOASLIZBApsKeE+L27lO1fwqrm1cc5zIye3dKXJ0NDnPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PFR5xCE9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PFR5xCE9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C572C4CEE2;
	Wed, 23 Apr 2025 14:48:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419686;
	bh=D4aSliOL+n0yJSM+Bl6du42Pz5CsVaR7pBu0zm0omcc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PFR5xCE9jmVD4qEewZiqjQvUJToKgJmpRElah/MV8USudVw9XWbkJuPb8NJpx7BPP
	 357CYYmVpFvtT3e3/vMj6E6LjSenkdH+KokLlEz23k2tRO0xmmqSEf+IKOjiBcQT0c
	 e2cikGnyvGaVUXWRcTEWGvTb/qVATk02vOKkjteE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Ethan Carter Edwards <ethan@ethancedwards.com>,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/223] ASoC: Intel: avs: Fix null-ptr-deref in avs_component_probe()
Date: Wed, 23 Apr 2025 16:41:26 +0200
Message-ID: <20250423142617.700591779@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 945f9c0a6a545..15defce0f3eb8 100644
--- a/sound/soc/intel/avs/pcm.c
+++ b/sound/soc/intel/avs/pcm.c
@@ -925,7 +925,8 @@ static int avs_component_probe(struct snd_soc_component *component)
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



