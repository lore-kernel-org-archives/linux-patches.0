Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 028D149738E;
	Fri,  9 Oct 2026 14:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555466; cv=none; b=noVg8FmC67cpj1SnqCA1TgM5xOQZM0ws/0hpoL23NJ7pV/9ZnDV+Q+4ZcSErzOCqKEliCPE4CWx3L0bkgq9rWWw6WYpTC9IRWVAjVO0nUcHSE9KY4Gcgkw6O05kRpL4Jw9SWwnLlQCAENVch9KpUJlK9f2ldvw2ecZcHEXdXwyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555466; c=relaxed/simple;
	bh=K1COrqzTp1cOvUlwUNHDHIHzNgBo7XhkGnHWpKViEso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HISfBIdFpHMhfI3b9qqrOKFbnsbeTTEZqHvKdnqMLzDIK5DQFeCNBlUkU+RNQE/mk3gV/X3nhFKtrhdl/KwNbaQKX14MBYU2+H7mg+J3RAVyM8gFToTc3i39GfnOtUrZnGWVIFv3n1bgfzd23DK0wg5xkkxLdRuAep746zAJAGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tz9/mSt/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tz9/mSt/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2F91F00898;
	Fri,  9 Oct 2026 14:17:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555457;
	bh=3WFqh0zYevrfY4pq5JjqlPVxdBXDE/nuN03jNnabTj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tz9/mSt/5qAbMVDmxK0LUCS9/tD//nGqjGMQ3lejP7znVOUX4koKi5XA9aGYV8Mvg
	 B6u2rrHE11mFAtlqPA+HyJDKoWZNSAgoGfP3jpp0lJvFISUUXyi2RRcJZF3DTuPAfq
	 wVcWRLy30ojrMa8l9MIdR5MgdUg/uCfXG6cx2rr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 061/403] nvmet: preserve device path on allocation failure
Date: Fri,  9 Oct 2026 16:07:02 +0200
Message-ID: <20261009140953.524988222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Julian Sun <sunjunchao@bytedance.com>

[ Upstream commit 2f271b812170d4cad578bae1f91db72f3c2e36e7 ]

nvmet_ns_device_path_store() frees the old path before allocating its
replacement, losing the existing configuration if allocation fails.
Allocate the new path before freeing the old one.

Fixes: a07b4970f464 ("nvmet: add a generic NVMe target")
Signed-off-by: Julian Sun <sunjunchao@bytedance.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/configfs.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/target/configfs.c b/drivers/nvme/target/configfs.c
index e44ef69dffc24..f6ac42eaac0e0 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -507,6 +507,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -518,12 +519,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	if (!len)
 		goto out_unlock;
 
-	kfree(ns->device_path);
 	ret = -ENOMEM;
-	ns->device_path = kmemdup_nul(page, len, GFP_KERNEL);
-	if (!ns->device_path)
+	new_path = kmemdup_nul(page, len, GFP_KERNEL);
+	if (!new_path)
 		goto out_unlock;
 
+	kfree(ns->device_path);
+	ns->device_path = new_path;
+
 	mutex_unlock(&subsys->lock);
 	return count;
 
-- 
2.53.0



