Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6926A50C28B;
	Wed, 30 Sep 2026 18:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790791912; cv=none; b=JtokWclR3FGzEBrxLGHTVUD4iduOYgoZ1l2597tOGYK6r5VObYvqrI/oYqL2mm9oUSDPE154Iux1h2RGC343ybY++0/8QDm4CPff2xgvepZZ/OgI2Z/5//M4ESp/c66dxrFWRbq0Z4yFgElFP92//TpVgzwJl4bS90A7nELg+2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790791912; c=relaxed/simple;
	bh=sWkRx2mdguSwtwT1RJoD1A0fP0QfLXfDeXCVSzLqT6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RhJHTCC8id4OPwS9m5y/MDgeeQWvuyn78DSlLnv/KQ7+XAWE5JBcRKfCIJxX6xXGYylDfOndLJL7fP9sYej5iJyPFWMgOT7bv72kXk3A0XWkPGoeBdn1sx1c/y97pXtDPlHUYZBwiWAwoRyUNynQUj1nEfpJ5/GEYZBijp4EgWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EXrJ6l6V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EXrJ6l6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D7451F000FF;
	Wed, 30 Sep 2026 18:11:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790791911;
	bh=/fc79w0b0XUa/BXd529OLnaBpcyuGlYWt0eVnS5RB+A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EXrJ6l6VZ65sM6nfV24ezEpHKdIGFbKzougQEQJxtZLkdoFVdMz+2Wb5T1dCTueKt
	 9p11p6UeTD53GoO9OhmyMlgfUlpr3hfuAjgB/+9NgXQZAHDWzX6mwbTybudBQm1Jh8
	 oLxQ1UzGrn7C7tWt6XZq/Rh6BhcER9ji6TN7Q180=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Shivank Garg <shivankg@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 470/752] dmaengine: Fix device kref underflow in dma_chan_put()
Date: Wed, 30 Sep 2026 17:25:40 +0200
Message-ID: <20260930152408.443825950@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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
index 68078e83d5756..7eb3ec8323ccc 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -513,7 +513,9 @@ static void dma_chan_put(struct dma_chan *chan)
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



