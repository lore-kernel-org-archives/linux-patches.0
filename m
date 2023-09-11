Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2071170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:53:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6E3EC433C8;
	Mon, 11 Sep 2023 13:53:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440408;
	bh=d1akeOc0NF0PHK2adKv4fHOdEzzjdZrHnOifQ5DIFBU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tAzlFbmhEAdewar0LavpLUQmAFAi7bFj7aKEY5SgY5na8a2aGTGk18SwECZCBMXW+
	 QQa0sjOxwgXhEwyjPcWeHhKKFAldhFke/96MtgABlJv5saUn5w2S6fFNl3//i/57DB
	 SJn4Z/q6n+e06HDvPiHOywh+GScm1pQ+pu7543n0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingbo Xu <jefflexu@linux.alibaba.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>,
	Chao Yu <chao@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 024/739] erofs: release ztailpacking pclusters properly
Date: Mon, 11 Sep 2023 15:37:03 +0200
Message-ID: <20230911134651.731779983@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jingbo Xu <jefflexu@linux.alibaba.com>

[ Upstream commit 91b1ad0815fbb1095c8b9e8a2bf4201186afe304 ]

Currently ztailpacking pclusters are chained with FOLLOWED_NOINPLACE and
not recorded into the managed_pslots XArray.

After commit 7674a42f35ea ("erofs: use struct lockref to replace
handcrafted approach"), ztailpacking pclusters won't be freed with
erofs_workgroup_put() anymore, which will cause the following issue:

BUG erofs_pcluster-1 (Tainted: G           OE     ): Objects remaining in erofs_pcluster-1 on __kmem_cache_shutdown()

Use z_erofs_free_pcluster() directly to free ztailpacking pclusters.

Fixes: 7674a42f35ea ("erofs: use struct lockref to replace handcrafted approach")
Signed-off-by: Jingbo Xu <jefflexu@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Link: https://lore.kernel.org/r/20230822110530.96831-1-jefflexu@linux.alibaba.com
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/erofs/zdata.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/fs/erofs/zdata.c b/fs/erofs/zdata.c
index 9c9350eb17040..9bfdb4ad7c763 100644
--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1412,7 +1412,10 @@ static void z_erofs_decompress_queue(const struct z_erofs_decompressqueue *io,
 		owned = READ_ONCE(be.pcl->next);
 
 		z_erofs_decompress_pcluster(&be, io->eio ? -EIO : 0);
-		erofs_workgroup_put(&be.pcl->obj);
+		if (z_erofs_is_inline_pcluster(be.pcl))
+			z_erofs_free_pcluster(be.pcl);
+		else
+			erofs_workgroup_put(&be.pcl->obj);
 	}
 }
 
-- 
2.40.1



