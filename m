Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8A542A9B;
	Tue, 27 May 2025 17:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368203; cv=none; b=b6en8PVoBcJB/klznN37qebFZ0lwjNvbeIVE+TotlydhVzfSlDvSExb47QG9RY2AtayR7066BTJ5u/1C8IlLiUvQ1ZOUyrzzQPfG5F2iqo0pLQ9MKP0JVM485Ndg6iIwkYsZx5IcS68Eh07hUW/LfPYcNaLFeWINS2sZhhsA8Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368203; c=relaxed/simple;
	bh=1Ooj7Bf1O3OAJS2kBThFeUAAR62ySHBUX+DYoSAbGkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rKjLfqkAC6dqarOEr2IWnBoqgqAn8aYs9p5/CXhdL8wFUGUxEOCnqKDHP3SFouJjaWg4653QlpcSqhKiErijqoF3xl0kwD3xWhKEGARvmFe6BO7tuPRlxek0ZunXvBBP5Q87L5GGbettw0N2dHVRHZSsYpxKykGC7EKPSwPiNFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZkdN8KLN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZkdN8KLN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF879C4CEE9;
	Tue, 27 May 2025 17:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368203;
	bh=1Ooj7Bf1O3OAJS2kBThFeUAAR62ySHBUX+DYoSAbGkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkdN8KLNL6TyRkDeQlSfbV2Z68fRYvW5B2f/8DsUcxOB0OPDeyiDM0HuacynvASwW
	 xxFEPVuMGzLV4kHZilKrZO6u6NYQeFpUTjpyGqFI+PAXecmd/TDbpWlpiLTuvxvOCL
	 Zl/zxn6opMcyzg6o1V8x9/Gli6yMcquUvRAwLY2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 631/783] ASoC: sma1307: Fix error handling in sma1307_setting_loaded()
Date: Tue, 27 May 2025 18:27:08 +0200
Message-ID: <20250527162538.841614520@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 012a6efcc805308b1d90a1056ba963eb08858645 ]

There are a couple bugs in this code:

1) The cleanup code calls kfree(sma1307->set.header) and
   kfree(sma1307->set.def) but those functions were allocated using
   devm_kzalloc().  It results in a double free.  Delete all these
   kfree() calls.

2) A missing call to kfree(data) if the checksum was wrong on this error
   path:
	if ((sma1307->set.checksum >> 8) != SMA1307_SETTING_CHECKSUM) {
   Since the "data" pointer is supposed to be freed on every return, I
   changed that to use the __free(kfree) cleanup attribute.

Fixes: 0ec6bd16705f ("ASoC: sma1307: Add NULL check in sma1307_setting_loaded()")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://patch.msgid.link/8d32dd96-1404-4373-9b6c-c612a9c18c4c@stanley.mountain
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1307.c | 11 ++---------
 1 file changed, 2 insertions(+), 9 deletions(-)

diff --git a/sound/soc/codecs/sma1307.c b/sound/soc/codecs/sma1307.c
index b9d8136fe3dc1..793abec56dd27 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1710,7 +1710,7 @@ static void sma1307_check_fault_worker(struct work_struct *work)
 static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *file)
 {
 	const struct firmware *fw;
-	int *data, size, offset, num_mode;
+	int size, offset, num_mode;
 	int ret;
 
 	ret = request_firmware(&fw, file, sma1307->dev);
@@ -1727,7 +1727,7 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 		return;
 	}
 
-	data = kzalloc(fw->size, GFP_KERNEL);
+	int *data __free(kfree) = kzalloc(fw->size, GFP_KERNEL);
 	if (!data) {
 		release_firmware(fw);
 		sma1307->set.status = false;
@@ -1747,7 +1747,6 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 					   sma1307->set.header_size,
 					   GFP_KERNEL);
 	if (!sma1307->set.header) {
-		kfree(data);
 		sma1307->set.status = false;
 		return;
 	}
@@ -1768,8 +1767,6 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	    = devm_kzalloc(sma1307->dev,
 			   sma1307->set.def_size * sizeof(int), GFP_KERNEL);
 	if (!sma1307->set.def) {
-		kfree(data);
-		kfree(sma1307->set.header);
 		sma1307->set.status = false;
 		return;
 	}
@@ -1787,9 +1784,6 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 				   sma1307->set.mode_size * 2 * sizeof(int),
 				   GFP_KERNEL);
 		if (!sma1307->set.mode_set[i]) {
-			kfree(data);
-			kfree(sma1307->set.header);
-			kfree(sma1307->set.def);
 			for (int j = 0; j < i; j++)
 				kfree(sma1307->set.mode_set[j]);
 			sma1307->set.status = false;
@@ -1804,7 +1798,6 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 		}
 	}
 
-	kfree(data);
 	sma1307->set.status = true;
 
 }
-- 
2.39.5



