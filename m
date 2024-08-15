Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F9F1714A1;
	Thu, 15 Aug 2024 13:54:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730055; cv=none; b=rYtFfNIDYlMRW08/0/grVovXpAiJMjKJE2V4hgIZTV6u05vZ2jw480R1P5XnHaHHM7q9V7LGFFmau8lD2Or3nakoQUQLIM+uJ1kB0R/9ETp4HYmaJ1HIRyXtld08jC89sRo6Tlm6/FX4qCzMMdcwEzGQzv0u1YxUcs/F0oCppik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730055; c=relaxed/simple;
	bh=i7QsemlssG5QUhv5wgHwf1rgTGa69Y3cAb2XXqHuHCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B/7AjVufB0mF/ogY/gEQBJfioNesYF4+ei15L3BO7cmWEixfYA6d6N9V+sy/NH6wZB+6fmvBXq3ANZSBIqQsEDGu/P3cj/iJMBjlOAMShWn8gA35hPfTUYWJB9GwVNPUA+OWffiWCDX00M4TybTJz8UEB1woEbYennFQ+b4pJpQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BSmVVY+m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BSmVVY+m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F7B1C32786;
	Thu, 15 Aug 2024 13:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730054;
	bh=i7QsemlssG5QUhv5wgHwf1rgTGa69Y3cAb2XXqHuHCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BSmVVY+mho6sVyHY+NLqkTRyXIZSjq8EXWO1BeUwGEndDriT2oLyjiNf5AfV55kmf
	 AkT8EwlapHS3n3NmLb3krAReQcMoREhd1OB3sfv6Ga6/67WNtG9gLcfFjSd1W70OYm
	 PWm//JKbnLkVwzFz3wylRn7wHdohIzL6hSDOQe/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ethanwu <ethanwu@synology.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 289/484] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Thu, 15 Aug 2024 15:22:27 +0200
Message-ID: <20240815131952.571096533@linuxfoundation.org>
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

From: ethanwu <ethanwu@synology.com>

[ Upstream commit 03230edb0bd831662a7c08b6fef66b2a9a817774 ]

The kmalloc size of pagevec mempool is incorrectly calculated.
It misses the size of page pointer and only accounts the number for the array.

Fixes: a0102bda5bc0 ("ceph: move sb->wb_pagevec_pool to be a global mempool")
Signed-off-by: ethanwu <ethanwu@synology.com>
Reviewed-by: Xiubo Li <xiubli@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/super.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 1723ec21cd470..b5ed6d9a19f4a 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -783,7 +783,8 @@ static int __init init_caches(void)
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
+	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
+	    (CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
 	if (!ceph_wb_pagevec_pool)
 		goto bad_pagevec_pool;
 
-- 
2.43.0



