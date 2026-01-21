Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7870E33EAFF;
	Wed, 21 Jan 2026 18:23:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019789; cv=none; b=VjhTjfaoYlYKu47YHNJ/HgwjoYi8iLTENdqzMQOuWKSbU1Z7LbMAYHlJSh11qWWDkcYm5xdPXTJZngQdm1SjakQXCaRHa8GHLLPetwcXn+cGQm8+6q8FcQcGNL/EHtmzjLMz6sePUZQ60tB9rYtjmoVhnf3d2rnKPqT6g/6TNgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019789; c=relaxed/simple;
	bh=GMq5AcbIuN5J7C76OojRtynT1HcqWT8EfeHKJ64i1Ds=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vn+HEbPpuGOJDVq7XV9kT03YSlEYLa4A3y/lS0K7dYu47siEFcguC8ZQ9isGEsA1t4vMnFnDj3f+25fqEBUSf+NQZscFKQeekhbUFQvV8Dg8fQmBgxLQq9JZlq81QHa8wGeWvUXyM5iscTc74dXLR9x2TWxD5ijU+5jzewfuaIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LyPl1bR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LyPl1bR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8988DC16AAE;
	Wed, 21 Jan 2026 18:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019789;
	bh=GMq5AcbIuN5J7C76OojRtynT1HcqWT8EfeHKJ64i1Ds=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LyPl1bR/nZkA6N5Niw+bwrBVOEGSKBflSY1khJmxteIxgVM+3SAjpya7g4li7vda
	 SiYEZRKc8grChrSbzpe04JYtZR20YceGZY7/cAkJYLWZpRPsJm02Dyftmhc1pGeJ/d
	 vo4r2uhQE3pLGg7s+TogZAvLxE8r/PfyQb2DYt9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.12 109/139] dmaengine: at_hdmac: fix device leak on of_dma_xlate()
Date: Wed, 21 Jan 2026 19:15:57 +0100
Message-ID: <20260121181415.370176688@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181411.452263583@linuxfoundation.org>
References: <20260121181411.452263583@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit b9074b2d7a230b6e28caa23165e9d8bc0677d333 upstream.

Make sure to drop the reference taken when looking up the DMA platform
device during of_dma_xlate() when releasing channel resources.

Note that commit 3832b78b3ec2 ("dmaengine: at_hdmac: add missing
put_device() call in at_dma_xlate()") fixed the leak in a couple of
error paths but the reference is still leaking on successful allocation.

Fixes: bbe89c8e3d59 ("at_hdmac: move to generic DMA binding")
Fixes: 3832b78b3ec2 ("dmaengine: at_hdmac: add missing put_device() call in at_dma_xlate()")
Cc: stable@vger.kernel.org	# 3.10: 3832b78b3ec2
Cc: Yu Kuai <yukuai3@huawei.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20251117161258.10679-2-johan@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/at_hdmac.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1765,6 +1765,7 @@ static int atc_alloc_chan_resources(stru
 static void atc_free_chan_resources(struct dma_chan *chan)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_slave	*atslave;
 
 	BUG_ON(atc_chan_is_enabled(atchan));
 
@@ -1774,8 +1775,12 @@ static void atc_free_chan_resources(stru
 	/*
 	 * Free atslave allocated in at_dma_xlate()
 	 */
-	kfree(chan->private);
-	chan->private = NULL;
+	atslave = chan->private;
+	if (atslave) {
+		put_device(atslave->dma_dev);
+		kfree(atslave);
+		chan->private = NULL;
+	}
 
 	dev_vdbg(chan2dev(chan), "free_chan_resources: done\n");
 }


