Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 963FB35F602;
	Sat, 12 Sep 2026 09:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203806; cv=none; b=I3ShseN3Hz6pSZi/b7Cm2IovSUVFgZYj/DcDoSk2LqN5aZO11gReypZZ2lh+kxS5kp530DRzlLlRnE4VLHNMI39ndw5WgqkrADp6dLSVWo380lVk7039AMQjIcWb/PSf+M7zk0uXNOeM8K42/2YMR/gGu8YW89OC8AhXxAp8a+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203806; c=relaxed/simple;
	bh=moL+AMXBuCrQqHBgF17lGja9JF4Ry7zdmqi1jBjCioo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WLS3/O0DrL8O6D0cwIqn7y9kW6N0zlTvuIF9j7LbF5afUh/PMAxnlnLsahYq2Hapn6bNGc9D5Nu6+5WHVxHm2fxtI5mHFxT9/zGX92zDROJQfflGvZfzLS4nWOTUECcc9dvE6zes3UbU7MH5Wt50Qy3KC9ZEW1lIPd82pqXEw6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8MV56Ff; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8MV56Ff"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFCD1F000FF;
	Sat, 12 Sep 2026 09:03:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203805;
	bh=G/JNdUd1kbd9OYd05AxsMnoBM88Q5GJIv41QBIXtzwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y8MV56Ff0xEeT5fv6XkMVh2b8C1Lo3Ym8n+ScI1cN94yOsFCPZ6CDzoCTAP3XAz89
	 IQPALFMRCp6ClSw48PO/wYmhqaBIYLK/DnVhkPjAMuGxumJjTxbhGzk8YH3vmsB4sQ
	 HMoKwhNu1cV+Un9Y3JacMf69LuGRKCKd2Apud1Ig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zizhi Wo <wozizhi@huawei.com>,
	Damien Le Moal <dlemoal@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Nilay Shroff <nilay@linux.ibm.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1483/1815] null_blk: free global tag_set on init error path
Date: Sat, 12 Sep 2026 08:53:53 +0200
Message-ID: <20260912065723.820733798@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zizhi Wo <wozizhi@huawei.com>

[ Upstream commit 5a1c5ff3a49ba93a1fd0b70537e7a0164071760d ]

If shared_tags is enabled, null_setup_tagset() allocates the global tag_set
via null_init_global_tag_set(). If device creation later fails, err_dev
destroys the default devices and calls unregister_blkdev(), but never frees
the global tag_set. Since module init failed, null_exit() is never invoked,
so the global tag_set's tags and maps are permanently leaked.

Free the global tag_set in err_dev, matching null_exit() which does
if (tag_set.ops) blk_mq_free_tag_set(&tag_set).

Fixes: 82f402fefa50 ("null_blk: add support for shared tags")
Signed-off-by: Zizhi Wo <wozizhi@huawei.com>
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
Link: https://patch.msgid.link/20260725022509.714271-5-wozizhi@huaweicloud.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/null_blk/main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 4613035222cd5..fda1ffd2a64ec 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -2185,6 +2185,8 @@ static int __init null_init(void)
 		null_destroy_dev(nullb);
 	}
 	unregister_blkdev(null_major, "nullb");
+	if (tag_set.ops)
+		blk_mq_free_tag_set(&tag_set);
 	return ret;
 }
 
-- 
2.53.0



