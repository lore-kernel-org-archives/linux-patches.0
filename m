Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB7EE1A76A1;
	Tue, 30 Jul 2024 17:24:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360267; cv=none; b=r9LQa9LKnT/XiwEpbVlphlNmTxjouH0wUFKG3o1EC0z1okQUkfMNoGLmPae6WzgzHTNww6cCYrNh3epLXOEaC373z6aqYDw+NnLGKF70DokL2mvOhZ2PRulkVhTAia/53wJX+x9Xinn4SdTuDsGmuJzupORSaVrkAR/zAbvo3Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360267; c=relaxed/simple;
	bh=Ox/QpAXdP7DKcXgaN5DyLefN8AuqX9Do4j5jybUbPd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VnZSWqmjYhUv59a8Zii9/jAUuKyFw4PcnR3c+w1bbCdUlBxKdmB1CzyqbXa/IbWqINVJvGNFQSbe5M2l7yCveF+hp2EECYSyo/yWStblC9qUaZtfOYvVUmZba9eysjELXOoViKz01VRH4susoY0k4VtY0uXoo990RmGRu0Ht7XU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SRakzJWz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SRakzJWz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C53AC32782;
	Tue, 30 Jul 2024 17:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360267;
	bh=Ox/QpAXdP7DKcXgaN5DyLefN8AuqX9Do4j5jybUbPd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRakzJWzYZNz/mMVliW8mH0K9WDk7YOI0YYuM64dVv3DZ/JuKC14Qxr5FvzODkc8A
	 H+o+2mhQDJwHk8mjo83rqzFbHTwtLIDt9ifJhJSPM7Aj8TBg3xQR4vLZrZFWyo3CKt
	 VbPs4IBDGXcsThPEKRTXAiFRkQ5GuNWHX8ta4O90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chunhai Guo <guochunhai@vivo.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.10 647/809] erofs: fix race in z_erofs_get_gbuf()
Date: Tue, 30 Jul 2024 17:48:43 +0200
Message-ID: <20240730151750.427107362@linuxfoundation.org>
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

From: Gao Xiang <hsiangkao@linux.alibaba.com>

commit 7dc5537c3f8be87e005f0844a7626c987914f8fd upstream.

In z_erofs_get_gbuf(), the current task may be migrated to another
CPU between `z_erofs_gbuf_id()` and `spin_lock(&gbuf->lock)`.

Therefore, z_erofs_put_gbuf() will trigger the following issue
which was found by stress test:

<2>[772156.434168] kernel BUG at fs/erofs/zutil.c:58!
..
<4>[772156.435007]
<4>[772156.439237] CPU: 0 PID: 3078 Comm: stress Kdump: loaded Tainted: G            E      6.10.0-rc7+ #2
<4>[772156.439239] Hardware name: Alibaba Cloud Alibaba Cloud ECS, BIOS 1.0.0 01/01/2017
<4>[772156.439241] pstate: 83400005 (Nzcv daif +PAN -UAO +TCO +DIT -SSBS BTYPE=--)
<4>[772156.439243] pc : z_erofs_put_gbuf+0x64/0x70 [erofs]
<4>[772156.439252] lr : z_erofs_lz4_decompress+0x600/0x6a0 [erofs]
..
<6>[772156.445958] stress (3127): drop_caches: 1
<4>[772156.446120] Call trace:
<4>[772156.446121]  z_erofs_put_gbuf+0x64/0x70 [erofs]
<4>[772156.446761]  z_erofs_lz4_decompress+0x600/0x6a0 [erofs]
<4>[772156.446897]  z_erofs_decompress_queue+0x740/0xa10 [erofs]
<4>[772156.447036]  z_erofs_runqueue+0x428/0x8c0 [erofs]
<4>[772156.447160]  z_erofs_readahead+0x224/0x390 [erofs]
..

Fixes: f36f3010f676 ("erofs: rename per-CPU buffers to global buffer pool and make it configurable")
Cc: <stable@vger.kernel.org> # 6.10+
Reviewed-by: Chunhai Guo <guochunhai@vivo.com>
Reviewed-by: Sandeep Dhavale <dhavale@google.com>
Reviewed-by: Chao Yu <chao@kernel.org>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Link: https://lore.kernel.org/r/20240722035110.3456740-1-hsiangkao@linux.alibaba.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zutil.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/erofs/zutil.c b/fs/erofs/zutil.c
index b80f612867c2..9b53883e5caf 100644
--- a/fs/erofs/zutil.c
+++ b/fs/erofs/zutil.c
@@ -38,11 +38,13 @@ void *z_erofs_get_gbuf(unsigned int requiredpages)
 {
 	struct z_erofs_gbuf *gbuf;
 
+	migrate_disable();
 	gbuf = &z_erofs_gbufpool[z_erofs_gbuf_id()];
 	spin_lock(&gbuf->lock);
 	/* check if the buffer is too small */
 	if (requiredpages > gbuf->nrpages) {
 		spin_unlock(&gbuf->lock);
+		migrate_enable();
 		/* (for sparse checker) pretend gbuf->lock is still taken */
 		__acquire(gbuf->lock);
 		return NULL;
@@ -57,6 +59,7 @@ void z_erofs_put_gbuf(void *ptr) __releases(gbuf->lock)
 	gbuf = &z_erofs_gbufpool[z_erofs_gbuf_id()];
 	DBG_BUGON(gbuf->ptr != ptr);
 	spin_unlock(&gbuf->lock);
+	migrate_enable();
 }
 
 int z_erofs_gbuf_growsize(unsigned int nrpages)
-- 
2.45.2



