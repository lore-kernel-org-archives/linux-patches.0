Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827021;
	b=hn8yE/y2nTOLB/7cgyhSyvby4wQ9bN45lKM2+2r4rSLjMy9pl62c7II+gZfQxxU6kWBn
	 EljCHHrQx3smeqFHlk6UX3EOmQyTtZRGowQ5d85y739/YWMw/tkuNDDhwwN7X8ifZ79u1
	 6pLCiL6MBkXMlzECqZxrGCdzbwcxWlqrmtNJHz9I8iiOMz2ov7NS8AJGX7R0gSDtTHBHU
	 31hm7JKIS0dlKweN8zz1JsovdBbtzhdLaJMcY9t53X6mnRSSFcOQ3iPW9gGWneXtmeUV0
	 Rrsz0aF4ZZyYh8Cjly2ORc2F3RM9Y+eO9rGjr+QjypWUTEchBRFhQJqKccQ1qgoFzUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827021;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/WgmUJssjUkjKBVBsQ2j1KvpQaVO/enQip7JhT4ssOM=;
	b=woR4aDVCT4kZm4Ucr+Z9VIYPa5qKj/moEIM8lPU0rXtAGC5z5bfU7nYSZqBjA/yUUnT2
	 w19nLrA7I53/szzt0XMG+PGVrXz47XjQL9Ix7YgzCF2XqGEo0X4dDhAnNdbAgNkSULQrl
	 dr+7U9PLbzgAikpfBmHCTFh6xz6FuaGi0KXvyVPBhtk7Nv+l6IkMXbFZRTSvHB5/n881H
	 PaRW3s1W99ZrXvc4gd/PtnCLPW6JwxARg67g+jYwNbi6MlpsXwZlwRRlb/dtCrbH1f02Q
	 5wOGszUWDxlnFdR8tePOU5SnxgpNOQy1a/e4DUv9GTQnw/F8gBa0FJa+u0/lAXaAutQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfdtviOB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 495ED606A865;
	Wed,  4 Nov 2026 21:17:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KfdtviOB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D9B1F00919;
	Wed,  4 Nov 2026 21:17:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827021;
	bh=/WgmUJssjUkjKBVBsQ2j1KvpQaVO/enQip7JhT4ssOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KfdtviOB98llAxQj180c3BJ1Zv3hSRlMi/fKDr13inh7sx8YWTjZ+AUQmVDYCv9Lf
	 9pvXG9Hhomow1GPCD5NBtQIXJsLMSj7WqsripPsRRIZk57rJYDYVTFDIheWZ3cGkRd
	 fVNcuvey21qyRoviSN4cC+bPShNl3wlcTAydhY0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Kim <james010kim@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexandre Bounine <alex.bou9@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Matt Porter <mporter@kernel.crashing.org>
Subject: [PATCH 7.3 148/547] rapidio: mport_cdev: fix use-after-free in mport_mm_close()
Date: Wed,  4 Nov 2026 16:05:32 -0500
Message-ID: <20261104211042.370805743@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2167,11 +2167,12 @@ static void mport_mm_open(struct vm_area
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


