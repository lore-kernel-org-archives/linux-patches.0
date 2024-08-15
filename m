Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CC36176ADE;
	Thu, 15 Aug 2024 13:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729529; cv=none; b=XOCE+JWNJhT/J1OqUucjyFqWnGuJy6rHM5HURSKQkltdYXtlGDmO9GEjgYkBgJfYL+ed/wmWD5LQHF/sTZhuJY3lfc0onjeZPqkuWy1W0p3CWfzP6rkj0cdfPhpXj0cbhQ9e4XC3588S0hGj0m4DF2OEfyrV3IxN1STwffLytyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729529; c=relaxed/simple;
	bh=tmk5wGkCrriL3kFo1khWJ8HCPMOZblz75aYtLNYR61o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hwxkkt1fgxZCgHHkeA/HgdyRLY1UAr8XjrDWa3sQBkOACLDarLipbJxirX2ro/xWza6yomBoCTxhL/grcgJ7NQuJPS+Sd2udJrgAFZBNWZ3EIKcOz7SDzoQyHd6lkSjVnA860c5ICJ61g65pO+iItXzYpgXnljicn73aEVXUEwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZdWIb++k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZdWIb++k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFA18C32786;
	Thu, 15 Aug 2024 13:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729529;
	bh=tmk5wGkCrriL3kFo1khWJ8HCPMOZblz75aYtLNYR61o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZdWIb++kh173Y5HQjKx+JZytxX5pHZAIGvQmkT7B0ejm5NaIBZBDGH0qQ2y6wYj4u
	 cnVV174xy7uxnc7uFbDTI61Hg0LiwY3HCKe+Z6VhtW13GFPR6b4/WGZmmd4kzT6554
	 seqbNtuLE9Ot73AFHO/J6A74yttG3VHsknK2UkJ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 125/484] RDMA/cache: Release GID table even if leak is detected
Date: Thu, 15 Aug 2024 15:19:43 +0200
Message-ID: <20240815131946.127781910@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit a92fbeac7e94a420b55570c10fe1b90e64da4025 ]

When the table is released, we nullify pointer to GID table, it means
that in case GID entry leak is detected, we will leak table too.

Delete code that prevents table destruction.

Fixes: b150c3862d21 ("IB/core: Introduce GID entry reference counts")
Link: https://lore.kernel.org/r/a62560af06ba82c88ef9194982bfa63d14768ff9.1716900410.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/core/cache.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/infiniband/core/cache.c b/drivers/infiniband/core/cache.c
index 0c98dd3dee678..98f3d8b382c15 100644
--- a/drivers/infiniband/core/cache.c
+++ b/drivers/infiniband/core/cache.c
@@ -794,7 +794,6 @@ static struct ib_gid_table *alloc_gid_table(int sz)
 static void release_gid_table(struct ib_device *device,
 			      struct ib_gid_table *table)
 {
-	bool leak = false;
 	int i;
 
 	if (!table)
@@ -803,15 +802,12 @@ static void release_gid_table(struct ib_device *device,
 	for (i = 0; i < table->sz; i++) {
 		if (is_gid_entry_free(table->data_vec[i]))
 			continue;
-		if (kref_read(&table->data_vec[i]->kref) > 1) {
-			dev_err(&device->dev,
-				"GID entry ref leak for index %d ref=%u\n", i,
-				kref_read(&table->data_vec[i]->kref));
-			leak = true;
-		}
+
+		WARN_ONCE(true,
+			  "GID entry ref leak for dev %s index %d ref=%u\n",
+			  dev_name(&device->dev), i,
+			  kref_read(&table->data_vec[i]->kref));
 	}
-	if (leak)
-		return;
 
 	mutex_destroy(&table->lock);
 	kfree(table->data_vec);
-- 
2.43.0



