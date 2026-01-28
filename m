Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A0A2244667;
	Wed, 28 Jan 2026 15:30:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614246; cv=none; b=ZZQVTj9xK37zFWc9iuJu3Z7O6ACPtvtiIX1tt5q6lIHUvhznICxu50SvdGmZSBYkaeGxZUEPcmR80WJi19Mfhy8heCfpdjSvHekimuqENJT60c5WYV9+hA5WiuX1Ey9cmTJuv3JRcwTYb0DEFfXdy29RVldJuNGRfygywYc5i2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614246; c=relaxed/simple;
	bh=lYAzpUJaM/lf0nfhM3PPSvLXXRxHDvQpzlhd0OcEr2w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6e6P5tSu8hZlX2KWwva7GHNmDo8QWzLoQZu5tnK2DOkcunyZrRm+1hPS9pS0wazOf6dB41U16suznDVtrCvZdFELmQDhTo8sgOpCol4yR1EdCfh7zvuKDUVwv3RiHWTHs6qCBNSHM286IbZ5pxUvOKr5GqT5Jr/hF+HBIiPUrI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=epXAe5Dy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="epXAe5Dy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0096DC4CEF1;
	Wed, 28 Jan 2026 15:30:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614246;
	bh=lYAzpUJaM/lf0nfhM3PPSvLXXRxHDvQpzlhd0OcEr2w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=epXAe5Dy761DXg1lvuqj3BPQA6Xf2WirnEMyrwIT/cRUh2eZYkHzLY/Ka8nQwNNjK
	 wtkurLgP5j3+9gHopiE8K4DXnzLyA6RlLWLyBeapqjAl8ri8GY/Jkl+/pvp9mrWiKA
	 25p2n8Syor8q/j4BHs1CG0q4jEBbAMqc60c2gwZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yu Kuai <yukuai3@huawei.com>,
	Johan Hovold <johan@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.6 079/254] dmaengine: at_hdmac: fix device leak on of_dma_xlate()
Date: Wed, 28 Jan 2026 16:20:55 +0100
Message-ID: <20260128145347.536341058@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1755,6 +1755,7 @@ static int atc_alloc_chan_resources(stru
 static void atc_free_chan_resources(struct dma_chan *chan)
 {
 	struct at_dma_chan	*atchan = to_at_dma_chan(chan);
+	struct at_dma_slave	*atslave;
 
 	BUG_ON(atc_chan_is_enabled(atchan));
 
@@ -1764,8 +1765,12 @@ static void atc_free_chan_resources(stru
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


