Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35A81A6192;
	Tue, 30 Jul 2024 16:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722357539; cv=none; b=Gzi6Tw47aRI4fwhHGH9Rld7lzS9mG36zwrOnX4/Wdit3Prv0UoHLfMqrWb8zacJepFnf/z9NE7WZyGrB4QeS6FoL2JLEpDm0G633pRSTGcsNU7O+N+wGJK1HjMPNTnR15+7JACH7mXw7fhgCI15wajz7eA7LA014jEkjsta3/7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722357539; c=relaxed/simple;
	bh=L6VhuMIqd5OQXNFX5C+xGQY7oyq+nFHqIYlpxD1Kyj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NG7H51lW/yexgT+FAmVl5h2+b6t028OtgrG2hYfkY0pxUfGCop+d9s1yk4mMokMP08NBtXgmcy5UnUiPGN2t2BKtQz6GeS50gbJePIOVQrNqamJY9ur5C5dgvEp/fUmQ0fwKmKp7RWZD05qbQilsZ0bAzPYn20dzPQNP7PAzv5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dqP7ICBv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dqP7ICBv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7702CC4AF0F;
	Tue, 30 Jul 2024 16:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722357538;
	bh=L6VhuMIqd5OQXNFX5C+xGQY7oyq+nFHqIYlpxD1Kyj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dqP7ICBv+jPwOd8aHjB9RaVxBKDVfYmyNQtXYBGi7OpNDA1QvAaHQnAf7o9Nt7wV3
	 Mh4UjGc0ErvIFVg3wCjrul4HkrFN82AMYL0HZ1El/ivtEelfL5W9ePqrY61Gfj4+n+
	 YuhwXnsXMOmu+fdL7wkjDN87rR3IVLd46Wtbt/eY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 264/568] RDMA/cache: Release GID table even if leak is detected
Date: Tue, 30 Jul 2024 17:46:11 +0200
Message-ID: <20240730151650.193864820@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
References: <20240730151639.792277039@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 7acc0f936dad3..b7251ed7a8dfb 100644
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



