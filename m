Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8355832ABC0;
	Thu, 28 May 2026 20:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998879; cv=none; b=ba38gEaBPEmSGML+WZUzrlJ3Ei6I0FMNZWB2cxIBvaa9vIIn4BwU3tZiQ2dGaG0IBJwYsB8nCEsDH6hJECP2dByZemjGqVx5zXRlCnBiJNWqPRa+ygkbQkBS48OBSlTbIdvfaPURq/LLLoPjmmk/WPtqYvm8HMvZ7U76BsgqN4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998879; c=relaxed/simple;
	bh=hkeE5hWeNFeUGSxYnt9nkh9wbINzuGbaCtFBt5n2Ek8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PRYTAfpmh30PXLunlBk3wqb7ZLVM3EcpRCALJjdMeT54CohtxMp7NEr+Qa6XpSF4rkSlhP84TbsULLlF3V8cwRqLqZcg4sMkwac905petZLN2eQjd/NjrYAQfhcRj6ZeH6WwXdixS4NJvJhlAA5O0uIBbWs9agh7XhPNzDIYsqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqX2pRRZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqX2pRRZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E16BC1F00A3A;
	Thu, 28 May 2026 20:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998878;
	bh=JeyAQcwtia3yiyH3sPsOPsE+YZMRAoAFz3oKdT77C2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqX2pRRZmS2e9qxcu8Jr+5dg3fY3oEAHvE5wquuQumSym5Kx7iBt2mIPJ5/AJTKm9
	 ZN55hnRPDxTPGdQktRHdlFDiMP5ss8zioXNyt8GM/WJcUrTLejKgBKsBcObpctCSGX
	 2+OpiMuKFhD2XSSMpujb85aWRAY6TXWnodb/n0SU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 313/461] ASoC: sdw_utils: Check speaker component string allocation
Date: Thu, 28 May 2026 21:47:22 +0200
Message-ID: <20260528194656.349696481@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cássio Gabriel <cassiogabrielcontato@gmail.com>

[ Upstream commit 5a30862dec5a70da0a9d259de3f87a7542cc95b2 ]

devm_kasprintf() can fail while building the temporary speaker
component string. If that happens, spk_components is set to NULL, but
the current code can still pass it to strlen() on a later loop iteration
or after the loop when appending the speaker component list to
card->components.

Use NULL to represent the initial "no speaker components" state, and
return -ENOMEM immediately if building spk_components fails.

Fixes: 0f60ecffbfe3 ("ASoC: sdw_utils: generate combined spk components string")
Signed-off-by: Cássio Gabriel <cassiogabrielcontato@gmail.com>
Link: https://patch.msgid.link/20260512-asoc-sdw-utils-spk-components-alloc-v1-1-c9bbd6d2e123@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdw_utils/soc_sdw_utils.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sdw_utils/soc_sdw_utils.c b/sound/soc/sdw_utils/soc_sdw_utils.c
index bf6629dd48860..1b897c8c2c2ca 100644
--- a/sound/soc/sdw_utils/soc_sdw_utils.c
+++ b/sound/soc/sdw_utils/soc_sdw_utils.c
@@ -928,7 +928,7 @@ int asoc_sdw_rtd_init(struct snd_soc_pcm_runtime *rtd)
 	struct asoc_sdw_codec_info *codec_info;
 	struct snd_soc_dai *dai;
 	struct sdw_slave *sdw_peripheral;
-	const char *spk_components="";
+	const char *spk_components = NULL;
 	int dai_index;
 	int ret;
 	int i;
@@ -1011,7 +1011,7 @@ int asoc_sdw_rtd_init(struct snd_soc_pcm_runtime *rtd)
 			else
 				component = codec_info->dais[dai_index].component_name;
 
-			if (strlen (spk_components) == 0)
+			if (!spk_components)
 				spk_components =
 					devm_kasprintf(card->dev, GFP_KERNEL, "%s", component);
 			else
@@ -1019,13 +1019,15 @@ int asoc_sdw_rtd_init(struct snd_soc_pcm_runtime *rtd)
 				spk_components =
 					devm_kasprintf(card->dev, GFP_KERNEL,
 						       "%s+%s", spk_components, component);
+
+			if (!spk_components)
+				return -ENOMEM;
 		}
 
 		codec_info->dais[dai_index].rtd_init_done = true;
-
 	}
 
-	if (strlen (spk_components) > 0) {
+	if (spk_components) {
 		/* Update card components for speaker components */
 		card->components = devm_kasprintf(card->dev, GFP_KERNEL, "%s spk:%s",
 						  card->components, spk_components);
-- 
2.53.0



