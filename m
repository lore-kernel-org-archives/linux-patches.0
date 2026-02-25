Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5581E2834;
	Wed, 25 Feb 2026 01:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983074; cv=none; b=E0S0XbjE1aQEP3ay3ziVTQx/M7Z5I5GRQk0z4yoS4YNPjEyKVWOLvFy11EEEYnh7LZNiLnMt1wHfZrQzyKx6G6NsfR4717sJROZH5DjFP6IuBD49QkVbQMFdqm+jPzVS/xsaeYRdJpq53zRr9ZFvhzTCm33b/Edpnfy8O6h4U6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983074; c=relaxed/simple;
	bh=xPr5uvrXkFxcQvvaBKW4Jdh9aRDcfqN6Z2PGrzIvfp4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pm1yscfRWFu+njwdzQMF55SEX4JL6uH4uFroE8DZCv5CAtZ2Cjy7wzPoeOghNIukK9cY0kvUX3Vv91B1blTMFwWW1bMGz4NDtpw9WTTGoxQQcEEOqQL3djkpjk8n6b1m1NxRzWJRfxwo3Pu1Szv3XV3E7fRmEBR/lgPktHqiA1I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w7TsFvRP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w7TsFvRP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0BC3C116D0;
	Wed, 25 Feb 2026 01:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983073;
	bh=xPr5uvrXkFxcQvvaBKW4Jdh9aRDcfqN6Z2PGrzIvfp4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7TsFvRPlD9x47yhXWpilsNJXRhwvyqMXb0qEHiz0ML/tFBPm1IxXVHHl1Nv29GHV
	 jWwB0FGQ4jZqmP0mz4bC0bCSn+WTnVPi5Tjae+hoyi1mrofRrNi5JT+hvtHu0/2JH/
	 UA2smOHPyG3rAqcoS1kjXVya37HwhKIRVOqT3PeU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 209/781] firmware: cs_dsp: Dont use __free() in cs_dsp_load() and cs_dsp_load_coeff()
Date: Tue, 24 Feb 2026 17:15:18 -0800
Message-ID: <20260225012404.840774117@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit ae9ccaed3f6701ee0fe40ad919516e0aa0844f21 ]

Replace the __free(kfree) in cs_dsp_load() and cs_dsp_load_coeff() with
a kfree(buf) at the end of the function.

The use of __free() can create new cleanup bugs that are difficult to spot
because the defective code is idiomatically correct regular C. In these two
functions the __free() was mixed with gotos, and also used the suspect
declaration __free(kfree) = NULL;.

The __free() did not do anything to simplify the code. There aren't any
early returns after the pointer is set, and the __free() can be replaced by
a kfree() at the end of the function.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 900baa6e7bb0 ("firmware: cs_dsp: Remove redundant download buffer allocator")
Link: https://patch.msgid.link/20251201160729.231867-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 57296f48dad0a..abed96fa5853a 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1488,7 +1488,7 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	const struct wmfw_region *region;
 	const struct cs_dsp_region *mem;
 	const char *region_name;
-	u8 *buf __free(kfree) = NULL;
+	u8 *buf = NULL;
 	size_t buf_len = 0;
 	size_t region_len;
 	unsigned int reg;
@@ -1643,6 +1643,8 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	ret = 0;
 out_fw:
+	kfree(buf);
+
 	if (ret == -EOVERFLOW)
 		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
 
@@ -2174,7 +2176,7 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 	struct cs_dsp_alg_region *alg_region;
 	const char *region_name;
 	int ret, pos, blocks, type, offset, reg, version;
-	u8 *buf __free(kfree) = NULL;
+	u8 *buf = NULL;
 	size_t buf_len = 0;
 	size_t region_len;
 
@@ -2353,6 +2355,8 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 	ret = 0;
 out_fw:
+	kfree(buf);
+
 	if (ret == -EOVERFLOW)
 		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
 
-- 
2.51.0



