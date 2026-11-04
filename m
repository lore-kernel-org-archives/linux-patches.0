Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793826847;
	b=5Rmg1sAaqUZYG5U4+B6iTOfHxeM8BqxjpgxoLUKJiibDzcT/UeWYrTAttzpBjVAzx5p1
	 9U7SlrcnfWQ4IaxqlUNXLbGQkuuKbTwPjKOiKOlvbEPUJIcZSnAjR2Z7E25YtnYhesYOt
	 /w+Bztry9k8ZgMyjBQJduGCEF8kb85zDh/JMTVEz2emA14tNW5n+PFe+WFgO3yZ4ZEQG0
	 IEO2D3CZRsnNpnf0J5TI8adYWy+Gvs/Ng+HDdeHKnRugMpi0ayMSocnCfnE5aN/Dut0U1
	 H2q7Y4eatX8FrTLxpX5TDjs+nNRmDydeI628suXrzaF4SUEi1H8Arj24Q4IuDP9zN5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793826847;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QTKuSddntdsFgCkBN1zLeg7mg5Ud/ByUJq3CiCcoFuU=;
	b=odyBSTdDDLF9UEJ5fD8vgXvcjQm60tmLKpJb0W7WIZTiB7T2Ud17e+xQyBuIBBMPKbVu
	 HLcdN1WkqFkM51CTrdfnJqAPhRFkHwS+8W0hu86BUy/G9WF98RiH09OHDpyp700bF6W5k
	 74hxbPmwsqk88ZKRq+AmWf/W4+KPp3kj2zMNo4PU5qaS9+hm1YwPfOLbQx11K0n8EORkD
	 6XEQRI43xBOwlbhbQwg4JASzOYMFmmNTVN4w3eHYlUHwWDIORzOIp4vz/61QksOEIxApQ
	 DCoAD8DdjqZ7C3wH2ac4ceGJAY4+JSHyLja2hk2E8pDqwqn6Gmlg5pO5jIVOWXnThag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbcjIkJF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A679660B1437;
	Wed,  4 Nov 2026 21:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PbcjIkJF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04DF91F00919;
	Wed,  4 Nov 2026 21:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793826846;
	bh=QTKuSddntdsFgCkBN1zLeg7mg5Ud/ByUJq3CiCcoFuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PbcjIkJF6K1LPDJQTCl+/SuILIQthPjZPIx48fwU9BwUGNLFOX048jj2PkicqsUJz
	 F3wHVl/OdkvnB90WwWfzDQBmKT2ekxHVWs4TAdDZfe7gj9czegvu4gl6kEmpwkWRXq
	 /ulWMDwBI+xRgv8SEpDzonaO0gzmARBckMo7jp1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 042/547] io_uring/register: handle index wrap when resizing
Date: Wed,  4 Nov 2026 16:03:46 -0500
Message-ID: <20261104211039.519138224@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit e8dee8d5498c710a22a84076d8ecb661627032b4 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/register.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index d7e9963ab9b02..bce4473dc2ddb 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -604,7 +604,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 	old_head = READ_ONCE(o.rings->sq.head);
 	if (tail - old_head > p->sq_entries)
 		goto overflow;
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned int dst, src;
 		size_t sq_size;
 
@@ -641,7 +641,7 @@ static int io_register_resize_rings(struct io_ring_ctx *ctx, void __user *arg)
 		ret = -EOVERFLOW;
 		goto out;
 	}
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned index, dst_mask, src_mask;
 		size_t cq_size;
 
-- 
2.53.0



