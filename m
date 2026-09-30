Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F8A1515989;
	Wed, 30 Sep 2026 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790789688; cv=none; b=QVMGmsbtGBVp5F8gGQrauvgwtasWDGMg5R06Vfe+3B9c/dvgihyNOtKHmi+RoCyy8F1aqY/jLesuyWwuNPzu5594eZJG70Dc+FD6/zPJiJfOUC37kZzMR7Ux/VBg/v2a9HLNfwyThIVIRAWB9wpketLLVlTKn2yZwl6KBKsZ6oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790789688; c=relaxed/simple;
	bh=d78cQNATTXmPs63QEeWTJUKG1wnZ0TfrEX3UBSlO4os=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AAlQgyuaRH/+M5bBuRFvjLuyVi1CHWXWyhDU4o3BKy+sRz5xsunY3tNcLMzr+s9eLXnVX4LC0BSCpggso1WXHBsFIbDqIOo4lXbN2JCWSr0kkSRseHjBj32WmUzf0iZEwOwLCzTcEG1s9pNPw3dMqwTToTuZlI6bjfh9Xcx/CRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjkOBzVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjkOBzVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B1EF1F00898;
	Wed, 30 Sep 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790789686;
	bh=DP0C154ZhGIaOlPpzOHGS/P6IMWztTm6cXTG3m2xCCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cjkOBzVu5tOoUQ2MFMrhv5NuZ4v1sD6yCI2ShMLhxntZlhLIH1ir1Rq6VbLh00AxC
	 kJArZDDvEq0gxye968BqDv5oCy6URYkyOrb/ymy5DDxxsICLwvFhAAPg5JDK2A4k0S
	 raUlKn2xgg5grEXvPbWNVFAaadQrnQzyu/Fo1ppw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Bence=20Cs=C3=B3k=C3=A1s?= <csokas.bence@prolan.hu>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 565/877] dmaengine: Add devm_dma_request_chan()
Date: Wed, 30 Sep 2026 17:24:36 +0200
Message-ID: <20260930152426.835124010@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

[ Upstream commit 08bf1663c21a3e815eda28fa242d84c945ca3b94 ]

Expand the arsenal of devm functions for DMA devices, this time for
requesting channels.

Signed-off-by: Bence Csókás <csokas.bence@prolan.hu>
Link: https://lore.kernel.org/r/20250610082256.400492-2-csokas.bence@prolan.hu
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Stable-dep-of: 777979e62711 ("i2c: mxs: fix DMA channel leak on probe error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/dmaengine.c   |   30 ++++++++++++++++++++++++++++++
 include/linux/dmaengine.h |    7 +++++++
 2 files changed, 37 insertions(+)

--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -933,6 +933,36 @@ void dma_release_channel(struct dma_chan
 }
 EXPORT_SYMBOL_GPL(dma_release_channel);
 
+static void dmaenginem_release_channel(void *chan)
+{
+	dma_release_channel(chan);
+}
+
+/**
+ * devm_dma_request_chan - try to allocate an exclusive slave channel
+ * @dev:	pointer to client device structure
+ * @name:	slave channel name
+ *
+ * Returns pointer to appropriate DMA channel on success or an error pointer.
+ *
+ * The operation is managed and will be undone on driver detach.
+ */
+
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name)
+{
+	struct dma_chan *chan = dma_request_chan(dev, name);
+	int ret = 0;
+
+	if (!IS_ERR(chan))
+		ret = devm_add_action_or_reset(dev, dmaenginem_release_channel, chan);
+
+	if (ret)
+		return ERR_PTR(ret);
+
+	return chan;
+}
+EXPORT_SYMBOL_GPL(devm_dma_request_chan);
+
 /**
  * dmaengine_get - register interest in dma_channels
  */
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -1521,6 +1521,7 @@ struct dma_chan *__dma_request_channel(c
 
 struct dma_chan *dma_request_chan(struct device *dev, const char *name);
 struct dma_chan *dma_request_chan_by_mask(const dma_cap_mask_t *mask);
+struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name);
 
 void dma_release_channel(struct dma_chan *chan);
 int dma_get_slave_caps(struct dma_chan *chan, struct dma_slave_caps *caps);
@@ -1557,6 +1558,12 @@ static inline struct dma_chan *dma_reque
 {
 	return ERR_PTR(-ENODEV);
 }
+
+static inline struct dma_chan *devm_dma_request_chan(struct device *dev, const char *name)
+{
+	return ERR_PTR(-ENODEV);
+}
+
 static inline void dma_release_channel(struct dma_chan *chan)
 {
 }


