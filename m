Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040497;
	b=vjLqOmIjUngHtBoQ7aULF3AQmyRvNQ+NAxWjy69y+Qn8dSk6QTbftQ3+fOU3pHxy8F0+
	 KYEjAKGrRoO09A2KMak4d/yp8jkzXDiT+VynvI9T23jUG+Y9XXs4BWk1Q4NJXy9c3XHAm
	 SGigoQTnTDqHQf3xhK58QMXCEGXDy34gu/KVcfnurjup/+op3f/VL3EGvRdtyFIKR97BN
	 BXMWbxYgB+asNSrZ3hhwQs/R1hrhN0/JAOqv39hcC0VHXt+EdrsdgB201tRj4DgyfDTXT
	 Q5DvV6KpGY9nPbb2DGu9RBDwR+6pVwQNwCN1oujYkn13Au6DTW+0A7jC3KOMFzXcsHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Lnqo/QycX+BBq4RGJ1rSEgmyNDstY8szIcHb3BlmijU=;
	b=vKD8aGD7fejWBFG6cNR2ps/OTt35W+weA2cMK4QcVdQncpz7bn9wLTWDHgnNvt9I3Yb/
	 Wzp+xUZceY28JTKGAq5BDgEtuehi6HjpLvexR+5ofpc9Gy8JQXdYLmJRNL8nzhlMva9g+
	 7JlZE/LxfaiF8YqvkykfEn8jFsL0ZzkLWD4PBvPxIQoYnlWRDcFU0pm3toXHgvWM77HhO
	 VBuxRsAQYcNnSuzPAwCRcErs0p2LA03Ey0C53hTZAakime13js7kpc1d3or5SqsY7eDID
	 APHowVfyycMqUKAWe2wwkh8NRht47V5FzO10OyPhShBaDwjfDRPA+E+/Xi3JvpE3GpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNp1FPNx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDDB2606A31C;
	Wed, 18 Nov 2026 22:21:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kNp1FPNx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD0A1F000C4;
	Wed, 18 Nov 2026 22:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040496;
	bh=Lnqo/QycX+BBq4RGJ1rSEgmyNDstY8szIcHb3BlmijU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kNp1FPNxu7wBUOXIyX73T8tkVj2ZHMPYWdOKpxUovPc9Plufd54hmX3LhSqNzYfHo
	 foL4Z41C7TADp70r4dYrd5uNpqmOnQxCo4Qeqb9MtlzJJCr/mJeesTRqaJqBeIVzy8
	 tSXYfGWtysx3ZJ8WJg0k+4tWucaBPiCqoUprgjlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Danish Khateeb <danishkhateeb03@gmail.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2477/3318] tools/nolibc: check for overflow in malloc()
Date: Wed, 18 Nov 2026 15:51:39 +0100
Message-ID: <20261118150435.713145252@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Danish Khateeb <danishkhateeb03@gmail.com>

[ Upstream commit 2111eb4273e7fda0815de85319653104f323c441 ]

malloc() adds the size of its header to the requested size without
checking for overflow. For a size within the header size of SIZE_MAX,
the sum wraps around to a few bytes, and malloc() returns a single page
instead of NULL.

calloc() checks its multiplication for overflow, but then passes the
product to malloc(), so calloc(SIZE_MAX, 1) returns a single page too.
So does realloc(ptr, SIZE_MAX).

Such a size is usually a bug in the caller, for instance a length of -1
used as a size_t, and returning a page instead of NULL can turn it into
a heap overflow.

Fail with ENOMEM when adding the header overflows, as glibc does for
sizes this large.

Fixes: 0e0ff638400b ("tools/nolibc/stdlib: Implement `malloc()`, `calloc()`, `realloc()` and `free()`")
Assisted-by: LLM
Signed-off-by: Danish Khateeb <danishkhateeb03@gmail.com>
Link: https://patch.msgid.link/20260926152414.251214-3-danishkhateeb03@gmail.com
Signed-off-by: Thomas Weißschuh <linux@weissschuh.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/include/nolibc/stdlib.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/tools/include/nolibc/stdlib.h b/tools/include/nolibc/stdlib.h
index 5393f001267dc..c7832a31ed483 100644
--- a/tools/include/nolibc/stdlib.h
+++ b/tools/include/nolibc/stdlib.h
@@ -132,7 +132,11 @@ void *malloc(size_t len)
 {
 	struct nolibc_heap *heap;
 
-	len  = sizeof(*heap) + len;
+	if (__builtin_expect(__builtin_add_overflow(len, sizeof(*heap), &len), 0)) {
+		SET_ERRNO(ENOMEM);
+		return NULL;
+	}
+
 	heap = mmap(NULL, len, PROT_READ|PROT_WRITE, MAP_ANONYMOUS|MAP_PRIVATE,
 		    -1, 0);
 	if (__builtin_expect(heap == MAP_FAILED, 0))
-- 
2.53.0



