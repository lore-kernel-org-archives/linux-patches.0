Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC5945013AB;
	Wed, 30 Sep 2026 15:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783390; cv=none; b=tOMMM4XHSwpaA2RlfANL44v9gyGNPHy9hz2AnS+xB8ZamJDAvNFzXC40239ilhbizbdZmaxsavMfQC2ox+9tHxE/yMbiwHRKOsevigLhfeev+fLw4YSiXMR4fq2tlpyJoFRpTSl+dQD/xaDpcEUs/bGGXQ58gt/KyXo7ibfgRpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783390; c=relaxed/simple;
	bh=6fvwf/vYEG5E6KtFv+pGgm6JxTU+50HuX2oIUfPaYKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3w2TrWPNG03+nOxaJa0vnsVIie8pu8Vfn0/A5VNJ3lQ3n15l8VQ8AKaQ1NTOTVU/MhzRrVYUY6vT+rlSGFdAJ0fTsmGj5cDAnQCFt/KgyalFPTfumnNimG3jrFindmN8sqiBhr5O2qIMfLa8JetX2RV/j3wZRRFtKFVO9Xiiz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G6RN3ffc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G6RN3ffc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C5371F00893;
	Wed, 30 Sep 2026 15:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783384;
	bh=oYCSXAOoIuWBzYzbLs9SvjkE64jzZqWlYt0i/kJaPNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G6RN3ffciLoZixFfmxkNzHsAXNIiyt/pxpy7xqHSPYFRGttVcOk8o90qOXlsn2dek
	 MebRbFEp4AdWPBZI88320C9pChIvENb7ByHkvBXWa6JHh8DH3DPTP6v41N1xGxLY+e
	 GvwNKVrFcJUOh2auAOPsFYSi07jbfHfFDQCVUemk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Shivank Garg <shivankg@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 380/595] dmaengine: fix use-after-free in dma_chan_put() and dma_release_channel()
Date: Wed, 30 Sep 2026 17:24:33 +0200
Message-ID: <20260930152355.851065357@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit e873c74132f0c5f1452816cd9bb26208f0bba1e1 ]

When dma_device_put() drops the last reference on chan->device->ref,
dma_device_release() runs and may free the dma_device along with its
channels.

dma_chan_put() then still reads chan->device->owner via
dma_chan_to_owner() for the trailing module_put(). KASAN catches it:

	slab-use-after-free in dma_chan_put+0x3e6/0x4c0
	Read of size 8 by task insmod/6319
	Freed by task 6319:
	  kfree+0x225/0x470
	  dma_chan_put+0x395/0x4c0
	  dmaengine_put+0xf8/0x160

Cache the module owner in dma_chan_put() before the put so the trailing
module_put() does not need chan->device.

Fixes: 8ad342a86359 ("dmaengine: Add reference counting to dma_device struct")
Suggested-by: Sashiko <sashiko-bot@kernel.org>
Link: https://sashiko.dev/#/patchset/20260518-dmaengine-kref-fix-v1-1-4d6125048fb7@amd.com
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Link: https://patch.msgid.link/20260822-dmaengine-kref-fix-v5-3-d4a4ee47d927@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index 7eb3ec8323ccc..ae4121a26c651 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -493,10 +493,13 @@ static int dma_chan_get(struct dma_chan *chan)
  */
 static void dma_chan_put(struct dma_chan *chan)
 {
+	struct module *owner;
+
 	/* This channel is not in use, bail out */
 	if (!chan->client_count)
 		return;
 
+	owner = dma_chan_to_owner(chan);
 	chan->client_count--;
 
 	/* This channel is not in use anymore, free it */
@@ -516,7 +519,7 @@ static void dma_chan_put(struct dma_chan *chan)
 	/* This channel is not in use anymore, drop the device ref */
 	if (!chan->client_count)
 		dma_device_put(chan->device);
-	module_put(dma_chan_to_owner(chan));
+	module_put(owner);
 }
 
 enum dma_status dma_sync_wait(struct dma_chan *chan, dma_cookie_t cookie)
-- 
2.53.0



