Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A751BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E315C433EF;
	Tue,  7 Mar 2023 18:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214577;
	bh=zORnDqSNv9UPwq7Cqmz+9o/qYe6mD3ACLDiFyBUFARw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OdJWySvLVXjKkJ4YDZSRSTGIPsB7SNiKABT/W0ljeD/HE+Wa4T/WrBD9ULEZkYHYu
	 YChplwBuDJI84TYjalqVbp9Dt/3wWNoHNQT9wBjZy3rLpUhOdlvXz8XdZSbgQeeGh0
	 PveMVq9MyijzCwrw5A8fBRNRUAgrbM7CMQKxBtwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tong Tiangen <tongtiangen@huawei.com>,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Hanjun Guo <guohanjun@huawei.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 837/885] memory tier: release the new_memtier in find_create_memory_tier()
Date: Tue,  7 Mar 2023 18:02:51 +0100
Message-Id: <20230307170038.209335231@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tong Tiangen <tongtiangen@huawei.com>

commit 93419139fa14124c1c507d804f2b28866ebee28d upstream.

In find_create_memory_tier(), if failed to register device, then we should
release new_memtier from the tier list and put device instead of memtier.

Link: https://lkml.kernel.org/r/20230129040651.1329208-1-tongtiangen@huawei.com
Fixes: 9832fb87834e ("mm/demotion: expose memory tier details via sysfs")
Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Cc: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Cc: Hanjun Guo <guohanjun@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Guohanjun <guohanjun@huawei.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memory-tiers.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memory-tiers.c b/mm/memory-tiers.c
index c734658c6242..e593e56e530b 100644
--- a/mm/memory-tiers.c
+++ b/mm/memory-tiers.c
@@ -211,8 +211,8 @@ static struct memory_tier *find_create_memory_tier(struct memory_dev_type *memty
 
 	ret = device_register(&new_memtier->dev);
 	if (ret) {
-		list_del(&memtier->list);
-		put_device(&memtier->dev);
+		list_del(&new_memtier->list);
+		put_device(&new_memtier->dev);
 		return ERR_PTR(ret);
 	}
 	memtier = new_memtier;
-- 
2.39.2



