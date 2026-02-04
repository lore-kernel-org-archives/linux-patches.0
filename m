Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1366B27F749;
	Wed,  4 Feb 2026 14:54:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216852; cv=none; b=Qx1pJ9+nC1fLNtyYc80s1E6QYjlZGlrkORDgxoWJzJ+b/s5sko/Wd854XmdxqKpWlDSUO2d8+6JwwDuK7ZzjN9aHfdfZEPq1y73QXX6WYajARHfu7iOgCqNQJWmf9kDeJfTV1pI9y84sJalULNhYkb832TLrz0Ej3wSnFX3f/IU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216852; c=relaxed/simple;
	bh=V9F3IMDegiXFD//RgPEd8wx8LEB2piF5MKGOGp3ZrQc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeJFpptTW0+iCoPmkFAmVHCMsGt/1FBZ+qrlbVD4VCKMoqDPRMZcv+KEGFwcbfmHNPLiycKzwLuaqqUM1dJ336PiJpjYIcLjP8g8ElH8lpwDK/PTVd9qR/BavA3RU+YkCE3xGkYX/3GnGBe/WoM5d6tTSesK9H3yLR3FVZd5BfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5N4P8C+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5N4P8C+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58AD8C4CEF7;
	Wed,  4 Feb 2026 14:54:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216852;
	bh=V9F3IMDegiXFD//RgPEd8wx8LEB2piF5MKGOGp3ZrQc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t5N4P8C+nFeIfWFtUBBxSiKfCULE3GVo6ypLq2hzNFEyJHe1OHW84txCsFgDnBI+t
	 1kmEnopYuCYz4+zW5ChbR7Hin+1TOy8kXA2D07awkBno6ybk8D/WJkFTfBCOiF4vff
	 F08r66KvKhrMJv+MNKXuOD1SBGQSh0UOGKMQL11g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.15 049/206] dmaengine: qcom: gpi: Fix memory leak in gpi_peripheral_config()
Date: Wed,  4 Feb 2026 15:38:00 +0100
Message-ID: <20260204143859.983275694@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1621,14 +1621,16 @@ static int
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


