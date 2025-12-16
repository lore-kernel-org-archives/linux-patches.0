Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FF2E342CB2;
	Tue, 16 Dec 2025 11:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884978; cv=none; b=m5xAphnJMjRhCWMdYYZ4EVIZGm4BfZzAgsFuqigOaV/qNMdvLXBDqHfNLkPc2drLBVmeWf4JKzWR97gAm/hf6e7CfuN2L9k4LDS4EG6mb0w25uNVLYYY+fpa3KjgM4BAJTsbEjZ3SZI7GB2C2t3Zx/GrvWmG5qpyw2dtxfvMKsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884978; c=relaxed/simple;
	bh=j1H1P8JMwnbc9zL2mPswzspQNFrAGEh8PAEugZoQEDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h2L8OpHzvBoGEDn7FiQ3lGsJHKO4m9nJEjg11PTBUTlqGFiXrRb1kc4Rsl09f9iLsBkAkg6TMboWYVZM+Sfk2n6vNQJtIlvRmNcdbcV5fyifNztfiTOwojVgEkTYCGBUvpOdNoEHJjgZStGIRvOxn/+2mAbxJy9lsCkNOOQDr60=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SoRvuMzo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SoRvuMzo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8368C4CEF1;
	Tue, 16 Dec 2025 11:36:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884978;
	bh=j1H1P8JMwnbc9zL2mPswzspQNFrAGEh8PAEugZoQEDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SoRvuMzodqKYXq2ZlDmoeKQgKT8mNg5vfY4FuFJiHZHZN0+zDdEMyjShL9FzKs/05
	 YdEi/bWXVEBQgGptAPTyO94In28MDuPZ5FYwiW/QqX9ps+JOGThBLTKcR9TIUE66Yd
	 jLjBCGqoljJIDctxUEMl7pH6PFgs4+DWlG4a255E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Israel Rukshin <israelr@nvidia.com>,
	Max Gurtovoy <mgurtovoy@nvidia.com>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 323/354] nvme-auth: use kvfree() for memory allocated with kvcalloc()
Date: Tue, 16 Dec 2025 12:14:50 +0100
Message-ID: <20251216111332.612250615@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
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

From: Israel Rukshin <israelr@nvidia.com>

[ Upstream commit bb9f4cca7c031de6f0e85f7ba24abf0172829f85 ]

Memory allocated by kvcalloc() may come from vmalloc or kmalloc,
so use kvfree() instead of kfree() for proper deallocation.

Fixes: aa36d711e945 ("nvme-auth: convert dhchap_auth_list to an array")
Signed-off-by: Israel Rukshin <israelr@nvidia.com>
Reviewed-by: Max Gurtovoy <mgurtovoy@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/auth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/auth.c b/drivers/nvme/host/auth.c
index 5ea0e21709da3..c2fb22bf6846e 100644
--- a/drivers/nvme/host/auth.c
+++ b/drivers/nvme/host/auth.c
@@ -994,7 +994,7 @@ void nvme_auth_free(struct nvme_ctrl *ctrl)
 	if (ctrl->dhchap_ctxs) {
 		for (i = 0; i < ctrl_max_dhchaps(ctrl); i++)
 			nvme_auth_free_dhchap(&ctrl->dhchap_ctxs[i]);
-		kfree(ctrl->dhchap_ctxs);
+		kvfree(ctrl->dhchap_ctxs);
 	}
 	if (ctrl->host_key) {
 		nvme_auth_free_key(ctrl->host_key);
-- 
2.51.0



