Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AFF3AE198;
	Wed, 23 Sep 2026 14:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790174255; cv=none; b=WgXxdpf/GnPlPsAIAlBWz6+OVNh+sTiq+h61UUVILG0E1mZOWdVJqeyxNAD7tENL+0+eIEyAl9311uURNpDB5mg1rOc1vbTIP5UdPzii5n9/eTTCc9WozQ2+Alj4C6DUVbD8jeXmSpci9fS+QtqIi7vciVhUYk6d+Ixv96XQKyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790174255; c=relaxed/simple;
	bh=BJMlksyTfO0OaTWqF+LfL1Oruy/Z1iHJDVI7eTOSOsg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZCWGyihbpdO9C+NRdUc31+vpNwraQGJ5nqFsXR6A2LFBs1BnTQEQnaTZpzHGw7GbmDOlRx9mZ2sJ06ih/sxtHAbEGekwhFbyJlwSam3Rl8MtvJ4GHD/XgM6tbJkyZC5u65ta6Hok/p5VIIC1jMN/feJdLHYQvbWpX+Jbb/3s6l0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NApEKTVe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NApEKTVe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0981F000FF;
	Wed, 23 Sep 2026 14:37:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790174253;
	bh=YIGQIH5R2htSGQxwzEywQMdgYsgrNimSw9EYHQCjeyk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NApEKTVeWbUcRr7pf8f7KdUEWLF6KDSzT9PR604cQEzS7x589OV9NQ1D+ZDvDljV4
	 vs6v+GCNd1iO7DdiOYFiOnw3rF084VEcF+L/SWSFMWSjWgY8w+MI9hE8CkN465b0zc
	 2nFKuuBCGno22W2hW8dwEp1wsxfYHADvZaYA10aQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Shivank Garg <shivankg@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 056/398] dmaengine: Fix device kref underflow in dma_chan_put()
Date: Wed, 23 Sep 2026 16:02:10 +0200
Message-ID: <20260923140644.876010401@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260923140643.441954610@linuxfoundation.org>
References: <20260923140643.441954610@linuxfoundation.org>
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

From: Shivank Garg <shivankg@amd.com>

[ Upstream commit 44dab659064eb5c10adb0306510eebe848ed592d ]

dma_chan_get() takes chan->device->ref only on the slow path:

	/* no kref on fast path */
	if (chan->client_count) {
		__module_get(owner);
		chan->client_count++;
		return 0;
	}
	if (!try_module_get(owner))
		return -ENODEV;
	if (!dma_device_get(chan->device)) { // calls kref_get_unless_zero()

dma_chan_put() drops the ref unconditionally, so every fast-path
get/put pair drops one extra device reference.

The bug fires when two conditions hold together: a non-private
provider has a persistent client holding chan->client_count > 0
and another client cycles dmaengine_get()/dmaengine_put().
When the kref hits zero, the subsequent dma_find_channel() returns
NULL even though the provider module is still loaded.

Fix this by dropping device->ref only on the last put, matching the
single slow-path get.

Fixes: 8ad342a86359 ("dmaengine: Add reference counting to dma_device struct")
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
Signed-off-by: Shivank Garg <shivankg@amd.com>
Link: https://patch.msgid.link/20260822-dmaengine-kref-fix-v5-2-d4a4ee47d927@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/dmaengine.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index e6d9d338a60a8..07eb4a7437c3c 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -515,7 +515,9 @@ static void dma_chan_put(struct dma_chan *chan)
 		chan->route_data = NULL;
 	}
 
-	dma_device_put(chan->device);
+	/* This channel is not in use anymore, drop the device ref */
+	if (!chan->client_count)
+		dma_device_put(chan->device);
 	module_put(dma_chan_to_owner(chan));
 }
 
-- 
2.53.0



