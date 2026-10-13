Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E68A54F85CD;
	Tue, 13 Oct 2026 12:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894763; cv=none; b=KVVdCDaxlOa9fbSOLgdXdYj716oPFk3LNGqY7EDWrDtNqJwWhC6AC5ZVsiGeJpAJHFYurZ0+qpx8otG7EloEVuNnP0v2U44tHk21FXBHHUWo6/ctTMRrm0N0sg7Rm+y0g4j8IQG9HcX1NlQrPbJrh7SzPpChSrXel1c2DkCzasc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894763; c=relaxed/simple;
	bh=hQA9/Sntf7z/9TImNkwTc58JpRIY0hRpclgLgwlaU2A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n1j2LydIfGdaZ/BlAih1IJwvZH5qvR7TcIPGuNpRwsoteqN0MzMuxP9WV7UQ2KsFQ1DCZFlzk5hZuiHF2LizpC7HIcEgxjv3TsRcOr4ow2aXt7kvOlD2Rhn5hlkHHDkL9rU9mAXmsLiznBzmJBbtj/oTPFWNFT0ZdO6XM1ErovQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NAOTtaLy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NAOTtaLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8D21F000FF;
	Tue, 13 Oct 2026 12:32:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894762;
	bh=W9rcVIu6tFM9UYNCLZu4WnGU2O7MhA96xW8wpzrJRmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NAOTtaLyqogjoe9DX7L0+bWLRYy2qFC1isRKkTdY4rcu5SImF/sDokt4HQTWtgAel
	 hcRoXCAe0au43kaVLHCTXMPSoovDeZHaLc7dRBspO2SVCfDeZfWIxLVm2tRV5it2RD
	 bym/kUxSK8aHGPrijSLETbn4aXUDtZLS+W379YvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Julian Sun <sunjunchao@bytedance.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/497] nvmet: preserve device path on allocation failure
Date: Tue, 13 Oct 2026 13:33:36 +0200
Message-ID: <20261013112909.052196380@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index cfbab198693b0..1bec5dc7fc452 100644
--- a/drivers/nvme/target/configfs.c
+++ b/drivers/nvme/target/configfs.c
@@ -505,6 +505,7 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
 	struct nvmet_subsys *subsys = ns->subsys;
 	size_t len;
 	int ret;
+	char *new_path = NULL;
 
 	mutex_lock(&subsys->lock);
 	ret = -EBUSY;
@@ -516,12 +517,14 @@ static ssize_t nvmet_ns_device_path_store(struct config_item *item,
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



