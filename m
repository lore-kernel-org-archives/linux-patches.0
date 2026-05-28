Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E81233F5B4;
	Thu, 28 May 2026 20:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999198; cv=none; b=IbPnFkGm5I0liHc0Io2dAxefcPCzW+fgyd8VW2eAI2H6IGUldIktkPSBrb2uDP5yTnPhliJFORgZZvmMV8EJ4sJvIM+tQEcpAJstRnwc7HrP1BzYUqnKAW+8SQMm+uc7K4aicUyXbQ3HSlLed7AIkQCKTELPrG31EjNz9YLaZNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999198; c=relaxed/simple;
	bh=7EUpSBkh+5kbgIg6sGigCD0sl5tSaORXO3ko9Ufvlbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IVtqw/5Ltwd2BJCfpCT1dYxXdZt1MIbIX7AY+R7K62vP+2B+zFvEc3Niy2JZgGhjdpoKFTHnm2c3467nBmQWPSXBj4g/zaZnSPCHoKOhorA9pOp8unb6NehSVu/gO5zt+efR40PGxG+QxZ3djikQF71Q0Mh4Qar+jwM069gSzJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M/RBYpyN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M/RBYpyN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D72D1F000E9;
	Thu, 28 May 2026 20:13:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999197;
	bh=tfyl8O6DYym8jx8Gse+cAK1wNmKMRjkxnZR+yYM31qE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M/RBYpyN3U0JezQGHwL1dJISxn6gcrdvsGaXfxZfnotLQMHj6RtcvEH1dJmRdEQV6
	 Px2y9xDLGVGGTKYOFmks9W4J0e1APeMCEXzhAzHAaVkVXGI7AnBYn0pFsyLuM1wjGg
	 PRNM553IFwbI3YYwOgCqxbo8wWf7rz+SZfQ5Ql4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 444/461] ASoC: cs-amp-lib: Fix missing dput() after debugfs_lookup()
Date: Thu, 28 May 2026 21:49:33 +0200
Message-ID: <20260528194700.384428394@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ba28a07a9a0b53a538c809e04e517e1ce1f1bee3 ]

Rewrite cs_amp_create_debugfs() so that dput() will be called on
a valid dentry returned from debugfs_lookup().

The pointer returned from debugfs_lookup() must be released by dput().
The pointer returned from debugfs_create_dir() does not need to be
passed to dput().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: cdd27fa3298a ("ASoC: cs-amp-lib: Add helpers for factory calibration")
Link: https://patch.msgid.link/20260521122511.987322-3-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs-amp-lib.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/sound/soc/codecs/cs-amp-lib.c b/sound/soc/codecs/cs-amp-lib.c
index 75baeaf64afd0..fae006aa78982 100644
--- a/sound/soc/codecs/cs-amp-lib.c
+++ b/sound/soc/codecs/cs-amp-lib.c
@@ -831,11 +831,18 @@ EXPORT_SYMBOL_NS_GPL(cs_amp_devm_get_vendor_specific_variant_id, "SND_SOC_CS_AMP
  */
 struct dentry *cs_amp_create_debugfs(struct device *dev)
 {
-	struct dentry *dir;
+	struct dentry *dir, *created;
 
+	/* debugfs_lookup() can return NULL or ERR_PTR on error */
 	dir = debugfs_lookup("cirrus_logic", NULL);
-	if (!dir)
-		dir = debugfs_create_dir("cirrus_logic", NULL);
+	if (!IS_ERR_OR_NULL(dir)) {
+		created = debugfs_create_dir(dev_name(dev), dir);
+		dput(dir);
+
+		return created;
+	}
+
+	dir = debugfs_create_dir("cirrus_logic", NULL);
 
 	return debugfs_create_dir(dev_name(dev), dir);
 }
-- 
2.53.0



