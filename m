Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E6E3A7F4F;
	Wed, 21 Jan 2026 18:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769020584; cv=none; b=KuYt5ZmcBLPaHTqNM6sVr156grAVgsCheWmbA0pzVOTfhryJX2YwNKWEv3NZIXpwtgWvAvyvsAV0/6QfUOmDBRjFsxqeYUSd3qkyq8nsjiRJ9w7WlIxJUvAIQjyX6Ggb8FT7YChshfyZLmtEOBTb4dk6g9S+5M00eF1zDcbjoSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769020584; c=relaxed/simple;
	bh=wkLL6Hfsnh8JdpAMRuIGlO8RIfRQ8cyIbD7kVSRFq+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eGRhrJ/OARh3S3JS51cnNbR8fTo7iceI6RSDW4UE2H/LQ6GRFM6JTUUtStrjs8CHadjWKmS9TgqjQho6HcigcKUmndGU/1G05byrdVDPYwGETNyIWR+t9suqRzLu2Z25DP2Z33GqidWrVoVidhk8jvcv6GfGlcD0cgcxyTPgNvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=azWfcc16; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="azWfcc16"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C884BC4CEF1;
	Wed, 21 Jan 2026 18:36:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769020584;
	bh=wkLL6Hfsnh8JdpAMRuIGlO8RIfRQ8cyIbD7kVSRFq+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=azWfcc16UrYxW2bZv6S0T+rd0f0iix4koaDaj/N0JVPm1D6Hy7EqO2ZESOzojoP5x
	 6ACMhdRkvLxvBbXFpvr36zC5NTisC5T/yXROInL2P6dQ+RFaFK2FLQPeuJv8ZVDX1x
	 /Z77OlLw0kA5YwIYtlso894hxGLNnZTYwxkPpPZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.18 176/198] dmaengine: qcom: gpi: Fix memory leak in gpi_peripheral_config()
Date: Wed, 21 Jan 2026 19:16:44 +0100
Message-ID: <20260121181424.884562339@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miaoqian Lin <linmq006@gmail.com>

commit 3f747004bbd641131d9396d87b5d2d3d1e182728 upstream.

Fix a memory leak in gpi_peripheral_config() where the original memory
pointed to by gchan->config could be lost if krealloc() fails.

The issue occurs when:
1. gchan->config points to previously allocated memory
2. krealloc() fails and returns NULL
3. The function directly assigns NULL to gchan->config, losing the
   reference to the original memory
4. The original memory becomes unreachable and cannot be freed

Fix this by using a temporary variable to hold the krealloc() result
and only updating gchan->config when the allocation succeeds.

Found via static analysis and code review.

Fixes: 5d0c3533a19f ("dmaengine: qcom: Add GPI dma driver")
Cc: stable@vger.kernel.org
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Bjorn Andersson <andersson@kernel.org>
Link: https://patch.msgid.link/20251029123421.91973-1-linmq006@gmail.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/qcom/gpi.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/dma/qcom/gpi.c
+++ b/drivers/dma/qcom/gpi.c
@@ -1605,14 +1605,16 @@ static int
 gpi_peripheral_config(struct dma_chan *chan, struct dma_slave_config *config)
 {
 	struct gchan *gchan = to_gchan(chan);
+	void *new_config;
 
 	if (!config->peripheral_config)
 		return -EINVAL;
 
-	gchan->config = krealloc(gchan->config, config->peripheral_size, GFP_NOWAIT);
-	if (!gchan->config)
+	new_config = krealloc(gchan->config, config->peripheral_size, GFP_NOWAIT);
+	if (!new_config)
 		return -ENOMEM;
 
+	gchan->config = new_config;
 	memcpy(gchan->config, config->peripheral_config, config->peripheral_size);
 
 	return 0;


