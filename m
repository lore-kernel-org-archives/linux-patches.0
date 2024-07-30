Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115D81A76B3;
	Tue, 30 Jul 2024 17:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360795; cv=none; b=uyLAjDavDDHz4/HKZc5rBpTDOrrgeLHPyecFX9TdElEv1V1rTKlpWFz8gr0pjSoSgT81GoFVgaS1gJe48DKeldo/wDHZiI1vfn2uFdXsjR7SNLjmJpqY6+/Pv72ov5gbyn/77Gyxvt4p4R7YZkyaX60GGI0RDgqW1a/Cz0Mzwwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360795; c=relaxed/simple;
	bh=xYSxt+3RFjTGmZX+MFjC9ZykXsDwko0qOQG4GAvXf1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6FAAzX6BE/9lUcBWQEN97O995Ei53CUyt90KXGSuYOKszPB5BppRAED1FnieBNK8++VhNdqrXPMShbhXu/3IuW7OpfrvUGrTP8U0TWyOzzDx0TOlKSkYNyJkHQr9DKLQEKG0iYp4lKs8092o4iFyap2vaCOnHb8b1ooc5IXfYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NImDgGuu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NImDgGuu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26988C4AF0A;
	Tue, 30 Jul 2024 17:33:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360794;
	bh=xYSxt+3RFjTGmZX+MFjC9ZykXsDwko0qOQG4GAvXf1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NImDgGuunSrExmX40caZzV8jrEFZWmfPMZYffizbK/mz1qmt9k9qk+S5QF3HfLfL4
	 NGcSPkf+FgNYrUOujfD4KdjU2PJao+PPg6lQHoHCF+yzXJ4OsWgKNod/ogPvAnU7n1
	 CKZnvAdpcvd1m2MXxkJM8HMToWhx567aHcwCcD4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ethanwu <ethanwu@synology.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 794/809] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Tue, 30 Jul 2024 17:51:10 +0200
Message-ID: <20240730151756.333319913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 885cb5d4e771a..0cdf84cd17912 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -961,7 +961,8 @@ static int __init init_caches(void)
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
+	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
+	    (CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
 	if (!ceph_wb_pagevec_pool)
 		goto bad_pagevec_pool;
 
-- 
2.43.0



