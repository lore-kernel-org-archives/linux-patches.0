Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523962494F0;
	Wed,  8 Apr 2026 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672317; cv=none; b=SYANK68htsvdKn7AMKnt0BwhkT9i9X9TsPFyBLPqIELjKtSBvFqyM52SO+Whr32NDvwIOw2kEhkvjKiSYgP0FfMnVHqi1WdgTDM9TaZxMWGyJUCJ6Xu96jF8flMyOunaUgqdASdBpdEDKZlAg7T21Mqec383FlZ6XeTgVeQJVJ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672317; c=relaxed/simple;
	bh=X/ih7MG/dZHaK0uHj1rSovLa2kdYYPD8eNvwgsAE4aM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ivP1sr83CjLD6K7ggoFn8gs2CEqq6TNryIjHBN66fZfleSFZX0e3UlIC5u+N0wn1NVzK6zTHz7LB8bADxWeiv1ERoE/+IjTZSzZCRj3dYBIg8TcwEg2cI3zCM7uWVlgw+R1atc87TY9wvc1ljgzo6r7us1Uvim6qvaL6XQUgWt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRx3+ddu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRx3+ddu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC9C0C19421;
	Wed,  8 Apr 2026 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672317;
	bh=X/ih7MG/dZHaK0uHj1rSovLa2kdYYPD8eNvwgsAE4aM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRx3+dduvKD1fPeZCIxQ2NlOTWdTI3o5dEohOXTJ8EYnfFemsTFVzcqIxAJecHKnH
	 v4kkrKTvDFGPB899KG3RjRB24AXD6yKZKeV4AppQyCKApOo85uJYuUEMOMHf6u3TzT
	 Hg3oXEQN1FJBRYnxvDL56UUWEgpTp1tHBF1V6Spg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org,
	"stable@vger.kernel.org, Zheng Qixing" <zhengqixing@huawei.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Yu Kuai <yukuai3@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Robert Garcia <rob_garcia@163.com>
Subject: [PATCH 6.1 274/312] block: fix resource leak in blk_register_queue() error path
Date: Wed,  8 Apr 2026 20:03:11 +0200
Message-ID: <20260408175943.981137531@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

From: Zheng Qixing <zhengqixing@huawei.com>

[ Upstream commit 40f2eb9b531475dd01b683fdaf61ca3cfd03a51e ]

When registering a queue fails after blk_mq_sysfs_register() is
successful but the function later encounters an error, we need
to clean up the blk_mq_sysfs resources.

Add the missing blk_mq_sysfs_unregister() call in the error path
to properly clean up these resources and prevent a memory leak.

Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Yu Kuai <yukuai3@huawei.com>
Link: https://lore.kernel.org/r/20250412092554.475218-1-zhengqixing@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
[ Minor context change fixed. ]
Signed-off-by: Robert Garcia <rob_garcia@163.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 block/blk-sysfs.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -867,6 +867,8 @@ put_dev:
 	elv_unregister_queue(q);
 	disk_unregister_independent_access_ranges(disk);
 	mutex_unlock(&q->sysfs_lock);
+	if (queue_is_mq(q))
+		blk_mq_sysfs_unregister(disk);
 	mutex_unlock(&q->sysfs_dir_lock);
 	kobject_del(&q->kobj);
 


