Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAFA63D5;
	Thu, 15 Aug 2024 14:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732533; cv=none; b=Eho5xmfI8a5P2BSryV03NbIQCwjCvFHvjim+HNu/AIcBV206dehNyIEkNEGbx2ibbIMzKV19sN6osyC4WYsPZVBMoq3OnUBMLSgIGeyrso8sp1fZCaCbIQCfBarrSGL7xnSFYLCzyEwKONw23Ev1nwnvlZJ7HTutC/37q9EUzqQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732533; c=relaxed/simple;
	bh=IIMGATqBPx/2vz2QPiXGd+Isl9JKoX/0UNWhHnBEt98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kGxxhaHqVvFRidlkbYap4jb51QcnhErlQisvWX0FgWl+flCORZwKpZ2ZIcgXjFmxwJYo1C1GP3lY50TROme0eWB9fSFznBLtYi89eTxGNKj7mkTgRi7wcP4rh3fvbOqg79UsfuRioNc8KIGg8+kPA6OES81Soo0N/97LV+4nzKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aG+85PC+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aG+85PC+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABBDEC4AF0C;
	Thu, 15 Aug 2024 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732533;
	bh=IIMGATqBPx/2vz2QPiXGd+Isl9JKoX/0UNWhHnBEt98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aG+85PC+a/FpSVen1CUcEkFwoi5alTd76NXEFFmW8dFD8+gfuKfprHYlrcC1J/Lu/
	 ClJ1ejpmdRqJ1PVyt0V9EgwZEZWYHeX1tKMGF8rbMUAzc1EfqOQZ+7Cz/E49DGwfP7
	 CxP+A6dOVZm6BGcuiFqN4gZ6QbN8eP8IhGfU4xhA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ethanwu <ethanwu@synology.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 208/352] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Thu, 15 Aug 2024 15:24:34 +0200
Message-ID: <20240815131927.324375807@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f2aff97348bc9..4e09d8e066473 100644
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



