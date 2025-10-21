Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A68DB258EDF;
	Tue, 21 Oct 2025 20:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761076964; cv=none; b=Ll/yfhgFSRT4Qt6jpv8g4CuDmKQ7zUeiWaIH6lhfhhsCyUI/ITUNrZMpKozlNbFhqxhYPrFAjX8iYv4b2O0YqlWsjBa0Bi4TyIFid8+peDNKMIWt0L7TW+VKzSNr4mgOLm1Kkk+1Z2OODy2UIyEjMypqDav1QVHhR42sm75wKVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761076964; c=relaxed/simple;
	bh=1J7tHA0audNBqoIWuKM9YIoOVt+s5DUN2BG2vLfUeG4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aG3feW+kBek1U6TCRMBZh0JBGEcc5CJ48tiQ+ZRIvnuhlrqtj6qANrnVrlLPrXwXIiiJoX7JU4iqoAMRAmWuNVnaz0baQtvqmZtklJnayp2g1e/rFJ6k/hfIHzY4Qm4jLv6oms7bnWEbUBCBpdxTWo3K2mVvMgGuDP1iB0prRgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0XUL74UX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0XUL74UX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0C3C4CEF1;
	Tue, 21 Oct 2025 20:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761076964;
	bh=1J7tHA0audNBqoIWuKM9YIoOVt+s5DUN2BG2vLfUeG4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0XUL74UX6ZuSa+Zu9Jwud0kZjA0Hk1dS0uLUVyNuZ40CuMcWHS2qdjW6QLMzVi9om
	 8s3o2JJgJBXrjdUHe3g3r60LRnBOi0vNKvasRR+M6K2snpao6499fjG2LfeLMOvEU1
	 Csfsu3biqYesMjQm9++ElmBn6AFzYe+vkLLBbrk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Qiang <liqiang01@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/136] ASoC: amd/sdw_utils: avoid NULL deref when devm_kasprintf() fails
Date: Tue, 21 Oct 2025 21:51:19 +0200
Message-ID: <20251021195038.149302892@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251021195035.953989698@linuxfoundation.org>
References: <20251021195035.953989698@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Li Qiang <liqiang01@kylinos.cn>

[ Upstream commit 5726b68473f7153a7f6294185e5998b7e2a230a2 ]

devm_kasprintf() may return NULL on memory allocation failure,
but the debug message prints cpus->dai_name before checking it.
Move the dev_dbg() call after the NULL check to prevent potential
NULL pointer dereference.

Fixes: cb8ea62e64020 ("ASoC: amd/sdw_utils: add sof based soundwire generic machine driver")
Signed-off-by: Li Qiang <liqiang01@kylinos.cn>
Link: https://patch.msgid.link/20251015075530.146851-1-liqiang01@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/acp/acp-sdw-sof-mach.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/amd/acp/acp-sdw-sof-mach.c b/sound/soc/amd/acp/acp-sdw-sof-mach.c
index 99a244f495bd3..876f0b7fcd3de 100644
--- a/sound/soc/amd/acp/acp-sdw-sof-mach.c
+++ b/sound/soc/amd/acp/acp-sdw-sof-mach.c
@@ -216,9 +216,9 @@ static int create_sdw_dailink(struct snd_soc_card *card,
 			cpus->dai_name = devm_kasprintf(dev, GFP_KERNEL,
 							"SDW%d Pin%d",
 							link_num, cpu_pin_id);
-			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 			if (!cpus->dai_name)
 				return -ENOMEM;
+			dev_dbg(dev, "cpu->dai_name:%s\n", cpus->dai_name);
 
 			codec_maps[j].cpu = 0;
 			codec_maps[j].codec = j;
-- 
2.51.0



