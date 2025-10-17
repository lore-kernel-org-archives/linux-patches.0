Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CE82F6932;
	Fri, 17 Oct 2025 15:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760713217; cv=none; b=epAMAbiFWatQvaYLIBHmpspn/O8GIUjR70q2UFMVI5Tep1oMPLTJsayAXYC3tBKHiv61EpyKUODXMkcL6MqRM7D8waYiV3FvgakdMANlWThn3yVXm3OqVHn6bkFOJ1Su8vIpIsyA+UQKk2w2AgWk4yTcE/6o75scD8ww9Voi5CM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760713217; c=relaxed/simple;
	bh=AtY7liOqmfkX+sWkW3oNqSn8sUZVuoYgIFzdrAbODis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aHGginq9AwWnU/UzqaAoSPUaegE9scNrWYXxcbZNhKsPg/zjvrjkmii125vUYUjBs5FN3/Zyr3gRxRHgb1DAF1wt12VJLzo3TrZri7IQR1soxMw89d4dbx6u8sB56DU/izr2JH5R8KYLLIdZlO3ORXIOySy61QkNAfUFVRKZMlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK4mJ0X5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK4mJ0X5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428B0C4CEE7;
	Fri, 17 Oct 2025 15:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760713217;
	bh=AtY7liOqmfkX+sWkW3oNqSn8sUZVuoYgIFzdrAbODis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK4mJ0X5FD2GUcHC0D/e1XQ2lLGW6URA1FEWi9gUwAu5Kd2yL1d3BNyF5tSeClEYu
	 gVTqDD1CcsY0oLkAdzPpgw3cxkNwaTDo+oXskTtR0+fKVn0ubfjL5Y+MXFwWxNnFGo
	 Auhyg/wbwGSWEARYwpTlwJ5Oov/5X1TNSXBUO+Ng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Vladimir Zapolskiy <vz@mleia.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 087/168] lib/genalloc: fix device leak in of_gen_pool_get()
Date: Fri, 17 Oct 2025 16:52:46 +0200
Message-ID: <20251017145132.230994374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
References: <20251017145129.000176255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 1260cbcffa608219fc9188a6cbe9c45a300ef8b5 upstream.

Make sure to drop the reference taken when looking up the genpool platform
device in of_gen_pool_get() before returning the pool.

Note that holding a reference to a device does typically not prevent its
devres managed resources from being released so there is no point in
keeping the reference.

Link: https://lkml.kernel.org/r/20250924080207.18006-1-johan@kernel.org
Fixes: 9375db07adea ("genalloc: add devres support, allow to find a managed pool by device")
Signed-off-by: Johan Hovold <johan@kernel.org>
Cc: Philipp Zabel <p.zabel@pengutronix.de>
Cc: Vladimir Zapolskiy <vz@mleia.com>
Cc: <stable@vger.kernel.org>	[3.10+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/genalloc.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -899,8 +899,11 @@ struct gen_pool *of_gen_pool_get(struct
 		if (!name)
 			name = np_pool->name;
 	}
-	if (pdev)
+	if (pdev) {
 		pool = gen_pool_get(&pdev->dev, name);
+		put_device(&pdev->dev);
+	}
+
 	of_node_put(np_pool);
 
 	return pool;


