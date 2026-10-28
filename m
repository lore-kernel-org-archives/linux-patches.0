Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207264;
	b=Z2ZNNWSVvr1pDjTMjJRmkSJ6++/ExhmzAZ7pVMhXpUPjLs/D6x74HI4vgvgqKTMiVz3i
	 ErXv+JC6plghuQ4/gx64dskncXAfZ4Q/93YRs4l+ReWbyQPbp8KzFz9qpzgzcB2igO0vR
	 tduMAx7ziNDGtiAb2Qle9ABq4UBsvZpWrZZ4kxiY3jDVulSwF/vTRhuSQRM982rvTw9KK
	 Iz+ph+huzOJEb//zgWg0Vjp+ZXwuv5rQ1zgFYfncE+bzjqCkMI14NkEozckoL3BCopkOI
	 Ik9YLLx3QGZYMyL+VOf/oyEGz7uEnGP09iI9xxjIQz4g7TbeX4PSZ/+KztxeK/JBYZQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207264;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o+la5x/lZqo3SKNJ5o8hRGJhdzvlJ8m/jojQ6s1jl9A=;
	b=q9ez/kIki+OjtS5mUDwt/AUDQU4aKgZx0r7r8gLeg+p3i0sKY7+yG4uduTRVJNxmhLDH
	 CDpA+Ww/fObqgz1YAvQqbSxyEkrhxBYn3s0MhBzT4r0nx6zbd+Hev/8140f+t+hGPdelp
	 7NfBhEspvSeEcRUymnom5nThGRYtjjGs7ddzXVH7i2Stmz8kYFCuIpbnYYcA5m26BZXBo
	 qqlLGwHDYNSXppiOdKqcEP2lQV85Bga/w+6ix86keKsSy9nZh32Ev/MKiSmxkFyvJYoO0
	 R9tApSaPyfI4ybXQ/Q3vKO8pwwgaosESVKo9YtpITCz3PMYrQXlIbn9pc5qFS/KbWNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFbvrADI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F0606A31D;
	Wed, 28 Oct 2026 17:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wFbvrADI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3A41F01825;
	Wed, 28 Oct 2026 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207263;
	bh=o+la5x/lZqo3SKNJ5o8hRGJhdzvlJ8m/jojQ6s1jl9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wFbvrADI3Bqp/yR9y2afdovnDWmezRy/+uwz416oKIHOybVBwjlg+/6gyu6/uYKDt
	 L/qpb+Gv+AWqMr7YmDpim/N0w1Vo85XjA58d5OKS9zLiFrzCK1MRYJ8Vi2OToUxzQ7
	 ZJwVkA4QVHAni38SoYTW6kTKtKhEWmbwcaPKRZ7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	"Claude Fable 5.1" <noreply@anthropic.com>
Subject: [PATCH 7.2 44/88] io_uring/fdinfo: fix CQE dump of CQE32 rings
Date: Wed, 28 Oct 2026 17:59:52 +0100
Message-ID: <20261028165943.152189509@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

Commit e4507a62c247081fffe299622c04c6f7c3d98e92 upstream.

Since the CQ ring dump was changed to deal with IORING_SETUP_CQE_MIXED, a
32b CQE is taken to occupy two entries of the ring. That is how it works
for mixed rings. With IORING_SETUP_CQE32 each entry has twice the size:
head and tail count 32b CQEs, and entry n is found at cqes[n << 1].

For such rings the dump reads cqes[n], and skips every other entry. It
shows half of the pending CQEs at best, and what it shows is taken from
the wrong place unless the head happens to be at the start of the ring.
The extra data of the last entry isn't shown at all, as the check that
keeps the dump of a mixed ring from reading beyond the array is applied to
these rings as well.

[ 7.2: without the last-slot check, which 7.2 does not have ]
Fixes: 82ceb7fcc5ff ("io_uring/fdinfo: handle mixed sized CQEs")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-28-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Co-Authored-By: Claude Fable 5.1 <noreply@anthropic.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/fdinfo.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -154,11 +154,17 @@ static void __io_uring_show_fdinfo(struc
 	cq_entries = min(cq_tail - cq_head, ctx->cq_entries);
 	for (i = 0; i < cq_entries; i++) {
 		struct io_uring_cqe *cqe;
-		bool cqe32 = false;
+		bool cqe32 = false, two_entries = false;
 
-		cqe = &r->cqes[(cq_head & cq_mask)];
-		if (cqe->flags & IORING_CQE_F_32 || ctx->flags & IORING_SETUP_CQE32)
+		if (ctx->flags & IORING_SETUP_CQE32) {
+			/* all entries have twice the size */
+			cqe = &r->cqes[(cq_head & cq_mask) << 1];
 			cqe32 = true;
+		} else {
+			cqe = &r->cqes[(cq_head & cq_mask)];
+			two_entries = cqe->flags & IORING_CQE_F_32;
+			cqe32 = two_entries;
+		}
 		seq_printf(m, "%5u: user_data:%llu, res:%d, flags:%x",
 			   cq_head & cq_mask, cqe->user_data, cqe->res,
 			   cqe->flags);
@@ -167,7 +173,7 @@ static void __io_uring_show_fdinfo(struc
 					cqe->big_cqe[0], cqe->big_cqe[1]);
 		seq_printf(m, "\n");
 		cq_head++;
-		if (cqe32) {
+		if (two_entries) {
 			cq_head++;
 			i++;
 		}


