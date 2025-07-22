Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A0CB2EA140;
	Tue, 22 Jul 2025 14:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192919; cv=none; b=rtZ0YnTwVJJGmf09w1JM7fr6R2Y5I2XHyZXk0mcLqTnCORreAmKxehv3ye275Huc7OuqZHKRnnwM0JZhMGqbShPzkDfLO95H/BTt44ZbJ9lzfe2ux2fNAVBpRUo1oNGZyOZMV/pafRyIFjAGnP8h+YDDmzA9f5k8ekQsQPFsXXc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192919; c=relaxed/simple;
	bh=DOMmhkmk/LwxDOIu6xtrfJkXM1x0H5XPyunchhfOdX8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nMlEurX/kKnnMExcB821ob5iE2gkSM+lyLcEdRkxk5J9xN4e6D179KfvJ5eVnXZYDFh1jLx1reLls25r7QIlzZkJheBSW3SI9svc3ldqCVyqeonslVlhiqERWXVJnWb19a65jpYue2wUQa3UjKXfm6io1TZqH8kEdO1rx7dB7eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JprOyn4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JprOyn4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D525BC4CEF6;
	Tue, 22 Jul 2025 14:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192919;
	bh=DOMmhkmk/LwxDOIu6xtrfJkXM1x0H5XPyunchhfOdX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JprOyn4oOGQhlFtZs1mH9VuxcpcNoBVYkKr2FDLmoiNV/YvQb5VjAnZHFMDk15nUz
	 bTAByTQcI8GjGuGoq2VYDoQUhHIaYOH+QXd9I8f1JTbfA11zrem5p9rpPJFQhaGUGO
	 FkGPl44INkgJeUpypuz+QaZ7aXRMmQ5DAw/hLujY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zheng Qixing <zhengqixing@huawei.com>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 096/158] nvme: fix inconsistent RCU list manipulation in nvme_ns_add_to_ctrl_list()
Date: Tue, 22 Jul 2025 15:44:40 +0200
Message-ID: <20250722134344.340290366@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 80d7762e0a42307ee31b21f090e21349b98c14f6 ]

When inserting a namespace into the controller's namespace list, the
function uses list_add_rcu() when the namespace is inserted in the middle
of the list, but falls back to a regular list_add() when adding at the
head of the list.

This inconsistency could lead to race conditions during concurrent
access, as users might observe a partially updated list. Fix this by
consistently using list_add_rcu() in both code paths to ensure proper
RCU protection throughout the entire function.

Fixes: be647e2c76b2 ("nvme: use srcu for iterating namespace list")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index abd42598fc78b..2ca14f2b7a0b1 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -3854,7 +3854,7 @@ static void nvme_ns_add_to_ctrl_list(struct nvme_ns *ns)
 			return;
 		}
 	}
-	list_add(&ns->list, &ns->ctrl->namespaces);
+	list_add_rcu(&ns->list, &ns->ctrl->namespaces);
 }
 
 static void nvme_alloc_ns(struct nvme_ctrl *ctrl, struct nvme_ns_info *info)
-- 
2.39.5



