Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5B121B191;
	Sat, 30 May 2026 18:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166492; cv=none; b=HUGWUdqUDOMuwBsj7TgfLjBk0Hmrq416jvX/e6MgF3vnqeYtMimAnfmIsewxMd17udEyGmPwAu5HZWUOgqGNEw80K7OBtwC+PyodOXs6h7bpD9lR11mSEkCsYdzt6eAJtoG3L+Rdm3pzAfQ98KXnwiujbs1eBRATVdUzzY1MwsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166492; c=relaxed/simple;
	bh=jA5tdF1mdXTJCcl8MRwcgPucjS870jv9bv9caTyQcKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTzhZZIv/xgF48qvLHWioxSfSa+pFm9igCyPHkOrPr2SruHulViMZNlgwde3A+oowMGxtTk7nVPJp9R0bmHCNWRSHyPlPdVnuA9vMF7MiGGNTn7hFzEfOJcdmpizu+JB8yZfmyzBFLNRufEwccm8CRf5tMwT8dWyfAmfNhkJLR8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dycRBR84; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dycRBR84"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDA21F00893;
	Sat, 30 May 2026 18:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166491;
	bh=+dc//LD8NpPKsigvqCWHvc06jFQq1Yw8BVr1Gfu+NJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dycRBR84AgJ4MVnDqPeTgykd77fNcWOYqdGlup0nUp5W1kWwyMAhj+mnPPGi5khRW
	 9NJip5kBwm/eCIYUj5FA40flaF14iXGIFsEgh+sWx3nLttnNbGG/gkflCuwc6kjyAc
	 2/+ysEcZKg94sXdiRiNNK1V/R5uYc/SiUB+EWwdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 388/589] dev_printk: add new dev_err_probe() helpers
Date: Sat, 30 May 2026 18:04:29 +0200
Message-ID: <20260530160234.999046396@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit dbbe7eaf0e4795bf003ac06872aaf52b6b6b1310 ]

This is similar to dev_err_probe() but for cases where an ERR_PTR() or
ERR_CAST() is to be returned simplifying patterns like:

	dev_err_probe(dev, ret, ...);
	return ERR_PTR(ret)
or
	dev_err_probe(dev, PTR_ERR(ptr), ...);
	return ERR_CAST(ptr)

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://patch.msgid.link/20240606-dev-add_dev_errp_probe-v3-1-51bb229edd79@analog.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 797cc011ae02 ("backlight: sky81452-backlight: Check return value of devm_gpiod_get_optional() in sky81452_bl_parse_dt()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/dev_printk.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/dev_printk.h b/include/linux/dev_printk.h
index 6a6a6baa10bac..7d467d5426576 100644
--- a/include/linux/dev_printk.h
+++ b/include/linux/dev_printk.h
@@ -244,4 +244,12 @@ do {									\
 
 __printf(3, 4) int dev_err_probe(const struct device *dev, int err, const char *fmt, ...);
 
+/* Simple helper for dev_err_probe() when ERR_PTR() is to be returned. */
+#define dev_err_ptr_probe(dev, ___err, fmt, ...) \
+	ERR_PTR(dev_err_probe(dev, ___err, fmt, ##__VA_ARGS__))
+
+/* Simple helper for dev_err_probe() when ERR_CAST() is to be returned. */
+#define dev_err_cast_probe(dev, ___err_ptr, fmt, ...) \
+	ERR_PTR(dev_err_probe(dev, PTR_ERR(___err_ptr), fmt, ##__VA_ARGS__))
+
 #endif /* _DEVICE_PRINTK_H_ */
-- 
2.53.0



