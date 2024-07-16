Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB84C17C9E9;
	Tue, 16 Jul 2024 15:49:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144966; cv=none; b=Vy23PX4tywinVEw0QrsOx7Qbyrj8C2+0MxOYTP3rKHVsvfeWSl46qFKURF0A/BaVjfrycmrVrOjYUVjVB9idTMUtQIbM0juVlpsZMgFnlheQJOiQbuczYq91Mc4wVixdXGG5K2878XkDhhJl/rKf9EP1QsWsFbc/678VlwX+58M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144966; c=relaxed/simple;
	bh=cmwqBhnInU2Vrc1RtmIJKvGefP+klf+vLOYCSjlBGAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6zgXTJtHfowboSdcJsy+15Zce0HEWV/vm03dFhOj31Mbd+WJQWwvg5cm1D3lbJLYZMU8hw2+V9KmH/6pG449YwWbtnU068l5bhaUtj8PUxvTCtTlmPhPgZdlsx2vpwys1iBKxFFTMCeC3is77H8NgrrtzKxvCuLwokcYZpo/po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GWK0XGDF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWK0XGDF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57C57C116B1;
	Tue, 16 Jul 2024 15:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144965;
	bh=cmwqBhnInU2Vrc1RtmIJKvGefP+klf+vLOYCSjlBGAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GWK0XGDFrOt+eZwtGs5je+unx0pf8pA9EidhIBFfxayF09Wmdjz7S+G2/9DlokJBC
	 ocpLW9XDS3Kly28PO5KH7Tpho43s7TGMe8GqD0saS6EghyqPEwdgvkenIuvjk29cWm
	 mVSiq4SIvfhV35HEjHuD7spxHxCScExtkulZm6JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 053/143] firmware: cs_dsp: Validate payload length before processing block
Date: Tue, 16 Jul 2024 17:30:49 +0200
Message-ID: <20240716152758.023702338@linuxfoundation.org>
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
index 27eb0b0fc9ad2..68dbbcd55b34c 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1398,6 +1398,12 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
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
@@ -1454,16 +1460,6 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
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
@@ -2093,6 +2089,11 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 		blk = (void *)(&firmware->data[pos]);
 
+		if (le32_to_cpu(blk->len) > firmware->size - pos - sizeof(*blk)) {
+			ret = -EOVERFLOW;
+			goto out_fw;
+		}
+
 		type = le16_to_cpu(blk->type);
 		offset = le16_to_cpu(blk->offset);
 		version = le32_to_cpu(blk->ver) >> 8;
@@ -2189,17 +2190,6 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
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
@@ -2239,6 +2229,10 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
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



