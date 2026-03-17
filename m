Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395B82E03EA;
	Tue, 17 Mar 2026 16:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773765634; cv=none; b=C3BsvWRrVlCqCUfbUSKoLUmg3t9uFJPh5FnLi7N89DlIVJ6ywhPKZEtess8SVm9AxPNSI50+lYeT22wSsNQHrXm0IL5+aWtVgaH3BEpi+Z8x7fPz+cQWybeboI5VGxMxyOxa7NPfAonuOVp4MbvxO11QceTIJxAnaItYipiPL7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773765634; c=relaxed/simple;
	bh=dCtqpqzqHjNSaXAxhZaeX9SvKUDtQagmg32zXWuCrps=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Fp/E98X8yGoymE3seHIXIBoRscOld5vJgzV+hDwbZ9H9dPH96QFDNNdgZoDAve9n/43hV+lXSQgtbDIgu9be8I3UlAM+k6vWzpV2aWNbjCgk3K1w+l65IQjvBxtxH9npN8W07UUZWmdTt/szfXDXqxc8iyv4SfF3iPhrk5pSIPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wxp4FhYF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wxp4FhYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2FB8C4CEF7;
	Tue, 17 Mar 2026 16:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773765634;
	bh=dCtqpqzqHjNSaXAxhZaeX9SvKUDtQagmg32zXWuCrps=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wxp4FhYFrY2EmAV7TP8TxO+/ftXsz3iRm0pFU+FF1OtamhnuPf3R2A+6d6SxZsrer
	 t8MeoREGkCfFF4+iXhYUg67meJUBWLA7X7iuaG7vsiypYVhoqpVuS+GWatY3IQD6rZ
	 +KigbkpBp9m5QFeFDYr42tiPPWZUFM8TBJ0KGgD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 054/378] firmware: cs_dsp: Fix fragmentation regression in firmware download
Date: Tue, 17 Mar 2026 17:30:11 +0100
Message-ID: <20260317163008.978605033@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

[ Upstream commit facfdef64d11c08e6f1e69d02a0b87cb74cee0f5 ]

Use vmalloc() instead of kmalloc(..., GFP_DMA) to alloc the temporary
buffer for firmware download blobs. This avoids the problem that a
heavily fragmented system cannot allocate enough physically-contiguous
memory for a large blob.

The redundant alloc buffer mechanism was removed in commit 900baa6e7bb0
("firmware: cs_dsp: Remove redundant download buffer allocator").
While doing that I was overly focused on the possibility of the
underlying bus requiring DMA-safe memory. So I used GFP_DMA kmalloc()s.
I failed to notice that the code I was removing used vmalloc().
This creates a regression.

Way back in 2014 the problem of fragmentation with kmalloc()s was fixed
by commit cdcd7f728753 ("ASoC: wm_adsp: Use vmalloc to allocate firmware
download buffer").

Although we don't need physically-contiguous memory, we don't know if the
bus needs some particular alignment of the buffers. Since the change in
2014, the firmware download has always used whatever alignment vmalloc()
returns. To avoid introducing a new problem, the temporary buffer is still
used, to keep the same alignment of pointers passed to regmap_raw_write().

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 900baa6e7bb0 ("firmware: cs_dsp: Remove redundant download buffer allocator")
Link: https://patch.msgid.link/20260304141250.1578597-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/cirrus/cs_dsp.c | 24 ++++++++++++++++++------
 1 file changed, 18 insertions(+), 6 deletions(-)

diff --git a/drivers/firmware/cirrus/cs_dsp.c b/drivers/firmware/cirrus/cs_dsp.c
index abed96fa5853a..a34633b875758 100644
--- a/drivers/firmware/cirrus/cs_dsp.c
+++ b/drivers/firmware/cirrus/cs_dsp.c
@@ -1610,11 +1610,17 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 			   region_name);
 
 		if (reg) {
+			/*
+			 * Although we expect the underlying bus does not require
+			 * physically-contiguous buffers, we pessimistically use
+			 * a temporary buffer instead of trusting that the
+			 * alignment of region->data is ok.
+			 */
 			region_len = le32_to_cpu(region->len);
 			if (region_len > buf_len) {
 				buf_len = round_up(region_len, PAGE_SIZE);
-				kfree(buf);
-				buf = kmalloc(buf_len, GFP_KERNEL | GFP_DMA);
+				vfree(buf);
+				buf = vmalloc(buf_len);
 				if (!buf) {
 					ret = -ENOMEM;
 					goto out_fw;
@@ -1643,7 +1649,7 @@ static int cs_dsp_load(struct cs_dsp *dsp, const struct firmware *firmware,
 
 	ret = 0;
 out_fw:
-	kfree(buf);
+	vfree(buf);
 
 	if (ret == -EOVERFLOW)
 		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
@@ -2320,11 +2326,17 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 		}
 
 		if (reg) {
+			/*
+			 * Although we expect the underlying bus does not require
+			 * physically-contiguous buffers, we pessimistically use
+			 * a temporary buffer instead of trusting that the
+			 * alignment of blk->data is ok.
+			 */
 			region_len = le32_to_cpu(blk->len);
 			if (region_len > buf_len) {
 				buf_len = round_up(region_len, PAGE_SIZE);
-				kfree(buf);
-				buf = kmalloc(buf_len, GFP_KERNEL | GFP_DMA);
+				vfree(buf);
+				buf = vmalloc(buf_len);
 				if (!buf) {
 					ret = -ENOMEM;
 					goto out_fw;
@@ -2355,7 +2367,7 @@ static int cs_dsp_load_coeff(struct cs_dsp *dsp, const struct firmware *firmware
 
 	ret = 0;
 out_fw:
-	kfree(buf);
+	vfree(buf);
 
 	if (ret == -EOVERFLOW)
 		cs_dsp_err(dsp, "%s: file content overflows file data\n", file);
-- 
2.51.0



