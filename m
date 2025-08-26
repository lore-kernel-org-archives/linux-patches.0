Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 470AC230BDF;
	Tue, 26 Aug 2025 13:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215417; cv=none; b=ASXgtbkE140xphs9XjG0jIyVqjSP2YXzxSklZPOm5XAkupjdq1PzyrnqDTXhKPzPcLQupdnFSOaq4ihH9bppAZMHfi6DMnUtk4CxhH+OnpZ3lm5bO0Y0lXsScHXnS8W+JFyTjdPqiVs3Q5uEwvJZMXSFRBUWUBLLAqlJSReum9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215417; c=relaxed/simple;
	bh=2XAme2whalMc8aLTlTfiBGWroJcz2h6y6UdkeXk61+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IfcdON7D0jxOIhSonJsFPZWw1OHSetYrMXjZFzVtoDwtOWBcStvSTYwYbRnOzlkbvG9pmZ1QgGNCUtewVgK+1Qu0WPc0xk9kBBn5gtgZRxT/z6ppN5t05s8tTgxcDSpLKJGe8+epDnQIsOc4/xbEQ3oDM2i9/4FmwwbB4BMj4Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gsLZwo0S; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gsLZwo0S"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB8FBC4CEF1;
	Tue, 26 Aug 2025 13:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215417;
	bh=2XAme2whalMc8aLTlTfiBGWroJcz2h6y6UdkeXk61+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gsLZwo0SgkXpU8JwY/Q0LNbI1VCTvRekK5SRdQXDebrKuUeLm4dGrmZEVqPOq/utY
	 +VpTA52Tc83Vqls8h/AVRXYPkRP08h9Esh12Emmm696lwuasxKwlUrzLh3w2ZlaPLv
	 52s8tjJ+BKErPr/a3RV9EdgF4eGhnFsS8PdcUjn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20Le=20Goffic?= <clement.legoffic@foss.st.com>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 5.15 006/644] i2c: stm32: fix the device used for the DMA map
Date: Tue, 26 Aug 2025 13:01:37 +0200
Message-ID: <20250826110946.668177726@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Le Goffic <clement.legoffic@foss.st.com>

commit c870cbbd71fccda71d575f0acd4a8d2b7cd88861 upstream.

If the DMA mapping failed, it produced an error log with the wrong
device name:
"stm32-dma3 40400000.dma-controller: rejecting DMA map of vmalloc memory"
Fix this issue by replacing the dev with the I2C dev.

Fixes: bb8822cbbc53 ("i2c: i2c-stm32: Add generic DMA API")
Signed-off-by: Clément Le Goffic <clement.legoffic@foss.st.com>
Cc: <stable@vger.kernel.org> # v4.18+
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20250704-i2c-upstream-v4-1-84a095a2c728@foss.st.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32.c   |    8 +++-----
 drivers/i2c/busses/i2c-stm32f7.c |    4 ++--
 2 files changed, 5 insertions(+), 7 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32.c
+++ b/drivers/i2c/busses/i2c-stm32.c
@@ -102,7 +102,6 @@ int stm32_i2c_prep_dma_xfer(struct devic
 			    void *dma_async_param)
 {
 	struct dma_async_tx_descriptor *txdesc;
-	struct device *chan_dev;
 	int ret;
 
 	if (rd_wr) {
@@ -116,11 +115,10 @@ int stm32_i2c_prep_dma_xfer(struct devic
 	}
 
 	dma->dma_len = len;
-	chan_dev = dma->chan_using->device->dev;
 
-	dma->dma_buf = dma_map_single(chan_dev, buf, dma->dma_len,
+	dma->dma_buf = dma_map_single(dev, buf, dma->dma_len,
 				      dma->dma_data_dir);
-	if (dma_mapping_error(chan_dev, dma->dma_buf)) {
+	if (dma_mapping_error(dev, dma->dma_buf)) {
 		dev_err(dev, "DMA mapping failed\n");
 		return -EINVAL;
 	}
@@ -150,7 +148,7 @@ int stm32_i2c_prep_dma_xfer(struct devic
 	return 0;
 
 err:
-	dma_unmap_single(chan_dev, dma->dma_buf, dma->dma_len,
+	dma_unmap_single(dev, dma->dma_buf, dma->dma_len,
 			 dma->dma_data_dir);
 	return ret;
 }
--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -721,10 +721,10 @@ static void stm32f7_i2c_dma_callback(voi
 {
 	struct stm32f7_i2c_dev *i2c_dev = (struct stm32f7_i2c_dev *)arg;
 	struct stm32_i2c_dma *dma = i2c_dev->dma;
-	struct device *dev = dma->chan_using->device->dev;
 
 	stm32f7_i2c_disable_dma_req(i2c_dev);
-	dma_unmap_single(dev, dma->dma_buf, dma->dma_len, dma->dma_data_dir);
+	dma_unmap_single(i2c_dev->dev, dma->dma_buf, dma->dma_len,
+			 dma->dma_data_dir);
 	complete(&dma->dma_complete);
 }
 


