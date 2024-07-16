Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFEC627733;
	Tue, 16 Jul 2024 15:49:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144977; cv=none; b=nOVg1XMsClasLpwt6zpicWKrg8t1Q9aXs+Cy6XFjUHnkcvmLslXkfbp11wN80fJuihjMbE9CPDyB8b7eLB6l9vx5cp4x/mnpDAp3YUZmYQSElMyUOpYGqVWy1kYnjSI6uOz9mQE//SZZExrcRiwoGvD2VfvPu3xNqrRkBBNj5+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144977; c=relaxed/simple;
	bh=meBLojAhZjL9aASUgQNC0g3BgRU+WPjazSb+kg1K2kE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dxIOFwy+CdNEBG7Fjnkd+rPs6H1F2Te6+NfUlTRNxtVraj4lUd5qiejRiS6hQBKNDdBOGw/YMMxNUXiuK8wc1XmGarSLncyWEXCVYXZab6C4Ak545Wl7prpgGcOEsI1Z9vUhjTsUwtCscg4XwYuM7KTne+VKv1mUULHAEj+DNO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BcNGNaTU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BcNGNaTU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D2F3C116B1;
	Tue, 16 Jul 2024 15:49:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144977;
	bh=meBLojAhZjL9aASUgQNC0g3BgRU+WPjazSb+kg1K2kE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BcNGNaTUGvIwTkhv7aAT1smLqGhft8Em+LwMrA/5WYFcTJ+4U74lB9pHCNq1dZ1LY
	 hoNjqz8zkBS/AJcVGhyzbTlViV2zEQ91JdgUnXaFzpsbH2NuYcAsqtb3zvZf1TEICH
	 aPwaR1clG1Vbx0K8O7g81ZxnVABFprp0ElJM+M+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 056/143] firmware: cs_dsp: Use strnlen() on name fields in V1 wmfw files
Date: Tue, 16 Jul 2024 17:30:52 +0200
Message-ID: <20240716152758.135750740@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152755.980289992@linuxfoundation.org>
References: <20240716152755.980289992@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 680e126ec0400f6daecf0510c5bb97a55779ff03 ]

Use strnlen() instead of strlen() on the algorithm and coefficient name
string arrays in V1 wmfw files.

In V1 wmfw files the name is a NUL-terminated string in a fixed-size
array. cs_dsp should protect against overrunning the array if the NUL
terminator is missing.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240708144855.385332-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index b6fd2ea1ce643..a1da7581adb03 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1128,7 +1128,7 @@ static int cs_dsp_coeff_parse_alg(struct cs_dsp *dsp,
 
 		blk->id = le32_to_cpu(raw->id);
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ncoeff = le32_to_cpu(raw->ncoeff);
 
 		pos = sizeof(*raw);
@@ -1204,7 +1204,7 @@ static int cs_dsp_coeff_parse_coeff(struct cs_dsp *dsp,
 			return -EOVERFLOW;
 
 		blk->name = raw->name;
-		blk->name_len = strlen(raw->name);
+		blk->name_len = strnlen(raw->name, ARRAY_SIZE(raw->name));
 		blk->ctl_type = le16_to_cpu(raw->ctl_type);
 		blk->flags = le16_to_cpu(raw->flags);
 		blk->len = le32_to_cpu(raw->len);
-- 
2.43.0



