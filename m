Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B7071A76A4;
	Tue, 30 Jul 2024 17:19:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722359961; cv=none; b=vDuPuDiJfgVKqceS5pZsOViNInYtOz6W9Ki2ZluhgmcYkmtefe0XSEngDs90RmVya1xq52A/MHCyxH3RxERUdskCwySTt9NgnqinnPcKRetZVxg5HEtRfnnZIqk3munCV8tH7mhFPrrpjXH0VfHCiVG5mjeE96io4ZwmErQPWSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722359961; c=relaxed/simple;
	bh=HRNuX7dyhhuYJQA7lDUNFppedP8tK17TdvOmqZhWVk4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k5+zn91wPHh+B3aBb7ARSIk/Jwa0mZB0AtXaK9gZorW4od6hRQlaZiYHMW1tK5VH3z/E7I7p5deJ3biLx91t3dunhuqeZ0RUaqml505vcg6EHImck8vShbLK+rnNzJ69RcNftlCGXf3djenep7p36wbH1KV5Kx1oDBXNAXcwjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WmeVVMnY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WmeVVMnY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65EE6C32782;
	Tue, 30 Jul 2024 17:19:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722359961;
	bh=HRNuX7dyhhuYJQA7lDUNFppedP8tK17TdvOmqZhWVk4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WmeVVMnYYJJJvRucOuOFJfkmQ3P6ytyi8d4p32iIrnNSTntXVZYBiVN34mKKNW86m
	 nBHJ7rpHQ9kYM5uSz9Gha5OqTn3u708PqF/mdee/xbR3E2zWwnBepK9Ykst4tD7E3M
	 3Dd2lwHI4uLAZ9jAQvgK+LZXwoNZ1O1LQDCbSwtU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ethanwu <ethanwu@synology.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 561/568] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Tue, 30 Jul 2024 17:51:08 +0200
Message-ID: <20240730151702.084099256@linuxfoundation.org>
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
index 52af90beab000..ec51e398562c6 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -958,7 +958,8 @@ static int __init init_caches(void)
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
+	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
+	    (CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
 	if (!ceph_wb_pagevec_pool)
 		goto bad_pagevec_pool;
 
-- 
2.43.0



