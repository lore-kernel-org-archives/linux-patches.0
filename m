Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FCB719AD72;
	Tue, 16 Jul 2024 15:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145390; cv=none; b=NZGYWbJMTsenuZZWWQn1HcRvObK3ev4qM4ojqxYfWuan3kDEk9HmKi8KIZFopkN81VVuNSncgz/u7TkPXNHsoj5LNYGryKUnaSMN9V1VaK24rbB0gRtJtZi3cTD7OS/sK2u9V6HtXFniCEz4Ix18GHwpzhb/8lGNkOKpw7jn4OU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145390; c=relaxed/simple;
	bh=ORY/iqQMZuCID2t6whPYr4EkzEwXYGivDoOVI8+MV7g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W6oUyW37MAW1EwLNnPPRU87L53nS37hH9M9VJi08anO/nvVJKMPMShZHFfB1qITYUqtYIMHHHwNFu+mi5nsHCHA+zECptd/d5Z/E6Y9mFcjHCcRNO0fpZAiJ+FPBomzlnUpEFfCIoyGjJYbiBna1FErry0ukK+T/262P66n/fkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a3hc+hQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a3hc+hQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03F75C116B1;
	Tue, 16 Jul 2024 15:56:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145390;
	bh=ORY/iqQMZuCID2t6whPYr4EkzEwXYGivDoOVI8+MV7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a3hc+hQHUxY+mLhWaTZ4gAbjd+fpBS4oH1MniWw7WSD+euagQ+YGXP7/ABfBWS1CN
	 P/mAqzrXE04PpsimNqGVCg/E5VsJLUO3Od//5UA07T378NmgYdmI690HoXWnsS8Ctn
	 mecHxIornMJ6k3SdX4YUuHCkAmP5HyEKomXVSNF8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 33/96] firmware: cs_dsp: Validate payload length before processing block
Date: Tue, 16 Jul 2024 17:31:44 +0200
Message-ID: <20240716152747.787145492@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152746.516194097@linuxfoundation.org>
References: <20240716152746.516194097@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 6598afa9320b6ab13041616950ca5f8f938c0cf1 ]

Move the payload length check in cs_dsp_load() and cs_dsp_coeff_load()
to be done before the block is processed.

The check that the length of a block payload does not exceed the number
of remaining bytes in the firwmware file buffer was being done near the
end of the loop iteration. However, some code before that check used the
length field without validating it.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: f6bc909e7673 ("firmware: cs_dsp: add driver to support firmware loading on Cirrus Logic DSPs")
Link: https://patch.msgid.link/20240627141432.93056-4-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 36 +++++++++++++-------------------
 1 file changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index 208c799af7968..7882f3a5f8556 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1356,6 +1356,12 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 		}
 
 		region = (void *)&(firmware->data[pos]);
+
+		if (le32_to_cpu(region->len) > firmware->size - pos - sizeof(*region)) {
+			ret = -EOVERFLOW;
+			goto out_fw;
+		}
+
 		region_name = "Unknown";
 		reg = 0;
 		text = NULL;
@@ -1412,16 +1418,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 			   regions, le32_to_cpu(region->len), offset,
 			   region_name);
 
-		if (le32_to_cpu(region->len) >
-		    firmware->size - pos - sizeof(*region)) {
-			cs_dsp_err(dsp,
-				   "%s.%d: %s region len %d bytes exceeds file length %zu\n",
-				   file, regions, region_name,
-				   le32_to_cpu(region->len), firmware->size);
-			ret = -EINVAL;
-			goto out_fw;
-		}
-
 		if (text) {
 			memcpy(text, region->data, le32_to_cpu(region->len));
 			cs_dsp_info(dsp, "%s: %s\n", file, text);
@@ -2051,6 +2047,11 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 		blk = (void *)(&firmware->data[pos]);
 
+		if (le32_to_cpu(blk->len) > firmware->size - pos - sizeof(*blk)) {
+			ret = -EOVERFLOW;
+			goto out_fw;
+		}
+
 		type = le16_to_cpu(blk->type);
 		offset = le16_to_cpu(blk->offset);
 		version = le32_to_cpu(blk->ver) >> 8;
@@ -2146,17 +2147,6 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 		}
 
 		if (reg) {
-			if (le32_to_cpu(blk->len) >
-			    firmware->size - pos - sizeof(*blk)) {
-				cs_dsp_err(dsp,
-					   "%s.%d: %s region len %d bytes exceeds file length %zu\n",
-					   file, blocks, region_name,
-					   le32_to_cpu(blk->len),
-					   firmware->size);
-				ret = -EINVAL;
-				goto out_fw;
-			}
-
 			buf = cs_dsp_buf_alloc(blk->data,
 					       le32_to_cpu(blk->len),
 					       &buf_list);
@@ -2196,6 +2186,10 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 	regmap_async_complete(regmap);
 	cs_dsp_buf_free(&buf_list);
 	kfree(text);
+
+	if (ret == -EOVERFLOW)
+		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
+
 	return ret;
 }
 
-- 
2.43.0



