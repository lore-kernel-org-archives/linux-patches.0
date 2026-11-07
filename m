Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061516;
	b=B0sRGO6dcVrvId7TyGP4CAqjE1TenoUM0AvqLBcGd88+anHKbGVuWBn2Uf69HO54nXnO
	 qIWkBtnAJSLrbdWeqpAFx3Br3UzoS9U/sL4GFkXz7CjvoXfggLXs8pTgX8tVotP+ENAe1
	 /dym8FPBzo5sarHpK6w6s7/nrsjAgcQ8vwbDImS7RuM3nsKFAd0IIL3tZPKxgsfhlcFYX
	 uSccGRKfc5Uvak/LoBYeX17j651tOUswqNuVYPG//RYLe3tS3FWUm1dltc/MHzeh4+j+P
	 y4U/LvAJcwjZNOSaDMGDqtzD+lgsI1MwOLVvCWNH9hiIP9CxZqgglHSG3vbxdlD2OXQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061516;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=keE+vP5Tx/p/Gijkdlt9rjJlAY5DG0vUWxGqYeJPY7Y=;
	b=5g6GO1iAxIttMRs58QUqPUenuuZb5lr5uspaFrNpcivWwVcfXmdL0yqw3kLikiZa8e6A
	 +TWPuf1jD67+MCWIH4KweCGUxRE0Co9C5A1SH0XJnGB7o9Q6UutF1SEyfpKINSF2QkjQC
	 uu8jHqtDCETBQI8pOR2bcgw1shNiZPGi4ZvDjd2rVxXFEpgf4j7be7GH+gSxH6K+8hxHh
	 NUEwoeCCtDeukN5nfrGoSvMnxi/fvQucQOBEeZbMRAtzi33H/9iXcpaKaJGajwWOpr+QW
	 jed8WeNL5q340wjE3ta9bByxxOIldtE8CLB3ljg8JeMxVxVUFIf/XVj5cq6IOJbM89Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7rd3fLA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C328606A32C;
	Sat,  7 Nov 2026 14:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7rd3fLA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBDE11F008A1;
	Sat,  7 Nov 2026 14:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061516;
	bh=keE+vP5Tx/p/Gijkdlt9rjJlAY5DG0vUWxGqYeJPY7Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7rd3fLA1Tcc93gvIL6ypyo/04WqVXxn2BU4Delgp7gfEAt63uvFJLcWHiN6E98eA
	 d2vFqqApLDTnvpwH1cD9nxA3NglpQapBqij9BgaW9saCZS8m8knnXZ8I9GHg6VS8mE
	 Gig1BVWfeX8Sl9ZVj0avzXVWDi0h6waH3vawVePQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 6.12 0606/1536] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Sat,  7 Nov 2026 08:43:42 -0500
Message-ID: <20261107135014.562461044@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Kim <james010kim@gmail.com>

commit 0f2cd84858e67cf8e02438bf28243bcdc67aa49a upstream.

A use-after-free vulnerability was identified in mport_mm_close() in
drivers/rapidio/devices/rio_mport_cdev.c, identical to the pattern
previously addressed in dma_req_free().

This is observable from userspace when an application creates an mmap
mapping via the RapidIO character device and subsequently unmaps it (or
terminates, triggering exit_mmap()).  During munmap, mport_mm_close() is
invoked and drops the mapping reference via kref_put().

If kref_put() drops the last reference, mport_release_mapping() is called,
which frees the underlying rio_mport_mapping structure.  The subsequent
mutex_unlock() then dereferences map->md to unlock buf_mutex, leading to a
use-after-free:

   mport_mm_close()
     -> mutex_lock(&map->md->buf_mutex);
     ...
     -> kref_put(&map->ref, mport_release_mapping); /* map is freed */
     -> mutex_unlock(&map->md->buf_mutex);          /* UAF: map used */

Fix this by caching map->md before kref_put() and using the cached pointer
for mutex unlocking, ensuring that freed memory is not accessed.

Link: https://lore.kernel.org/20260914042327.49798-1-james010kim@gmail.com
Fixes: e8de370188d0 ("rapidio: add mport char device driver")
Signed-off-by: James Kim <james010kim@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Dan Carpenter <dan.carpenter@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rapidio/devices/rio_mport_cdev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/rapidio/devices/rio_mport_cdev.c
+++ b/drivers/rapidio/devices/rio_mport_cdev.c
@@ -2188,11 +2188,12 @@ static void mport_mm_open(struct vm_area
 static void mport_mm_close(struct vm_area_struct *vma)
 {
 	struct rio_mport_mapping *map = vma->vm_private_data;
+	struct mport_dev *md = map->md;
 
 	rmcd_debug(MMAP, "%pad", &map->phys_addr);
-	mutex_lock(&map->md->buf_mutex);
+	mutex_lock(&md->buf_mutex);
 	kref_put(&map->ref, mport_release_mapping);
-	mutex_unlock(&map->md->buf_mutex);
+	mutex_unlock(&md->buf_mutex);
 }
 
 static const struct vm_operations_struct vm_ops = {


