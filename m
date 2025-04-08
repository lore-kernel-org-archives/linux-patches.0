Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA296207E14;
	Tue,  8 Apr 2025 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115148; cv=none; b=VV9hG8sOs4gZhu5f/r0ZxME0Db24RgmWbJ44L8dXMlvFFFeNGDQ3Xh9PHlmKf3bvL5HHxyKuSLil2CFgLZ7c4oUBKkxUcoWyKd5QX8uEW7oTFuL8wpSY7Kn1/dPkbD91TFwl3Degte4AmA6UdsRQ639lHE4L+SxkD9+Mjmqilrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115148; c=relaxed/simple;
	bh=eFsRBsfCTL+8hfkxa2ASBtSPQdwPxOpdFxQ4BMFEAfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CZSSVu+1w6XYTA3PG7k2YP6dc39QZSOxVmsUWktZ4eWZFcyhxSyRHdnkp0+MydSXWHITKZbFi5InSyiSaODwIpI4rO5My9+qescYWFZZM6du2FvCqakZsdwv9StyNBReanF8N20/P+Lglmr5O8DCILbLIkO+HwX0B+5z0aE+tv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ighg/fdE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ighg/fdE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77000C4CEE5;
	Tue,  8 Apr 2025 12:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115147;
	bh=eFsRBsfCTL+8hfkxa2ASBtSPQdwPxOpdFxQ4BMFEAfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ighg/fdEHX3PKgflfJe0GBca54hTVNi//MPvhBG0L6rhfx/GrAQ2Arq1kQt/kQnBj
	 UcAfjxkGgbxV1fBmTKSoJqUPB+BF7CNmV5qpA6d70RFU8zjbJyuSiNjCYt6XNsQCM/
	 HUPtAOwIyugdoBfBDtAGwpNHXzIo9D1rLHqy4jcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 366/499] firmware: cs_dsp: Ensure cs_dsp_load[_coeff]() returns 0 on success
Date: Tue,  8 Apr 2025 12:49:38 +0200
Message-ID: <20250408104900.356969727@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 2593f7e0dc93a898a84220b3fb180d86f1ca8c60 ]

Set ret = 0 on successful completion of the processing loop in
cs_dsp_load() and cs_dsp_load_coeff() to ensure that the function
returns 0 on success.

All normal firmware files will have at least one data block, and
processing this block will set ret == 0, from the result of either
regmap_raw_write() or cs_dsp_parse_coeff().

The kunit tests create a dummy firmware file that contains only the
header, without any data blocks. This gives cs_dsp a file to "load"
that will not cause any side-effects. As there aren't any data blocks,
the processing loop will not set ret == 0.

Originally there was a line after the processing loop:

    ret = regmap_async_complete(regmap);

which would set ret == 0 before the function returned.

Commit fe08b7d5085a ("firmware: cs_dsp: Remove async regmap writes")
changed the regmap write to a normal sync write, so the call to
regmap_async_complete() wasn't necessary and was removed. It was
overlooked that the ret here wasn't only to check the result of
regmap_async_complete(), it also set the final return value of the
function.

Fixes: fe08b7d5085a ("firmware: cs_dsp: Remove async regmap writes")
Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Link: https://patch.msgid.link/20250323170529.197205-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 42433c19eb308..560724ce21aa3 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1631,6 +1631,7 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	cs_dsp_debugfs_save_wmfwname(dsp, file);
 
+	ret = 0;
 out_fw:
 	cs_dsp_buf_free(&buf_list);
 
@@ -2338,6 +2339,7 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 	cs_dsp_debugfs_save_binname(dsp, file);
 
+	ret = 0;
 out_fw:
 	cs_dsp_buf_free(&buf_list);
 
-- 
2.39.5



