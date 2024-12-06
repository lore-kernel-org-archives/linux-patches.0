Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 111F91FCCFB;
	Fri,  6 Dec 2024 15:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733498010; cv=none; b=MBV9W3omdfGuw4dDgKbBlE08KY/FGsr7sx3LV1NGr1IwyJWxf7399sTJnC5SgQF+j4jwowZqwxjxPzWhvpYeJZzBTtlQDhnZq46oFA4/+wmTOFk+wQQ7eKLHhbq4+6YvHDSptPVqYwu1jUc9BCzB7VFdRu6ZD8yaZxvpLOO+JC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733498010; c=relaxed/simple;
	bh=yNgJ5BSJ4m/niRcLrYmvLMwgoRYNLXbE9xZ8Ugy1H0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k2P119CSnatiFBOwJKKHDYRlTpCDJvecxoT9Hb81FO5/OeoiqTnQ97Fk9omvuDF8pGwSNR0nQDiYdlU8z3yROiAvqsKAU5Jh1Dh+KeeBOy7EFsSkW0sD5PaONkBrZ1gbjpMLoUXojGtr1k9pnt59jAX4fWW7rhiMWPksGvzsGI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mr593oFd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mr593oFd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E63C4CEDE;
	Fri,  6 Dec 2024 15:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733498009;
	bh=yNgJ5BSJ4m/niRcLrYmvLMwgoRYNLXbE9xZ8Ugy1H0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mr593oFdALUbSs78wJac4Xwn06X9YftFUd+jOOETaoC8on3MAevSwWPi5ksMGexWo
	 O9JKzlnMJQI6G98o73Iwhs0g19EtEz/DqvE2wb/htViSE1sxn79azlD4sghhel7bLz
	 Pyg3OCYHERfYXg5AZ6LRJ5PVjfkNpSuBwEN2RrF0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.6 460/676] dm-bufio: fix warnings about duplicate slab caches
Date: Fri,  6 Dec 2024 15:34:39 +0100
Message-ID: <20241206143711.337815672@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

From: Mikulas Patocka <mpatocka@redhat.com>

commit 42964e4b5e3ac95090bdd23ed7da2a941ccd902c upstream.

The commit 4c39529663b9 adds a warning about duplicate cache names if
CONFIG_DEBUG_VM is selected. These warnings are triggered by the dm-bufio
code. The dm-bufio code allocates a slab cache with each client. It is
not possible to preallocate the caches in the module init function
because the size of auxiliary per-buffer data is not known at this point.

So, this commit changes dm-bufio so that it appends a unique atomic value
to the cache name, to avoid the warnings.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Fixes: 4c39529663b9 ("slab: Warn on duplicate cache names when DEBUG_VM=y")
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-bufio.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -2444,7 +2444,8 @@ struct dm_bufio_client *dm_bufio_client_
 	int r;
 	unsigned int num_locks;
 	struct dm_bufio_client *c;
-	char slab_name[27];
+	char slab_name[64];
+	static atomic_t seqno = ATOMIC_INIT(0);
 
 	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
 		DMERR("%s: block size not specified or is not multiple of 512b", __func__);
@@ -2495,7 +2496,8 @@ struct dm_bufio_client *dm_bufio_client_
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u", block_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u-%u",
+					block_size, atomic_inc_return(&seqno));
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
@@ -2504,9 +2506,11 @@ struct dm_bufio_client *dm_bufio_client_
 		}
 	}
 	if (aux_size)
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u", aux_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u-%u",
+					aux_size, atomic_inc_return(&seqno));
 	else
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer");
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_buffer-%u",
+					atomic_inc_return(&seqno));
 	c->slab_buffer = kmem_cache_create(slab_name, sizeof(struct dm_buffer) + aux_size,
 					   0, SLAB_RECLAIM_ACCOUNT, NULL);
 	if (!c->slab_buffer) {


