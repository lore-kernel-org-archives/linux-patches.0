Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09ECB1DA4D;
	Tue, 16 Jul 2024 15:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144960; cv=none; b=B+KEQbSvpcDOQOTw+xtH007FBmNzEmM3h7xrK2NrQXkXbrJ6NYITTbo7cctfoa7gqZzRzZJvM3/SAl+GQi6rEs9mQbl4XKBVGqdIMstTMOZj/8JxwBmK4kdOO/56ZwaQF2JRNY9CvO8wMRN1e07xFffre/S9DHEafw8cAufiS58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144960; c=relaxed/simple;
	bh=j67RivgkszF4mfAg/g0MaLKZCLSbK2iUBIVNvUmmcjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPNCCtu+3iROJswnKdu7BDGfz6UbJHwlInIPQLD9Gw54nqrclSeUqCNZSdwxfY2aJBpO58MTUwwQ7ti0ZP8q1bYIdyFAeLoR3w9IzVK8sahB/riqh8PEUR+Any/3TW6zLPMcRpHY7buVem+/b9P/EKJ75DXhDYQt1EvnaBwGtUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Is4mlIyB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Is4mlIyB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79DCEC116B1;
	Tue, 16 Jul 2024 15:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144959;
	bh=j67RivgkszF4mfAg/g0MaLKZCLSbK2iUBIVNvUmmcjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Is4mlIyBqL7fmkSIfVBXW06Z34QK6MLCtbQCX1c3fd2p6Eo6O7YZJBbjeM3hwjvdJ
	 n3cR9Rm9pVEaO+O72lM7tkzpDwjbOGN08726Wm7OSNwoXwf09xyuIaldBAsD43fTJc
	 s14d85mDb8CfmRXdh94SoF3tThilTEWofgyvEQ08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 051/143] firmware: cs_dsp: Fix overflow checking of wmfw header
Date: Tue, 16 Jul 2024 17:30:47 +0200
Message-ID: <20240716152757.948652609@linuxfoundation.org>
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

[ Upstream commit 3019b86bce16fbb5bc1964f3544d0ce7d0137278 ]

Fix the checking that firmware file buffer is large enough for the
wmfw header, to prevent overrunning the buffer.

The original code tested that the firmware data buffer contained
enough bytes for the sums of the size of the structs

	wmfw_header + wmfw_adsp1_sizes + wmfw_footer

But wmfw_adsp1_sizes is only used on ADSP1 firmware. For ADSP2 and
Halo Core the equivalent struct is wmfw_adsp2_sizes, which is
4 bytes longer. So the length check didn't guarantee that there
are enough bytes in the firmware buffer for a header with
wmfw_adsp2_sizes.

This patch splits the length check into three separate parts. Each
of the wmfw_header, wmfw_adsp?_sizes and wmfw_footer are checked
separately before they are used.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240627141432.93056-2-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 9f3d665cfdcf7..5acd6611dba31 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1267,6 +1267,10 @@ static unsigned int cs_dsp_adsp1_parse_sizes(struct cs_dsp *dsp,
 	const struct wmfw_adsp1_sizes *adsp1_sizes;
 
 	adsp1_sizes = (void *)&firmware->data[pos];
+	if (sizeof(*adsp1_sizes) > firmware->size - pos) {
+		cs_dsp_err(dsp, "%s: file truncated\n", file);
+		return 0;
+	}
 
 	cs_dsp_dbg(dsp, "%s: %d DM, %d PM, %d ZM\n", file,
 		   le32_to_cpu(adsp1_sizes->dm), le32_to_cpu(adsp1_sizes->pm),
@@ -1283,6 +1287,10 @@ static unsigned int cs_dsp_adsp2_parse_sizes(struct cs_dsp *dsp,
 	const struct wmfw_adsp2_sizes *adsp2_sizes;
 
 	adsp2_sizes = (void *)&firmware->data[pos];
+	if (sizeof(*adsp2_sizes) > firmware->size - pos) {
+		cs_dsp_err(dsp, "%s: file truncated\n", file);
+		return 0;
+	}
 
 	cs_dsp_dbg(dsp, "%s: %d XM, %d YM %d PM, %d ZM\n", file,
 		   le32_to_cpu(adsp2_sizes->xm), le32_to_cpu(adsp2_sizes->ym),
@@ -1322,7 +1330,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	struct regmap *regmap = dsp->regmap;
 	unsigned int pos = 0;
 	const struct wmfw_header *header;
-	const struct wmfw_adsp1_sizes *adsp1_sizes;
 	const struct wmfw_footer *footer;
 	const struct wmfw_region *region;
 	const struct cs_dsp_region *mem;
@@ -1338,10 +1345,8 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	ret = -EINVAL;
 
-	pos = sizeof(*header) + sizeof(*adsp1_sizes) + sizeof(*footer);
-	if (pos >= firmware->size) {
-		cs_dsp_err(dsp, "%s: file too short, %zu bytes\n",
-			   file, firmware->size);
+	if (sizeof(*header) >= firmware->size) {
+		ret = -EOVERFLOW;
 		goto out_fw;
 	}
 
@@ -1369,13 +1374,16 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	pos = sizeof(*header);
 	pos = dsp->ops->parse_sizes(dsp, file, pos, firmware);
+	if ((pos == 0) || (sizeof(*footer) > firmware->size - pos)) {
+		ret = -EOVERFLOW;
+		goto out_fw;
+	}
 
 	footer = (void *)&firmware->data[pos];
 	pos += sizeof(*footer);
 
 	if (le32_to_cpu(header->len) != pos) {
-		cs_dsp_err(dsp, "%s: unexpected header length %d\n",
-			   file, le32_to_cpu(header->len));
+		ret = -EOVERFLOW;
 		goto out_fw;
 	}
 
@@ -1501,6 +1509,9 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 	cs_dsp_buf_free(&buf_list);
 	kfree(text);
 
+	if (ret == -EOVERFLOW)
+		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
+
 	return ret;
 }
 
-- 
2.43.0



