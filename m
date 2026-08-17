Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F395175A6B;
	Mon, 17 Aug 2026 15:03:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978993; cv=none; b=jVzZPPy03o//BvkoX5VrDWg3eSyIPP2h1PYo5vyR2ynmZMLGMth8vjogP6DMu0FH7T18wu16s4N9FRYNv3ef9YTeV56aD7SZIAK2tIxS239uz4X/Q6JT2tH3e7ba7vboTU9/OODrMFzyUHkvKpA98T2R2jjuYMfg3HZRwnaH4Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978993; c=relaxed/simple;
	bh=MY5Vp7BDiLwcw5rW10RuzBvzlzhpf++Lc/ud9t0gYic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrebCzeI0LpqUj/bTm0vydMJ8TqBb5fC7KovQA4cPlvF8kYZFH7Ws3acJIehKDFXTfAwaTwJYM9v5tmxJGKlUbenbDrky+mmv/pJ5JiUun3HuvcHqWLu6yq+d+B4mq1Og2tOiynak98R6B6SmU2SOFCDx42YkSN0jSsfBO01L8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9PyGBbO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9PyGBbO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DAA1F000E9;
	Mon, 17 Aug 2026 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978992;
	bh=RRFCXYYTixELW3btpSobJ9joxJNwg5N7RFyEZtkEdww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=i9PyGBbOZm8te0pe5nbHw5sNF0taJ8RwWF3aM/HJCBsUWbM3B+tUrMwsfhdXyhyOc
	 CzPbgX8owS1EGLshv+ngk4YbF+6PTGou8F4jq8Lm4OjymAMuhx/I6fXSMSWVU7hf4N
	 2pcGd+Qtp2Ts0HXyWFQ8cV+OUP83N7pJBk+59SxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Gerlitz <ogerlitz@ddn.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/609] RDMA/cma: Fix hardware address comparison length in netevent callback
Date: Mon, 17 Aug 2026 15:25:27 +0200
Message-ID: <20260817132544.295784693@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

From: Or Gerlitz <ogerlitz@ddn.com>

[ Upstream commit 18313833e2c6de222a4f6c072da759d0d5888528 ]

The cited commit hardcoded the hardware address comparison len to ETH_ALEN.

This breaks IPoIB, which uses 20-byte addresses. By truncating the
memcmp, the CMA may incorrectly assume the target address is
unchanged and fails to abort the stalled connection.

Fix this by replacing ETH_ALEN with the dynamic neigh->dev->addr_len
to correctly evaluate the full address regardless of the link layer.

Fixes: 925d046e7e52 ("RDMA/core: Add a netevent notifier to cma")
Signed-off-by: Or Gerlitz <ogerlitz@ddn.com>
Link: https://patch.msgid.link/20260617-fix-cma-ipoib-v1-1-03f869344304@ddn.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b5924919e7f06f..e7827352409026 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -5190,7 +5190,7 @@ static int cma_netevent_callback(struct notifier_block *self,
 
 	list_for_each_entry(current_id, &ips_node->id_list, id_list_entry) {
 		if (!memcmp(current_id->id.route.addr.dev_addr.dst_dev_addr,
-			   neigh->ha, ETH_ALEN))
+			   neigh->ha, neigh->dev->addr_len))
 			continue;
 		cma_id_get(current_id);
 		if (!queue_work(cma_wq, &current_id->id.net_work))
-- 
2.53.0



