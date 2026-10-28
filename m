Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207258;
	b=Fk0v/N3pwcxbEVM4FbIJTc4b59g7LqpYliZyFu5PgJncHXLs5nz5+H2ehQxGwNQjW3PF
	 5cz7n6MgJkTekKSbSFU4HYaltnOMzls1apF6vJTY+udUXzvlBYu3iR2mtzbeuf3WEUxeU
	 Mx8yXgPWalsbIFWVdDqtCrGidAck4YFL1Fc2rI3336fD8NVqVH6HCXElPE1hTq911XR9x
	 EIo+wKjGfq6KJF/pk0nzI8pbZbYLBGW5QmJhe1Mrpyh6M+SqwWAiUj5J0bgyFq2PADLe4
	 xqEShawIkOkN4LziR0iujUR0rUAcvrIqdHHVj2RfGe6vp7HNAVbCaQFLi98hQ6VXeSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tq2bUIlvQ7wyPrqfCWbLoi8YTHzS+xKVuOlETG/sp5M=;
	b=Eq/MzDWyhwkrm5JGdorX9Miiozj2WWWj2GncYrnr6bx4iCNb+bbye3JXIO4GtwzoFK7y
	 YxbqXwI+1F/nISJlElgQQLuU4PkdBjGvIualMuqnAr4YWwsbL/gcZnUvqb7q3A7aN9PLm
	 /F81AaQxrMg0VyPsnPvFvClu08X7l16/o2E17ttl+FG7XN3joq4Dzo7pzeXLpwT391G+X
	 3xSGcsFSmDVkhLV+SMMfqsIuE3iTSUdA72Ry71bStG2LqI90g7j3R4dk5laTHbdHn911w
	 lKg1wy6p014+pmH+4/t4dS9rWhhezrknApXWZurzy46KNH9tAq9iwpzjvdRVid969lA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIkiJX7j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E38C606A31A;
	Wed, 28 Oct 2026 17:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tIkiJX7j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3801F01825;
	Wed, 28 Oct 2026 17:07:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207257;
	bh=tq2bUIlvQ7wyPrqfCWbLoi8YTHzS+xKVuOlETG/sp5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tIkiJX7jdp2HSEzXPxqk3JQe70+moTdtw8wVCvFek4BUEm7pCHdjxyGglhX4Q301G
	 u1qwVzDvIZ2uzgXK8dqVz/7LvtnGTN/Yo7QNImN7nYQ6TfmHuaxjBBWVj58lW3tmp3
	 68dBNnWGEjBr/5dZxPbCHD9aQv492p5+uf/NCDgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7.2 42/88] io_uring/register: handle index wrap when resizing
Date: Wed, 28 Oct 2026 17:59:50 +0100
Message-ID: <20261028165943.102337862@linuxfoundation.org>
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

Commit e8dee8d5498c710a22a84076d8ecb661627032b4 upstream.

The ring heads and tails are free running 32-bit counters.
io_register_resize_rings() takes that into account when it checks whether
the pending entries fit into the new rings, but then copies them with

	for (i = old_head; i < tail; i++)

If the tail has wrapped and the head hasn't, that copies nothing. The new
rings get the old head and tail, so the application finds whatever is in
the freshly allocated memory, zeroes, in place of the CQEs it hasn't
reaped yet, or the kernel in place of the SQEs that have not been
submitted yet. A ring that completes a million requests per second gets
there after little more than an hour.

Loop until the tail is reached, the number of iterations has been bounded
by the size of the new ring at that point.

Fixes: 79cfe9e59c2a ("io_uring/register: add IORING_REGISTER_RESIZE_RINGS")
Assisted-by: LLM
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Link: https://patch.msgid.link/20261015-b4-io-uring-fixes-v1-26-c1556f5d7bf5@toxicpanda.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/register.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -604,7 +604,7 @@ static int io_register_resize_rings(stru
 	old_head = READ_ONCE(o.rings->sq.head);
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned int dst, src;
 		size_t sq_size;
 
@@ -641,7 +641,7 @@ overflow:
 		ret = -EOVERFLOW;
 		goto out;
 	}
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned index, dst_mask, src_mask;
 		size_t cq_size;
 


