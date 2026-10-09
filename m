Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55C982BE7CD;
	Fri,  9 Oct 2026 14:26:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555981; cv=none; b=fgK3HhyybBHODJXHS+CkyxeZxJyngnuzgKQWUbNrvYNr/D4R9Rpxfx2Br3Ayey8fsVgc1h+RzGYBoqUPRAG+nbuF+PL/WUelqhwwo3ekrYNVhhHqVXAWjH+aVpulQfW2/2cEkCA8MVuS1tkV558pMGUsstzxMihuW0Vq8w3WMHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555981; c=relaxed/simple;
	bh=RVaV56a3FlxZ8ObkpouyWOKi1iMIkhD4dvDnSDHZ6IY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cBIoPDwFAC6nZcsgotUd1sRuJMSxzQIpqdAohL/r6F6zeVFDc1hQQJD+IdEBSFSNsYHoKa57KYuKtUbnKV2LBGD55p8S0VSGrGj7EXmmWw+EVxOu4eAWWDau9GkEDQa3ySdGMow5CNeg16jlulBtYJiOedhZ6i9ymloIo86bbaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtsMkfku; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtsMkfku"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5BCC1F000FF;
	Fri,  9 Oct 2026 14:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555980;
	bh=gjIvAhN2zZd5Vo1YkD/G7sAwTEOuejlN8GZc2TnlMKU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CtsMkfkucAbus0OabTgDcfzYkqDf/GKicZsdf+50DZnrYeoz5YvOdJsnl7gF59ouH
	 9LHZXOYsROYvq7TUVvMtY5JWkjBe+Kk9sUqM3hPbK93CIhtLASUqgUihmi7/qJKoir
	 cNyxg+7rl/UnT0j7grBAQcRgaogrbeUtXp/VWxOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Strozek <mstrozek@opensource.cirrus.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 100/428] ASoC: SDCA: Add better pm_runtime error handling in func probe
Date: Fri,  9 Oct 2026 16:07:17 +0200
Message-ID: <20261009140948.412857204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Maciej Strozek <mstrozek@opensource.cirrus.com>

[ Upstream commit 91094f9c86216898ce92141c26c8fec7e97544c0 ]

Add a common error path in probe that balances the runtime PM reference.

Fixes: 3af1815a2f9c ("ASoC: SDCA: Add basic SDCA function driver")
Signed-off-by: Maciej Strozek <mstrozek@opensource.cirrus.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/20260924095458.2683755-3-mstrozek@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_class_function.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/sound/soc/sdca/sdca_class_function.c b/sound/soc/sdca/sdca_class_function.c
index 86e5d28511542..60eecf34c7788 100644
--- a/sound/soc/sdca/sdca_class_function.c
+++ b/sound/soc/sdca/sdca_class_function.c
@@ -388,20 +388,27 @@ static int class_function_probe(struct auxiliary_device *auxdev,
 
 	ret = devm_pm_runtime_enable(dev);
 	if (ret)
-		return ret;
+		goto err_pm;
 
 	ret = class_function_boot(drv);
 	if (ret)
-		return ret;
+		goto err_pm;
 
 	ret = devm_snd_soc_register_component(dev, cmp_drv, dais, num_dais);
-	if (ret)
-		return dev_err_probe(dev, ret, "failed to register component\n");
+	if (ret) {
+		dev_err_probe(dev, ret, "failed to register component\n");
+		goto err_pm;
+	}
 
 	pm_runtime_mark_last_busy(dev);
 	pm_runtime_put_autosuspend(dev);
 
 	return 0;
+
+err_pm:
+	pm_runtime_put_sync(dev);
+
+	return ret;
 }
 
 static void class_function_remove(struct auxiliary_device *auxdev)
-- 
2.53.0



