Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D3A43806C6;
	Sat, 12 Sep 2026 07:14:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197297; cv=none; b=rdCS0cGIK6IojBZf0JO0riy19X0jD86jGfR+zIQ86luqBwknmd6OKtZiOM3JVb1ZDbhVNJjhtpLe4Svc1NAJgAMadVdtWRaaqetyegRR7UQPFm6Q5ids9YqbjzmPDU4E4jic5lblIvE9rroA6NJJQ0NrW1Gd89Gu7r6dlmriXdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197297; c=relaxed/simple;
	bh=POtBEwo1+dUtvUCWiVFYA/59MLx3vz43nxJvIid7+RI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eXNjeeERP67Fl2MFNuX7egBlGcFNfnuv3qQBXFSx+7pldYEVRPzyDi5e93xl2bOBpUQUwkNO6tS10py7i5+9ohFijEo45i7NwQXpdUsszuX2aYrHi2M+EiZDoUkQLBYyKohcwpOW6lCmSYOULw1M8Fl0oeP4WhMkDwwQCmlX6jo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h5egNU3J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h5egNU3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AB7C1F000FF;
	Sat, 12 Sep 2026 07:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197296;
	bh=fFBs+39Zmt0xKrncHcqB1Ep31GAwFrPURNYm7sRDxRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h5egNU3JKUucY2eN9zSOZFRysE+i8G4XiYO6em6Eo2x1PXk89hic+HBDwxMZfo8dv
	 nJcZd59phP3tyjG9UAAZGWcU3zNoG1v/8H0NiUI3GM8WKvFqVoRL5iOsqAIIO/WhWg
	 02RQ7uRNzCgETH2wr1VZV3TdijG0uqJMO7IeALQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0146/1815] ASoC: ti: j721e-evm: Avoid mixing goto with guard()
Date: Sat, 12 Sep 2026 08:31:36 +0200
Message-ID: <20260912065652.443617744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 47a0dde9a3bdd01359ce3a5f0b59a9de33b73dce ]

The previous guard(mutex) conversion mixed cleanup helpers with
goto-based error handling, which is discouraged by the cleanup.h
guidelines.
Restore mutex_lock()/mutex_unlock() instead.

Fixes: 6f4cf77320ae ("ASoC: ti: j721e-evm: Use guard() for mutex locks")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260701041310.230725-3-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ti/j721e-evm.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/sound/soc/ti/j721e-evm.c b/sound/soc/ti/j721e-evm.c
index c214ae0d7b95e..312298e0b0049 100644
--- a/sound/soc/ti/j721e-evm.c
+++ b/sound/soc/ti/j721e-evm.c
@@ -4,6 +4,7 @@
  *  Author: Peter Ujfalusi <peter.ujfalusi@ti.com>
  */
 
+#include <linux/cleanup.h>
 #include <linux/clk.h>
 #include <linux/module.h>
 #include <linux/of.h>
@@ -263,7 +264,7 @@ static int j721e_audio_startup(struct snd_pcm_substream *substream)
 	int ret = 0;
 	int i;
 
-	guard(mutex)(&priv->mutex);
+	mutex_lock(&priv->mutex);
 
 	domain->active++;
 
@@ -303,6 +304,7 @@ static int j721e_audio_startup(struct snd_pcm_substream *substream)
 out:
 	if (ret)
 		domain->active--;
+	mutex_unlock(&priv->mutex);
 
 	return ret;
 }
-- 
2.53.0



