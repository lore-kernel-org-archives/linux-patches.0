Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEAA13DB98;
	Tue, 27 Feb 2024 13:49:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041752; cv=none; b=qOI9PGYTcdWWw4CdiSFC6yOPA2AvNSi/n8KbkpxXemLUuLz90mnVL5UL54Jy8YBZRU/a/E1l1vXbWsNY0CXc8aZ9329khjs+x5LGUuw7vhj9zAJ7L8582tJW5Z1zEfa+XO1+SxO0bk4Slq2UIIPcM6URH4AzTGA9l5MphKavbd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041752; c=relaxed/simple;
	bh=0bZwtsoM59erayj6dG2VT1O2iszEaiV2nKGmvAaOgck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PPmapWfrj7rxGFAO+wAkrpfWY1ReqOm8sEO9firjSc1lntELo9D0jfsAsQeCIPtIRzRa7wdPUm3jzqn23p6nMw2Qo8gdW7DBr91+l5UJTeBk+4hnhc0qfIjGD4UJ73dYQofbmYpklxNB6ymF68SQXhD1Y/Bv4rLqdUjMCZulXFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OkL1f6GD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OkL1f6GD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5539CC43390;
	Tue, 27 Feb 2024 13:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041752;
	bh=0bZwtsoM59erayj6dG2VT1O2iszEaiV2nKGmvAaOgck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OkL1f6GDYkJnirGM4yoT/kKn09xIV8ATH4Mc/qJk0z7nahX3aZ9asXjkyqIiIi+su
	 QuSHfhw75KSsXjxjjN9D2WYwRuoGgclTCQ8hVQxuiVF+EAeeeLheSX0U/LI6tZi5r8
	 NOcSQ0cfq5QK/IXHVLyTuw3Td05/YGXCwde4J/tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 056/299] ASoC: wm_adsp: Dont overwrite fwf_name with the default
Date: Tue, 27 Feb 2024 14:22:47 +0100
Message-ID: <20240227131627.766654333@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit daf3f0f99cde93a066240462b7a87cdfeedc04c0 ]

There's no need to overwrite fwf_name with a kstrdup() of the cs_dsp part
name. It is trivial to select either fwf_name or cs_dsp.part as the string
to use when building the filename in wm_adsp_request_firmware_file().

This leaves fwf_name entirely owned by the codec driver.

It also avoids problems with freeing the pointer. With the original code
fwf_name was either a pointer owned by the codec driver, or a kstrdup()
created by wm_adsp. This meant wm_adsp must free it if it set it, but not
if the codec driver set it. The code was handling this by using
devm_kstrdup().
But there is no absolute requirement that wm_adsp_common_init() must be
called from probe(), so this was a pseudo-memory leak - each new call to
wm_adsp_common_init() would allocate another block of memory but these
would only be freed if the owning codec driver was removed.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://msgid.link/r/20240129162737.497-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_adsp.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

diff --git a/sound/soc/codecs/wm_adsp.c b/sound/soc/codecs/wm_adsp.c
index cb654f1b09f10..72b90a7ee4b68 100644
--- a/sound/soc/codecs/wm_adsp.c
+++ b/sound/soc/codecs/wm_adsp.c
@@ -739,19 +739,25 @@ static int wm_adsp_request_firmware_file(struct wm_adsp *dsp,
 					 const char *filetype)
 {
 	struct cs_dsp *cs_dsp = &dsp->cs_dsp;
+	const char *fwf;
 	char *s, c;
 	int ret = 0;
 
+	if (dsp->fwf_name)
+		fwf = dsp->fwf_name;
+	else
+		fwf = dsp->cs_dsp.name;
+
 	if (system_name && asoc_component_prefix)
 		*filename = kasprintf(GFP_KERNEL, "%s%s-%s-%s-%s-%s.%s", dir, dsp->part,
-				      dsp->fwf_name, wm_adsp_fw[dsp->fw].file, system_name,
+				      fwf, wm_adsp_fw[dsp->fw].file, system_name,
 				      asoc_component_prefix, filetype);
 	else if (system_name)
 		*filename = kasprintf(GFP_KERNEL, "%s%s-%s-%s-%s.%s", dir, dsp->part,
-				      dsp->fwf_name, wm_adsp_fw[dsp->fw].file, system_name,
+				      fwf, wm_adsp_fw[dsp->fw].file, system_name,
 				      filetype);
 	else
-		*filename = kasprintf(GFP_KERNEL, "%s%s-%s-%s.%s", dir, dsp->part, dsp->fwf_name,
+		*filename = kasprintf(GFP_KERNEL, "%s%s-%s-%s.%s", dir, dsp->part, fwf,
 				      wm_adsp_fw[dsp->fw].file, filetype);
 
 	if (*filename == NULL)
@@ -863,29 +869,18 @@ static int wm_adsp_request_firmware_files(struct wm_adsp *dsp,
 	}
 
 	adsp_err(dsp, "Failed to request firmware <%s>%s-%s-%s<-%s<%s>>.wmfw\n",
-		 cirrus_dir, dsp->part, dsp->fwf_name, wm_adsp_fw[dsp->fw].file,
-		 system_name, asoc_component_prefix);
+		 cirrus_dir, dsp->part,
+		 dsp->fwf_name ? dsp->fwf_name : dsp->cs_dsp.name,
+		 wm_adsp_fw[dsp->fw].file, system_name, asoc_component_prefix);
 
 	return -ENOENT;
 }
 
 static int wm_adsp_common_init(struct wm_adsp *dsp)
 {
-	char *p;
-
 	INIT_LIST_HEAD(&dsp->compr_list);
 	INIT_LIST_HEAD(&dsp->buffer_list);
 
-	if (!dsp->fwf_name) {
-		p = devm_kstrdup(dsp->cs_dsp.dev, dsp->cs_dsp.name, GFP_KERNEL);
-		if (!p)
-			return -ENOMEM;
-
-		dsp->fwf_name = p;
-		for (; *p != 0; ++p)
-			*p = tolower(*p);
-	}
-
 	return 0;
 }
 
-- 
2.43.0



