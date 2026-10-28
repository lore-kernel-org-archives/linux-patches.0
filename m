Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209754;
	b=J4NGoF2ORDxb0fSzcu+1FCjcebGDkEb+Py0wCD7LOyHIuPVpfr0IuWNixz3NAaJcqpBP
	 RM1MB7opH2juMpmReWRk1oIl+CmE8aRbX9xGju1aRl8qR11TSeXYjr82xb0wkCeBFmcog
	 eRmbbjLU475tPsTn2FHpy2VTn75DgfKikC6IVTT/QTz+Q7gzV8aGLD2fdTXGxQ8AEHcWC
	 zGz0UMMSeNtmNdpY5EwMvf/QTO+pUl44MDgmDguojVNqfPMWnW1zdAGAiJl9aM6ouNF3n
	 i8RB8de7t16n53F0SpotPBracEKtNj3EauENsUT7jjAOAcG8sjOqE6OySPvojtfnzWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209754;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/wXPfZxTIFzWbGR0l5Kxi4PDtbeBodIM2ZxcMnMpokk=;
	b=SYULX36FMP7nhK2bOsbiADFks+FVlcp0TXBnZHGw1deg9gmz9nqdlOx1EObgeZ7xIqO6
	 Mhp2fxb8DCZA0lud3fftb7Sc4sWieSQw+lMTIrssRlvR8MEqFkUmiI0wxS9af7BMwC7Cu
	 CNF6Q89n6qL2/b70WDZ472DNr5O6NxyEyzMLpYWo/XGsqZ+bFOPmCvqsz4CRGdCE4c3/3
	 nrFE3/ic1Kd89Hwt/hn9RQxVgkr5e6zcGnIEeh7nblItZ0nAGp6Rq1LR53bTvZyI9S9OK
	 EjNYM/GX3CWxY849D/o7YzU/RFytbIYO9yr40CpgUuNig8k26LYKDuQ+9lCPfncUpgg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMVlp5A+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEE8A606A31C;
	Wed, 28 Oct 2026 17:49:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GMVlp5A+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A7401F01825;
	Wed, 28 Oct 2026 17:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209753;
	bh=/wXPfZxTIFzWbGR0l5Kxi4PDtbeBodIM2ZxcMnMpokk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GMVlp5A+Pqu4AHpyigaKl+akHE5d1wm7FmgQkS05/aQhXyYLP2qc9axMo2BMWo4yp
	 l3fyzVv40+9rgGhOWsopvhCmj3FO1rL2UwI4ZfY/7L0TgkwvpSjIOfb84uWVuZjY98
	 xxX0gvQY/9EpxSlXRvr9MISq6Wy7Djyy6WzEysyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 065/109] io_uring/register: handle index wrap when resizing
Date: Wed, 28 Oct 2026 18:00:49 +0100
Message-ID: <20261028165943.890419765@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -515,7 +515,7 @@ static int io_register_resize_rings(stru
 	old_head = READ_ONCE(o.rings->sq.head);
 	if (tail - old_head > p.sq_entries)
 		goto overflow;
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned index, dst_mask, src_mask;
 		size_t sq_size;
 
@@ -545,7 +545,7 @@ overflow:
 		ret = -EOVERFLOW;
 		goto out;
 	}
-	for (i = old_head; i < tail; i++) {
+	for (i = old_head; i != tail; i++) {
 		unsigned index, dst_mask, src_mask;
 		size_t cq_size;
 


