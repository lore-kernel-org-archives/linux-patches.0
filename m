Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10D827D784;
	Tue, 27 May 2025 17:26:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366768; cv=none; b=UEZzdyRfgppTI7vNtYNiOhl7tlRD/KjO6ihmC5jtUOJsS+xtkj643d7D5l/fv9ehTGzC73A4qc4cTmySuupRpeLiSWy+e8WkQq44ImIVHsCuQ7fwP2ChexTC38g5KvCyr2h6Yav5la674hDwmuuD1nrME5kGijPTf7Q26CNUU7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366768; c=relaxed/simple;
	bh=hb2LTwjyN5OsC2BLAlIJAkiGW5PFWFBGo4MqeqlxiMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gMnq9/Rru84/cLoyEH9wzNkGlvhHFmiYjtjjQ3XYgzngA7dn8pWkBMm0JmrIDe5UgidsQyAOAnnMXkfH5Vb0EoUNMwONjfzN2ouRaGavvOIyASAITPBIDNjiHJmuYVFBuyXH2eRReruzBsxfswpg4XdmRCcoOS+a9bMWWQEt/3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fBYqnRwA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fBYqnRwA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C65C4CEE9;
	Tue, 27 May 2025 17:26:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366766;
	bh=hb2LTwjyN5OsC2BLAlIJAkiGW5PFWFBGo4MqeqlxiMo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fBYqnRwAzUiWDL/a58q8UtbCoXCOGzamhyCLtM25LFnMmtavIdFF0r1ijLSVMeMiH
	 +ZVpAj3YC8ehXr98t9f/uL48noVPZdofnSsrb74X/37J+BfUehgWuoPz0CUjFVF9rR
	 cLexMd85k3jJT+QjSIw3GlkVX/TCQ1rBfS7ThjAE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chenyuan Yang <chenyuan0y@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 172/783] ASoC: sma1307: Add NULL check in sma1307_setting_loaded()
Date: Tue, 27 May 2025 18:19:29 +0200
Message-ID: <20250527162520.169950473@linuxfoundation.org>
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

From: Chenyuan Yang <chenyuan0y@gmail.com>

[ Upstream commit 0ec6bd16705fe21d6429d6b8f7981eae2142bba8 ]

All varibale allocated by kzalloc and devm_kzalloc could be NULL.
Multiple pointer checks and their cleanup are added.

This issue is found by our static analysis tool

Signed-off-by: Chenyuan Yang <chenyuan0y@gmail.com>
Link: https://patch.msgid.link/20250311015714.1333857-1-chenyuan0y@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/sma1307.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/sound/soc/codecs/sma1307.c b/sound/soc/codecs/sma1307.c
index 480bcea48541e..b9d8136fe3dc1 100644
--- a/sound/soc/codecs/sma1307.c
+++ b/sound/soc/codecs/sma1307.c
@@ -1728,6 +1728,11 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	}
 
 	data = kzalloc(fw->size, GFP_KERNEL);
+	if (!data) {
+		release_firmware(fw);
+		sma1307->set.status = false;
+		return;
+	}
 	size = fw->size >> 2;
 	memcpy(data, fw->data, fw->size);
 
@@ -1741,6 +1746,12 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	sma1307->set.header = devm_kzalloc(sma1307->dev,
 					   sma1307->set.header_size,
 					   GFP_KERNEL);
+	if (!sma1307->set.header) {
+		kfree(data);
+		sma1307->set.status = false;
+		return;
+	}
+
 	memcpy(sma1307->set.header, data,
 	       sma1307->set.header_size * sizeof(int));
 
@@ -1756,6 +1767,13 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 	sma1307->set.def
 	    = devm_kzalloc(sma1307->dev,
 			   sma1307->set.def_size * sizeof(int), GFP_KERNEL);
+	if (!sma1307->set.def) {
+		kfree(data);
+		kfree(sma1307->set.header);
+		sma1307->set.status = false;
+		return;
+	}
+
 	memcpy(sma1307->set.def,
 	       &data[sma1307->set.header_size],
 	       sma1307->set.def_size * sizeof(int));
@@ -1768,6 +1786,16 @@ static void sma1307_setting_loaded(struct sma1307_priv *sma1307, const char *fil
 		    = devm_kzalloc(sma1307->dev,
 				   sma1307->set.mode_size * 2 * sizeof(int),
 				   GFP_KERNEL);
+		if (!sma1307->set.mode_set[i]) {
+			kfree(data);
+			kfree(sma1307->set.header);
+			kfree(sma1307->set.def);
+			for (int j = 0; j < i; j++)
+				kfree(sma1307->set.mode_set[j]);
+			sma1307->set.status = false;
+			return;
+		}
+
 		for (int j = 0; j < sma1307->set.mode_size; j++) {
 			sma1307->set.mode_set[i][2 * j]
 			    = data[offset + ((num_mode + 1) * j)];
-- 
2.39.5



