Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BA57187FF6;
	Tue, 30 Jul 2024 17:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358918; cv=none; b=I79xuz3Vc4mRaqL17WjLXcCB0zzLQCQj/vMx9GAmi3liyOJ8lSBXp8L0xJixHBZo5XDPHY5wQi819j/0qDdNHejxL1iI7HABwN1RPIqOctCIJj45oljvmsPmD2FUxqA3/NzCdt0Ztjg3D9j4maSeiixulrZ0qYIJ87acoQvOukk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358918; c=relaxed/simple;
	bh=rRbeQnlt/bK9NMVO3piPYKLRJnZEKpsoxPBMUtIpWv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmSs7hr9NvVS2IwujtSZc0LmraqOfPUO+S5DjlWDHtRnTSawmPoHWBzULBcSgE35BQsQmhwT71maQhxHbymD5z02bIvbSS76QC7qQTUDtCWimQWUQ6NObaZOk54/GpDEI9Ib5v4WDEoeRDVzH1SfWuNFMsX6pE3O+ddustzsuXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AdLx+B1p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AdLx+B1p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C81C32782;
	Tue, 30 Jul 2024 17:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358918;
	bh=rRbeQnlt/bK9NMVO3piPYKLRJnZEKpsoxPBMUtIpWv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AdLx+B1pnq68t+x2qRp2iBX2ZC2Sk1dVSGuU269bbYVDKY3KWPvlE02bVad+kcZvQ
	 cARAHMcJODMGzahuvXk8v2t6cu8tkTpHwI9liIoF7dMpmjEHyVSJ7+mcDNtD1za14W
	 8VFtj+FGgMkIgIcXlZXCGGmlfv1e3Zcca1XKQHnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ethanwu <ethanwu@synology.com>,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 433/440] ceph: fix incorrect kmalloc size of pagevec mempool
Date: Tue, 30 Jul 2024 17:51:06 +0200
Message-ID: <20240730151632.688073203@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 281b493fdac8e..aa75aa796e434 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -924,7 +924,8 @@ static int __init init_caches(void)
 	if (!ceph_mds_request_cachep)
 		goto bad_mds_req;
 
-	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10, CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT);
+	ceph_wb_pagevec_pool = mempool_create_kmalloc_pool(10,
+	    (CEPH_MAX_WRITE_SIZE >> PAGE_SHIFT) * sizeof(struct page *));
 	if (!ceph_wb_pagevec_pool)
 		goto bad_pagevec_pool;
 
-- 
2.43.0



