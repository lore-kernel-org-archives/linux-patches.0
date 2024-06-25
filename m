Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8E86149C4C;
	Tue, 25 Jun 2024 09:45:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308716; cv=none; b=Nh28v9Mv2gGYu/BA7uiFxz8QDy7bhUtqPtGd4J1s0CUcrjsBGqpK8zdAlKrvbz0Ni8c+Pbk6FHLWKE7oA6SCPu8LFbpH2HaO2MwyY37uoxqaf5iLst2fVlU5LWOD2lpVLO9nWNS49fzyT2smJHP0LbhUan39mGJlRc89P3PeonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308716; c=relaxed/simple;
	bh=WtQYskxsRi4iWpV8/1qNy80kZt4WoqHcnDJsBsA3JyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WtJnP93+z3vfz8mkrMn2CeJR/0CG2Aiy/gUvyM4os82fAWCL5POazgSrUfPkRSYzYnj+oMUPInxF5zf5u0okfKBVuY/0zycNHgLg5DsZ4DoH7/wbpYo0DOXy+a8BEwGQk0UsFtt85pXtkH8wMueZanKZGTAW7pd53u3mG/0OCYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss6Jtpkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss6Jtpkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6941DC32781;
	Tue, 25 Jun 2024 09:45:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308715;
	bh=WtQYskxsRi4iWpV8/1qNy80kZt4WoqHcnDJsBsA3JyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss6JtpkhBI2bHgjZe0rC1hKZJYVvBIhVp6FoY4UeFJVdfdH0u+J3viynwLxvXHAWh
	 6l35iKDoeD8aMc1WlzZPPtjuuFs3bhkJWkf3aFSzjQrNasqwmq73QKlZbCCYtzm2LH
	 nSO/L6dLgLNYZPp5wCUZxz/LsU7+vdOiqolFXudk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis Chauvet <louis.chauvet@bootlin.com>,
	Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 6.9 215/250] dmaengine: xilinx: xdma: Fix data synchronisation in xdma_channel_isr()
Date: Tue, 25 Jun 2024 11:32:53 +0200
Message-ID: <20240625085556.306726329@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

From: Louis Chauvet <louis.chauvet@bootlin.com>

commit 462237d2d93fc9e9221d1cf9f773954d27da83c0 upstream.

Requests the vchan lock before using xdma->stop_request.

Fixes: 6a40fb824596 ("dmaengine: xilinx: xdma: Fix synchronization issue")
Cc: stable@vger.kernel.org
Signed-off-by: Louis Chauvet <louis.chauvet@bootlin.com>
Link: https://lore.kernel.org/r/20240607-xdma-fixes-v2-1-0282319ce345@bootlin.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/xilinx/xdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/dma/xilinx/xdma.c b/drivers/dma/xilinx/xdma.c
index e143a7330816..718842fdaf98 100644
--- a/drivers/dma/xilinx/xdma.c
+++ b/drivers/dma/xilinx/xdma.c
@@ -885,11 +885,11 @@ static irqreturn_t xdma_channel_isr(int irq, void *dev_id)
 	u32 st;
 	bool repeat_tx;
 
+	spin_lock(&xchan->vchan.lock);
+
 	if (xchan->stop_requested)
 		complete(&xchan->last_interrupt);
 
-	spin_lock(&xchan->vchan.lock);
-
 	/* get submitted request */
 	vd = vchan_next_desc(&xchan->vchan);
 	if (!vd)
-- 
2.45.2



