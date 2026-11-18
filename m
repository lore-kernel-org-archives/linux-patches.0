Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044334;
	b=K8YyQNvrQME7fWHAGxWPUUl5fhwpmPtIYPKYNhCA246XwRGu1xoaxJ0Vn4qGckN1q+s9
	 w+h3+maebbjHAKk/7FZi8PidhY2ijCpOePKLbaG6EE+jBsVQo7qc4I6Z5z4wjNJBWF2wn
	 NsQhyvwh7SUG4ZDd1sse+kQEaIK9zR9j24Q7fRITMM59YO918MxqR9xAxDycQXduzKIYQ
	 hytJ0rwelSBMJb8WayuPXEJZAJWkLNxkFu6LVQ15vuqGrW3gMYTnMZJwLTcUxYpTQRvTj
	 8U1hRbK2lB1lW8mch+NtOv/c2GqtYMMR/NxFCLtgNn9V6BAtU48L6Q35o2igCSutp3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044334;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ADJxkMMPtXtr9Mu8+0acAuyUB5KHVnYqozWk64RnzdA=;
	b=Kwp8qz5T/2YARR7SA/NBOelhUF8toX0owjyD34bcrBCokaFBz0XtxHquzAp/FWKbxb9J
	 DNzwaPfca3598ZWI994u0/6DeM6atHHsFx+vH4huC0oNnD1g04tmJVhh861sEpneUQkOA
	 8oOF5D6p+fme1AJ1mGOVkzoQsv3e0qWwP0ugVURebi431w+Mk1dGGe+pn65tJRu9J/cV+
	 FFXLR6mlgUez4gPBX76RQ38OCbCXZCZCGnVxjyeaN1ymvjqnFOUmnzS60DkvBxi5tQ3Cn
	 8u4qI2jkNam7BSqSahzdLsqTc5nnY4FFm0LEqTWm1etngfRW9u1g5d3SemfoKL9/Tbg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyeFOjzl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 528F7606A31C;
	Wed, 18 Nov 2026 23:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VyeFOjzl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF7E1F000C4;
	Wed, 18 Nov 2026 23:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044333;
	bh=ADJxkMMPtXtr9Mu8+0acAuyUB5KHVnYqozWk64RnzdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VyeFOjzlE3AVZiVVLagLAgcrNOBNerhv2UlOhnZ/KXtZNA8inZcQGRkPxOu4P5ZlD
	 P/r+g9TBpdBqlqYvxW4tosyG8p0RyRQe2y2mx/0Avqwng1CiDGWcJFdzoNez+/WaXu
	 fRnHUHz2dOrSXRQrqruUTsYu6KzKb0E+sXmRZSjc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 6.1 0531/2857] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed, 18 Nov 2026 15:26:05 +0100
Message-ID: <20261118150220.596725761@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2186,11 +2186,12 @@ static void mport_mm_open(struct vm_area
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


