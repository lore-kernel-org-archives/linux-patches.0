Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45021F130F;
	Tue,  3 Dec 2024 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239495; cv=none; b=FpHBDNKEDctAJzoyZstcNPV0Sk4ThBj9iODyXH3t5RpkpX20NhBtfIpE0b9ejqn5Ytv6VYb7T6O4jJRIbao2+474vQYvSKU+uYhp1D+4NF8Ka8LMg5/2TBw/0FTbb37heFxc5JUcPiFvwJxIc+sospCqU0L3zHSYG7Rlmna7Qs0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239495; c=relaxed/simple;
	bh=QDEi+z1VqoTZ5+QSeam1OV06MNf93WPz3XR1ZEMRwTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFMRUKvtpUlvlgfVlE8XhtIJ7iEbKR7t838WL5SvbT61h1u3G0GuFhbtxRt8G+K07rKzaleU9aEhx4cxFydX3SnNyAiuIylR91KVAu1Yibenj5mmzOS7JuCLEoLsghrZHrPheNoXwgvB7EdW6cVDV9hCWcTdjtTz607W8Hbcjnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bzvr9yKW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bzvr9yKW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A84FC4CED8;
	Tue,  3 Dec 2024 15:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239494;
	bh=QDEi+z1VqoTZ5+QSeam1OV06MNf93WPz3XR1ZEMRwTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bzvr9yKWv3AVp2OfH9pj85GKfhtLgBuJxEQ7gMMhscQWKKxW1i8TNW7AT8H0w7vrI
	 +thp37X3FVzWAnHIP2PqMRsqqWXhNKF3Fhcj5xiIHL0/y3EO4Qhcplr5cvQVkKaaPK
	 UJpKAav7js9SX2Q/1HKZKR2oO+potRSfwiEFk+rE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.11 633/817] dm-bufio: fix warnings about duplicate slab caches
Date: Tue,  3 Dec 2024 15:43:25 +0100
Message-ID: <20241203144020.645196985@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2474,7 +2474,8 @@ struct dm_bufio_client *dm_bufio_client_
 	int r;
 	unsigned int num_locks;
 	struct dm_bufio_client *c;
-	char slab_name[27];
+	char slab_name[64];
+	static atomic_t seqno = ATOMIC_INIT(0);
 
 	if (!block_size || block_size & ((1 << SECTOR_SHIFT) - 1)) {
 		DMERR("%s: block size not specified or is not multiple of 512b", __func__);
@@ -2525,7 +2526,8 @@ struct dm_bufio_client *dm_bufio_client_
 	    (block_size < PAGE_SIZE || !is_power_of_2(block_size))) {
 		unsigned int align = min(1U << __ffs(block_size), (unsigned int)PAGE_SIZE);
 
-		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u", block_size);
+		snprintf(slab_name, sizeof(slab_name), "dm_bufio_cache-%u-%u",
+					block_size, atomic_inc_return(&seqno));
 		c->slab_cache = kmem_cache_create(slab_name, block_size, align,
 						  SLAB_RECLAIM_ACCOUNT, NULL);
 		if (!c->slab_cache) {
@@ -2534,9 +2536,11 @@ struct dm_bufio_client *dm_bufio_client_
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


